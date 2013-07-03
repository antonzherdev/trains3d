#import <Foundation/Foundation.h>
#import "EGTypes.h"


@interface EGEventMac : EGEvent
- (id)initWithEvent:(NSEvent *)event viewSize:(CGSize)viewSize;

+ (id)eventMacWithEvent:(NSEvent *)event viewSize:(CGSize)viewSize;

@end