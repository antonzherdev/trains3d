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

typedef enum EGBlendModeR {
    EGBlendMode_Nil = 0,
    EGBlendMode_first = 1,
    EGBlendMode_second = 2,
    EGBlendMode_multiply = 3,
    EGBlendMode_darken = 4
} EGBlendModeR;
@interface EGBlendMode : CNEnum
@property (nonatomic, readonly) NSString*(^blend)(NSString*, NSString*);

+ (NSArray*)values;
+ (EGBlendMode*)value:(EGBlendModeR)r;
@end


@interface EGMaterial : NSObject
+ (instancetype)material;
- (instancetype)init;
- (CNClassType*)type;
- (EGShaderSystem*)shaderSystem;
- (void)drawMesh:(EGMesh*)mesh;
- (void)drawVertex:(id<EGVertexBuffer>)vertex index:(id<EGIndexSource>)index;
- (EGShader*)shader;
+ (EGMaterial*)applyColor:(GEVec4)color;
+ (EGMaterial*)applyTexture:(EGTexture*)texture;
- (NSString*)description;
+ (CNClassType*)type;
@end


@interface EGColorSource : EGMaterial {
@protected
    GEVec4 _color;
    EGTexture* _texture;
    EGBlendModeR _blendMode;
    float _alphaTestLevel;
}
@property (nonatomic, readonly) GEVec4 color;
@property (nonatomic, readonly) EGTexture* texture;
@property (nonatomic, readonly) EGBlendModeR blendMode;
@property (nonatomic, readonly) float alphaTestLevel;

+ (instancetype)colorSourceWithColor:(GEVec4)color texture:(EGTexture*)texture blendMode:(EGBlendModeR)blendMode alphaTestLevel:(float)alphaTestLevel;
- (instancetype)initWithColor:(GEVec4)color texture:(EGTexture*)texture blendMode:(EGBlendModeR)blendMode alphaTestLevel:(float)alphaTestLevel;
- (CNClassType*)type;
+ (EGColorSource*)applyColor:(GEVec4)color texture:(EGTexture*)texture;
+ (EGColorSource*)applyColor:(GEVec4)color texture:(EGTexture*)texture alphaTestLevel:(float)alphaTestLevel;
+ (EGColorSource*)applyColor:(GEVec4)color texture:(EGTexture*)texture blendMode:(EGBlendModeR)blendMode;
+ (EGColorSource*)applyColor:(GEVec4)color;
+ (EGColorSource*)applyTexture:(EGTexture*)texture;
- (EGShaderSystem*)shaderSystem;
- (EGColorSource*)setColor:(GEVec4)color;
- (GERect)uv;
- (NSString*)description;
+ (CNClassType*)type;
@end


@interface EGStandardMaterial : EGMaterial {
@protected
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
- (CNClassType*)type;
+ (EGStandardMaterial*)applyDiffuse:(EGColorSource*)diffuse;
- (EGShaderSystem*)shaderSystem;
- (NSString*)description;
+ (CNClassType*)type;
@end


@interface EGNormalMap : NSObject {
@protected
    EGTexture* _texture;
    BOOL _tangent;
}
@property (nonatomic, readonly) EGTexture* texture;
@property (nonatomic, readonly) BOOL tangent;

+ (instancetype)normalMapWithTexture:(EGTexture*)texture tangent:(BOOL)tangent;
- (instancetype)initWithTexture:(EGTexture*)texture tangent:(BOOL)tangent;
- (CNClassType*)type;
- (NSString*)description;
+ (CNClassType*)type;
@end


@interface EGBlendFunction : NSObject {
@protected
    unsigned int _source;
    unsigned int _destination;
}
@property (nonatomic, readonly) unsigned int source;
@property (nonatomic, readonly) unsigned int destination;

+ (instancetype)blendFunctionWithSource:(unsigned int)source destination:(unsigned int)destination;
- (instancetype)initWithSource:(unsigned int)source destination:(unsigned int)destination;
- (CNClassType*)type;
- (void)bind;
- (NSString*)description;
+ (EGBlendFunction*)standard;
+ (EGBlendFunction*)premultiplied;
+ (CNClassType*)type;
@end


