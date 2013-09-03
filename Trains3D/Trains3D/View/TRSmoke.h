#import "objd.h"
@class CNPArray;
@class CNPArrayIterator;
@class CNMutablePArray;
@class EG;
#import "EGGL.h"
#import "EGTypes.h"
@class EGBuffer;
@class EGVertexBuffer;
@class EGIndexBuffer;
@class EGShaderProgram;
@class EGShader;
@class EGShaderAttribute;
@class EGShaderUniform;
@protocol EGShaderSystem;
@class EGContext;
@class EGMutableMatrix;
@class EGTexture;
@class EGFileTexture;
@class EGMatrix;
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
@property (nonatomic) EGVec3 position;
@property (nonatomic) EGVec3 speed;
@property (nonatomic) CGFloat time;

+ (id)smokeParticle;
- (id)init;
- (ODClassType*)type;
- (void)updateWithDelta:(CGFloat)delta;
- (BOOL)isLive;
+ (NSInteger)lifeTime;
+ (CGFloat)dragCoefficient;
+ (ODClassType*)type;
@end


struct TRSmokeBufferData {
    float x;
    float y;
    float z;
    float uvx;
    float uvy;
};
static inline TRSmokeBufferData TRSmokeBufferDataMake(float x, float y, float z, float uvx, float uvy) {
    TRSmokeBufferData ret;
    ret.x = x;
    ret.y = y;
    ret.z = z;
    ret.uvx = uvx;
    ret.uvy = uvy;
    return ret;
}
static inline BOOL TRSmokeBufferDataEq(TRSmokeBufferData s1, TRSmokeBufferData s2) {
    return eqf4(s1.x, s2.x) && eqf4(s1.y, s2.y) && eqf4(s1.z, s2.z) && eqf4(s1.uvx, s2.uvx) && eqf4(s1.uvy, s2.uvy);
}
static inline NSUInteger TRSmokeBufferDataHash(TRSmokeBufferData self) {
    NSUInteger hash = 0;
    hash = hash * 31 + float4Hash(self.x);
    hash = hash * 31 + float4Hash(self.y);
    hash = hash * 31 + float4Hash(self.z);
    hash = hash * 31 + float4Hash(self.uvx);
    hash = hash * 31 + float4Hash(self.uvy);
    return hash;
}
static inline NSString* TRSmokeBufferDataDescription(TRSmokeBufferData self) {
    NSMutableString* description = [NSMutableString stringWithString:@"<TRSmokeBufferData: "];
    [description appendFormat:@"x=%f", self.x];
    [description appendFormat:@", y=%f", self.y];
    [description appendFormat:@", z=%f", self.z];
    [description appendFormat:@", uvx=%f", self.uvx];
    [description appendFormat:@", uvy=%f", self.uvy];
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
@property (nonatomic, readonly) EGFileTexture* texture;

+ (id)smokeView;
- (id)init;
- (ODClassType*)type;
- (void)drawSmoke:(TRSmoke*)smoke;
+ (ODClassType*)type;
@end


@interface TRSmokeShader : NSObject
@property (nonatomic, readonly) EGShaderProgram* program;
@property (nonatomic, readonly) EGShaderAttribute* positionSlot;
@property (nonatomic, readonly) EGShaderAttribute* uvSlot;
@property (nonatomic, readonly) EGMatrix* m;
@property (nonatomic, readonly) EGShaderUniform* wcpUniform;
@property (nonatomic, readonly) EGShaderUniform* mUniform;

+ (id)smokeShader;
- (id)init;
- (ODClassType*)type;
- (void)applyTexture:(EGFileTexture*)texture positionBuffer:(EGVertexBuffer*)positionBuffer draw:(void(^)())draw;
+ (NSString*)vertex;
+ (NSString*)fragment;
+ (TRSmokeShader*)instance;
+ (ODClassType*)type;
@end


