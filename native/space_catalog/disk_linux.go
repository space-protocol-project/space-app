package main

import (
	"os"
	"strconv"
	"strings"
	"syscall"
)

const readFlags = os.O_RDONLY | syscall.O_NOFOLLOW | syscall.O_NONBLOCK | syscall.O_NOCTTY

func localDisk(f *os.File) bool {
	var s syscall.Statfs_t
	if syscall.Fstatfs(int(f.Fd()), &s) != nil {
		return false
	}
	switch s.Type {
	case 0xef53, 0x01021994, 0x58465342, 0x9123683e, 0x794c7630:
		return true
	}
	return false
}
func mountID(f *os.File) string {
	b, e := os.ReadFile("/proc/self/fdinfo/" + strconv.Itoa(int(f.Fd())))
	if e != nil {
		return ""
	}
	for _, l := range strings.Split(string(b), "\n") {
		if strings.HasPrefix(l, "mnt_id:") {
			return l
		}
	}
	return ""
}
func sameDisk(a, b *os.File) bool { id := mountID(a); return id != "" && id == mountID(b) }

func permittedRoot(string) bool { return true }
