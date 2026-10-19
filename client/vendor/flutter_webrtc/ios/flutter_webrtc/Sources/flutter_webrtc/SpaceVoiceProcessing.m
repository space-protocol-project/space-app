#import "SpaceVoiceProcessing.h"
#include "space_voice_samples.h"
#include <stdatomic.h>
#include <stdbool.h>
#include "space_voice_denoiser.h"
#import <os/lock.h>

@implementation SpaceVoiceProcessing {
  _Atomic(float) _gain;
  _Atomic(float) _level;
  _Atomic(bool) _transmit;
  os_unfair_lock _denoiseLock;
  SpaceVoiceDenoiser _denoiser;
  int _sampleRate;
}
- (instancetype)init {
  if (self = [super init]) { atomic_init(&_gain, 1); atomic_init(&_level, 0); atomic_init(&_transmit, true); _denoiseLock = (os_unfair_lock)OS_UNFAIR_LOCK_INIT; _denoiser = (SpaceVoiceDenoiser){0}; _sampleRate = 48000; }
  return self;
}
- (float)gain { return atomic_load(&_gain); }
- (void)setGain:(float)gain { atomic_store(&_gain, gain); }
- (BOOL)transmit { return atomic_load(&_transmit); }
- (void)setTransmit:(BOOL)value { atomic_store(&_transmit, value); }
- (float)level { return atomic_load(&_level); }
- (BOOL)healthy {
  os_unfair_lock_lock(&_denoiseLock);
  BOOL value = !_denoiser.failed;
  os_unfair_lock_unlock(&_denoiseLock);
  return value;
}
- (void)configureDenoiser:(uintptr_t)context callback:(uintptr_t)callback expected:(uintptr_t)expected {
  os_unfair_lock_lock(&_denoiseLock);
  if (!expected || _denoiser.context == (void*)expected) {
    _denoiser = (SpaceVoiceDenoiser){(void*)context, (SpaceVoiceDenoiseFunction)callback, 0};
  }
  os_unfair_lock_unlock(&_denoiseLock);
}
- (void)audioProcessingInitializeWithSampleRate:(size_t)rate channels:(size_t)channels {
  _sampleRate = (int)rate;
  atomic_store(&_level, 0);
}
- (void)audioProcessingRelease { atomic_store(&_level, 0); }
- (void)audioProcessingProcess:(RTC_OBJC_TYPE(RTCAudioBuffer)*)buffer {
  float maximum = 0;
  os_unfair_lock_lock(&_denoiseLock);
  if (_denoiser.context && buffer.channels != 1) _denoiser.failed = 1;
  for (size_t channel = 0; channel < buffer.channels; ++channel) {
    if (!SpaceDenoise(&_denoiser, [buffer rawBufferForChannel:channel], (int)buffer.frames, _sampleRate)) continue;
    float level = SpaceApplyVoiceGain([buffer rawBufferForChannel:channel], buffer.frames,
                                     atomic_load(&_gain));
    SpaceMuteVoiceSamples([buffer rawBufferForChannel:channel], buffer.frames, atomic_load(&_transmit));
    if (level > maximum) maximum = level;
  }
  os_unfair_lock_unlock(&_denoiseLock);
  atomic_store(&_level, maximum);
}
@end
