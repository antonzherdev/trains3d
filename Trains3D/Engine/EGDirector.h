#import <Foundation/Foundation.h>
#import "EGScene.h"

@interface EGDirector : NSObject
@property (nonatomic, retain) EGScene* scene;

+ (id)director;
- (id)init;
- (void)draw;
- (void)reshapeWithSize:(CGSize)size;
@end


