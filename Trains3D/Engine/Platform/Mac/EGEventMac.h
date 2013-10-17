#import <Foundation/Foundation.h>
#import "EGInput.h"

@class EGOpenGLViewMac;

enum EGEventMacType {
    EGEventTouchBegan = 0x100,
    EGEventTouchMoved = 0x101,
    EGEventTouchEnded = 0x102,
    EGEventTouchCanceled = 0x103,
    EGEventTap = 0x104
};

@interface EGEventMac : EGEvent
@property (readonly, nonatomic) NSEvent* event;
@property (readonly, nonatomic, weak) EGOpenGLViewMac * view;

- (id)initWithEvent:(NSEvent *)event type:(NSUInteger)type view:(EGOpenGLViewMac *)view camera:(id)camera;

+ (id)eventMacWithEvent:(NSEvent *)event type:(NSUInteger)type view:(EGOpenGLViewMac *)view camera:(id)camera;
@end