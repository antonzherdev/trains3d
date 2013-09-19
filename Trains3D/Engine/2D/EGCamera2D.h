#import "objd.h"
#import "EGScene.h"
#import "GEVec.h"
@class EGMatrixModel;
@class GEMat4;

@class EGCamera2D;

@interface EGCamera2D : NSObject<EGCamera>
@property (nonatomic, readonly) GEVec2 size;
@property (nonatomic, readonly) EGMatrixModel* matrixModel;

+ (id)camera2DWithSize:(GEVec2)size;
- (id)initWithSize:(GEVec2)size;
- (ODClassType*)type;
- (GERecti)viewportWithViewSize:(GEVec2)viewSize;
+ (ODClassType*)type;
@end


