#import "EGMaterial.h"

#import "EG.h"
#import "EGShader.h"
#import "EGMesh.h"
#import "EGSimpleShaderSystem.h"
#import "EGStandardShaderSystem.h"
#import "EGTexture.h"
@implementation EGColorSource
static ODClassType* _EGColorSource_type;

+ (id)colorSource {
    return [[EGColorSource alloc] init];
}

- (id)init {
    self = [super init];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGColorSource_type = [ODClassType classTypeWithCls:[EGColorSource class]];
}

+ (EGColorSource*)applyColor:(EGColor)color {
    return [EGColorSourceColor colorSourceColorWithColor:color];
}

+ (EGColorSource*)applyTexture:(EGTexture*)texture {
    return [EGColorSourceTexture colorSourceTextureWithTexture:texture];
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


@implementation EGColorSourceColor{
    EGColor _color;
}
static ODClassType* _EGColorSourceColor_type;
@synthesize color = _color;

+ (id)colorSourceColorWithColor:(EGColor)color {
    return [[EGColorSourceColor alloc] initWithColor:color];
}

- (id)initWithColor:(EGColor)color {
    self = [super init];
    if(self) _color = color;
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGColorSourceColor_type = [ODClassType classTypeWithCls:[EGColorSourceColor class]];
}

- (ODClassType*)type {
    return [EGColorSourceColor type];
}

+ (ODClassType*)type {
    return _EGColorSourceColor_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGColorSourceColor* o = ((EGColorSourceColor*)(other));
    return EGColorEq(self.color, o.color);
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + EGColorHash(self.color);
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"color=%@", EGColorDescription(self.color)];
    [description appendString:@">"];
    return description;
}

@end


@implementation EGColorSourceTexture{
    EGTexture* _texture;
}
static ODClassType* _EGColorSourceTexture_type;
@synthesize texture = _texture;

+ (id)colorSourceTextureWithTexture:(EGTexture*)texture {
    return [[EGColorSourceTexture alloc] initWithTexture:texture];
}

- (id)initWithTexture:(EGTexture*)texture {
    self = [super init];
    if(self) _texture = texture;
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGColorSourceTexture_type = [ODClassType classTypeWithCls:[EGColorSourceTexture class]];
}

- (ODClassType*)type {
    return [EGColorSourceTexture type];
}

+ (ODClassType*)type {
    return _EGColorSourceTexture_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGColorSourceTexture* o = ((EGColorSourceTexture*)(other));
    return [self.texture isEqual:o.texture];
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.texture hash];
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"texture=%@", self.texture];
    [description appendString:@">"];
    return description;
}

@end


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
    [[self shaderSystem] drawMaterial:self mesh:mesh];
}

+ (EGMaterial*)applyColor:(EGColor)color {
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


@implementation EGSimpleMaterial{
    EGColorSource* _color;
}
static ODClassType* _EGSimpleMaterial_type;
@synthesize color = _color;

+ (id)simpleMaterialWithColor:(EGColorSource*)color {
    return [[EGSimpleMaterial alloc] initWithColor:color];
}

- (id)initWithColor:(EGColorSource*)color {
    self = [super init];
    if(self) _color = color;
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGSimpleMaterial_type = [ODClassType classTypeWithCls:[EGSimpleMaterial class]];
}

- (EGShaderSystem*)shaderSystem {
    return EGSimpleShaderSystem.instance;
}

- (ODClassType*)type {
    return [EGSimpleMaterial type];
}

+ (ODClassType*)type {
    return _EGSimpleMaterial_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGSimpleMaterial* o = ((EGSimpleMaterial*)(other));
    return [self.color isEqual:o.color];
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.color hash];
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"color=%@", self.color];
    [description appendString:@">"];
    return description;
}

@end


@implementation EGStandardMaterial{
    EGColorSource* _diffuse;
    EGColor _specularColor;
    CGFloat _specularSize;
}
static ODClassType* _EGStandardMaterial_type;
@synthesize diffuse = _diffuse;
@synthesize specularColor = _specularColor;
@synthesize specularSize = _specularSize;

+ (id)standardMaterialWithDiffuse:(EGColorSource*)diffuse specularColor:(EGColor)specularColor specularSize:(CGFloat)specularSize {
    return [[EGStandardMaterial alloc] initWithDiffuse:diffuse specularColor:specularColor specularSize:specularSize];
}

- (id)initWithDiffuse:(EGColorSource*)diffuse specularColor:(EGColor)specularColor specularSize:(CGFloat)specularSize {
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
    return [EGStandardMaterial standardMaterialWithDiffuse:diffuse specularColor:EGColorMake(0.0, 0.0, 0.0, 1.0) specularSize:1.0];
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
    return [self.diffuse isEqual:o.diffuse] && EGColorEq(self.specularColor, o.specularColor) && eqf(self.specularSize, o.specularSize);
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.diffuse hash];
    hash = hash * 31 + EGColorHash(self.specularColor);
    hash = hash * 31 + floatHash(self.specularSize);
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"diffuse=%@", self.diffuse];
    [description appendFormat:@", specularColor=%@", EGColorDescription(self.specularColor)];
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


void egBlendFunctionApplyDraw(EGBlendFunction self, void(^draw)()) {
    glEnable(GL_BLEND);
    glBlendFunc(self.source, self.destination);
    ((void(^)())(draw))();
    glDisable(GL_BLEND);
}
EGBlendFunction egBlendFunctionStandard() {
    static EGBlendFunction _ret = {GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA};
    return _ret;
}
EGBlendFunction egBlendFunctionPremultiplied() {
    static EGBlendFunction _ret = {GL_ONE, GL_ONE_MINUS_SRC_ALPHA};
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



