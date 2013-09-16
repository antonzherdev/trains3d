#import "objd.h"
#import "GEVec.h"

@class EGEGEnvironment;
@class EGEGLight;
@class EGEGDirectLight;
@protocol EGController;
@protocol EGCamera;
typedef struct EGColor EGColor;

struct EGColor {
    float r;
    float g;
    float b;
    float a;
};
static inline EGColor EGColorMake(float r, float g, float b, float a) {
    return (EGColor){r, g, b, a};
}
static inline BOOL EGColorEq(EGColor s1, EGColor s2) {
    return eqf4(s1.r, s2.r) && eqf4(s1.g, s2.g) && eqf4(s1.b, s2.b) && eqf4(s1.a, s2.a);
}
static inline NSUInteger EGColorHash(EGColor self) {
    NSUInteger hash = 0;
    hash = hash * 31 + float4Hash(self.r);
    hash = hash * 31 + float4Hash(self.g);
    hash = hash * 31 + float4Hash(self.b);
    hash = hash * 31 + float4Hash(self.a);
    return hash;
}
static inline NSString* EGColorDescription(EGColor self) {
    NSMutableString* description = [NSMutableString stringWithString:@"<EGColor: "];
    [description appendFormat:@"r=%f", self.r];
    [description appendFormat:@", g=%f", self.g];
    [description appendFormat:@", b=%f", self.b];
    [description appendFormat:@", a=%f", self.a];
    [description appendString:@">"];
    return description;
}
EGColor egColorWhite();
ODType* egColorType();
@interface EGColorWrap : NSObject
@property (readonly, nonatomic) EGColor value;

+ (id)wrapWithValue:(EGColor)value;
- (id)initWithValue:(EGColor)value;
@end



@protocol EGController<NSObject>
- (void)updateWithDelta:(CGFloat)delta;
@end


@protocol EGCamera<NSObject>
- (void)focusForViewSize:(GEVec2)viewSize;
- (GEVec2)translateWithViewSize:(GEVec2)viewSize viewPoint:(GEVec2)viewPoint;
@end


@interface EGEGEnvironment : NSObject
@property (nonatomic, readonly) EGColor ambientColor;
@property (nonatomic, readonly) id<CNSeq> lights;

+ (id)environmentWithAmbientColor:(EGColor)ambientColor lights:(id<CNSeq>)lights;
- (id)initWithAmbientColor:(EGColor)ambientColor lights:(id<CNSeq>)lights;
- (ODClassType*)type;
+ (EGEGEnvironment*)applyLights:(id<CNSeq>)lights;
+ (EGEGEnvironment*)applyLight:(EGEGLight*)light;
+ (EGEGEnvironment*)aDefault;
+ (ODType*)type;
@end


@interface EGEGLight : NSObject
@property (nonatomic, readonly) EGColor color;

+ (id)lightWithColor:(EGColor)color;
- (id)initWithColor:(EGColor)color;
- (ODClassType*)type;
+ (ODType*)type;
@end


@interface EGEGDirectLight : EGEGLight
@property (nonatomic, readonly) GEVec3 direction;

+ (id)directLightWithColor:(EGColor)color direction:(GEVec3)direction;
- (id)initWithColor:(EGColor)color direction:(GEVec3)direction;
- (ODClassType*)type;
+ (ODType*)type;
@end


