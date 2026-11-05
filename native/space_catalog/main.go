package main

import (
	"bufio"
	"crypto/rand"
	"encoding/hex"
	"encoding/json"
	"errors"
	"io"
	"os"
	"path/filepath"
	"strings"
	"unicode"
	"unicode/utf8"
)

var denied = errors.New("PermissionDenied")
var limited = errors.New("ResourceLimit")

type entry struct {
	Name   string `json:"name"`
	Handle string `json:"handle"`
}
type fileRecord struct {
	name string
	file *os.File
	info os.FileInfo
}
type catalog struct {
	root      *os.Root
	directory *os.File
	files     map[string]fileRecord
	listed    bool
}
type query struct {
	Op, Handle string
	Offset     int64
	Limit      int
}

func openCatalog(path string) (*catalog, error) {
	if !filepath.IsAbs(path) {
		return nil, denied
	}
	selected, err := os.Lstat(path)
	if err != nil || !selected.IsDir() {
		return nil, denied
	}
	root, err := os.OpenRoot(path)
	if err != nil {
		return nil, denied
	}
	dir, err := root.Open(".")
	if err != nil {
		root.Close()
		return nil, denied
	}
	info, err := dir.Stat()
	if err != nil || !os.SameFile(selected, info) || !localDisk(dir) {
		dir.Close()
		root.Close()
		return nil, denied
	}
	return &catalog{root: root, directory: dir, files: make(map[string]fileRecord)}, nil
}
func (c *catalog) close() {
	for _, r := range c.files {
		r.file.Close()
	}
	c.directory.Close()
	c.root.Close()
}
func safeName(name string) bool {
	if !utf8.ValidString(name) || len(name) > 255 || name == "." || name == ".." || strings.ContainsAny(name, `/\:`) {
		return false
	}
	return strings.IndexFunc(name, func(r rune) bool { return unicode.IsControl(r) || unicode.Is(unicode.Cf, r) }) < 0
}
func (c *catalog) capture(d os.DirEntry) (entry, bool) {
	name := d.Name()
	if !safeName(name) || !d.Type().IsRegular() {
		return entry{}, false
	}
	before, err := c.root.Lstat(name)
	if err != nil || !before.Mode().IsRegular() {
		return entry{}, false
	}
	f, err := c.root.OpenFile(name, readFlags, 0)
	if err != nil {
		return entry{}, false
	}
	info, err := f.Stat()
	if err != nil || !info.Mode().IsRegular() || !os.SameFile(before, info) || !sameDisk(c.directory, f) {
		f.Close()
		return entry{}, false
	}
	var id [16]byte
	rand.Read(id[:])
	handle := hex.EncodeToString(id[:])
	c.files[handle] = fileRecord{name, f, info}
	return entry{name, handle}, true
}
func (c *catalog) list() (any, error) {
	if c.listed {
		return nil, limited
	}
	c.listed = true
	dirs, err := c.directory.ReadDir(129)
	if err != nil && err != io.EOF {
		return nil, denied
	}
	if len(dirs) > 128 {
		return nil, limited
	}
	entries := make([]entry, 0, len(dirs))
	for _, d := range dirs {
		if e, ok := c.capture(d); ok {
			entries = append(entries, e)
		}
	}
	return entries, nil
}
func (c *catalog) read(q query) (any, error) {
	r, ok := c.files[q.Handle]
	if !ok {
		return nil, denied
	}
	if q.Limit < 1 || q.Limit > 65536 || q.Offset < 0 || q.Offset > 1<<53-1-int64(q.Limit) {
		return nil, limited
	}
	current := func() bool {
		live, err := c.root.Lstat(r.name)
		if err != nil || !live.Mode().IsRegular() || !os.SameFile(live, r.info) {
			return false
		}
		stat, e := r.file.Stat()
		return e == nil && stat.Size() == r.info.Size() && stat.ModTime().Equal(r.info.ModTime())
	}
	if !current() || q.Offset > r.info.Size() {
		return nil, denied
	}
	buf := make([]byte, q.Limit)
	n, err := r.file.ReadAt(buf, q.Offset)
	if (err != nil && err != io.EOF) || !current() {
		return nil, denied
	}
	return map[string]any{"bytes": buf[:n], "eof": q.Offset+int64(n) == r.info.Size()}, nil
}
func run() error {
	if len(os.Args) != 2 {
		return denied
	}
	c, err := openCatalog(os.Args[1])
	if err != nil {
		return err
	}
	defer c.close()
	out := json.NewEncoder(os.Stdout)
	if err = out.Encode(true); err != nil {
		return err
	}
	scanner := bufio.NewScanner(os.Stdin)
	scanner.Buffer(make([]byte, 512), 2048)
	for scanner.Scan() {
		var q query
		if json.Unmarshal(scanner.Bytes(), &q) != nil {
			return denied
		}
		var value any
		switch q.Op {
		case "list":
			value, err = c.list()
		case "read":
			value, err = c.read(q)
		default:
			return denied
		}
		if err != nil {
			value = map[string]string{"error": err.Error()}
		}
		if err = out.Encode(value); err != nil {
			return err
		}
	}
	return scanner.Err()
}
func main() {
	if run() != nil {
		os.Exit(1)
	}
}
