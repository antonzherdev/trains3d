#import "objd.h"
@class CNPArray;
@class CNPArrayIterator;
@class CNMutablePArray;
@class EG;
@class EGContext;
@class EGMatrixStack;
@class EGMatrixModel;
#import "EGGL.h"
#import "EGTypes.h"
@class EGShaderProgram;
@class EGShader;
@class EGShaderAttribute;
@class EGShaderUniform;
@protocol EGShaderSystem;
@class EGTexture;
@class EGFileTexture;
@class EGMatrix;
@class EGSurface;
@class EGSurfaceShader;
@class EGMesh;
@class EGBuffer;
@class EGVertexBuffer;
@class EGIndexBuffer;
#import "EGVec.h"
#import "EGBillboard.h"
@class TRTrainType;
@class TRTrain;
@class TREngineType;
@class TRCarType;
@class TRCar;
@class TRTrainGenerator;
@class TRRailConnector;
@class TRRailForm;
@class TRRailPoint;
@class TRRailPointCorrection;
@class EGColorSource;
@class EGColorSourceColor;
@class EGColorSourceTexture;
@class EGMaterial;
@class EGSimpleMaterial;
@class EGStandardMaterial;
@class EGMeshModel;

@class TRSmoke;
@class TRSmokeParticle;
@class TRSmokeView;
@class TRSmokeShader;
typedef struct TRSmokeBufferData TRSmokeBufferData;

@interface TRSmoke : NSObject<EGController>
@property (nonatomic, readonly, weak) TRTrain* train;

+ (id)smokeWithTrain:(TRTrain*)train;
- (id)initWithTrain:(TRTrain*)train;
- (ODClassType*)type;
- (CNList*)particles;
- (void)updateWithDelta:(CGFloat)delta;
- (void)createParticle;
+ (ODClassType*)type;
@end


@interface TRSmokeParticle : NSObject<EGController>
@property (nonatomic, readonly) NSInteger texture;
@property (nonatomic) EGVec3 position;
@property (nonatomic) EGVec3 speed;
@property (nonatomic) CGFloat time;

+ (id)smokeParticleWithTexture:(NSInteger)texture;
- (id)initWithTexture:(NSInteger)texture;
- (ODClassType*)type;
- (void)updateWithDelta:(CGFloat)delta;
- (BOOL)isLive;
+ (NSInteger)lifeTime;
+ (NSInteger)dragCoefficient;
+ (ODClassType*)type;
@end


struct TRSmokeBufferData {
    float x;
    float y;
    float z;
    float uvx;
    float uvy;
    float time;
    float textureX;
    float textureY;
};
static inline TRSmokeBufferData TRSmokeBufferDataMake(float x, float y, float z, float uvx, float uvy, float time, float textureX, float textureY) {
    TRSmokeBufferData ret;
    ret.x = x;
    ret.y = y;
    ret.z = z;
    ret.uvx = uvx;
    ret.uvy = uvy;
    ret.time = time;
    ret.textureX = textureX;
    ret.textureY = textureY;
    return ret;
}
static inline BOOL TRSmokeBufferDataEq(TRSmokeBufferData s1, TRSmokeBufferData s2) {
    return eqf4(s1.x, s2.x) && eqf4(s1.y, s2.y) && eqf4(s1.z, s2.z) && eqf4(s1.uvx, s2.uvx) && eqf4(s1.uvy, s2.uvy) && eqf4(s1.time, s2.time) && eqf4(s1.textureX, s2.textureX) && eqf4(s1.textureY, s2.textureY);
}
static inline NSUInteger TRSmokeBufferDataHash(TRSmokeBufferData self) {
    NSUInteger hash = 0;
    hash = hash * 31 + float4Hash(self.x);
    hash = hash * 31 + float4Hash(self.y);
    hash = hash * 31 + float4Hash(self.z);
    hash = hash * 31 + float4Hash(self.uvx);
    hash = hash * 31 + float4Hash(self.uvy);
    hash = hash * 31 + float4Hash(self.time);
    hash = hash * 31 + float4Hash(self.textureX);
    hash = hash * 31 + float4Hash(self.textureY);
    return hash;
}
static inline NSString* TRSmokeBufferDataDescription(TRSmokeBufferData self) {
    NSMutableString* description = [NSMutableString stringWithString:@"<TRSmokeBufferData: "];
    [description appendFormat:@"x=%f", self.x];
    [description appendFormat:@", y=%f", self.y];
    [description appendFormat:@", z=%f", self.z];
    [description appendFormat:@", uvx=%f", self.uvx];
    [description appendFormat:@", uvy=%f", self.uvy];
    [description appendFormat:@", time=%f", self.time];
    [description appendFormat:@", textureX=%f", self.textureX];
    [description appendFormat:@", textureY=%f", self.textureY];
    [description appendString:@">"];
    return description;
}
ODPType* trSmokeBufferDataType();
@interface TRSmokeBufferDataWrap : NSObject
@property (readonly, nonatomic) TRSmokeBufferData value;

+ (id)wrapWithValue:(TRSmokeBufferData)value;
- (id)initWithValue:(TRSmokeBufferData)value;
@end



@interface TRSmokeView : NSObject
@property (nonatomic, readonly) EGVertexBuffer* positionBuffer;
@property (nonatomic, readonly) EGIndexBuffer* indexBuffer;
@property (nonatomic, readonly) TRSmokeShader* shader;
@property (nonatomic, readonly) EGSimpleMaterial* texture;

+ (id)smokeView;
- (id)init;
- (ODClassType*)type;
- (void)begin;
- (void)end;
- (void)drawSmoke:(TRSmoke*)smoke;
+ (CGFloat)particleSize;
+ (ODClassType*)type;
@end


@interface TRSmokeShader : EGBillboardShader
@property (nonatomic, readonly) EGShaderAttribute* lifeSlot;

+ (id)smokeShader;
- (id)init;
- (ODClassType*)type;
- (void)loadVertexBuffer:(EGVertexBuffer*)vertexBuffer material:(EGSimpleMaterial*)material;
+ (NSString*)vertex;
+ (NSString*)fragment;
+ (TRSmokeShader*)instance;
+ (ODClassType*)type;
@end


