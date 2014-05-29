#import "EGMaterial.h"

#import "EGShader.h"
#import "EGMesh.h"
#import "EGVertex.h"
#import "EGIndex.h"
#import "EGTexture.h"
#import "EGSimpleShaderSystem.h"
#import "EGStandardShaderSystem.h"
#import "GL.h"
#import "EGContext.h"
@implementation EGMaterial
static CNClassType* _EGMaterial_type;

+ (instancetype)material {
    return [[EGMaterial alloc] init];
}

- (instancetype)init {
    self = [super init];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGMaterial class]) _EGMaterial_type = [CNClassType classTypeWithCls:[EGMaterial class]];
}

- (EGShaderSystem*)shaderSystem {
    @throw @"Method shaderSystem is abstract";
}

- (void)drawMesh:(EGMesh*)mesh {
    [[self shaderSystem] drawParam:self vertex:mesh.vertex index:mesh.index];
}

- (void)drawVertex:(id<EGVertexBuffer>)vertex index:(id<EGIndexSource>)index {
    [[self shaderSystem] drawParam:self vertex:vertex index:index];
}

- (EGShader*)shader {
    return [[self shaderSystem] shaderForParam:self];
}

+ (EGMaterial*)applyColor:(GEVec4)color {
    return [EGStandardMaterial applyDiffuse:[EGColorSource applyColor:color]];
}

+ (EGMaterial*)applyTexture:(EGTexture*)texture {
    return [EGStandardMaterial applyDiffuse:[EGColorSource applyTexture:texture]];
}

- (NSString*)description {
    return @"Material";
}

- (CNClassType*)type {
    return [EGMaterial type];
}

+ (CNClassType*)type {
    return _EGMaterial_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation EGBlendMode{
    NSString*(^_blend)(NSString*, NSString*);
}
@synthesize blend = _blend;

+ (instancetype)blendModeWithOrdinal:(NSUInteger)ordinal name:(NSString*)name blend:(NSString*(^)(NSString*, NSString*))blend {
    return [[EGBlendMode alloc] initWithOrdinal:ordinal name:name blend:blend];
}

- (instancetype)initWithOrdinal:(NSUInteger)ordinal name:(NSString*)name blend:(NSString*(^)(NSString*, NSString*))blend {
    self = [super initWithOrdinal:ordinal name:name];
    if(self) _blend = [blend copy];
    
    return self;
}

+ (void)load {
    [super load];
    EGBlendMode_first_Desc = [EGBlendMode blendModeWithOrdinal:0 name:@"first" blend:^NSString*(NSString* a, NSString* b) {
        return a;
    }];
    EGBlendMode_second_Desc = [EGBlendMode blendModeWithOrdinal:1 name:@"second" blend:^NSString*(NSString* a, NSString* b) {
        return b;
    }];
    EGBlendMode_multiply_Desc = [EGBlendMode blendModeWithOrdinal:2 name:@"multiply" blend:^NSString*(NSString* a, NSString* b) {
        return [NSString stringWithFormat:@"%@ * %@", a, b];
    }];
    EGBlendMode_darken_Desc = [EGBlendMode blendModeWithOrdinal:3 name:@"darken" blend:^NSString*(NSString* a, NSString* b) {
        return [NSString stringWithFormat:@"min(%@, %@)", a, b];
    }];
    EGBlendMode_Values[0] = nil;
    EGBlendMode_Values[1] = EGBlendMode_first_Desc;
    EGBlendMode_Values[2] = EGBlendMode_second_Desc;
    EGBlendMode_Values[3] = EGBlendMode_multiply_Desc;
    EGBlendMode_Values[4] = EGBlendMode_darken_Desc;
}

+ (NSArray*)values {
    return (@[EGBlendMode_first_Desc, EGBlendMode_second_Desc, EGBlendMode_multiply_Desc, EGBlendMode_darken_Desc]);
}

@end

@implementation EGColorSource
static CNClassType* _EGColorSource_type;
@synthesize color = _color;
@synthesize texture = _texture;
@synthesize blendMode = _blendMode;
@synthesize alphaTestLevel = _alphaTestLevel;

+ (instancetype)colorSourceWithColor:(GEVec4)color texture:(EGTexture*)texture blendMode:(EGBlendModeR)blendMode alphaTestLevel:(float)alphaTestLevel {
    return [[EGColorSource alloc] initWithColor:color texture:texture blendMode:blendMode alphaTestLevel:alphaTestLevel];
}

- (instancetype)initWithColor:(GEVec4)color texture:(EGTexture*)texture blendMode:(EGBlendModeR)blendMode alphaTestLevel:(float)alphaTestLevel {
    self = [super init];
    if(self) {
        _color = color;
        _texture = texture;
        _blendMode = blendMode;
        _alphaTestLevel = alphaTestLevel;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGColorSource class]) _EGColorSource_type = [CNClassType classTypeWithCls:[EGColorSource class]];
}

+ (EGColorSource*)applyColor:(GEVec4)color texture:(EGTexture*)texture {
    return [EGColorSource colorSourceWithColor:color texture:texture blendMode:EGBlendMode_multiply alphaTestLevel:-1.0];
}

+ (EGColorSource*)applyColor:(GEVec4)color texture:(EGTexture*)texture alphaTestLevel:(float)alphaTestLevel {
    return [EGColorSource colorSourceWithColor:color texture:texture blendMode:EGBlendMode_multiply alphaTestLevel:alphaTestLevel];
}

+ (EGColorSource*)applyColor:(GEVec4)color texture:(EGTexture*)texture blendMode:(EGBlendModeR)blendMode {
    return [EGColorSource colorSourceWithColor:color texture:texture blendMode:blendMode alphaTestLevel:-1.0];
}

+ (EGColorSource*)applyColor:(GEVec4)color {
    return [EGColorSource colorSourceWithColor:color texture:nil blendMode:EGBlendMode_first alphaTestLevel:-1.0];
}

+ (EGColorSource*)applyTexture:(EGTexture*)texture {
    return [EGColorSource colorSourceWithColor:GEVec4Make(1.0, 1.0, 1.0, 1.0) texture:texture blendMode:EGBlendMode_second alphaTestLevel:-1.0];
}

- (EGShaderSystem*)shaderSystem {
    return EGSimpleShaderSystem.instance;
}

- (EGColorSource*)setColor:(GEVec4)color {
    return [EGColorSource colorSourceWithColor:color texture:_texture blendMode:_blendMode alphaTestLevel:_alphaTestLevel];
}

- (GERect)uv {
    if(_texture != nil) return [((EGTexture*)(nonnil(_texture))) uv];
    else return geRectApplyXYWidthHeight(0.0, 0.0, 1.0, 1.0);
}

- (NSString*)description {
    return [NSString stringWithFormat:@"ColorSource(%@, %@, %@, %f)", geVec4Description(_color), _texture, EGBlendMode_Values[_blendMode], _alphaTestLevel];
}

- (CNClassType*)type {
    return [EGColorSource type];
}

+ (CNClassType*)type {
    return _EGColorSource_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation EGStandardMaterial
static CNClassType* _EGStandardMaterial_type;
@synthesize diffuse = _diffuse;
@synthesize specularColor = _specularColor;
@synthesize specularSize = _specularSize;
@synthesize normalMap = _normalMap;

+ (instancetype)standardMaterialWithDiffuse:(EGColorSource*)diffuse specularColor:(GEVec4)specularColor specularSize:(CGFloat)specularSize normalMap:(EGNormalMap*)normalMap {
    return [[EGStandardMaterial alloc] initWithDiffuse:diffuse specularColor:specularColor specularSize:specularSize normalMap:normalMap];
}

- (instancetype)initWithDiffuse:(EGColorSource*)diffuse specularColor:(GEVec4)specularColor specularSize:(CGFloat)specularSize normalMap:(EGNormalMap*)normalMap {
    self = [super init];
    if(self) {
        _diffuse = diffuse;
        _specularColor = specularColor;
        _specularSize = specularSize;
        _normalMap = normalMap;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGStandardMaterial class]) _EGStandardMaterial_type = [CNClassType classTypeWithCls:[EGStandardMaterial class]];
}

+ (EGStandardMaterial*)applyDiffuse:(EGColorSource*)diffuse {
    return [EGStandardMaterial standardMaterialWithDiffuse:diffuse specularColor:GEVec4Make(0.0, 0.0, 0.0, 1.0) specularSize:0.0 normalMap:nil];
}

- (EGShaderSystem*)shaderSystem {
    return EGStandardShaderSystem.instance;
}

- (NSString*)description {
    return [NSString stringWithFormat:@"StandardMaterial(%@, %@, %f, %@)", _diffuse, geVec4Description(_specularColor), _specularSize, _normalMap];
}

- (CNClassType*)type {
    return [EGStandardMaterial type];
}

+ (CNClassType*)type {
    return _EGStandardMaterial_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation EGNormalMap
static CNClassType* _EGNormalMap_type;
@synthesize texture = _texture;
@synthesize tangent = _tangent;

+ (instancetype)normalMapWithTexture:(EGTexture*)texture tangent:(BOOL)tangent {
    return [[EGNormalMap alloc] initWithTexture:texture tangent:tangent];
}

- (instancetype)initWithTexture:(EGTexture*)texture tangent:(BOOL)tangent {
    self = [super init];
    if(self) {
        _texture = texture;
        _tangent = tangent;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGNormalMap class]) _EGNormalMap_type = [CNClassType classTypeWithCls:[EGNormalMap class]];
}

- (NSString*)description {
    return [NSString stringWithFormat:@"NormalMap(%@, %d)", _texture, _tangent];
}

- (CNClassType*)type {
    return [EGNormalMap type];
}

+ (CNClassType*)type {
    return _EGNormalMap_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation EGBlendFunction
static EGBlendFunction* _EGBlendFunction_standard;
static EGBlendFunction* _EGBlendFunction_premultiplied;
static CNClassType* _EGBlendFunction_type;
@synthesize source = _source;
@synthesize destination = _destination;

+ (instancetype)blendFunctionWithSource:(unsigned int)source destination:(unsigned int)destination {
    return [[EGBlendFunction alloc] initWithSource:source destination:destination];
}

- (instancetype)initWithSource:(unsigned int)source destination:(unsigned int)destination {
    self = [super init];
    if(self) {
        _source = source;
        _destination = destination;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGBlendFunction class]) {
        _EGBlendFunction_type = [CNClassType classTypeWithCls:[EGBlendFunction class]];
        _EGBlendFunction_standard = [EGBlendFunction blendFunctionWithSource:GL_SRC_ALPHA destination:GL_ONE_MINUS_SRC_ALPHA];
        _EGBlendFunction_premultiplied = [EGBlendFunction blendFunctionWithSource:GL_ONE destination:GL_ONE_MINUS_SRC_ALPHA];
    }
}

- (void)applyDraw:(void(^)())draw {
    EGEnablingState* __tmp__il__0self = EGGlobal.context.blend;
    {
        BOOL __il__0changed = [__tmp__il__0self enable];
        {
            [EGGlobal.context setBlendFunction:self];
            draw();
        }
        if(__il__0changed) [__tmp__il__0self disable];
    }
}

- (void)bind {
    glBlendFunc(_source, _destination);
}

- (NSString*)description {
    return [NSString stringWithFormat:@"BlendFunction(%u, %u)", _source, _destination];
}

- (CNClassType*)type {
    return [EGBlendFunction type];
}

+ (EGBlendFunction*)standard {
    return _EGBlendFunction_standard;
}

+ (EGBlendFunction*)premultiplied {
    return _EGBlendFunction_premultiplied;
}

+ (CNClassType*)type {
    return _EGBlendFunction_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

