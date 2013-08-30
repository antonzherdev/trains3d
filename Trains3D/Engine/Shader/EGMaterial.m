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


@implementation EGMaterial{
    EGColor _ambient;
    EGColor _diffuse;
    EGColor _specular;
    CGFloat _shininess;
}
static EGMaterial* _EGMaterial_default;
static EGMaterial* _EGMaterial_emerald;
static EGMaterial* _EGMaterial_jade;
static EGMaterial* _EGMaterial_obsidian;
static EGMaterial* _EGMaterial_pearl;
static EGMaterial* _EGMaterial_ruby;
static EGMaterial* _EGMaterial_turquoise;
static EGMaterial* _EGMaterial_brass;
static EGMaterial* _EGMaterial_bronze;
static EGMaterial* _EGMaterial_chrome;
static EGMaterial* _EGMaterial_copper;
static EGMaterial* _EGMaterial_gold;
static EGMaterial* _EGMaterial_silver;
static EGMaterial* _EGMaterial_blackPlastic;
static EGMaterial* _EGMaterial_cyanPlastic;
static EGMaterial* _EGMaterial_greenPlastic;
static EGMaterial* _EGMaterial_redPlastic;
static EGMaterial* _EGMaterial_whitePlastic;
static EGMaterial* _EGMaterial_yellowPlastic;
static EGMaterial* _EGMaterial_blackRubber;
static EGMaterial* _EGMaterial_cyanRubber;
static EGMaterial* _EGMaterial_greenRubber;
static EGMaterial* _EGMaterial_redRubber;
static EGMaterial* _EGMaterial_whiteRubber;
static EGMaterial* _EGMaterial_yellowRubber;
static EGMaterial* _EGMaterial_wood;
static EGMaterial* _EGMaterial_stone;
static EGMaterial* _EGMaterial_steel;
static EGMaterial* _EGMaterial_blackMetal;
static EGMaterial* _EGMaterial_grass;
static ODType* _EGMaterial_type;
@synthesize ambient = _ambient;
@synthesize diffuse = _diffuse;
@synthesize specular = _specular;
@synthesize shininess = _shininess;

+ (id)materialWithAmbient:(EGColor)ambient diffuse:(EGColor)diffuse specular:(EGColor)specular shininess:(CGFloat)shininess {
    return [[EGMaterial alloc] initWithAmbient:ambient diffuse:diffuse specular:specular shininess:shininess];
}

- (id)initWithAmbient:(EGColor)ambient diffuse:(EGColor)diffuse specular:(EGColor)specular shininess:(CGFloat)shininess {
    self = [super init];
    if(self) {
        _ambient = ambient;
        _diffuse = diffuse;
        _specular = specular;
        _shininess = shininess;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGMaterial_default = [EGMaterial materialWithAmbient:EGColorMake(0.2, 0.2, 0.2, 1.0) diffuse:EGColorMake(0.8, 0.8, 0.8, 1.0) specular:EGColorMake(0.0, 0.0, 0.0, 1.0) shininess:0.0];
    _EGMaterial_emerald = [EGMaterial materialWithAmbient:EGColorMake(0.0215, 0.1745, 0.0215, 1.0) diffuse:EGColorMake(0.07568, 0.61424, 0.07568, 1.0) specular:EGColorMake(0.633, 0.727811, 0.633, 1.0) shininess:0.6];
    _EGMaterial_jade = [EGMaterial materialWithAmbient:EGColorMake(0.135, 0.2225, 0.1575, 1.0) diffuse:EGColorMake(0.54, 0.89, 0.63, 1.0) specular:EGColorMake(0.316228, 0.316228, 0.316228, 1.0) shininess:0.1];
    _EGMaterial_obsidian = [EGMaterial materialWithAmbient:EGColorMake(0.05375, 0.05, 0.06625, 1.0) diffuse:EGColorMake(0.18275, 0.17, 0.22525, 1.0) specular:EGColorMake(0.332741, 0.328634, 0.346435, 1.0) shininess:0.3];
    _EGMaterial_pearl = [EGMaterial materialWithAmbient:EGColorMake(0.25, 0.20725, 0.20725, 1.0) diffuse:EGColorMake(1.0, 0.829, 0.829, 1.0) specular:EGColorMake(0.296648, 0.296648, 0.296648, 1.0) shininess:0.088];
    _EGMaterial_ruby = [EGMaterial materialWithAmbient:EGColorMake(0.1745, 0.01175, 0.01175, 1.0) diffuse:EGColorMake(0.61424, 0.04136, 0.04136, 1.0) specular:EGColorMake(0.727811, 0.626959, 0.626959, 1.0) shininess:0.6];
    _EGMaterial_turquoise = [EGMaterial materialWithAmbient:EGColorMake(0.1, 0.18725, 0.1745, 1.0) diffuse:EGColorMake(0.396, 0.74151, 0.69102, 1.0) specular:EGColorMake(0.297254, 0.30829, 0.306678, 1.0) shininess:0.1];
    _EGMaterial_brass = [EGMaterial materialWithAmbient:EGColorMake(0.329412, 0.223529, 0.027451, 1.0) diffuse:EGColorMake(0.780392, 0.568627, 0.113725, 1.0) specular:EGColorMake(0.992157, 0.941176, 0.807843, 1.0) shininess:0.21794872];
    _EGMaterial_bronze = [EGMaterial materialWithAmbient:EGColorMake(0.2125, 0.1275, 0.054, 1.0) diffuse:EGColorMake(0.714, 0.4284, 0.18144, 1.0) specular:EGColorMake(0.393548, 0.271906, 0.166721, 1.0) shininess:0.2];
    _EGMaterial_chrome = [EGMaterial materialWithAmbient:EGColorMake(0.25, 0.25, 0.25, 1.0) diffuse:EGColorMake(0.4, 0.4, 0.4, 1.0) specular:EGColorMake(0.774597, 0.774597, 0.774597, 1.0) shininess:0.6];
    _EGMaterial_copper = [EGMaterial materialWithAmbient:EGColorMake(0.19125, 0.0735, 0.0225, 1.0) diffuse:EGColorMake(0.7038, 0.27048, 0.0828, 1.0) specular:EGColorMake(0.256777, 0.137622, 0.086014, 1.0) shininess:0.1];
    _EGMaterial_gold = [EGMaterial materialWithAmbient:EGColorMake(0.24725, 0.1995, 0.0745, 1.0) diffuse:EGColorMake(0.75164, 0.60648, 0.22648, 1.0) specular:EGColorMake(0.628281, 0.555802, 0.366065, 1.0) shininess:0.4];
    _EGMaterial_silver = [EGMaterial materialWithAmbient:EGColorMake(0.19225, 0.19225, 0.19225, 1.0) diffuse:EGColorMake(0.50754, 0.50754, 0.50754, 1.0) specular:EGColorMake(0.508273, 0.508273, 0.508273, 1.0) shininess:0.4];
    _EGMaterial_blackPlastic = [EGMaterial materialWithAmbient:EGColorMake(0.0, 0.0, 0.0, 1.0) diffuse:EGColorMake(0.01, 0.01, 0.01, 1.0) specular:EGColorMake(0.50, 0.50, 0.50, 1.0) shininess:0.25];
    _EGMaterial_cyanPlastic = [EGMaterial materialWithAmbient:EGColorMake(0.0, 0.1, 0.06, 1.0) diffuse:EGColorMake(0.0, 0.50980392, 0.50980392, 1.0) specular:EGColorMake(0.50196078, 0.50196078, 0.50196078, 1.0) shininess:0.25];
    _EGMaterial_greenPlastic = [EGMaterial materialWithAmbient:EGColorMake(0.0, 0.0, 0.0, 1.0) diffuse:EGColorMake(0.1, 0.35, 0.1, 1.0) specular:EGColorMake(0.45, 0.55, 0.45, 1.0) shininess:0.25];
    _EGMaterial_redPlastic = [EGMaterial materialWithAmbient:EGColorMake(0.0, 0.0, 0.0, 1.0) diffuse:EGColorMake(0.5, 0.0, 0.0, 1.0) specular:EGColorMake(0.7, 0.6, 0.6, 1.0) shininess:0.25];
    _EGMaterial_whitePlastic = [EGMaterial materialWithAmbient:EGColorMake(0.0, 0.0, 0.0, 1.0) diffuse:EGColorMake(0.55, 0.55, 0.55, 1.0) specular:EGColorMake(0.70, 0.70, 0.70, 1.0) shininess:0.25];
    _EGMaterial_yellowPlastic = [EGMaterial materialWithAmbient:EGColorMake(0.0, 0.0, 0.0, 1.0) diffuse:EGColorMake(0.5, 0.5, 0.0, 1.0) specular:EGColorMake(0.60, 0.60, 0.50, 1.0) shininess:0.25];
    _EGMaterial_blackRubber = [EGMaterial materialWithAmbient:EGColorMake(0.02, 0.02, 0.02, 1.0) diffuse:EGColorMake(0.01, 0.01, 0.01, 1.0) specular:EGColorMake(0.4, 0.4, 0.4, 1.0) shininess:0.078125];
    _EGMaterial_cyanRubber = [EGMaterial materialWithAmbient:EGColorMake(0.0, 0.05, 0.05, 1.0) diffuse:EGColorMake(0.4, 0.5, 0.5, 1.0) specular:EGColorMake(0.04, 0.7, 0.7, 1.0) shininess:0.078125];
    _EGMaterial_greenRubber = [EGMaterial materialWithAmbient:EGColorMake(0.0, 0.05, 0.0, 1.0) diffuse:EGColorMake(0.4, 0.5, 0.4, 1.0) specular:EGColorMake(0.04, 0.7, 0.04, 1.0) shininess:0.078125];
    _EGMaterial_redRubber = [EGMaterial materialWithAmbient:EGColorMake(0.05, 0.0, 0.0, 1.0) diffuse:EGColorMake(0.5, 0.4, 0.4, 1.0) specular:EGColorMake(0.7, 0.04, 0.04, 1.0) shininess:0.078125];
    _EGMaterial_whiteRubber = [EGMaterial materialWithAmbient:EGColorMake(0.05, 0.05, 0.05, 1.0) diffuse:EGColorMake(0.5, 0.5, 0.5, 1.0) specular:EGColorMake(0.7, 0.7, 0.7, 1.0) shininess:0.078125];
    _EGMaterial_yellowRubber = [EGMaterial materialWithAmbient:EGColorMake(0.05, 0.05, 0.0, 1.0) diffuse:EGColorMake(0.5, 0.5, 0.4, 1.0) specular:EGColorMake(0.7, 0.7, 0.04, 1.0) shininess:0.078125];
    _EGMaterial_wood = [EGMaterial materialWithAmbient:EGColorMake(0.05, 0.0, 0.0, 1.0) diffuse:EGColorMake(0.55, 0.45, 0.25, 1.0) specular:EGColorMake(0.04, 0.04, 0.04, 1.0) shininess:0.07];
    _EGMaterial_stone = [EGMaterial materialWithAmbient:EGColorMake(0.0, 0.0, 0.0, 1.0) diffuse:EGColorMake(0.9, 0.85, 0.8, 1.0) specular:EGColorMake(0.0, 0.0, 0.0, 1.0) shininess:0.0];
    _EGMaterial_steel = [EGMaterial materialWithAmbient:EGColorMake(0.189, 0.19, 0.2, 1.0) diffuse:EGColorMake(0.45, 0.47, 0.55, 1.0) specular:EGColorMake(0.508273, 0.508273, 0.508273, 1.0) shininess:0.4];
    _EGMaterial_blackMetal = [EGMaterial materialWithAmbient:EGColorMake(0.05, 0.05, 0.05, 1.0) diffuse:EGColorMake(0.1, 0.1, 0.1, 1.0) specular:EGColorMake(0.3, 0.3, 0.3, 1.0) shininess:0.2];
    _EGMaterial_grass = [EGMaterial materialWithAmbient:EGColorMake(0.7, 0.8, 0.6, 1.0) diffuse:EGColorMake(0.7, 0.8, 0.6, 1.0) specular:EGColorMake(0.0, 0.0, 0.0, 1.0) shininess:0.0];
    _EGMaterial_type = [ODType typeWithCls:[EGMaterial class]];
}

- (void)set {
    egColor(_ambient);
    egMaterialColor(GL_FRONT_AND_BACK, GL_AMBIENT, _ambient);
    egMaterialColor(GL_FRONT_AND_BACK, GL_DIFFUSE, _diffuse);
    egMaterialColor(GL_FRONT_AND_BACK, GL_SPECULAR, _specular);
    egMaterial(GL_FRONT_AND_BACK, GL_SHININESS, 128.0 * _shininess);
}

- (void)drawF:(void(^)())f {
    [self set];
    ((void(^)())(f))();
    [_EGMaterial_default set];
}

- (ODType*)type {
    return _EGMaterial_type;
}

+ (EGMaterial*)aDefault {
    return _EGMaterial_default;
}

+ (EGMaterial*)emerald {
    return _EGMaterial_emerald;
}

+ (EGMaterial*)jade {
    return _EGMaterial_jade;
}

+ (EGMaterial*)obsidian {
    return _EGMaterial_obsidian;
}

+ (EGMaterial*)pearl {
    return _EGMaterial_pearl;
}

+ (EGMaterial*)ruby {
    return _EGMaterial_ruby;
}

+ (EGMaterial*)turquoise {
    return _EGMaterial_turquoise;
}

+ (EGMaterial*)brass {
    return _EGMaterial_brass;
}

+ (EGMaterial*)bronze {
    return _EGMaterial_bronze;
}

+ (EGMaterial*)chrome {
    return _EGMaterial_chrome;
}

+ (EGMaterial*)copper {
    return _EGMaterial_copper;
}

+ (EGMaterial*)gold {
    return _EGMaterial_gold;
}

+ (EGMaterial*)silver {
    return _EGMaterial_silver;
}

+ (EGMaterial*)blackPlastic {
    return _EGMaterial_blackPlastic;
}

+ (EGMaterial*)cyanPlastic {
    return _EGMaterial_cyanPlastic;
}

+ (EGMaterial*)greenPlastic {
    return _EGMaterial_greenPlastic;
}

+ (EGMaterial*)redPlastic {
    return _EGMaterial_redPlastic;
}

+ (EGMaterial*)whitePlastic {
    return _EGMaterial_whitePlastic;
}

+ (EGMaterial*)yellowPlastic {
    return _EGMaterial_yellowPlastic;
}

+ (EGMaterial*)blackRubber {
    return _EGMaterial_blackRubber;
}

+ (EGMaterial*)cyanRubber {
    return _EGMaterial_cyanRubber;
}

+ (EGMaterial*)greenRubber {
    return _EGMaterial_greenRubber;
}

+ (EGMaterial*)redRubber {
    return _EGMaterial_redRubber;
}

+ (EGMaterial*)whiteRubber {
    return _EGMaterial_whiteRubber;
}

+ (EGMaterial*)yellowRubber {
    return _EGMaterial_yellowRubber;
}

+ (EGMaterial*)wood {
    return _EGMaterial_wood;
}

+ (EGMaterial*)stone {
    return _EGMaterial_stone;
}

+ (EGMaterial*)steel {
    return _EGMaterial_steel;
}

+ (EGMaterial*)blackMetal {
    return _EGMaterial_blackMetal;
}

+ (EGMaterial*)grass {
    return _EGMaterial_grass;
}

+ (ODType*)type {
    return _EGMaterial_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGMaterial* o = ((EGMaterial*)(other));
    return EGColorEq(self.ambient, o.ambient) && EGColorEq(self.diffuse, o.diffuse) && EGColorEq(self.specular, o.specular) && eqf(self.shininess, o.shininess);
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + EGColorHash(self.ambient);
    hash = hash * 31 + EGColorHash(self.diffuse);
    hash = hash * 31 + EGColorHash(self.specular);
    hash = hash * 31 + floatHash(self.shininess);
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"ambient=%@", EGColorDescription(self.ambient)];
    [description appendFormat:@", diffuse=%@", EGColorDescription(self.diffuse)];
    [description appendFormat:@", specular=%@", EGColorDescription(self.specular)];
    [description appendFormat:@", shininess=%f", self.shininess];
    [description appendString:@">"];
    return description;
}

@end


