#ifndef SPACE_VOICE_DENOISER_H
#define SPACE_VOICE_DENOISER_H
#include <stdint.h>
#include <string.h>

typedef int32_t (*SpaceVoiceDenoiseFunction)(void*, float*, int32_t, int32_t);
typedef struct {
  void* context;
  SpaceVoiceDenoiseFunction process;
  int failed;
} SpaceVoiceDenoiser;

// Владелец сериализует настройку, callback и отсоединение контекста.
static inline int SpaceDenoise(SpaceVoiceDenoiser* engine, float* samples,
                               int frames, int rate) {
  if (!engine->context) return 1;
  if (!engine->failed && engine->process &&
      engine->process(engine->context, samples, frames, rate) == 1) return 1;
  engine->failed = 1;
  memset(samples, 0, (size_t)frames * sizeof(float));
  return 0;
}
#endif
