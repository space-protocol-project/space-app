// Копируется только стендом CI в пакет postgres сервера.
package postgres

import (
	"context"
	"errors"
	"net/http/httptest"
	"os"
	"os/exec"
	"sync/atomic"
	"testing"
	"time"

	"connectrpc.com/connect"
	pb "github.com/space-protocol-project/space-server/gen/space/v1"
	"github.com/space-protocol-project/space-server/gen/space/v1/spacev1connect"
	"google.golang.org/grpc/metadata"
	"google.golang.org/grpc/status"
)

type commandClientBridge struct {
	spacev1connect.UnimplementedExtensionP1ServiceHandler
	api   pb.ExtensionP1ServiceClient
	calls atomic.Int32
}

func bridgeContext(ctx context.Context, header string) context.Context {
	return metadata.AppendToOutgoingContext(ctx, "authorization", header)
}

func bridgeResponse[T any](value *T, err error) (*connect.Response[T], error) {
	if err != nil {
		return nil, connect.NewError(connect.Code(status.Code(err)), errors.New("Отказ RPC"))
	}
	return connect.NewResponse(value), nil
}

func (b *commandClientBridge) GetExtensionMutationContext(ctx context.Context, r *connect.Request[pb.GetExtensionMutationContextRequest]) (*connect.Response[pb.GetExtensionMutationContextResponse], error) {
	value, err := b.api.GetExtensionMutationContext(bridgeContext(ctx, r.Header().Get("Authorization")), r.Msg)
	return bridgeResponse(value, err)
}

func (b *commandClientBridge) ExecuteExtensionCommand(ctx context.Context, r *connect.Request[pb.ExecuteExtensionCommandRequest]) (*connect.Response[pb.ExecuteExtensionCommandResponse], error) {
	value, err := b.api.ExecuteExtensionCommand(bridgeContext(ctx, r.Header().Get("Authorization")), r.Msg)
	if err == nil && b.calls.Add(1) == 1 {
		// Настоящий commit состоялся, но клиент не получает сохранённый ответ.
		return nil, connect.NewError(connect.CodeUnavailable, errors.New("Потеря ответа после commit"))
	}
	return bridgeResponse(value, err)
}

func (b *commandClientBridge) ReconcileExtensionCommand(ctx context.Context, r *connect.Request[pb.ReconcileExtensionCommandRequest]) (*connect.Response[pb.ReconcileExtensionCommandResponse], error) {
	value, err := b.api.ReconcileExtensionCommand(bridgeContext(ctx, r.Header().Get("Authorization")), r.Msg)
	return bridgeResponse(value, err)
}

func TestExtensionClientCommands(t *testing.T) {
	client := os.Getenv("SPACE_P1_FLUTTER_CLIENT")
	if client == "" {
		t.Skip("Требуется Flutter-клиент стенда")
	}
	f := newChannelFixtureTimeout(t, 10*time.Minute)
	c := f.create(t, "client_retry")
	h := &mutationProbe{run: func(context.Context) ([]byte, error) { return mutationOutput(0), nil }}
	b := &commandClientBridge{api: mutationClient(t, f, h, []byte{1}, c.Id)}
	_, handler := spacev1connect.NewExtensionP1ServiceHandler(b)
	server := httptest.NewServer(handler)
	defer server.Close()
	cmd := exec.CommandContext(f.ctx, "flutter", "test", "test/extensions_p1_command_rpc_test.dart", "--reporter", "expanded")
	cmd.Dir = client
	cmd.Env = append(os.Environ(), "SPACE_P1_COMMAND_URL="+server.URL, "SPACE_P1_COMMAND_AUTH="+outgoingAuthorization(f.owner), "SPACE_P1_COMMAND_PRINCIPAL="+f.ownerID)
	output, err := cmd.CombinedOutput()
	t.Log(string(output))
	if err != nil {
		t.Fatal(err)
	}
	mutationCounts(t, f, 1, 1, 1, 1)
	if h.calls.Load() != 1 || b.calls.Load() != 2 {
		t.Fatal("Повтор изменил число эффектов", h.calls.Load(), b.calls.Load())
	}
}
