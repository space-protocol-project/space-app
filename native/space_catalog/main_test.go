package main

import (
	"errors"
	"fmt"
	"os"
	"path/filepath"
	"runtime"
	"syscall"
	"testing"
)

func TestBoundsAndReplacement(t *testing.T) {
	dir := t.TempDir()
	path := filepath.Join(dir, "game")
	if err := os.WriteFile(path, []byte("abcdef"), 0600); err != nil {
		t.Fatal(err)
	}
	c, err := openCatalog(dir)
	if err != nil {
		t.Fatal(err)
	}
	defer c.close()
	all, err := c.list()
	if err != nil {
		t.Fatal(err)
	}
	files := all.([]entry)
	if len(files) != 1 {
		t.Fatal(files)
	}
	id := files[0].Handle
	for _, q := range []query{{Handle: id, Limit: 65537}, {Handle: id, Offset: 1<<53 - 1, Limit: 1}, {Handle: id, Offset: -1, Limit: 1}} {
		if _, err = c.read(q); !errors.Is(err, limited) {
			t.Fatal(err)
		}
	}
	if err = os.WriteFile(path, []byte("changed"), 0600); err != nil {
		t.Fatal(err)
	}
	if _, err = c.read(query{Handle: id, Limit: 1}); err == nil {
		t.Fatal("changed file accepted")
	}
}
func TestExternalLink(t *testing.T) {
	dir := t.TempDir()
	outside := filepath.Join(t.TempDir(), "secret")
	if err := os.WriteFile(outside, []byte("secret"), 0600); err != nil {
		t.Fatal(err)
	}
	if err := os.Symlink(outside, filepath.Join(dir, "link")); err != nil {
		t.Fatal(err)
	}
	c, err := openCatalog(dir)
	if err != nil {
		t.Fatal(err)
	}
	defer c.close()
	list, err := c.list()
	if err != nil || len(list.([]entry)) != 0 {
		t.Fatal("escaped root", err)
	}
}
func TestSnapshotBudget(t *testing.T) {
	dir := t.TempDir()
	for i := 0; i < 129; i++ {
		if e := os.WriteFile(filepath.Join(dir, fmt.Sprint(i)), nil, 0600); e != nil {
			t.Fatal(e)
		}
	}
	c, e := openCatalog(dir)
	if e != nil {
		t.Fatal(e)
	}
	defer c.close()
	if _, e = c.list(); e != limited {
		t.Fatal(e)
	}
}

// На Windows открытый дескриптор сам может запретить переименование.
func renamePinned(t *testing.T, path, next string) bool {
	t.Helper()
	err := os.Rename(path, next)
	if err == nil {
		return true
	}
	if runtime.GOOS == "windows" && (errors.Is(err, syscall.Errno(32)) || errors.Is(err, os.ErrPermission)) {
		return false
	}
	t.Fatal(err)
	return false
}

func TestReplaceIssuedEntry(t *testing.T) {
	dir := t.TempDir()
	path := filepath.Join(dir, "game")
	if err := os.WriteFile(path, []byte("old"), 0600); err != nil {
		t.Fatal(err)
	}
	c, err := openCatalog(dir)
	if err != nil {
		t.Fatal(err)
	}
	defer c.close()
	list, err := c.list()
	if err != nil {
		t.Fatal(err)
	}
	id := list.([]entry)[0].Handle
	if !renamePinned(t, path, path+".old") {
		return
	}
	if err = os.WriteFile(path, []byte("new"), 0600); err != nil {
		t.Fatal(err)
	}
	if _, err = c.read(query{Handle: id, Limit: 3}); err != denied {
		t.Fatal("replacement accepted", err)
	}
}
func TestRootIsPinned(t *testing.T) {
	dir := filepath.Join(t.TempDir(), "library")
	if err := os.Mkdir(dir, 0700); err != nil {
		t.Fatal(err)
	}
	if err := os.WriteFile(filepath.Join(dir, "chosen"), nil, 0600); err != nil {
		t.Fatal(err)
	}
	c, err := openCatalog(dir)
	if err != nil {
		t.Fatal(err)
	}
	defer c.close()
	if !renamePinned(t, dir, dir+".old") {
		return
	}
	if err = os.Mkdir(dir, 0700); err != nil {
		t.Fatal(err)
	}
	if err = os.WriteFile(filepath.Join(dir, "foreign"), nil, 0600); err != nil {
		t.Fatal(err)
	}
	list, err := c.list()
	if err != nil {
		t.Fatal(err)
	}
	files := list.([]entry)
	if len(files) != 1 || files[0].Name != "chosen" {
		t.Fatal("root changed", files)
	}
}
