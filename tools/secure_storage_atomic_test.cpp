#include "../client/vendor/flutter_secure_storage_windows/windows/atomic_secure_file.h"
#include <iostream>
#define REQUIRE(condition) do { if (!(condition)) { std::cerr << __LINE__ << ": Windows error " << GetLastError() << std::endl; return 1; } } while (false)
#include <filesystem>
#include <fstream>
#include <iterator>

#pragma comment(lib, "bcrypt.lib")

using flutter_secure_storage_windows::SecureFilePart;
using flutter_secure_storage_windows::WriteSecureFileAtomically;

std::string Read(const std::filesystem::path& path) {
  std::ifstream input(path, std::ios::binary);
  return {std::istreambuf_iterator<char>(input), std::istreambuf_iterator<char>()};
}

int wmain(int argc, wchar_t** argv) {
  REQUIRE(argc == 2);
  const std::filesystem::path directory(argv[1]);
  std::filesystem::create_directories(directory);
  const auto path = directory / L"test.secure";
  const BYTE first[] = {1, 2, 3};
  const BYTE second[] = {4, 5};
  const SecureFilePart old[] = {{first, sizeof(first)}};
  const SecureFilePart next[] = {{second, sizeof(second)}, {first, sizeof(first)}};
  REQUIRE(WriteSecureFileAtomically(path.wstring(), old, 1));
  const auto original = Read(path);
  HANDLE locked = CreateFileW(path.c_str(), GENERIC_READ, FILE_SHARE_READ | FILE_SHARE_WRITE,
                              nullptr, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, nullptr);
  REQUIRE(locked != INVALID_HANDLE_VALUE);
  REQUIRE(!WriteSecureFileAtomically(path.wstring(), next, 2));
  REQUIRE(Read(path) == original);
  REQUIRE(CloseHandle(locked));

  HANDLE reader = CreateFileW(path.c_str(), GENERIC_READ,
      FILE_SHARE_READ | FILE_SHARE_WRITE | FILE_SHARE_DELETE,
      nullptr, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, nullptr);
  REQUIRE(reader != INVALID_HANDLE_VALUE);
  const bool replaced = WriteSecureFileAtomically(path.wstring(), next, 2);
  BYTE bytes[3]{};
  DWORD count = 0;
  REQUIRE(ReadFile(reader, bytes, sizeof(bytes), &count, nullptr));
  REQUIRE(count == 3 && bytes[0] == 1 && bytes[2] == 3);
  REQUIRE(CloseHandle(reader));
  if (!replaced) {
    REQUIRE(Read(path) == original);
    REQUIRE(WriteSecureFileAtomically(path.wstring(), next, 2));
  }
  REQUIRE(Read(path) == std::string("\x04\x05\x01\x02\x03", 5));
  size_t files = 0;
  for (const auto& entry : std::filesystem::directory_iterator(directory)) {
    REQUIRE(entry.path() == path);
    ++files;
  }
  REQUIRE(files == 1);
}
