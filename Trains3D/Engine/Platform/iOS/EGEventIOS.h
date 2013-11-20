#import <Foundation/Foundation.h>
#import "EGInput.h"

@class EGOpenGLViewIOS;


@interface EGEventIOS : EGEvent
@property (readonly, nonatomic, weak) EGOpenGLViewIOS * view;

- (instancetype)initWithTp:(EGRecognizerType *)tp phase:(EGEventPhase *)phase location:(GEVec2)location view:(__weak EGOpenGLViewIOS *)view camera:(id)camera;

+ (instancetype)eventIOsWithTp:(EGRecognizerType *)tp phase:(EGEventPhase *)phase location:(GEVec2)location view:(__weak EGOpenGLViewIOS *)view camera:(id)camera;


@end