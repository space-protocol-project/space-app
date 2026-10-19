#ifndef SPACE_VOICE_SIGNAL_H
#define SPACE_VOICE_SIGNAL_H

#include <atomic>
#include <cmath>
#include <cstddef>
#include "space_voice_samples.h"

// Аудио WebRTC в формате FloatS16. Только атомарные поля на аудиопотоке.
class SpaceVoiceSignal {
 public:
  void SetGain(float gain) { gain_.store(gain); }
  void SetTransmit(bool enabled) { transmit_.store(enabled); }
  float level() const { return level_.load(); }
  void Reset() { level_.store(0); }

  void Process(float* samples, size_t frames) {
    level_.store(SpaceApplyVoiceGain(samples, frames, gain_.load()));
    SpaceMuteVoiceSamples(samples, frames, transmit_.load());
  }

 private:
  std::atomic<float> gain_{1};
  std::atomic<float> level_{0};
  std::atomic<bool> transmit_{true};
};
#endif
