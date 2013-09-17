#import "objd.h"
#import "GEVec.h"

@class EGEnvironment;
@class EGLight;
@class EGDirectLight;
@protocol EGController;
@protocol EGCamera;

@protocol EGController<NSObject>
- (void)updateWithDelta:(CGFloat)delta;
@end


@protocol EGCamera<NSObject>
- (void)focusForViewSize:(GEVec2)viewSize;
- (GEVec2)translateWithViewSize:(GEVec2)viewSize viewPoint:(GEVec2)viewPoint;
- (GERecti)viewportWithViewSize:(GEVec2)viewSize;
@end


@interface EGEnvironment : NSObject
@property (nonatomic, readonly) GEVec4 ambientColor;
@property (nonatomic, readonly) id<CNSeq> lights;

+ (id)environmentWithAmbientColor:(GEVec4)ambientColor lights:(id<CNSeq>)lights;
- (id)initWithAmbientColor:(GEVec4)ambientColor lights:(id<CNSeq>)lights;
- (ODClassType*)type;
+ (EGEnvironment*)applyLights:(id<CNSeq>)lights;
+ (EGEnvironment*)applyLight:(EGLight*)light;
+ (EGEnvironment*)aDefault;
+ (ODClassType*)type;
@end


@interface EGLight : NSObject
@property (nonatomic, readonly) GEVec4 color;

+ (id)lightWithColor:(GEVec4)color;
- (id)initWithColor:(GEVec4)color;
- (ODClassType*)type;
+ (ODClassType*)type;
@end


@interface EGDirectLight : EGLight
@property (nonatomic, readonly) GEVec3 direction;

+ (id)directLightWithColor:(GEVec4)color direction:(GEVec3)direction;
- (id)initWithColor:(GEVec4)color direction:(GEVec3)direction;
- (ODClassType*)type;
+ (ODClassType*)type;
@end


