#import <Foundation/Foundation.h>

@interface EGCamera : NSObject
+ (id)camera;
- (id)init;
- (void)startDraw;
- (void)reshapeWithSize:(CGSize)size;
@end


@interface EGIsometricCamera : EGCamera
@property (readonly, nonatomic) CGPoint center;
@property (readonly, nonatomic) CGSize tilesOnScreen;

+ (id)isometricCameraWithCenter:(CGPoint)center tilesOnScreen:(CGSize)tilesOnScreen;
- (id)initWithCenter:(CGPoint)center tilesOnScreen:(CGSize)tilesOnScreen;
- (void)startDraw;
- (void)reshapeWithSize:(CGSize)size;
@end


