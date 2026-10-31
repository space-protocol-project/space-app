//go:build linux

// Только стенд CI: копируется в пакет postgres рядом с p1_command_bridge_test.go.
package postgres

import (
	"context"
	"crypto/ed25519"
	"crypto/rand"
	"encoding/json"
	"errors"
	"net/http/httptest"
	"os"
	"os/exec"
	"path/filepath"
	"sync/atomic"
	"syscall"
	"testing"
	"time"

	"connectrpc.com/connect"
	pb "github.com/space-protocol-project/space-server/gen/space/v1"
	"github.com/space-protocol-project/space-server/gen/space/v1/spacev1connect"
	"google.golang.org/grpc/metadata"
)

type crashCommandBridge struct {
	*commandClientBridge
	contexts, executes, reconciles atomic.Int32
	committed                      chan struct{}
}

func (b *crashCommandBridge) GetExtensionMutationContext(ctx context.Context, r *connect.Request[pb.GetExtensionMutationContextRequest]) (*connect.Response[pb.GetExtensionMutationContextResponse], error) {
	b.contexts.Add(1)
	return b.commandClientBridge.GetExtensionMutationContext(ctx, r)
}
func (b *crashCommandBridge) ExecuteExtensionCommand(ctx context.Context, r *connect.Request[pb.ExecuteExtensionCommandRequest]) (*connect.Response[pb.ExecuteExtensionCommandResponse], error) {
	b.executes.Add(1)
	_, err := b.api.ExecuteExtensionCommand(bridgeContext(ctx, r.Header().Get("Authorization")), r.Msg)
	if err != nil {
		return bridgeResponse[pb.ExecuteExtensionCommandResponse](nil, err)
	}
	select {
	case b.committed <- struct{}{}:
	default:
	}
	<-ctx.Done()
	return nil, connect.NewError(connect.CodeCanceled, errors.New("Клиент остановлен после commit"))
}
func (b *crashCommandBridge) ReconcileExtensionCommand(ctx context.Context, r *connect.Request[pb.ReconcileExtensionCommandRequest]) (*connect.Response[pb.ReconcileExtensionCommandResponse], error) {
	b.reconciles.Add(1)
	return b.commandClientBridge.ReconcileExtensionCommand(ctx, r)
}

type commandNativeProcess struct {
	cmd          *exec.Cmd
	done         chan struct{}
	err          error
	control, log string
}

func startCommandNative(t *testing.T, profile, url, principal, authorization, role, stage string) *commandNativeProcess {
	t.Helper()
	control, err := os.MkdirTemp(filepath.Dir(profile), role+"-")
	if err != nil {
		t.Fatal(err)
	}
	for _, name := range []string{"data", "config", "cache"} {
		if err = os.MkdirAll(filepath.Join(profile, name), 0700); err != nil {
			t.Fatal(err)
		}
	}
	logName := filepath.Join(control, "native.log")
	log, err := os.Create(logName)
	if err != nil {
		t.Fatal(err)
	}
	cmd := exec.Command("dbus-run-session", "--", "python3", os.Getenv("SPACE_P1_KEYRING_WRAPPER"), os.Getenv("SPACE_P1_NATIVE_COMMAND"))
	cmd.SysProcAttr = &syscall.SysProcAttr{Setpgid: true}
	cmd.Env = append(os.Environ(),
		"P1_COMMAND_CONTROL="+control, "P1_COMMAND_ROLE="+role, "P1_COMMAND_STAGE="+stage,
		"SPACE_P1_COMMAND_URL="+url, "SPACE_P1_COMMAND_AUTH="+authorization, "SPACE_P1_COMMAND_PRINCIPAL="+principal,
		"DIRECTORY_CRASH_PROFILE="+profile, "DIRECTORY_CRASH_CONTROL="+control, "DIRECTORY_CRASH_ROLE="+role,
		"XDG_DATA_HOME="+filepath.Join(profile, "data"), "XDG_CONFIG_HOME="+filepath.Join(profile, "config"), "XDG_CACHE_HOME="+filepath.Join(profile, "cache"), "LIBGL_ALWAYS_SOFTWARE=1")
	cmd.Stdout, cmd.Stderr = log, log
	if err = cmd.Start(); err != nil {
		log.Close()
		t.Fatal(err)
	}
	p := &commandNativeProcess{cmd: cmd, done: make(chan struct{}), control: control, log: logName}
	go func() { p.err = cmd.Wait(); log.Close(); close(p.done) }()
	t.Cleanup(func() {
		select {
		case <-p.done:
			return
		default:
			syscall.Kill(-cmd.Process.Pid, syscall.SIGKILL)
			<-p.done
		}
	})
	return p
}

func (p *commandNativeProcess) marker(t *testing.T, name string) map[string]any {
	t.Helper()
	deadline := time.After(60 * time.Second)
	for {
		raw, err := os.ReadFile(filepath.Join(p.control, name+".json"))
		if err == nil {
			var result map[string]any
			if err = json.Unmarshal(raw, &result); err != nil {
				t.Fatal(err)
			}
			return result
		}
		select {
		case <-p.done:
			log, _ := os.ReadFile(p.log)
			t.Fatalf("Нет %s: %v\n%s", name, p.err, log)
		case <-deadline:
			t.Fatal("Нет контрольной точки", name)
		case <-time.After(20 * time.Millisecond):
		}
	}
}

func (p *commandNativeProcess) kill(t *testing.T, nativePID int) {
	t.Helper()
	group, err := syscall.Getpgid(nativePID)
	if err != nil || group != p.cmd.Process.Pid || group == syscall.Getpgrp() {
		t.Fatal("Чужая группа процессов", err)
	}
	if err = syscall.Kill(-group, syscall.SIGKILL); err != nil {
		t.Fatal(err)
	}
	select {
	case <-p.done:
	case <-time.After(15 * time.Second):
		t.Fatal("SIGKILL не завершил процесс")
	}
	if p.err == nil || p.cmd.ProcessState.Sys().(syscall.WaitStatus).Signal() != syscall.SIGKILL {
		t.Fatal("Не подтверждён SIGKILL")
	}
}

func runCommandNative(t *testing.T, profile, url, principal, authorization, role, want string) map[string]any {
	t.Helper()
	p := startCommandNative(t, profile, url, principal, authorization, role, "")
	result := p.marker(t, "done")
	select {
	case <-p.done:
	case <-time.After(15 * time.Second):
		t.Fatal("Клиент не завершился")
	}
	if p.err != nil || result["phase"] != want || result["independent_read"] != true {
		t.Fatal("Неверное восстановление", result, p.err)
	}
	if result["present"] == true && result["encrypted_keyring"] != true {
		t.Fatal("Не подтверждено системное шифрование")
	}
	t.Logf("native role=%s result=%s pid=%.0f present=%v independent_read=true", role, want, result["pid"], result["present"])
	return result
}

func commandRelogin(t *testing.T, f *channelFixture) (string, func() context.Context) {
	t.Helper()
	root, private, _ := ed25519.GenerateKey(rand.Reader)
	device, devicePrivate, _ := ed25519.GenerateKey(rand.Reader)
	grant := complete(t, f.ctx, f.auth, &pb.CreateChallengeRequest{Purpose: "device.register", RootPublicKey: root, DevicePublicKey: device, Administrative: true}, private)
	return grant.PrincipalId, func() context.Context {
		session := complete(t, f.ctx, f.auth, &pb.CreateChallengeRequest{Purpose: "auth.login", GrantId: grant.GrantId}, devicePrivate)
		return metadata.AppendToOutgoingContext(f.ctx, "authorization", "Bearer "+session.AccessToken)
	}
}

func TestExtensionClientCrashRecovery(t *testing.T) {
	if os.Getenv("SPACE_P1_NATIVE_COMMAND") == "" {
		t.Skip("Требуется нативный Flutter")
	}
	for _, stage := range []string{"before-save", "after-save", "after-commit"} {
		t.Run(stage, func(t *testing.T) { checkCommandCrash(t, stage) })
	}
}

func checkCommandCrash(t *testing.T, stage string) {
	f := newChannelFixtureTimeout(t, 8*time.Minute)
	c := f.create(t, "native_crash")
	f.acl(t, c, roleRule("member", permissions(true, true, true, false)))
	principal, login := commandRelogin(t, f)
	original := login()
	h := &mutationProbe{run: func(context.Context) ([]byte, error) { return mutationOutput(0), nil }}
	b := &crashCommandBridge{commandClientBridge: &commandClientBridge{api: mutationClient(t, f, h, []byte{1}, c.Id)}, committed: make(chan struct{}, 1)}
	_, handler := spacev1connect.NewExtensionP1ServiceHandler(b)
	server := httptest.NewServer(handler)
	defer server.Close()
	root, err := os.MkdirTemp(os.Getenv("RUNNER_TEMP"), "p1-command-crash-")
	if err != nil {
		t.Fatal(err)
	}
	profile := filepath.Join(root, "profile")
	p := startCommandNative(t, profile, server.URL, principal, outgoingAuthorization(original), "start", stage)
	ready := p.marker(t, "ready")
	if stage == "after-commit" {
		select {
		case <-b.committed:
		case <-time.After(45 * time.Second):
			t.Fatal("Нет commit")
		}
	} else {
		p.marker(t, "checkpoint")
	}
	p.kill(t, int(ready["pid"].(float64)))
	t.Log("SIGKILL confirmed", stage)
	if stage == "before-save" {
		result := runCommandNative(t, profile, server.URL, principal, outgoingAuthorization(original), "inspect", "idle")
		if result["present"] != false || b.executes.Load() != 0 {
			t.Fatal("Команда отправлена до сохранения")
		}
		mutationCounts(t, f, 0, 0, 0, 0)
		return
	}
	checkCommandRelogin(t, f, c, b, profile, server.URL, principal, original, login, stage, p.marker(t, "saved")["snapshot_sha256"])
	expected := 0
	if stage == "after-commit" {
		expected = 1
	}
	mutationCounts(t, f, expected, expected, expected, expected)
	if int(h.calls.Load()) != expected || int(b.executes.Load()) != expected || b.contexts.Load() != 1 {
		t.Fatal("Восстановление повторило команду или контекст")
	}
}

func checkCommandRelogin(t *testing.T, f *channelFixture, channel *pb.Channel, b *crashCommandBridge, profile, url, principal string, original context.Context, login func() context.Context, stage string, savedHash any) {
	if _, err := f.auth.Logout(original, &pb.LogoutRequest{}); err != nil {
		t.Fatal(err)
	}
	old := runCommandNative(t, profile, url, principal, outgoingAuthorization(original), "expired", "reauthenticate")
	if old["snapshot_sha256"] != savedHash {
		t.Fatal("Сохранённый снимок изменился после SIGKILL")
	}
	fresh := login()
	if outgoingAuthorization(fresh) == outgoingAuthorization(original) {
		t.Fatal("Сессия не обновилась")
	}
	calls := b.reconciles.Load()
	foreign := runCommandNative(t, profile, url, principal, outgoingAuthorization(fresh), "foreign", "stop")
	if b.reconciles.Load() != calls {
		t.Fatal("Чужая привязка отправила RPC")
	}
	// Отзыв прав не раскрывает квитанцию и не удаляет снимок.
	f.acl(t, channel, roleRule("member", permissions(true, true, false, false)))
	denied := runCommandNative(t, profile, url, principal, outgoingAuthorization(fresh), "denied", "stop")
	f.acl(t, channel, roleRule("member", permissions(true, true, true, false)))
	want := "stop"
	if stage == "after-commit" {
		want = "confirmed"
	}
	recovered := runCommandNative(t, profile, url, principal, outgoingAuthorization(fresh), "resume", want)
	for _, result := range []map[string]any{foreign, denied, recovered} {
		if result["snapshot_sha256"] != old["snapshot_sha256"] || result["present"] != true {
			t.Fatal("Снимок изменился", result)
		}
	}
}
