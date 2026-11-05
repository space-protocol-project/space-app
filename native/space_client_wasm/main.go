// Клиентский supervisor не компилирует WASM; компиляция и вызов принадлежат ProcessHost.
package main

import (
	"context"
	"encoding/json"
	"fmt"
	"io"
	"os"

	host "github.com/space-protocol-project/space-server/experiments/extensions"
)

type request struct {
	WASM  []byte `json:"wasm"`
	Input []byte `json:"input"`
}

func main() {
	var err error
	if len(os.Args) == 1 {
		err = host.Worker(os.Stdin, os.Stdout)
	} else if len(os.Args) == 2 && os.Args[1] == "--serve" {
		err = platformServe(os.Stdin, os.Stdout)
	} else if len(os.Args) == 2 && os.Args[1] == "--linux-broker" {
		err = linuxBroker()
	} else {
		err = fmt.Errorf("arguments")
	}
	if err != nil {
		fmt.Fprintln(os.Stderr, "ClientWasmUnavailable")
		os.Exit(1)
	}
}

func serve(input io.Reader, output io.Writer) error {
	executable, err := os.Executable()
	if err != nil {
		return err
	}
	// В настольном Linux нет привилегированного launcher: NewProcessHost отказывает.
	// Этот параметр используется только доверенным привилегированным стендом Linux.
	root := os.Getenv("SPACE_CLIENT_WASM_CGROUP")
	if root == "" {
		root = os.TempDir()
	}
	runtime, err := host.NewProcessHost(root, executable)
	if err != nil {
		return err
	}
	defer runtime.Close()
	return serveCall(runtime, input, output)
}

func serveCall(runtime *host.ProcessHost, input io.Reader, output io.Writer) error {
	encoder := json.NewEncoder(output)
	if err := encoder.Encode(map[string]bool{"ready": true}); err != nil {
		return err
	}
	decoder := json.NewDecoder(io.LimitReader(input, 128<<10))
	decoder.DisallowUnknownFields()
	var call request
	if err := decoder.Decode(&call); err != nil {
		return err
	}
	// Клиентский посредник держит stdin открытым до завершения запроса.
	// EOF отменяет исполнение; закрытие supervisor также закрывает Job/cgroup worker.
	ctx, cancel := context.WithCancel(context.Background())
	defer cancel()
	go func() { var extra any; _ = decoder.Decode(&extra); cancel() }()
	result, err := runtime.CompileAndCall(ctx, call.WASM, call.Input, true, false)
	if err != nil {
		return err
	}
	return encoder.Encode(map[string][]byte{"result": result})
}
