package main

import (
	"os"
	"path/filepath"
	"strings"
	"syscall"
	"unsafe"
)

const readFlags = os.O_RDONLY

var kernel = syscall.NewLazyDLL("kernel32.dll")

func localDisk(f *os.File) bool {
	buf := make([]uint16, 32768)
	n, _, _ := kernel.NewProc("GetFinalPathNameByHandleW").Call(f.Fd(), uintptr(unsafe.Pointer(&buf[0])), uintptr(len(buf)), 0)
	if n == 0 || n >= uintptr(len(buf)) {
		return false
	}
	name := strings.TrimPrefix(syscall.UTF16ToString(buf[:n]), `\\?\`)
	return permittedRoot(name)
}

func permittedRoot(name string) bool {
	vol := filepath.VolumeName(name)
	if len(vol) != 2 {
		return false
	}
	path, _ := syscall.UTF16PtrFromString(vol + `\`)
	kind, _, _ := kernel.NewProc("GetDriveTypeW").Call(uintptr(unsafe.Pointer(path)))
	return kind == 3
}
func sameDisk(a, b *os.File) bool {
	var x, y syscall.ByHandleFileInformation
	return syscall.GetFileInformationByHandle(syscall.Handle(a.Fd()), &x) == nil && syscall.GetFileInformationByHandle(syscall.Handle(b.Fd()), &y) == nil && x.VolumeSerialNumber == y.VolumeSerialNumber && y.FileAttributes&syscall.FILE_ATTRIBUTE_REPARSE_POINT == 0
}
