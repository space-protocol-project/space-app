package main

import (
	"os"
	"syscall"
)

const readFlags = os.O_RDONLY | syscall.O_NOFOLLOW | syscall.O_NONBLOCK | syscall.O_NOCTTY

func localDisk(f *os.File) bool {
	var s syscall.Statfs_t
	return syscall.Fstatfs(int(f.Fd()), &s) == nil && s.Flags&0x1000 != 0
}
func sameDisk(a, b *os.File) bool {
	var x, y syscall.Statfs_t
	return syscall.Fstatfs(int(a.Fd()), &x) == nil && syscall.Fstatfs(int(b.Fd()), &y) == nil && x.Fsid == y.Fsid
}
