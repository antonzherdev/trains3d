#import "EGMaterial.h"

#import "EG.h"
#import "EGContext.h"
#import "EGShader.h"
#import "EGSimpleShaderSystem.h"
#import "EGStandardShaderSystem.h"
#import "EGTexture.h"
@implementation EGColorSource
static ODType* _EGColorSource_type;

+ (id)colorSource {
    return [[EGColorSource alloc] init];
}

- (id)init {
    self = [super init];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGColorSource_type = [ODType typeWithCls:[EGColorSource class]];
}

+ (EGColorSource*)applyColor:(EGColor)color {
    return [EGColorSourceColor colorSourceColorWithColor:color];
}

+ (EGColorSource*)applyTexture:(EGTexture*)texture {
    return [EGColorSourceTexture colorSourceTextureWithTexture:texture];
}

- (ODType*)type {
    return _EGColorSource_type;
}

+ (ODType*)type {
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
static ODType* _EGColorSourceColor_type;
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
    _EGColorSourceColor_type = [ODType typeWithCls:[EGColorSourceColor class]];
}

- (ODType*)type {
    return _EGColorSourceColor_type;
}

+ (ODType*)type {
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
static ODType* _EGColorSourceTexture_type;
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
    _EGColorSourceTexture_type = [ODType typeWithCls:[EGColorSourceTexture class]];
}

- (ODType*)type {
    return _EGColorSourceTexture_type;
}

+ (ODType*)type {
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


@implementation EGMaterial2
static ODType* _EGMaterial2_type;

+ (id)material2 {
    return [[EGMaterial2 alloc] init];
}

- (id)init {
    self = [super init];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGMaterial2_type = [ODType typeWithCls:[EGMaterial2 class]];
}

- (id<EGShaderSystem>)shaderSystem {
    @throw @"Method shaderSystem is abstract";
}

- (void)applyDraw:(void(^)())draw {
    [[self shaderSystem] applyContext:[EG context] material:self draw:draw];
}

+ (EGMaterial2*)applyColor:(EGColor)color {
    return [EGStandardMaterial applyDiffuse:[EGColorSource applyColor:color]];
}

+ (EGMaterial2*)applyTexture:(EGTexture*)texture {
    return [EGStandardMaterial applyDiffuse:[EGColorSource applyTexture:texture]];
}

- (ODType*)type {
    return _EGMaterial2_type;
}

+ (ODType*)type {
    return _EGMaterial2_type;
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
static ODType* _EGSimpleMaterial_type;
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
    _EGSimpleMaterial_type = [ODType typeWithCls:[EGSimpleMaterial class]];
}

- (id<EGShaderSystem>)shaderSystem {
    return EGSimpleShaderSystem.instance;
}

- (ODType*)type {
    return _EGSimpleMaterial_type;
}

+ (ODType*)type {
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
static ODType* _EGStandardMaterial_type;
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
    _EGStandardMaterial_type = [ODType typeWithCls:[EGStandardMaterial class]];
}

+ (EGStandardMaterial*)applyDiffuse:(EGColorSource*)diffuse {
    return [EGStandardMaterial standardMaterialWithDiffuse:diffuse specularColor:EGColorMake(0.0, 0.0, 0.0, 1.0) specularSize:1.0];
}

- (id<EGShaderSystem>)shaderSystem {
    return EGStandardShaderSystem.instance;
}

- (ODType*)type {
    return _EGStandardMaterial_type;
}

+ (ODType*)type {
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


