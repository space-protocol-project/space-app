#import "SpaceVoiceProcessing.h"
#include "space_voice_samples.h"
#include <stdatomic.h>
#include <stdbool.h>

@implementation SpaceVoiceProcessing {
  _Atomic(float) _gain;
  _Atomic(float) _level;
  _Atomic(bool) _transmit;
}
- (instancetype)init {
  if (self = [super init]) { atomic_init(&_gain, 1); atomic_init(&_level, 0); atomic_init(&_transmit, true); }
  return self;
}
- (float)gain { return atomic_load(&_gain); }
- (void)setGain:(float)gain { atomic_store(&_gain, gain); }
- (BOOL)transmit { return atomic_load(&_transmit); }
- (void)setTransmit:(BOOL)value { atomic_store(&_transmit, value); }
- (float)level { return atomic_load(&_level); }
- (void)audioProcessingInitializeWithSampleRate:(size_t)rate channels:(size_t)channels {
  atomic_store(&_level, 0);
}
- (void)audioProcessingRelease { atomic_store(&_level, 0); }
- (void)audioProcessingProcess:(RTC_OBJC_TYPE(RTCAudioBuffer)*)buffer {
  float maximum = 0;
  for (size_t channel = 0; channel < buffer.channels; ++channel) {
    float level = SpaceApplyVoiceGain([buffer rawBufferForChannel:channel], buffer.frames,
                                     atomic_load(&_gain));
    SpaceMuteVoiceSamples([buffer rawBufferForChannel:channel], buffer.frames, atomic_load(&_transmit));
    if (level > maximum) maximum = level;
  }
  atomic_store(&_level, maximum);
}
@end
