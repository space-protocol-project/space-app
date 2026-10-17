#ifndef RUNNER_NOTIFICATION_ACTIVATION_H_
#define RUNNER_NOTIFICATION_ACTIVATION_H_

#include <flutter/binary_messenger.h>
#include <flutter/method_channel.h>
#include <flutter/encodable_value.h>
#include <windows.h>
#include <memory>
#include <string>
#include <vector>

class NotificationActivation {
 public:
  explicit NotificationActivation(flutter::BinaryMessenger* messenger);
  void Receive(const std::string& token);
  static std::string Parse(const std::vector<std::string>& arguments);
  static bool Forward(const std::string& token);
  static HANDLE InstanceMutex();
  static constexpr ULONG_PTR kCopyData = 0x53504e31;

 private:
  std::unique_ptr<flutter::MethodChannel<flutter::EncodableValue>> channel_;
  std::string pending_;
  bool ready_ = false;
};
#endif
