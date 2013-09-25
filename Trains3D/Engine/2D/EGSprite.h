#import "objd.h"
#import "EGMesh.h"
#import "GEVec.h"
@class EGColorSource;
@class EGTexture;

@class EGSprite;

@interface EGSprite : NSObject
@property (nonatomic, retain) EGColorSource* material;
@property (nonatomic) GERect uv;
@property (nonatomic) GEVec2 position;
@property (nonatomic) GEVec2 size;

+ (id)sprite;
- (id)init;
- (ODClassType*)type;
+ (void)drawMaterial:(EGColorSource*)material in:(GERect)in;
+ (void)drawMaterial:(EGColorSource*)material in:(GERect)in uv:(GERect)uv;
- (void)draw;
- (GERect)rect;
+ (EGSprite*)applyMaterial:(EGColorSource*)material size:(GEVec2)size;
+ (EGSprite*)applyMaterial:(EGColorSource*)material uv:(GERect)uv pixelsInPoint:(float)pixelsInPoint;
- (BOOL)containsVec2:(GEVec2)vec2;
+ (ODClassType*)type;
@end


