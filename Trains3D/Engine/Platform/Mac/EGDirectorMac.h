#import <Foundation/Foundation.h>
#import "EGDirector.h"

@class EGOpenGLView;

@interface EGDirectorMac : EGDirector
@property (readonly, assign) EGOpenGLView* view;

- (id)initWithView:(__unsafe_unretained EGOpenGLView *)view;

+ (id)directorWithView:(__unsafe_unretained EGOpenGLView *)view;

@end