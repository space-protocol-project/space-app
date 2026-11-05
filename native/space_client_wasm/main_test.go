package main

import (
	"bufio"
	"context"
	"encoding/json"
	"os"
	"os/exec"
	"path/filepath"
	"runtime"
	"testing"
	"time"
)

func TestProtectedWorker(t *testing.T) {
	binary := os.Getenv("SPACE_CLIENT_WASM_BINARY")
	fixtures := os.Getenv("WASM_FIXTURES")
	if binary == "" || fixtures == "" {
		t.Fatal("CI fixture paths required")
	}
	for _, name := range []string{"catalog", "loop", "trap"} {
		t.Run(name, func(t *testing.T) {
			ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
			defer cancel()
			command := exec.CommandContext(ctx, binary, "--serve")
			input, err := command.StdinPipe()
			if err != nil {
				t.Fatal(err)
			}
			output, err := command.StdoutPipe()
			if err != nil {
				t.Fatal(err)
			}
			if err = command.Start(); err != nil {
				t.Fatal(err)
			}
			defer command.Process.Kill()
			lines := bufio.NewScanner(output)
			supported := runtime.GOOS == "windows" || (runtime.GOOS == "linux" && (os.Getenv("SPACE_CLIENT_WASM_CGROUP") != "" || os.Getenv("SPACE_CLIENT_WASM_BROKER_TEST") == "1"))
			if !supported {
				if lines.Scan() {
					t.Fatal("unprotected worker became ready")
				}
				if command.Wait() == nil {
					t.Fatal("expected isolation refusal")
				}
				return
			}
			if !lines.Scan() || lines.Text() != "{\"ready\":true}" {
				t.Fatal("missing ready")
			}
			module, err := os.ReadFile(filepath.Join(fixtures, name+".wasm"))
			if err != nil {
				t.Fatal(err)
			}
			if err = json.NewEncoder(input).Encode(request{module, []byte(`{"event":"start"}`)}); err != nil {
				t.Fatal(err)
			}
			found := lines.Scan()
			input.Close()
			err = command.Wait()
			if name == "catalog" {
				if !found || err != nil {
					t.Fatalf("execution failed: %v", err)
				}
				var reply struct {
					Result []byte `json:"result"`
				}
				if json.Unmarshal(lines.Bytes(), &reply) != nil || string(reply.Result) != `{"op":"list","limit":1,"cursor":null,"state":null}` {
					t.Fatal("result")
				}
			} else if found || err == nil {
				t.Fatal("bad guest accepted")
			}
		})
	}
}
