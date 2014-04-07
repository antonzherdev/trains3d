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
static ODClassType* _EGMaterial_type;

+ (instancetype)material {
    return [[EGMaterial alloc] init];
}

- (instancetype)init {
    self = [super init];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGMaterial class]) _EGMaterial_type = [ODClassType classTypeWithCls:[EGMaterial class]];
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

- (ODClassType*)type {
    return [EGMaterial type];
}

+ (ODClassType*)type {
    return _EGMaterial_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendString:@">"];
    return description;
}

@end


@implementation EGColorSource
static ODClassType* _EGColorSource_type;
@synthesize color = _color;
@synthesize texture = _texture;
@synthesize blendMode = _blendMode;
@synthesize alphaTestLevel = _alphaTestLevel;

+ (instancetype)colorSourceWithColor:(GEVec4)color texture:(EGTexture*)texture blendMode:(EGBlendMode*)blendMode alphaTestLevel:(float)alphaTestLevel {
    return [[EGColorSource alloc] initWithColor:color texture:texture blendMode:blendMode alphaTestLevel:alphaTestLevel];
}

- (instancetype)initWithColor:(GEVec4)color texture:(EGTexture*)texture blendMode:(EGBlendMode*)blendMode alphaTestLevel:(float)alphaTestLevel {
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
    if(self == [EGColorSource class]) _EGColorSource_type = [ODClassType classTypeWithCls:[EGColorSource class]];
}

+ (EGColorSource*)applyColor:(GEVec4)color texture:(EGTexture*)texture {
    return [EGColorSource colorSourceWithColor:color texture:texture blendMode:EGBlendMode.multiply alphaTestLevel:-1.0];
}

+ (EGColorSource*)applyColor:(GEVec4)color texture:(EGTexture*)texture alphaTestLevel:(float)alphaTestLevel {
    return [EGColorSource colorSourceWithColor:color texture:texture blendMode:EGBlendMode.multiply alphaTestLevel:alphaTestLevel];
}

+ (EGColorSource*)applyColor:(GEVec4)color texture:(EGTexture*)texture blendMode:(EGBlendMode*)blendMode {
    return [EGColorSource colorSourceWithColor:color texture:texture blendMode:blendMode alphaTestLevel:-1.0];
}

+ (EGColorSource*)applyColor:(GEVec4)color {
    return [EGColorSource colorSourceWithColor:color texture:nil blendMode:EGBlendMode.first alphaTestLevel:-1.0];
}

+ (EGColorSource*)applyTexture:(EGTexture*)texture {
    return [EGColorSource colorSourceWithColor:GEVec4Make(1.0, 1.0, 1.0, 1.0) texture:texture blendMode:EGBlendMode.second alphaTestLevel:-1.0];
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

- (ODClassType*)type {
    return [EGColorSource type];
}

+ (ODClassType*)type {
    return _EGColorSource_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"color=%@", GEVec4Description(self.color)];
    [description appendFormat:@", texture=%@", self.texture];
    [description appendFormat:@", blendMode=%@", self.blendMode];
    [description appendFormat:@", alphaTestLevel=%f", self.alphaTestLevel];
    [description appendString:@">"];
    return description;
}

@end


@implementation EGBlendMode{
    NSString*(^_blend)(NSString*, NSString*);
}
static EGBlendMode* _EGBlendMode_first;
static EGBlendMode* _EGBlendMode_second;
static EGBlendMode* _EGBlendMode_multiply;
static EGBlendMode* _EGBlendMode_darken;
static NSArray* _EGBlendMode_values;
@synthesize blend = _blend;

+ (instancetype)blendModeWithOrdinal:(NSUInteger)ordinal name:(NSString*)name blend:(NSString*(^)(NSString*, NSString*))blend {
    return [[EGBlendMode alloc] initWithOrdinal:ordinal name:name blend:blend];
}

- (instancetype)initWithOrdinal:(NSUInteger)ordinal name:(NSString*)name blend:(NSString*(^)(NSString*, NSString*))blend {
    self = [super initWithOrdinal:ordinal name:name];
    if(self) _blend = [blend copy];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGBlendMode_first = [EGBlendMode blendModeWithOrdinal:0 name:@"first" blend:^NSString*(NSString* a, NSString* b) {
        return a;
    }];
    _EGBlendMode_second = [EGBlendMode blendModeWithOrdinal:1 name:@"second" blend:^NSString*(NSString* a, NSString* b) {
        return b;
    }];
    _EGBlendMode_multiply = [EGBlendMode blendModeWithOrdinal:2 name:@"multiply" blend:^NSString*(NSString* a, NSString* b) {
        return [NSString stringWithFormat:@"%@ * %@", a, b];
    }];
    _EGBlendMode_darken = [EGBlendMode blendModeWithOrdinal:3 name:@"darken" blend:^NSString*(NSString* a, NSString* b) {
        return [NSString stringWithFormat:@"min(%@, %@)", a, b];
    }];
    _EGBlendMode_values = (@[_EGBlendMode_first, _EGBlendMode_second, _EGBlendMode_multiply, _EGBlendMode_darken]);
}

+ (EGBlendMode*)first {
    return _EGBlendMode_first;
}

+ (EGBlendMode*)second {
    return _EGBlendMode_second;
}

+ (EGBlendMode*)multiply {
    return _EGBlendMode_multiply;
}

+ (EGBlendMode*)darken {
    return _EGBlendMode_darken;
}

+ (NSArray*)values {
    return _EGBlendMode_values;
}

@end


@implementation EGStandardMaterial
static ODClassType* _EGStandardMaterial_type;
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
    if(self == [EGStandardMaterial class]) _EGStandardMaterial_type = [ODClassType classTypeWithCls:[EGStandardMaterial class]];
}

+ (EGStandardMaterial*)applyDiffuse:(EGColorSource*)diffuse {
    return [EGStandardMaterial standardMaterialWithDiffuse:diffuse specularColor:GEVec4Make(0.0, 0.0, 0.0, 1.0) specularSize:0.0 normalMap:nil];
}

- (EGShaderSystem*)shaderSystem {
    return EGStandardShaderSystem.instance;
}

- (ODClassType*)type {
    return [EGStandardMaterial type];
}

+ (ODClassType*)type {
    return _EGStandardMaterial_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"diffuse=%@", self.diffuse];
    [description appendFormat:@", specularColor=%@", GEVec4Description(self.specularColor)];
    [description appendFormat:@", specularSize=%f", self.specularSize];
    [description appendFormat:@", normalMap=%@", self.normalMap];
    [description appendString:@">"];
    return description;
}

@end


@implementation EGNormalMap
static ODClassType* _EGNormalMap_type;
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
    if(self == [EGNormalMap class]) _EGNormalMap_type = [ODClassType classTypeWithCls:[EGNormalMap class]];
}

- (ODClassType*)type {
    return [EGNormalMap type];
}

+ (ODClassType*)type {
    return _EGNormalMap_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"texture=%@", self.texture];
    [description appendFormat:@", tangent=%d", self.tangent];
    [description appendString:@">"];
    return description;
}

@end


@implementation EGBlendFunction
static EGBlendFunction* _EGBlendFunction_standard;
static EGBlendFunction* _EGBlendFunction_premultiplied;
static EGBlendFunction* _EGBlendFunction__lastFunction;
static ODClassType* _EGBlendFunction_type;
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
        _EGBlendFunction_type = [ODClassType classTypeWithCls:[EGBlendFunction class]];
        _EGBlendFunction_standard = [EGBlendFunction blendFunctionWithSource:GL_SRC_ALPHA destination:GL_ONE_MINUS_SRC_ALPHA];
        _EGBlendFunction_premultiplied = [EGBlendFunction blendFunctionWithSource:GL_ONE destination:GL_ONE_MINUS_SRC_ALPHA];
    }
}

- (void)applyDraw:(void(^)())draw {
    [EGGlobal.context.blend enable];
    if(!([_EGBlendFunction__lastFunction isEqual:self])) {
        glBlendFunc(_source, _destination);
        _EGBlendFunction__lastFunction = self;
    }
    draw();
    [EGGlobal.context.blend disable];
}

- (ODClassType*)type {
    return [EGBlendFunction type];
}

+ (EGBlendFunction*)standard {
    return _EGBlendFunction_standard;
}

+ (EGBlendFunction*)premultiplied {
    return _EGBlendFunction_premultiplied;
}

+ (ODClassType*)type {
    return _EGBlendFunction_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"source=%u", self.source];
    [description appendFormat:@", destination=%u", self.destination];
    [description appendString:@">"];
    return description;
}

@end


