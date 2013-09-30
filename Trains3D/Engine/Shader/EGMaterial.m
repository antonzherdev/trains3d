#import "EGMaterial.h"

#import "EGShader.h"
#import "EGMesh.h"
#import "EGTexture.h"
#import "EGSimpleShaderSystem.h"
#import "EGStandardShaderSystem.h"
#import "GL.h"
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
    [[self shaderSystem] drawParam:self mesh:mesh];
}

- (void)drawVb:(EGVertexBuffer*)vb index:(CNPArray*)index mode:(unsigned int)mode {
    [[self shaderSystem] drawParam:self vb:vb index:index mode:mode];
}

- (void)drawVb:(EGVertexBuffer*)vb mode:(unsigned int)mode {
    [[self shaderSystem] drawParam:self vb:vb mode:mode];
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
    float _alphaTestLevel;
}
static ODClassType* _EGColorSource_type;
@synthesize color = _color;
@synthesize texture = _texture;
@synthesize alphaTestLevel = _alphaTestLevel;

+ (id)colorSourceWithColor:(GEVec4)color texture:(id)texture alphaTestLevel:(float)alphaTestLevel {
    return [[EGColorSource alloc] initWithColor:color texture:texture alphaTestLevel:alphaTestLevel];
}

- (id)initWithColor:(GEVec4)color texture:(id)texture alphaTestLevel:(float)alphaTestLevel {
    self = [super init];
    if(self) {
        _color = color;
        _texture = texture;
        _alphaTestLevel = alphaTestLevel;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGColorSource_type = [ODClassType classTypeWithCls:[EGColorSource class]];
}

+ (EGColorSource*)applyColor:(GEVec4)color texture:(EGTexture*)texture {
    return [EGColorSource colorSourceWithColor:color texture:[CNOption applyValue:texture] alphaTestLevel:-1.0];
}

+ (EGColorSource*)applyColor:(GEVec4)color {
    return [EGColorSource colorSourceWithColor:color texture:[CNOption none] alphaTestLevel:-1.0];
}

+ (EGColorSource*)applyTexture:(EGTexture*)texture {
    return [EGColorSource colorSourceWithColor:GEVec4Make(1.0, 1.0, 1.0, 1.0) texture:[CNOption applyValue:texture] alphaTestLevel:-1.0];
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
    return GEVec4Eq(self.color, o.color) && [self.texture isEqual:o.texture] && eqf4(self.alphaTestLevel, o.alphaTestLevel);
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + GEVec4Hash(self.color);
    hash = hash * 31 + [self.texture hash];
    hash = hash * 31 + float4Hash(self.alphaTestLevel);
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"color=%@", GEVec4Description(self.color)];
    [description appendFormat:@", texture=%@", self.texture];
    [description appendFormat:@", alphaTestLevel=%f", self.alphaTestLevel];
    [description appendString:@">"];
    return description;
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
    return [EGStandardMaterial standardMaterialWithDiffuse:diffuse specularColor:GEVec4Make(0.0, 0.0, 0.0, 1.0) specularSize:1.0];
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


@implementation EGMeshModel{
    id<CNSeq> _meshes;
}
static ODClassType* _EGMeshModel_type;
@synthesize meshes = _meshes;

+ (id)meshModelWithMeshes:(id<CNSeq>)meshes {
    return [[EGMeshModel alloc] initWithMeshes:meshes];
}

- (id)initWithMeshes:(id<CNSeq>)meshes {
    self = [super init];
    if(self) _meshes = meshes;
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGMeshModel_type = [ODClassType classTypeWithCls:[EGMeshModel class]];
}

- (void)draw {
    [_meshes forEach:^void(CNTuple* p) {
        [((EGMaterial*)(p.b)) drawMesh:((EGMesh*)(p.a))];
    }];
}

- (ODClassType*)type {
    return [EGMeshModel type];
}

+ (ODClassType*)type {
    return _EGMeshModel_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGMeshModel* o = ((EGMeshModel*)(other));
    return [self.meshes isEqual:o.meshes];
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.meshes hash];
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"meshes=%@", self.meshes];
    [description appendString:@">"];
    return description;
}

@end


NSString* EGBlendFunctionDescription(EGBlendFunction self) {
    NSMutableString* description = [NSMutableString stringWithString:@"<EGBlendFunction: "];
    [description appendFormat:@"source=%d", self.source];
    [description appendFormat:@", destination=%d", self.destination];
    [description appendString:@">"];
    return description;
}
void egBlendFunctionApplyDraw(EGBlendFunction self, void(^draw)()) {
    glEnable(GL_BLEND);
    glBlendFunc(self.source, self.destination);
    ((void(^)())(draw))();
    glDisable(GL_BLEND);
}
EGBlendFunction egBlendFunctionStandard() {
    static EGBlendFunction _ret = (EGBlendFunction){((unsigned int)(GL_SRC_ALPHA)), ((unsigned int)(GL_ONE_MINUS_SRC_ALPHA))};
    return _ret;
}
EGBlendFunction egBlendFunctionPremultiplied() {
    static EGBlendFunction _ret = (EGBlendFunction){((unsigned int)(GL_ONE)), ((unsigned int)(GL_ONE_MINUS_SRC_ALPHA))};
    return _ret;
}
ODPType* egBlendFunctionType() {
    static ODPType* _ret = nil;
    if(_ret == nil) _ret = [ODPType typeWithCls:[EGBlendFunctionWrap class] name:@"EGBlendFunction" size:sizeof(EGBlendFunction) wrap:^id(void* data, NSUInteger i) {
        return wrap(EGBlendFunction, ((EGBlendFunction*)(data))[i]);
    }];
    return _ret;
}
@implementation EGBlendFunctionWrap{
    EGBlendFunction _value;
}
@synthesize value = _value;

+ (id)wrapWithValue:(EGBlendFunction)value {
    return [[EGBlendFunctionWrap alloc] initWithValue:value];
}

- (id)initWithValue:(EGBlendFunction)value {
    self = [super init];
    if(self) _value = value;
    return self;
}

- (NSString*)description {
    return EGBlendFunctionDescription(_value);
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGBlendFunctionWrap* o = ((EGBlendFunctionWrap*)(other));
    return EGBlendFunctionEq(_value, o.value);
}

- (NSUInteger)hash {
    return EGBlendFunctionHash(_value);
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end



