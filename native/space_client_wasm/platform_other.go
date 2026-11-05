//go:build !linux

package main

import "io"
import "fmt"

func platformServe(input io.Reader, output io.Writer) error { return serve(input, output) }
func linuxBroker() error                                    { return fmt.Errorf("unsupported platform") }
func checkLinuxBroker() error                               { return fmt.Errorf("unsupported platform") }
