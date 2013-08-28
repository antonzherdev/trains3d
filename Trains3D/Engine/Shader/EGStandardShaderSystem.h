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

@class EGStandardShaderSystem;
@class EGStandardShaderKey;
@class EGStanda;

@interface EGStandardShaderSystem : NSObject<EGShaderSystem>
+ (id)standardShaderSystem;
- (id)init;
- (EGShader*)shaderForContext:(EGContext*)context material:(EGStandardMaterial*)material;
- (ODType*)type;
+ (ODType*)type;
@end


@interface EGStandardShaderKey : NSObject
@property (nonatomic, readonly) NSUInteger directLightCount;
@property (nonatomic, readonly) BOOL texture;

+ (id)standardShaderKeyWithDirectLightCount:(NSUInteger)directLightCount texture:(BOOL)texture;
- (id)initWithDirectLightCount:(NSUInteger)directLightCount texture:(BOOL)texture;
- (EGShader*)shader;
- (NSString*)lightsVertexUniform;
- (NSString*)lightsVaryings;
- (NSString*)lightsCalculateVaryings;
- (NSString*)lightsFragmentUniform;
- (NSString*)lightsDiffuse;
- (ODType*)type;
+ (ODType*)type;
@end


@interface EGStanda : NSObject
+ (id)standa;
- (id)init;
- (ODType*)type;
+ (ODType*)type;
@end


