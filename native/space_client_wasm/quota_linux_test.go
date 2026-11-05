//go:build linux

package main

import (
	"context"
	"os"
	"runtime"
	"testing"

	host "github.com/space-protocol-project/space-server/experiments/extensions"
)

// Только тестовый executable. Производственный worker не содержит команды нагрузки.
func TestMain(m *testing.M) {
	if os.Geteuid() == 65534 && os.Getenv("GOMEMLIMIT") == "64MiB" {
		memory := make([]byte, 512<<20)
		for i := range memory {
			memory[i] = byte(i)
		}
		runtime.KeepAlive(memory)
		os.Exit(90)
	}
	os.Exit(m.Run())
}

func TestLinuxMemoryEnforced(t *testing.T) {
	root := os.Getenv("SPACE_CLIENT_WASM_CGROUP")
	if os.Geteuid() != 0 || root == "" {
		t.Skip("отдельный привилегированный стенд квот")
	}
	binary, err := os.Executable()
	if err != nil {
		t.Fatal(err)
	}
	// Go помещает тест в закрытый временный каталог. Worker получает только executable.
	copy, err := os.ReadFile(binary)
	if err != nil {
		t.Fatal(err)
	}
	file, err := os.CreateTemp("/tmp", "space-quota-test-")
	if err != nil {
		t.Fatal(err)
	}
	defer os.Remove(file.Name())
	if _, err = file.Write(copy); err != nil {
		t.Fatal(err)
	}
	if err = file.Chmod(0755); err != nil {
		t.Fatal(err)
	}
	file.Close()
	process, err := host.NewProcessHost(root, file.Name())
	if err != nil {
		t.Fatal(err)
	}
	defer process.Close()
	_, err = process.CompileAndCall(context.Background(), []byte{0}, []byte(`{}`), true, false)
	if err == nil {
		t.Fatal("memory bomb accepted")
	}
	stats := process.Stats()
	if stats.OOMKills == 0 || stats.Active != 0 || stats.PeakBytes > host.TotalMemory {
		t.Fatalf("quota not enforced: %+v", stats)
	}
	t.Logf("kernel OOM and released reservation: %+v", stats)
}
