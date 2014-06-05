#import "objd.h"
#import "PGTexture.h"
#import "PGVec.h"
#import "TRRailPoint.h"
#import "PGMesh.h"
@class CNReactFlag;
@class PGGlobal;
@class PGContext;
@class CNVar;
@class TRLevelView;
@class PGCameraIsoMove;
@class TRModels;
@class PGColorSource;
@class PGPlatform;
@class CNChain;
@class TRRailroadState;
@class PGMatrixStack;
@class PGMMatrixModel;
@class TRRailLightState;
@class PGMat4;
@class PGMatrixModel;
@class PGRenderTarget;
@class PGCullFace;
@class TRRailroad;

@class TRLightView;

@interface TRLightView : NSObject {
@public
    CNReactFlag* __matrixChanged;
    CNReactFlag* __matrixShadowChanged;
    CNReactFlag* __lightGlowChanged;
    NSUInteger __lastId;
    NSUInteger __lastShadowId;
    NSArray* __matrixArr;
    PGMeshUnite* _bodies;
    PGMeshUnite* _shadows;
    PGMeshUnite* _glows;
}
+ (instancetype)lightViewWithLevelView:(TRLevelView*)levelView railroad:(TRRailroad*)railroad;
- (instancetype)initWithLevelView:(TRLevelView*)levelView railroad:(TRRailroad*)railroad;
- (CNClassType*)type;
- (void)drawBodiesRrState:(TRRailroadState*)rrState;
- (void)drawShadowRrState:(TRRailroadState*)rrState;
- (void)drawGlows;
- (NSString*)description;
+ (CNClassType*)type;
@end


