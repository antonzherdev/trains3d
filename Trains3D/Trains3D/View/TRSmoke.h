#import "objd.h"
@class CNPArray;
@class CNPArrayIterator;
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
@class EGShaderSystem;
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
#import "EGParticleSystem.h"
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
#import "CNTypes.h"
@class EGColorSource;
@class EGColorSourceColor;
@class EGColorSourceTexture;
@class EGMaterial;
@class EGSimpleMaterial;
@class EGStandardMaterial;
@class EGMeshModel;
#import "CNVoidRefArray.h"

@class TRSmoke;
@class TRSmokeParticle;
@class TRSmokeView;
typedef struct TRSmokeBufferData TRSmokeBufferData;

@interface TRSmoke : EGParticleSystem
@property (nonatomic, readonly, weak) TRTrain* train;

+ (id)smokeWithTrain:(TRTrain*)train;
- (id)initWithTrain:(TRTrain*)train;
- (ODClassType*)type;
- (void)generateParticlesWithDelta:(CGFloat)delta;
- (TRSmokeParticle*)generateParticle;
+ (ODClassType*)type;
@end


@interface TRSmokeParticle : EGParticle
@property (nonatomic, readonly) NSInteger texture;
@property (nonatomic) EGVec3 position;
@property (nonatomic) EGVec3 speed;

+ (id)smokeParticleWithTexture:(NSInteger)texture;
- (id)initWithTexture:(NSInteger)texture;
- (ODClassType*)type;
- (void)updateWithDelta:(CGFloat)delta;
- (CNVoidRefArray)writeToArray:(CNVoidRefArray)array;
+ (NSInteger)dragCoefficient;
+ (float)particleSize;
+ (EGVec4)defColor;
+ (ODClassType*)type;
@end


struct TRSmokeBufferData {
    EGVec3 position;
    EGVec2 model;
    EGVec4 color;
    EGVec2 uv;
};
static inline TRSmokeBufferData TRSmokeBufferDataMake(EGVec3 position, EGVec2 model, EGVec4 color, EGVec2 uv) {
    return (TRSmokeBufferData){position, model, color, uv};
}
static inline BOOL TRSmokeBufferDataEq(TRSmokeBufferData s1, TRSmokeBufferData s2) {
    return EGVec3Eq(s1.position, s2.position) && EGVec2Eq(s1.model, s2.model) && EGVec4Eq(s1.color, s2.color) && EGVec2Eq(s1.uv, s2.uv);
}
static inline NSUInteger TRSmokeBufferDataHash(TRSmokeBufferData self) {
    NSUInteger hash = 0;
    hash = hash * 31 + EGVec3Hash(self.position);
    hash = hash * 31 + EGVec2Hash(self.model);
    hash = hash * 31 + EGVec4Hash(self.color);
    hash = hash * 31 + EGVec2Hash(self.uv);
    return hash;
}
static inline NSString* TRSmokeBufferDataDescription(TRSmokeBufferData self) {
    NSMutableString* description = [NSMutableString stringWithString:@"<TRSmokeBufferData: "];
    [description appendFormat:@"position=%@", EGVec3Description(self.position)];
    [description appendFormat:@", model=%@", EGVec2Description(self.model)];
    [description appendFormat:@", color=%@", EGVec4Description(self.color)];
    [description appendFormat:@", uv=%@", EGVec2Description(self.uv)];
    [description appendString:@">"];
    return description;
}
ODPType* trSmokeBufferDataType();
@interface TRSmokeBufferDataWrap : NSObject
@property (readonly, nonatomic) TRSmokeBufferData value;

+ (id)wrapWithValue:(TRSmokeBufferData)value;
- (id)initWithValue:(TRSmokeBufferData)value;
@end



@interface TRSmokeView : EGParticleSystemView
@property (nonatomic, readonly) EGBillboardShader* shader;
@property (nonatomic, readonly) EGSimpleMaterial* material;

+ (id)smokeView;
- (id)init;
- (ODClassType*)type;
- (NSUInteger)vertexCount;
+ (ODClassType*)type;
@end


