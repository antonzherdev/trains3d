#import "TestFlight.h"

@implementation TestFlight
+ (void)addCustomEnvironmentInformation:(NSString *)information forKey:(NSString *)key {

}

+ (void)takeOff:(NSString *)applicationToken {
}

+ (void)setOptions:(NSDictionary *)options {

}

+ (void)passCheckpoint:(NSString *)checkpointName {
    NSLog(@"Stub TestFlight: Checkpoint Passed - %@", checkpointName);
}

+ (void)submitFeedback:(NSString *)feedback {

}

+ (void)setDeviceIdentifier:(NSString *)deviceIdentifer {

}
@end