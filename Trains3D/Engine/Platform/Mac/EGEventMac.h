#import <Foundation/Foundation.h>
#import "EGProcessor.h"


@interface EGEventMac : EGEvent
- (id)initWithEvent:(NSEvent *)event locationInView:(CGPoint)locationInView viewSize:(CGSize)viewSize camera:(id)camera;

+ (id)eventMacWithEvent:(NSEvent *)event locationInView:(CGPoint)locationInWindow viewSize:(CGSize)viewSize camera:(id)camera;
@end