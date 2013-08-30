#import "objd.h"
#import "EGShader.h"
@class EGColorSource;
@class EGColorSourceColor;
@class EGColorSourceTexture;
@class EGMaterial2;
@class EGSimpleMaterial;
@class EGStandardMaterial;
@class EGMaterial;
@class EGContext;
@class EGMutableMatrix;
#import "EGTypes.h"
@class EGTexture;
#import "EGGL.h"

@class EGStandardShaderSystem;
@class EGStandardShaderKey;
@class EGStandardShader;

@interface EGStandardShaderSystem : NSObject<EGShaderSystem>
+ (id)standardShaderSystem;
- (id)init;
- (EGShader*)shaderForContext:(EGContext*)context material:(EGStandardMaterial*)material;
- (ODType*)type;
+ (EGStandardShaderSystem*)instance;
+ (ODType*)type;
@end


@interface EGStandardShaderKey : NSObject
@property (nonatomic, readonly) NSUInteger directLightCount;
@property (nonatomic, readonly) BOOL texture;

+ (id)standardShaderKeyWithDirectLightCount:(NSUInteger)directLightCount texture:(BOOL)texture;
- (id)initWithDirectLightCount:(NSUInteger)directLightCount texture:(BOOL)texture;
- (EGStandardShader*)shader;
- (NSString*)lightsVertexUniform;
- (NSString*)lightsVaryings;
- (NSString*)lightsCalculateVaryings;
- (NSString*)lightsFragmentUniform;
- (NSString*)lightsDiffuse;
- (ODType*)type;
+ (ODType*)type;
@end


@interface EGStandardShader : EGShader
@property (nonatomic, readonly) EGStandardShaderKey* key;
@property (nonatomic, readonly) EGShaderAttribute* positionSlot;
@property (nonatomic, readonly) id normalSlot;
@property (nonatomic, readonly) id uvSlot;
@property (nonatomic, readonly) EGShaderUniform* ambientColor;
@property (nonatomic, readonly) EGShaderUniform* diffuseUniform;
@property (nonatomic, readonly) EGShaderUniform* mwcpUniform;
@property (nonatomic, readonly) id mUniform;
@property (nonatomic, readonly) id<CNSeq> directLightDirections;
@property (nonatomic, readonly) id<CNSeq> directLightColors;

+ (id)standardShaderWithKey:(EGStandardShaderKey*)key program:(EGShaderProgram*)program;
- (id)initWithKey:(EGStandardShaderKey*)key program:(EGShaderProgram*)program;
- (void)loadContext:(EGContext*)context material:(EGStandardMaterial*)material;
- (ODType*)type;
+ (NSInteger)STRIDE;
+ (NSInteger)UV_SHIFT;
+ (NSInteger)NORMAL_SHIFT;
+ (NSInteger)POSITION_SHIFT;
+ (ODType*)type;
@end


