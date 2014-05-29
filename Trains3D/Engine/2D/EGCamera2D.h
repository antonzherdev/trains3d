#import "objd.h"
#import "EGScene.h"
#import "GEVec.h"
@class EGMatrixModel;
@class GEMat4;
@class EGImMatrixModel;

@class EGCamera2D;

@interface EGCamera2D : EGCamera_impl {
@protected
    GEVec2 _size;
    CGFloat _viewportRatio;
    EGMatrixModel* _matrixModel;
}
@property (nonatomic, readonly) GEVec2 size;
@property (nonatomic, readonly) CGFloat viewportRatio;
@property (nonatomic, readonly) EGMatrixModel* matrixModel;

+ (instancetype)camera2DWithSize:(GEVec2)size;
- (instancetype)initWithSize:(GEVec2)size;
- (CNClassType*)type;
- (NSString*)description;
+ (CNClassType*)type;
@end


