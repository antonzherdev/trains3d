#import <Foundation/Foundation.h>
#import "EGDirector.h"

@class EGOpenGLViewMac;

@interface EGDirectorMac : EGDirector
@property (readonly, assign) EGOpenGLViewMac * view;

- (id)initWithView:(__unsafe_unretained EGOpenGLViewMac *)view;

+ (id)directorWithView:(__unsafe_unretained EGOpenGLViewMac *)view;

@end