#import "objd.h"
#import "GEVec.h"
@class EGShaderSystem;
@class EGMesh;
@protocol EGVertexBuffer;
@protocol EGIndexSource;
@class EGShader;
@class EGTexture;
@class EGSimpleShaderSystem;
@class EGStandardShaderSystem;
@class EGGlobal;
@class EGContext;
@class EGEnablingState;

@class EGMaterial;
@class EGColorSource;
@class EGStandardMaterial;
@class EGNormalMap;
@class EGBlendFunction;
@class EGBlendMode;

@interface EGMaterial : NSObject
+ (instancetype)material;
- (instancetype)init;
- (ODClassType*)type;
- (EGShaderSystem*)shaderSystem;
- (void)drawMesh:(EGMesh*)mesh;
- (void)drawVertex:(id<EGVertexBuffer>)vertex index:(id<EGIndexSource>)index;
- (EGShader*)shader;
+ (EGMaterial*)applyColor:(GEVec4)color;
+ (EGMaterial*)applyTexture:(EGTexture*)texture;
+ (ODClassType*)type;
@end


@interface EGColorSource : EGMaterial {
@private
    GEVec4 _color;
    EGTexture* _texture;
    EGBlendMode* _blendMode;
    float _alphaTestLevel;
}
@property (nonatomic, readonly) GEVec4 color;
@property (nonatomic, readonly) EGTexture* texture;
@property (nonatomic, readonly) EGBlendMode* blendMode;
@property (nonatomic, readonly) float alphaTestLevel;

+ (instancetype)colorSourceWithColor:(GEVec4)color texture:(EGTexture*)texture blendMode:(EGBlendMode*)blendMode alphaTestLevel:(float)alphaTestLevel;
- (instancetype)initWithColor:(GEVec4)color texture:(EGTexture*)texture blendMode:(EGBlendMode*)blendMode alphaTestLevel:(float)alphaTestLevel;
- (ODClassType*)type;
+ (EGColorSource*)applyColor:(GEVec4)color texture:(EGTexture*)texture;
+ (EGColorSource*)applyColor:(GEVec4)color texture:(EGTexture*)texture alphaTestLevel:(float)alphaTestLevel;
+ (EGColorSource*)applyColor:(GEVec4)color texture:(EGTexture*)texture blendMode:(EGBlendMode*)blendMode;
+ (EGColorSource*)applyColor:(GEVec4)color;
+ (EGColorSource*)applyTexture:(EGTexture*)texture;
- (EGShaderSystem*)shaderSystem;
- (EGColorSource*)setColor:(GEVec4)color;
- (GERect)uv;
+ (ODClassType*)type;
@end


@interface EGBlendMode : ODEnum
@property (nonatomic, readonly) NSString*(^blend)(NSString*, NSString*);

+ (EGBlendMode*)first;
+ (EGBlendMode*)second;
+ (EGBlendMode*)multiply;
+ (EGBlendMode*)darken;
+ (NSArray*)values;
@end


@interface EGStandardMaterial : EGMaterial {
@private
    EGColorSource* _diffuse;
    GEVec4 _specularColor;
    CGFloat _specularSize;
    EGNormalMap* _normalMap;
}
@property (nonatomic, readonly) EGColorSource* diffuse;
@property (nonatomic, readonly) GEVec4 specularColor;
@property (nonatomic, readonly) CGFloat specularSize;
@property (nonatomic, readonly) EGNormalMap* normalMap;

+ (instancetype)standardMaterialWithDiffuse:(EGColorSource*)diffuse specularColor:(GEVec4)specularColor specularSize:(CGFloat)specularSize normalMap:(EGNormalMap*)normalMap;
- (instancetype)initWithDiffuse:(EGColorSource*)diffuse specularColor:(GEVec4)specularColor specularSize:(CGFloat)specularSize normalMap:(EGNormalMap*)normalMap;
- (ODClassType*)type;
+ (EGStandardMaterial*)applyDiffuse:(EGColorSource*)diffuse;
- (EGShaderSystem*)shaderSystem;
+ (ODClassType*)type;
@end


@interface EGNormalMap : NSObject {
@private
    EGTexture* _texture;
    BOOL _tangent;
}
@property (nonatomic, readonly) EGTexture* texture;
@property (nonatomic, readonly) BOOL tangent;

+ (instancetype)normalMapWithTexture:(EGTexture*)texture tangent:(BOOL)tangent;
- (instancetype)initWithTexture:(EGTexture*)texture tangent:(BOOL)tangent;
- (ODClassType*)type;
+ (ODClassType*)type;
@end


@interface EGBlendFunction : NSObject {
@private
    unsigned int _source;
    unsigned int _destination;
}
@property (nonatomic, readonly) unsigned int source;
@property (nonatomic, readonly) unsigned int destination;

+ (instancetype)blendFunctionWithSource:(unsigned int)source destination:(unsigned int)destination;
- (instancetype)initWithSource:(unsigned int)source destination:(unsigned int)destination;
- (ODClassType*)type;
- (void)bind;
+ (EGBlendFunction*)standard;
+ (EGBlendFunction*)premultiplied;
+ (ODClassType*)type;
@end


