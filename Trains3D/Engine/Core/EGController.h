#import "objd.h"

@class EGUpdatable_impl;
@class EGController_impl;
@protocol EGUpdatable;
@protocol EGController;

@protocol EGUpdatable<NSObject>
- (void)updateWithDelta:(CGFloat)delta;
- (NSString*)description;
@end


@interface EGUpdatable_impl : NSObject<EGUpdatable>
+ (instancetype)updatable_impl;
- (instancetype)init;
@end


@protocol EGController<EGUpdatable>
- (void)start;
- (void)stop;
- (NSString*)description;
@end


@interface EGController_impl : EGUpdatable_impl<EGController>
+ (instancetype)controller_impl;
- (instancetype)init;
@end


