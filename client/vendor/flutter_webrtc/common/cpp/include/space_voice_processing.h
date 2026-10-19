#ifndef SPACE_VOICE_PROCESSING_H
#define SPACE_VOICE_PROCESSING_H
#include "rtc_audio_processing.h"
#include "../../space_voice_signal.h"
#include "../../space_voice_denoiser.h"
#include <mutex>

namespace flutter_webrtc_plugin {
class SpaceVoiceProcessing : public libwebrtc::RTCAudioProcessing::CustomProcessing {
 public:
  SpaceVoiceSignal signal;
  void Initialize(int rate, int) override { rate_ = rate; signal.Reset(); }
  void Reset(int rate) override { rate_ = rate; signal.Reset(); }
  void Release() override { signal.Reset(); }
  void Configure(void* context, SpaceVoiceDenoiseFunction process, void* expected) {
    std::lock_guard<std::mutex> lock(mutex_);
    if (expected && denoiser_.context != expected) return;
    denoiser_ = {context, process, 0};
  }
  bool healthy() {
    std::lock_guard<std::mutex> lock(mutex_);
    return !denoiser_.failed;
  }
  void Process(int, int frames, int size, float* buffer) override {
    if (frames <= 0 || frames > size) return;
    std::lock_guard<std::mutex> lock(mutex_);
    if (!SpaceDenoise(&denoiser_, buffer, frames, rate_)) {
      signal.Reset();
      return;
    }
    signal.Process(buffer, frames);
  }
 private:
  int rate_ = 48000;
  std::mutex mutex_;
  SpaceVoiceDenoiser denoiser_ = {nullptr, nullptr, 0};
};
}
#endif
