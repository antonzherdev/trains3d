#import "objd.h"
#import "EGMesh.h"
#import "GEVec.h"
#import "GELine.h"
@class EGColorSource;
@class EGGlobal;
@class EGContext;
@class EGEnablingState;

@class EGD3D;

@interface EGD3D : NSObject
- (ODClassType*)type;
+ (void)drawQuadMaterial:(EGColorSource*)material quad3:(GEQuad3)quad3;
+ (void)drawQuadMaterial:(EGColorSource*)material quad3:(GEQuad3)quad3 uv:(GEQuad)uv;
+ (ODClassType*)type;
@end


