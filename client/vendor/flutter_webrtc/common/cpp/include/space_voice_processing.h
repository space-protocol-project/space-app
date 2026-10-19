#ifndef SPACE_VOICE_PROCESSING_H
#define SPACE_VOICE_PROCESSING_H
#include "rtc_audio_processing.h"
#include "../../space_voice_signal.h"

namespace flutter_webrtc_plugin {
class SpaceVoiceProcessing : public libwebrtc::RTCAudioProcessing::CustomProcessing {
 public:
  SpaceVoiceSignal signal;
  void Initialize(int, int) override { signal.Reset(); }
  void Reset(int) override { signal.Reset(); }
  void Release() override { signal.Reset(); }
  void Process(int, int frames, int size, float* buffer) override {
    if (frames > 0 && frames <= size) signal.Process(buffer, frames);
  }
};
}
#endif
