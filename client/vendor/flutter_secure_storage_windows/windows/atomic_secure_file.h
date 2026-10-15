#pragma once

#include <windows.h>
#include <bcrypt.h>
#include <string>

namespace flutter_secure_storage_windows {

struct SecureFilePart {
  const BYTE* data;
  DWORD size;
};

// Исходная запись остаётся целой до полной записи и синхронизации новой.
inline bool WriteSecureFileAtomically(const std::wstring& destination,
                                     const SecureFilePart* parts,
                                     size_t count) {
  BYTE random[16];
  if (BCryptGenRandom(nullptr, random, sizeof(random),
                      BCRYPT_USE_SYSTEM_PREFERRED_RNG) != 0) return false;
  const wchar_t hex[] = L"0123456789abcdef";
  std::wstring temporary = destination + L".";
  for (BYTE value : random) {
    temporary += hex[value >> 4];
    temporary += hex[value & 15];
  }
  temporary += L".tmp";
  HANDLE file = CreateFileW(temporary.c_str(), GENERIC_WRITE, 0, nullptr,
                            CREATE_NEW, FILE_ATTRIBUTE_NORMAL | FILE_FLAG_WRITE_THROUGH, nullptr);
  if (file == INVALID_HANDLE_VALUE) return false;
  bool complete = true;
  for (size_t index = 0; index < count && complete; ++index) {
    DWORD written = 0;
    complete = WriteFile(file, parts[index].data, parts[index].size, &written, nullptr)
               && written == parts[index].size;
  }
  complete = complete && FlushFileBuffers(file);
  complete = CloseHandle(file) && complete;
  if (complete) {
    complete = MoveFileExW(temporary.c_str(), destination.c_str(),
                           MOVEFILE_REPLACE_EXISTING | MOVEFILE_WRITE_THROUGH) != 0;
  }
  if (!complete) DeleteFileW(temporary.c_str());
  return complete;
}

}  // namespace flutter_secure_storage_windows
