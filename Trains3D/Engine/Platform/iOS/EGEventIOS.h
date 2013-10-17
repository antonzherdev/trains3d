#import <Foundation/Foundation.h>
#import "EGInput.h"

@class EGOpenGLViewIOS;

enum EGEventIOSType {
    EGEventTouchBegan = 0x100,
    EGEventTouchMoved = 0x101,
    EGEventTouchEnded = 0x102,
    EGEventTouchCanceled = 0x103,
    EGEventTap = 0x104,
};
typedef  enum EGEventIOSType EGEventIOSType;

@interface EGEventIOS : EGEvent
@property (readonly, nonatomic) UIEvent* event;
@property (readonly, nonatomic) NSSet* touches;
@property (readonly, nonatomic, weak) EGOpenGLViewIOS * view;

@property(nonatomic, strong) UIGestureRecognizer *recognizer;

- (id)initWithEvent:(UIEvent *)event recognizer:(UIGestureRecognizer *)recognizer type:(EGEventIOSType)type view:(EGOpenGLViewIOS *)view camera:(id)camera;

+ (id)eventIOSWithEvent:(UIEvent *)event type:(EGEventIOSType)type view:(EGOpenGLViewIOS *)view camera:(id)camera;
+ (id)eventIOSWithRecognizer:(UIGestureRecognizer *)recognizer type:(EGEventIOSType)type view:(EGOpenGLViewIOS *)view camera:(id)camera;
@end