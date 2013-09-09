#import "objd.h"
#import "EGShader.h"
#import "EGVec.h"
@class EG;
@class EGContext;
@class EGEnvironment;
@class EGLight;
@class EGDirectLight;
@class EGStandardMaterial;
@class EGColorSource;
@class EGVertexBuffer;
@class EGMatrixStack;
@class EGMatrixModel;
@class EGColorSourceTexture;
@class EGTexture;
@class EGColorSourceColor;
@class EGMatrix;
@class EGSimpleMaterial;

@class EGStandardShaderSystem;
@class EGStandardShaderKey;
@class EGStandardShader;

@interface EGStandardShaderSystem : EGShaderSystem
+ (id)standardShaderSystem;
- (id)init;
- (ODClassType*)type;
- (EGShader*)shaderForMaterial:(EGStandardMaterial*)material;
+ (EGStandardShaderSystem*)instance;
+ (ODClassType*)type;
@end


@interface EGStandardShaderKey : NSObject
@property (nonatomic, readonly) NSUInteger directLightCount;
@property (nonatomic, readonly) BOOL texture;

+ (id)standardShaderKeyWithDirectLightCount:(NSUInteger)directLightCount texture:(BOOL)texture;
- (id)initWithDirectLightCount:(NSUInteger)directLightCount texture:(BOOL)texture;
- (ODClassType*)type;
- (EGStandardShader*)shader;
- (NSString*)lightsVertexUniform;
- (NSString*)lightsVaryings;
- (NSString*)lightsCalculateVaryings;
- (NSString*)lightsFragmentUniform;
- (NSString*)lightsDiffuse;
+ (ODClassType*)type;
@end


@interface EGStandardShader : EGShader
@property (nonatomic, readonly) EGStandardShaderKey* key;
@property (nonatomic, readonly) EGShaderAttribute* positionSlot;
@property (nonatomic, readonly) id normalSlot;
@property (nonatomic, readonly) id uvSlot;
@property (nonatomic, readonly) EGShaderUniform* ambientColor;
@property (nonatomic, readonly) EGShaderUniform* specularColor;
@property (nonatomic, readonly) EGShaderUniform* specularSize;
@property (nonatomic, readonly) EGShaderUniform* diffuseUniform;
@property (nonatomic, readonly) EGShaderUniform* mwcpUniform;
@property (nonatomic, readonly) id mwcUniform;
@property (nonatomic, readonly) id<CNSeq> directLightDirections;
@property (nonatomic, readonly) id<CNSeq> directLightColors;

+ (id)standardShaderWithKey:(EGStandardShaderKey*)key program:(EGShaderProgram*)program;
- (id)initWithKey:(EGStandardShaderKey*)key program:(EGShaderProgram*)program;
- (ODClassType*)type;
- (void)loadVertexBuffer:(EGVertexBuffer*)vertexBuffer material:(EGStandardMaterial*)material;
- (void)unloadMaterial:(EGSimpleMaterial*)material;
+ (NSInteger)UV_SHIFT;
+ (NSInteger)NORMAL_SHIFT;
+ (NSInteger)POSITION_SHIFT;
+ (ODClassType*)type;
@end


