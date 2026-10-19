#import "AudioProcessingAdapter.h"
#include <stdint.h>

@interface SpaceVoiceProcessing : NSObject <ExternalAudioProcessingDelegate>
@property(nonatomic) float gain;
@property(nonatomic) BOOL transmit;
@property(nonatomic, readonly) float level;
@property(nonatomic, readonly) BOOL healthy;
- (void)configureDenoiser:(uintptr_t)context callback:(uintptr_t)callback expected:(uintptr_t)expected;
@end
