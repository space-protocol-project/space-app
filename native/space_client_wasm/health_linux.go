//go:build linux

package main

import (
	"encoding/json"
	"fmt"
	"io"
	"net"
	"os"
	"time"
)

// Минимальный модуль без импортов: alloc возвращает 1024, free ничего не делает,
// handle возвращает указатель 0 и длину 2; сегмент данных содержит {}.
// Проверяет компиляцию и исполнение в worker, а не только доступность сокета.
var healthModule = []byte{
	0, 97, 115, 109, 1, 0, 0, 0,
	1, 17, 3, 96, 1, 127, 1, 127, 96, 2, 127, 127, 0, 96, 2, 127, 127, 1, 126,
	3, 4, 3, 0, 1, 2,
	5, 4, 1, 1, 1, 4,
	7, 52, 4,
	6, 'm', 'e', 'm', 'o', 'r', 'y', 2, 0,
	11, 's', 'p', 'a', 'c', 'e', '_', 'a', 'l', 'l', 'o', 'c', 0, 0,
	10, 's', 'p', 'a', 'c', 'e', '_', 'f', 'r', 'e', 'e', 0, 1,
	12, 's', 'p', 'a', 'c', 'e', '_', 'h', 'a', 'n', 'd', 'l', 'e', 0, 2,
	10, 15, 3, 5, 0, 65, 128, 8, 11, 2, 0, 11, 4, 0, 66, 2, 11,
	11, 8, 1, 0, 65, 0, 11, 2, '{', '}',
}

func checkLinuxBroker() error {
	if os.Geteuid() == 0 {
		return fmt.Errorf("health check requires unprivileged uid")
	}
	connection, err := net.DialTimeout("unix", brokerSocket, time.Second)
	if err != nil {
		return err
	}
	defer connection.Close()
	socket := connection.(*net.UnixConn)
	uid, err := peerUID(socket)
	if err != nil || uid != 0 {
		return fmt.Errorf("health peer")
	}
	if err = socket.SetDeadline(time.Now().Add(5 * time.Second)); err != nil {
		return err
	}
	reader, err := clientHandshake(socket)
	if err != nil {
		return err
	}
	ready, err := reader.ReadString('\n')
	if err != nil || ready != "{\"ready\":true}\n" {
		return fmt.Errorf("health ready")
	}
	if err = json.NewEncoder(socket).Encode(request{healthModule, []byte(`{}`)}); err != nil {
		return err
	}
	var result struct {
		Result []byte `json:"result"`
	}
	decoder := json.NewDecoder(io.LimitReader(reader, 1024))
	decoder.DisallowUnknownFields()
	if err = decoder.Decode(&result); err != nil {
		return err
	}
	if string(result.Result) != `{}` {
		return fmt.Errorf("health result")
	}
	return nil
}
