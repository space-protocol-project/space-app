#import "AudioProcessingAdapter.h"

@interface SpaceVoiceProcessing : NSObject <ExternalAudioProcessingDelegate>
@property(nonatomic) float gain;
@property(nonatomic) BOOL transmit;
@property(nonatomic, readonly) float level;
@end
