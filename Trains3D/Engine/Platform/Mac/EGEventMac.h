#import <Foundation/Foundation.h>
#import "EGProcessor.h"

@class EGOpenGLView;

enum EGEventMacType {
    EGEventTouchBegan = 0x100,
    EGEventTouchMoved = 0x101,
    EGEventTouchEnded = 0x102,
    EGEventTouchCanceled = 0x103,
};

@interface EGEventMac : EGEvent
@property (readonly, nonatomic) NSEvent* event;
@property (readonly, nonatomic, weak) EGOpenGLView* view;

- (id)initWithEvent:(NSEvent *)event type:(NSUInteger)type view:(EGOpenGLView *)view camera:(id)camera;

+ (id)eventMacWithEvent:(NSEvent *)event type:(NSUInteger)type view:(EGOpenGLView *)view camera:(id)camera;
@end