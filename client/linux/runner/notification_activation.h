#ifndef SPACE_NOTIFICATION_ACTIVATION_H_
#define SPACE_NOTIFICATION_ACTIVATION_H_
#include <flutter_linux/flutter_linux.h>
#include <gio/gio.h>
#include <string>

class NotificationActivation {
 public:
  NotificationActivation(GApplication* application, FlBinaryMessenger* messenger);
  ~NotificationActivation();
  void Receive(const gchar* token);
  static bool Valid(const gchar* token);
 private:
  void Handle(FlMethodCall* call);
  void Show(FlMethodCall* call);
  void Clear(FlMethodCall* call);
  GApplication* application_;
  FlMethodChannel* channel_;
  std::string pending_;
  bool ready_ = false;
};
#endif
