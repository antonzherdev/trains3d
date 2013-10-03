#import "objd.h"
#import "EGBillboard.h"
#import "EGMesh.h"
#import "GEVec.h"
@class EGColorSource;
@class EGTexture;

@class EGD2D;
@class EGSprite;
@class EGLine2d;

@interface EGD2D : NSObject
- (ODClassType*)type;
+ (void)drawSpriteMaterial:(EGColorSource*)material at:(GEVec3)at rect:(GERect)rect;
+ (void)drawSpriteMaterial:(EGColorSource*)material at:(GEVec3)at quad:(GEQuad)quad uv:(GEQuad)uv;
+ (void)drawLineMaterial:(EGColorSource*)material p0:(GEVec2)p0 p1:(GEVec2)p1;
+ (ODClassType*)type;
@end


@interface EGSprite : NSObject
@property (nonatomic, retain) EGColorSource* material;
@property (nonatomic) GERect uv;
@property (nonatomic) GEVec2 position;
@property (nonatomic) GEVec2 size;

+ (id)sprite;
- (id)init;
- (ODClassType*)type;
- (void)draw;
- (GERect)rect;
+ (EGSprite*)applyMaterial:(EGColorSource*)material size:(GEVec2)size;
+ (EGSprite*)applyMaterial:(EGColorSource*)material uv:(GERect)uv pixelsInPoint:(float)pixelsInPoint;
- (BOOL)containsVec2:(GEVec2)vec2;
+ (ODClassType*)type;
@end


@interface EGLine2d : NSObject
@property (nonatomic, retain) EGColorSource* material;
@property (nonatomic) GEVec2 p0;
@property (nonatomic) GEVec2 p1;

+ (id)line2d;
- (id)init;
- (ODClassType*)type;
+ (EGLine2d*)applyMaterial:(EGColorSource*)material;
- (void)draw;
+ (ODClassType*)type;
@end


