//go:build linux

// Только стенд CI: соединяет нативный журнал с отказом протокола PostgreSQL.
package postgres

import (
	"context"
	"net/http/httptest"
	"os"
	"path/filepath"
	"sync/atomic"
	"testing"
	"time"

	"connectrpc.com/connect"
	pb "github.com/space-protocol-project/space-server/gen/space/v1"
	"github.com/space-protocol-project/space-server/gen/space/v1/spacev1connect"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"
	"google.golang.org/protobuf/proto"
)

type commandDatabaseResult struct {
	request *pb.ExecuteExtensionCommandRequest
	code    codes.Code
	outcome pb.ExtensionCommandOutcome
}

type databaseCommandBridge struct {
	*crashCommandBridge
	executed   chan commandDatabaseResult
	reconciled chan commandDatabaseResult
}

func (b *databaseCommandBridge) ExecuteExtensionCommand(ctx context.Context, r *connect.Request[pb.ExecuteExtensionCommandRequest]) (*connect.Response[pb.ExecuteExtensionCommandResponse], error) {
	b.executes.Add(1)
	_, err := b.api.ExecuteExtensionCommand(bridgeContext(ctx, r.Header().Get("Authorization")), r.Msg)
	b.executed <- commandDatabaseResult{request: proto.Clone(r.Msg).(*pb.ExecuteExtensionCommandRequest), code: status.Code(err)}
	// Сервер уже получил неопределённый результат COMMIT. Клиент будет убит
	// до получения ответа, поэтому его таймер повторов ещё не запускается.
	<-ctx.Done()
	return nil, connect.NewError(connect.CodeCanceled, ctx.Err())
}

func (b *databaseCommandBridge) ReconcileExtensionCommand(ctx context.Context, r *connect.Request[pb.ReconcileExtensionCommandRequest]) (*connect.Response[pb.ReconcileExtensionCommandResponse], error) {
	b.reconciles.Add(1)
	value, err := b.api.ReconcileExtensionCommand(bridgeContext(ctx, r.Header().Get("Authorization")), r.Msg)
	b.reconciled <- commandDatabaseResult{request: proto.Clone(r.Msg.Command).(*pb.ExecuteExtensionCommandRequest), code: status.Code(err), outcome: value.GetOutcome()}
	return bridgeResponse(value, err)
}

func TestExtensionClientDatabaseRecovery(t *testing.T) {
	if os.Getenv("SPACE_P1_NATIVE_COMMAND") == "" || os.Getenv("SPACE_P1_DATABASE_CONTAINER") == "" {
		t.Skip("Нужны нативный Flutter и выделенный контейнер PostgreSQL CI")
	}
	for _, mode := range []string{"before_commit", "after_commit"} {
		t.Run(mode, func(t *testing.T) { checkCommandDatabaseCrash(t, mode) })
	}
}

func checkCommandDatabaseCrash(t *testing.T, mode string) {
	f := newChannelFixtureTimeout(t, 8*time.Minute)
	c := f.create(t, "client_database_crash")
	proxy, database := newExtensionDatabaseProxy(t, f.url, mode)
	store, _, err := Open(f.ctx, database)
	if err != nil {
		t.Fatal(err)
	}
	t.Cleanup(store.Close)
	var invoked atomic.Bool
	host := &mutationProbe{run: func(context.Context) ([]byte, error) {
		if !invoked.Swap(true) {
			proxy.armed.Store(true)
		}
		return mutationOutput(0), nil
	}}
	svc, err := store.NewExtensionP1MutationService(f.ctx, host, mutationBindings(c.Id, []byte{1}))
	if err != nil {
		t.Fatal(err)
	}
	b := &databaseCommandBridge{
		crashCommandBridge: &crashCommandBridge{commandClientBridge: &commandClientBridge{api: extensionP1RPCClient(t, f, svc)}},
		executed:           make(chan commandDatabaseResult, 1), reconciled: make(chan commandDatabaseResult, 1),
	}
	_, handler := spacev1connect.NewExtensionP1ServiceHandler(b)
	server := httptest.NewServer(handler)
	t.Cleanup(server.Close)
	root, err := os.MkdirTemp(os.Getenv("RUNNER_TEMP"), "p1-command-database-")
	if err != nil {
		t.Fatal(err)
	}
	profile := filepath.Join(root, "profile")
	p := startCommandNative(t, profile, server.URL, f.ownerID, outgoingAuthorization(f.owner), "start", "database")
	ready := p.marker(t, "ready")
	saved := p.marker(t, "saved")
	select {
	case evidence := <-proxy.hit:
		t.Log("database boundary:", evidence)
	case <-time.After(10 * time.Second):
		t.Fatal("Не достигнут COMMIT PostgreSQL")
	}
	var original commandDatabaseResult
	select {
	case original = <-b.executed:
		if original.code != codes.Internal {
			t.Fatal("Ожидался неопределённый Internal, получен", original.code)
		}
	case <-time.After(10 * time.Second):
		t.Fatal("Нет результата оборванного COMMIT")
	}
	p.kill(t, int(ready["pid"].(float64)))
	t.Log("SIGKILL confirmed client", mode, "server_code=Internal")
	restartExtensionDatabase(t, f)
	want := 0
	if mode == "after_commit" {
		want = 1
	}
	mutationCounts(t, f, want, want, want, want)
	event := ""
	if want == 1 {
		event = verifyExtensionCrashData(t, f)
	}
	checkCommandDatabaseReconcile(t, f, b, profile, server.URL, original.request, saved["snapshot_sha256"], want)
	mutationCounts(t, f, want, want, want, want)
	if want == 1 && verifyExtensionCrashData(t, f) != event {
		t.Fatal("Сверка изменила ID события")
	}
	if host.calls.Load() != 1 || b.executes.Load() != 1 || b.contexts.Load() != 1 {
		t.Fatal("Восстановление повторило гостя, Execute или контекст", host.calls.Load(), b.executes.Load(), b.contexts.Load())
	}
	t.Logf("mode=%s revision=%d data=%d receipts=%d outbox=%d guest_calls=1 execute_calls=1 context_calls=1", mode, want, want, want, want)
}

func checkCommandDatabaseReconcile(t *testing.T, f *channelFixture, b *databaseCommandBridge, profile, url string, original *pb.ExecuteExtensionCommandRequest, savedHash any, want int) {
	t.Helper()
	// После аварии старое соединение пула может дать Internal. Контроллер
	// разрешает до четырёх новых запусков клиента, каждый делает одну сверку.
	// Execute не повторяется; отсутствие квитанции прекращает проверку сразу.
	for attempt := 1; attempt <= 4; attempt++ {
		result := runCommandNative(t, profile, url, f.ownerID, outgoingAuthorization(f.owner), "resume", "")
		var rpc commandDatabaseResult
		select {
		case rpc = <-b.reconciled:
		case <-time.After(time.Second):
			t.Fatal("Нет результата RPC сверки")
		}
		if !proto.Equal(original, rpc.request) || result["snapshot_sha256"] != savedHash || result["present"] != true || result["attempts"] != float64(0) {
			t.Fatal("Изменился снимок или началась повторная отправка")
		}
		t.Logf("cold_reconcile_attempt=%d code=%s outcome=%s", attempt, rpc.code, rpc.outcome)
		if rpc.code == codes.Internal {
			if result["phase"] != "stop" || result["unknown"] != true {
				t.Fatal("Internal скрыл неопределённость", result)
			}
			continue
		}
		if rpc.code != codes.OK {
			t.Fatal("Неожиданный отказ сверки", rpc.code)
		}
		phase, outcome := "stop", pb.ExtensionCommandOutcome_EXTENSION_COMMAND_OUTCOME_UNKNOWN
		if want == 1 {
			phase, outcome = "confirmed", pb.ExtensionCommandOutcome_EXTENSION_COMMAND_OUTCOME_CONFIRMED
		}
		if result["phase"] != phase || result["unknown"] != (want == 0) || rpc.outcome != outcome {
			t.Fatal("Неверный результат сверки", result, rpc.outcome)
		}
		return
	}
	t.Fatal("Сверка не восстановилась за четыре холодных запуска")
}
