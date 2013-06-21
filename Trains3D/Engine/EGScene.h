#import <Foundation/Foundation.h>
#import "EGCamera.h"

@interface EGScene : NSObject
@property (nonatomic, retain) EGCamera* camera;

+ (id)scene;
- (id)init;
- (void)reshapeWithSize:(CGSize)size;
- (void)draw;
@end


