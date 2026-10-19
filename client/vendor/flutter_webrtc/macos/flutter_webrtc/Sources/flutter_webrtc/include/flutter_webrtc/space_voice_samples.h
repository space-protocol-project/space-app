#ifndef SPACE_VOICE_SAMPLES_H
#define SPACE_VOICE_SAMPLES_H
#include <math.h>
#include <stddef.h>

// WebRTC FloatS16; возвращает RMS в диапазоне 0..1 после усиления.
static inline float SpaceApplyVoiceGain(float* samples, size_t frames, float gain) {
  double energy = 0;
  for (size_t i = 0; i < frames; ++i) {
    float value = samples[i] * gain;
    if (!isfinite(value)) value = 0;
    if (value > 32767) value = 32767;
    if (value < -32768) value = -32768;
    samples[i] = value;
    energy += (double)value * value;
  }
  return frames == 0 ? 0 : (float)(sqrt(energy / frames) / 32768);
}

// Измерение выполняется до закрытия передачи, чтобы речь могла открыть её снова.
static inline void SpaceMuteVoiceSamples(float* samples, size_t frames, int transmit) {
  if (transmit) return;
  for (size_t i = 0; i < frames; ++i) samples[i] = 0;
}
#endif
