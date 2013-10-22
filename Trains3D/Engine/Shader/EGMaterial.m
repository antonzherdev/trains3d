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

+ (id)material {
    return [[EGMaterial alloc] init];
}

- (id)init {
    self = [super init];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGMaterial_type = [ODClassType classTypeWithCls:[EGMaterial class]];
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

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    return YES;
}

- (NSUInteger)hash {
    return 0;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendString:@">"];
    return description;
}

@end


@implementation EGColorSource{
    GEVec4 _color;
    id _texture;
    EGBlendMode* _blendMode;
    float _alphaTestLevel;
}
static ODClassType* _EGColorSource_type;
@synthesize color = _color;
@synthesize texture = _texture;
@synthesize blendMode = _blendMode;
@synthesize alphaTestLevel = _alphaTestLevel;

+ (id)colorSourceWithColor:(GEVec4)color texture:(id)texture blendMode:(EGBlendMode*)blendMode alphaTestLevel:(float)alphaTestLevel {
    return [[EGColorSource alloc] initWithColor:color texture:texture blendMode:blendMode alphaTestLevel:alphaTestLevel];
}

- (id)initWithColor:(GEVec4)color texture:(id)texture blendMode:(EGBlendMode*)blendMode alphaTestLevel:(float)alphaTestLevel {
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
    _EGColorSource_type = [ODClassType classTypeWithCls:[EGColorSource class]];
}

+ (EGColorSource*)applyColor:(GEVec4)color texture:(EGTexture*)texture {
    return [EGColorSource colorSourceWithColor:color texture:[CNOption applyValue:texture] blendMode:EGBlendMode.multiply alphaTestLevel:-1.0];
}

+ (EGColorSource*)applyColor:(GEVec4)color texture:(EGTexture*)texture alphaTestLevel:(float)alphaTestLevel {
    return [EGColorSource colorSourceWithColor:color texture:[CNOption applyValue:texture] blendMode:EGBlendMode.multiply alphaTestLevel:alphaTestLevel];
}

+ (EGColorSource*)applyColor:(GEVec4)color texture:(EGTexture*)texture blendMode:(EGBlendMode*)blendMode {
    return [EGColorSource colorSourceWithColor:color texture:[CNOption applyValue:texture] blendMode:blendMode alphaTestLevel:-1.0];
}

+ (EGColorSource*)applyColor:(GEVec4)color {
    return [EGColorSource colorSourceWithColor:color texture:[CNOption none] blendMode:EGBlendMode.first alphaTestLevel:-1.0];
}

+ (EGColorSource*)applyTexture:(EGTexture*)texture {
    return [EGColorSource colorSourceWithColor:GEVec4Make(1.0, 1.0, 1.0, 1.0) texture:[CNOption applyValue:texture] blendMode:EGBlendMode.second alphaTestLevel:-1.0];
}

- (EGShaderSystem*)shaderSystem {
    return EGSimpleShaderSystem.instance;
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

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGColorSource* o = ((EGColorSource*)(other));
    return GEVec4Eq(self.color, o.color) && [self.texture isEqual:o.texture] && self.blendMode == o.blendMode && eqf4(self.alphaTestLevel, o.alphaTestLevel);
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + GEVec4Hash(self.color);
    hash = hash * 31 + [self.texture hash];
    hash = hash * 31 + [self.blendMode ordinal];
    hash = hash * 31 + float4Hash(self.alphaTestLevel);
    return hash;
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

+ (id)blendModeWithOrdinal:(NSUInteger)ordinal name:(NSString*)name blend:(NSString*(^)(NSString*, NSString*))blend {
    return [[EGBlendMode alloc] initWithOrdinal:ordinal name:name blend:blend];
}

- (id)initWithOrdinal:(NSUInteger)ordinal name:(NSString*)name blend:(NSString*(^)(NSString*, NSString*))blend {
    self = [super initWithOrdinal:ordinal name:name];
    if(self) _blend = blend;
    
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


@implementation EGStandardMaterial{
    EGColorSource* _diffuse;
    GEVec4 _specularColor;
    CGFloat _specularSize;
}
static ODClassType* _EGStandardMaterial_type;
@synthesize diffuse = _diffuse;
@synthesize specularColor = _specularColor;
@synthesize specularSize = _specularSize;

+ (id)standardMaterialWithDiffuse:(EGColorSource*)diffuse specularColor:(GEVec4)specularColor specularSize:(CGFloat)specularSize {
    return [[EGStandardMaterial alloc] initWithDiffuse:diffuse specularColor:specularColor specularSize:specularSize];
}

- (id)initWithDiffuse:(EGColorSource*)diffuse specularColor:(GEVec4)specularColor specularSize:(CGFloat)specularSize {
    self = [super init];
    if(self) {
        _diffuse = diffuse;
        _specularColor = specularColor;
        _specularSize = specularSize;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGStandardMaterial_type = [ODClassType classTypeWithCls:[EGStandardMaterial class]];
}

+ (EGStandardMaterial*)applyDiffuse:(EGColorSource*)diffuse {
    return [EGStandardMaterial standardMaterialWithDiffuse:diffuse specularColor:GEVec4Make(0.0, 0.0, 0.0, 1.0) specularSize:0.0];
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

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGStandardMaterial* o = ((EGStandardMaterial*)(other));
    return [self.diffuse isEqual:o.diffuse] && GEVec4Eq(self.specularColor, o.specularColor) && eqf(self.specularSize, o.specularSize);
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.diffuse hash];
    hash = hash * 31 + GEVec4Hash(self.specularColor);
    hash = hash * 31 + floatHash(self.specularSize);
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"diffuse=%@", self.diffuse];
    [description appendFormat:@", specularColor=%@", GEVec4Description(self.specularColor)];
    [description appendFormat:@", specularSize=%f", self.specularSize];
    [description appendString:@">"];
    return description;
}

@end


@implementation EGBlendFunction{
    unsigned int _source;
    unsigned int _destination;
}
static EGBlendFunction* _EGBlendFunction_standard;
static EGBlendFunction* _EGBlendFunction_premultiplied;
static EGBlendFunction* _EGBlendFunction__lastFunction;
static ODClassType* _EGBlendFunction_type;
@synthesize source = _source;
@synthesize destination = _destination;

+ (id)blendFunctionWithSource:(unsigned int)source destination:(unsigned int)destination {
    return [[EGBlendFunction alloc] initWithSource:source destination:destination];
}

- (id)initWithSource:(unsigned int)source destination:(unsigned int)destination {
    self = [super init];
    if(self) {
        _source = source;
        _destination = destination;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGBlendFunction_type = [ODClassType classTypeWithCls:[EGBlendFunction class]];
    _EGBlendFunction_standard = [EGBlendFunction blendFunctionWithSource:GL_SRC_ALPHA destination:GL_ONE_MINUS_SRC_ALPHA];
    _EGBlendFunction_premultiplied = [EGBlendFunction blendFunctionWithSource:GL_ONE destination:GL_ONE_MINUS_SRC_ALPHA];
}

- (void)applyDraw:(void(^)())draw {
    [EGGlobal.context.blend enable];
    if(!([_EGBlendFunction__lastFunction isEqual:self])) {
        glBlendFunc(_source, _destination);
        _EGBlendFunction__lastFunction = self;
    }
    ((void(^)())(draw))();
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

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGBlendFunction* o = ((EGBlendFunction*)(other));
    return self.source == o.source && self.destination == o.destination;
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + self.source;
    hash = hash * 31 + self.destination;
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"source=%u", self.source];
    [description appendFormat:@", destination=%u", self.destination];
    [description appendString:@">"];
    return description;
}

@end


