#include "notification_activation.h"
#include <cstring>

namespace {
const gchar* Field(FlValue* args, const gchar* key) {
  if (!args || fl_value_get_type(args) != FL_VALUE_TYPE_MAP) return nullptr;
  FlValue* value = fl_value_lookup_string(args, key);
  return value && fl_value_get_type(value) == FL_VALUE_TYPE_STRING
      ? fl_value_get_string(value) : nullptr;
}
void Success(FlMethodCall* call, FlValue* value = nullptr) {
  fl_method_call_respond_success(call, value, nullptr);
}
}  // namespace

bool NotificationActivation::Valid(const gchar* token) {
  if (!token || strlen(token) != 32) return false;
  for (int i = 0; i < 32; ++i) {
    if (!(token[i] >= '0' && token[i] <= '9') &&
        !(token[i] >= 'a' && token[i] <= 'f')) return false;
  }
  return true;
}

NotificationActivation::NotificationActivation(GApplication* application,
    FlBinaryMessenger* messenger) : application_(application) {
  g_autoptr(FlStandardMethodCodec) codec = fl_standard_method_codec_new();
  channel_ = fl_method_channel_new(messenger, "space/notification-activation", FL_METHOD_CODEC(codec));
  fl_method_channel_set_method_call_handler(channel_, [](FlMethodChannel*, FlMethodCall* call, gpointer data) {
    static_cast<NotificationActivation*>(data)->Handle(call);
  }, this, nullptr);
}

NotificationActivation::~NotificationActivation() {
  fl_method_channel_set_method_call_handler(channel_, nullptr, nullptr, nullptr);
  g_clear_object(&channel_);
}

void NotificationActivation::Receive(const gchar* token) {
  if (!Valid(token)) return;
  if (!ready_) { pending_ = token; return; }
  g_autoptr(FlValue) value = fl_value_new_string(token);
  fl_method_channel_invoke_method(channel_, "activate", value, nullptr, nullptr, nullptr);
}

void NotificationActivation::Handle(FlMethodCall* call) {
  const gchar* method = fl_method_call_get_name(call);
  if (strcmp(method, "initialize") == 0) {
    Success(call);
  } else if (strcmp(method, "permission") == 0) {
    g_autoptr(FlValue) value = fl_value_new_bool(TRUE);
    Success(call, value);
  } else if (strcmp(method, "initial") == 0) {
    ready_ = true;
    g_autoptr(FlValue) value = fl_value_new_string(pending_.c_str());
    pending_.clear();
    Success(call, value);
  } else if (strcmp(method, "show") == 0) {
    Show(call);
  } else if (strcmp(method, "clear") == 0) {
    Clear(call);
  } else {
    fl_method_call_respond_not_implemented(call, nullptr);
  }
}

void NotificationActivation::Show(FlMethodCall* call) {
  FlValue* args = fl_method_call_get_args(call);
  const auto token = Field(args, "token"), title = Field(args, "title"), body = Field(args, "body");
  const auto tag = Field(args, "tag"), action = Field(args, "actionLabel");
  if (!Valid(token) || !title || !body || !tag || strlen(tag) > 16 || !action) {
    fl_method_call_respond_error(call, "notification", "Invalid notification", nullptr, nullptr);
    return;
  }
  g_autoptr(GNotification) notice = g_notification_new(title);
  g_notification_set_body(notice, body);
  g_notification_set_default_action_and_target(notice, "app.open-notification", "s", token);
  g_notification_add_button_with_target(notice, action, "app.open-notification", "s", token);
  g_autoptr(GIcon) icon = g_themed_icon_new("org.spaceprotocol.space_client");
  g_notification_set_icon(notice, icon);
  const auto identifier = std::string("space-") + tag;
  g_application_send_notification(application_, identifier.c_str(), notice);
  Success(call);
}

void NotificationActivation::Clear(FlMethodCall* call) {
  FlValue* args = fl_method_call_get_args(call);
  FlValue* ids = args && fl_value_get_type(args) == FL_VALUE_TYPE_MAP
      ? fl_value_lookup_string(args, "ids") : nullptr;
  if (ids && fl_value_get_type(ids) == FL_VALUE_TYPE_LIST && fl_value_get_length(ids) <= 64) {
    for (size_t i = 0; i < fl_value_get_length(ids); ++i) {
      FlValue* id = fl_value_get_list_value(ids, i);
      if (fl_value_get_type(id) != FL_VALUE_TYPE_INT) continue;
      const auto identifier = std::string("space-") + std::to_string(fl_value_get_int(id));
      g_application_withdraw_notification(application_, identifier.c_str());
    }
  }
  Success(call);
}
