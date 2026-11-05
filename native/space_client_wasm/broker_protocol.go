package main

import (
	"bufio"
	"io"

	host "github.com/space-protocol-project/space-server/experiments/extensions"
)

// Версия транспорта, не версия пакета или опубликованного приложения.
// Канонический короткий кадр не допускает лишних полей и неоднозначного разбора.
const brokerHello = "{\"protocol\":\"space.client.wasm.linux.p1\",\"version\":1}\n"

func readBrokerHello(input *bufio.Reader) error {
	line, err := input.ReadSlice('\n')
	if err != nil || string(line) != brokerHello {
		return host.ErrIsolation
	}
	return nil
}

func clientHandshake(connection io.ReadWriter) (*bufio.Reader, error) {
	input := bufio.NewReaderSize(connection, 512)
	if err := readBrokerHello(input); err != nil {
		return nil, err
	}
	if _, err := io.WriteString(connection, brokerHello); err != nil {
		return nil, err
	}
	return input, nil
}

func serverHandshake(connection io.ReadWriter) (*bufio.Reader, error) {
	if _, err := io.WriteString(connection, brokerHello); err != nil {
		return nil, err
	}
	input := bufio.NewReaderSize(connection, 512)
	if err := readBrokerHello(input); err != nil {
		return nil, err
	}
	return input, nil
}
