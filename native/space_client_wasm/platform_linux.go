//go:build linux

package main

import (
	"fmt"
	"io"
	"net"
	"os"
	"path/filepath"
	"strconv"
	"strings"
	"time"

	host "github.com/space-protocol-project/space-server/experiments/extensions"
	"golang.org/x/sys/unix"
)

const brokerSocket = "/run/space-client-wasm/control.sock"
const brokerBinary = "/usr/libexec/space-client-wasm/space-client-wasm"

// Обычный клиент не создаёт cgroup и никогда не вызывает sudo/pkexec.
func platformServe(input io.Reader, output io.Writer) error {
	if os.Geteuid() == 0 {
		// Сохранён отдельный привилегированный стенд ProcessHost.
		if os.Getenv("SPACE_CLIENT_WASM_CGROUP") == "" {
			return host.ErrIsolation
		}
		return serve(input, output)
	}
	connection, err := net.DialTimeout("unix", brokerSocket, time.Second)
	if err != nil {
		return host.ErrIsolation
	}
	defer connection.Close()
	socket := connection.(*net.UnixConn)
	uid, err := peerUID(socket)
	if err != nil || uid != 0 {
		return host.ErrIsolation
	}
	_ = socket.SetDeadline(time.Now().Add(5 * time.Second))
	replies, err := clientHandshake(socket)
	if err != nil {
		return err
	}
	go func() {
		_, _ = io.Copy(socket, io.LimitReader(input, 128<<10))
		_ = socket.CloseWrite()
	}()
	written, err := io.Copy(output, io.LimitReader(replies, 32<<10))
	if err != nil {
		return err
	}
	// EOF после ready не означает успешное выполнение гостя.
	if written <= int64(len("{\"ready\":true}\n")) {
		return host.ErrWorker
	}
	return nil
}

func peerUID(connection *net.UnixConn) (uint32, error) {
	raw, err := connection.SyscallConn()
	if err != nil {
		return 0, err
	}
	var credential *unix.Ucred
	var failure error
	err = raw.Control(func(fd uintptr) {
		credential, failure = unix.GetsockoptUcred(int(fd), unix.SOL_SOCKET, unix.SO_PEERCRED)
	})
	if err != nil {
		return 0, err
	}
	if failure != nil {
		return 0, failure
	}
	return credential.Uid, nil
}

func linuxBroker() error {
	if os.Geteuid() != 0 || os.Getenv("LISTEN_PID") != strconv.Itoa(os.Getpid()) || os.Getenv("LISTEN_FDS") != "1" {
		return host.ErrIsolation
	}
	executable, err := os.Executable()
	if err != nil || executable != brokerBinary {
		return host.ErrIsolation
	}
	root, err := delegatedRoot()
	if err != nil {
		return err
	}
	runtime, err := host.NewProcessHost(root, brokerBinary)
	if err != nil {
		return err
	}
	defer runtime.Close()
	file := os.NewFile(3, "systemd-socket")
	listener, err := net.FileListener(file)
	_ = file.Close()
	if err != nil {
		return err
	}
	defer listener.Close()
	// Даже медленные/злонамеренные локальные клиенты не создают неограниченные goroutine.
	slots := make(chan struct{}, 4)
	for {
		connection, err := listener.Accept()
		if err != nil {
			return err
		}
		select {
		case slots <- struct{}{}:
			go func() {
				defer func() { <-slots }()
				defer connection.Close()
				socket := connection.(*net.UnixConn)
				uid, err := peerUID(socket)
				if err != nil || uid == 0 {
					return
				}
				_ = socket.SetDeadline(time.Now().Add(4 * time.Second))
				input, err := serverHandshake(socket)
				if err != nil {
					return
				}
				_ = serveCall(runtime, input, socket)
			}()
		default:
			_ = connection.Close()
		}
	}
}

func delegatedRoot() (string, error) {
	raw, err := os.ReadFile("/proc/self/cgroup")
	if err != nil {
		return "", err
	}
	path := strings.TrimPrefix(strings.TrimSpace(string(raw)), "0::")
	if !strings.HasPrefix(path, "/") || !strings.HasSuffix(path, "/space-client-wasm.service/supervisor") {
		return "", fmt.Errorf("unexpected delegation")
	}
	root := filepath.Join("/sys/fs/cgroup", filepath.Dir(path))
	// systemd 254+ помещает supervisor в лист до ExecStart.
	err = os.WriteFile(filepath.Join(root, "cgroup.subtree_control"), []byte("+memory +pids +cpu"), 0600)
	return root, err
}
