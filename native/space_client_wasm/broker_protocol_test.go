package main

import (
	"bufio"
	"bytes"
	"io"
	"net"
	"strings"
	"testing"
	"testing/iotest"
	"time"
)

func TestBrokerHello(t *testing.T) {
	for name, wire := range map[string]string{
		"old":       "{\"ready\":true}\n",
		"future":    strings.Replace(brokerHello, ":1", ":2", 1),
		"duplicate": strings.Replace(brokerHello, ":1}", ":1,\"version\":1}", 1),
		"extra":     strings.Replace(brokerHello, ":1}", ":1,\"extra\":true}", 1),
		"long":      strings.Repeat("x", 513) + "\n",
		"truncated": strings.TrimSuffix(brokerHello, "\n"),
		"empty":     "",
	} {
		t.Run(name, func(t *testing.T) {
			if readBrokerHello(bufio.NewReaderSize(strings.NewReader(wire), 512)) == nil {
				t.Fatal("incompatible protocol accepted")
			}
		})
	}
}

func TestBrokerHandshake(t *testing.T) {
	client, server := net.Pipe()
	defer client.Close()
	defer server.Close()
	client.SetDeadline(time.Now().Add(time.Second))
	server.SetDeadline(time.Now().Add(time.Second))
	done := make(chan error, 1)
	go func() {
		reader, err := serverHandshake(server)
		if err == nil {
			var payload [4]byte
			_, err = io.ReadFull(reader, payload[:])
			if err == nil && !bytes.Equal(payload[:], []byte("data")) {
				err = io.ErrUnexpectedEOF
			}
		}
		done <- err
	}()
	if _, err := clientHandshake(client); err != nil {
		t.Fatal(err)
	}
	if _, err := io.WriteString(client, "data"); err != nil {
		t.Fatal(err)
	}
	if err := <-done; err != nil {
		t.Fatal(err)
	}
}

func TestBrokerBufferedPayload(t *testing.T) {
	input := bufio.NewReaderSize(strings.NewReader(brokerHello+"data"), 512)
	if err := readBrokerHello(input); err != nil {
		t.Fatal(err)
	}
	payload, err := io.ReadAll(input)
	if err != nil || string(payload) != "data" {
		t.Fatal("buffered payload lost")
	}
}

func TestBrokerFragmentedHello(t *testing.T) {
	input := bufio.NewReaderSize(iotest.OneByteReader(strings.NewReader(brokerHello)), 512)
	if err := readBrokerHello(input); err != nil {
		t.Fatal(err)
	}
}
