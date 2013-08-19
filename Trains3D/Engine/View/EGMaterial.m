#import "EGMaterial.h"

#import "EGGL.h"
@implementation EGMaterial{
    EGColor _ambient;
    EGColor _diffuse;
    EGColor _specular;
    double _shininess;
}
static EGMaterial* _default;
static EGMaterial* _emerald;
static EGMaterial* _jade;
static EGMaterial* _obsidian;
static EGMaterial* _pearl;
static EGMaterial* _ruby;
static EGMaterial* _turquoise;
static EGMaterial* _brass;
static EGMaterial* _bronze;
static EGMaterial* _chrome;
static EGMaterial* _copper;
static EGMaterial* _gold;
static EGMaterial* _silver;
static EGMaterial* _blackPlastic;
static EGMaterial* _cyanPlastic;
static EGMaterial* _greenPlastic;
static EGMaterial* _redPlastic;
static EGMaterial* _whitePlastic;
static EGMaterial* _yellowPlastic;
static EGMaterial* _blackRubber;
static EGMaterial* _cyanRubber;
static EGMaterial* _greenRubber;
static EGMaterial* _redRubber;
static EGMaterial* _whiteRubber;
static EGMaterial* _yellowRubber;
static EGMaterial* _wood;
static EGMaterial* _stone;
static EGMaterial* _steel;
static EGMaterial* _grass;
@synthesize ambient = _ambient;
@synthesize diffuse = _diffuse;
@synthesize specular = _specular;
@synthesize shininess = _shininess;

+ (id)materialWithAmbient:(EGColor)ambient diffuse:(EGColor)diffuse specular:(EGColor)specular shininess:(double)shininess {
    return [[EGMaterial alloc] initWithAmbient:ambient diffuse:diffuse specular:specular shininess:shininess];
}

- (id)initWithAmbient:(EGColor)ambient diffuse:(EGColor)diffuse specular:(EGColor)specular shininess:(double)shininess {
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
    _default = [EGMaterial materialWithAmbient:EGColorMake(0.2, 0.2, 0.2, 1) diffuse:EGColorMake(0.8, 0.8, 0.8, 1) specular:EGColorMake(0.0, 0.0, 0.0, 1) shininess:0];
    _emerald = [EGMaterial materialWithAmbient:EGColorMake(0.0215, 0.1745, 0.0215, 1) diffuse:EGColorMake(0.07568, 0.61424, 0.07568, 1) specular:EGColorMake(0.633, 0.727811, 0.633, 1) shininess:0.6];
    _jade = [EGMaterial materialWithAmbient:EGColorMake(0.135, 0.2225, 0.1575, 1) diffuse:EGColorMake(0.54, 0.89, 0.63, 1) specular:EGColorMake(0.316228, 0.316228, 0.316228, 1) shininess:0.1];
    _obsidian = [EGMaterial materialWithAmbient:EGColorMake(0.05375, 0.05, 0.06625, 1) diffuse:EGColorMake(0.18275, 0.17, 0.22525, 1) specular:EGColorMake(0.332741, 0.328634, 0.346435, 1) shininess:0.3];
    _pearl = [EGMaterial materialWithAmbient:EGColorMake(0.25, 0.20725, 0.20725, 1) diffuse:EGColorMake(1, 0.829, 0.829, 1) specular:EGColorMake(0.296648, 0.296648, 0.296648, 1) shininess:0.088];
    _ruby = [EGMaterial materialWithAmbient:EGColorMake(0.1745, 0.01175, 0.01175, 1) diffuse:EGColorMake(0.61424, 0.04136, 0.04136, 1) specular:EGColorMake(0.727811, 0.626959, 0.626959, 1) shininess:0.6];
    _turquoise = [EGMaterial materialWithAmbient:EGColorMake(0.1, 0.18725, 0.1745, 1) diffuse:EGColorMake(0.396, 0.74151, 0.69102, 1) specular:EGColorMake(0.297254, 0.30829, 0.306678, 1) shininess:0.1];
    _brass = [EGMaterial materialWithAmbient:EGColorMake(0.329412, 0.223529, 0.027451, 1) diffuse:EGColorMake(0.780392, 0.568627, 0.113725, 1) specular:EGColorMake(0.992157, 0.941176, 0.807843, 1) shininess:0.21794872];
    _bronze = [EGMaterial materialWithAmbient:EGColorMake(0.2125, 0.1275, 0.054, 1) diffuse:EGColorMake(0.714, 0.4284, 0.18144, 1) specular:EGColorMake(0.393548, 0.271906, 0.166721, 1) shininess:0.2];
    _chrome = [EGMaterial materialWithAmbient:EGColorMake(0.25, 0.25, 0.25, 1) diffuse:EGColorMake(0.4, 0.4, 0.4, 1) specular:EGColorMake(0.774597, 0.774597, 0.774597, 1) shininess:0.6];
    _copper = [EGMaterial materialWithAmbient:EGColorMake(0.19125, 0.0735, 0.0225, 1) diffuse:EGColorMake(0.7038, 0.27048, 0.0828, 1) specular:EGColorMake(0.256777, 0.137622, 0.086014, 1) shininess:0.1];
    _gold = [EGMaterial materialWithAmbient:EGColorMake(0.24725, 0.1995, 0.0745, 1) diffuse:EGColorMake(0.75164, 0.60648, 0.22648, 1) specular:EGColorMake(0.628281, 0.555802, 0.366065, 1) shininess:0.4];
    _silver = [EGMaterial materialWithAmbient:EGColorMake(0.19225, 0.19225, 0.19225, 1) diffuse:EGColorMake(0.50754, 0.50754, 0.50754, 1) specular:EGColorMake(0.508273, 0.508273, 0.508273, 1) shininess:0.4];
    _blackPlastic = [EGMaterial materialWithAmbient:EGColorMake(0.0, 0.0, 0.0, 1) diffuse:EGColorMake(0.01, 0.01, 0.01, 1) specular:EGColorMake(0.50, 0.50, 0.50, 1) shininess:0.25];
    _cyanPlastic = [EGMaterial materialWithAmbient:EGColorMake(0.0, 0.1, 0.06, 1) diffuse:EGColorMake(0.0, 0.50980392, 0.50980392, 1) specular:EGColorMake(0.50196078, 0.50196078, 0.50196078, 1) shininess:0.25];
    _greenPlastic = [EGMaterial materialWithAmbient:EGColorMake(0.0, 0.0, 0.0, 1) diffuse:EGColorMake(0.1, 0.35, 0.1, 1) specular:EGColorMake(0.45, 0.55, 0.45, 1) shininess:0.25];
    _redPlastic = [EGMaterial materialWithAmbient:EGColorMake(0.0, 0.0, 0.0, 1) diffuse:EGColorMake(0.5, 0.0, 0.0, 1) specular:EGColorMake(0.7, 0.6, 0.6, 1) shininess:0.25];
    _whitePlastic = [EGMaterial materialWithAmbient:EGColorMake(0.0, 0.0, 0.0, 1) diffuse:EGColorMake(0.55, 0.55, 0.55, 1) specular:EGColorMake(0.70, 0.70, 0.70, 1) shininess:0.25];
    _yellowPlastic = [EGMaterial materialWithAmbient:EGColorMake(0.0, 0.0, 0.0, 1) diffuse:EGColorMake(0.5, 0.5, 0.0, 1) specular:EGColorMake(0.60, 0.60, 0.50, 1) shininess:0.25];
    _blackRubber = [EGMaterial materialWithAmbient:EGColorMake(0.02, 0.02, 0.02, 1) diffuse:EGColorMake(0.01, 0.01, 0.01, 1) specular:EGColorMake(0.4, 0.4, 0.4, 1) shininess:0.078125];
    _cyanRubber = [EGMaterial materialWithAmbient:EGColorMake(0.0, 0.05, 0.05, 1) diffuse:EGColorMake(0.4, 0.5, 0.5, 1) specular:EGColorMake(0.04, 0.7, 0.7, 1) shininess:0.078125];
    _greenRubber = [EGMaterial materialWithAmbient:EGColorMake(0.0, 0.05, 0.0, 1) diffuse:EGColorMake(0.4, 0.5, 0.4, 1) specular:EGColorMake(0.04, 0.7, 0.04, 1) shininess:0.078125];
    _redRubber = [EGMaterial materialWithAmbient:EGColorMake(0.05, 0.0, 0.0, 1) diffuse:EGColorMake(0.5, 0.4, 0.4, 1) specular:EGColorMake(0.7, 0.04, 0.04, 1) shininess:0.078125];
    _whiteRubber = [EGMaterial materialWithAmbient:EGColorMake(0.05, 0.05, 0.05, 1) diffuse:EGColorMake(0.5, 0.5, 0.5, 1) specular:EGColorMake(0.7, 0.7, 0.7, 1) shininess:0.078125];
    _yellowRubber = [EGMaterial materialWithAmbient:EGColorMake(0.05, 0.05, 0.0, 1) diffuse:EGColorMake(0.5, 0.5, 0.4, 1) specular:EGColorMake(0.7, 0.7, 0.04, 1) shininess:0.078125];
    _wood = [EGMaterial materialWithAmbient:EGColorMake(0.05, 0.0, 0.0, 1) diffuse:EGColorMake(0.55, 0.45, 0.25, 1) specular:EGColorMake(0.04, 0.04, 0.04, 1) shininess:0.07];
    _stone = [EGMaterial materialWithAmbient:EGColorMake(0.0, 0.0, 0.0, 1) diffuse:EGColorMake(0.9, 0.85, 0.8, 1) specular:EGColorMake(0.0, 0.0, 0.0, 1) shininess:0.0];
    _steel = [EGMaterial materialWithAmbient:EGColorMake(0.189, 0.19, 0.2, 1) diffuse:EGColorMake(0.45, 0.47, 0.55, 1) specular:EGColorMake(0.508273, 0.508273, 0.508273, 1) shininess:0.4];
    _grass = [EGMaterial materialWithAmbient:EGColorMake(0.7, 0.8, 0.6, 1) diffuse:EGColorMake(0.7, 0.8, 0.6, 1) specular:EGColorMake(0.0, 0.0, 0.0, 1) shininess:0.0];
}

- (void)set {
    egColorSet(_ambient);
    egMaterialColor(GL_FRONT_AND_BACK, GL_AMBIENT, _ambient);
    egMaterialColor(GL_FRONT_AND_BACK, GL_DIFFUSE, _diffuse);
    egMaterialColor(GL_FRONT_AND_BACK, GL_SPECULAR, _specular);
    egMaterial(GL_FRONT_AND_BACK, GL_SHININESS, 128.0 * _shininess);
}

- (void)drawF:(void(^)())f {
    [self set];
    ((void(^)())(f))();
    [_default set];
}

+ (EGMaterial*)default {
    return _default;
}

+ (EGMaterial*)emerald {
    return _emerald;
}

+ (EGMaterial*)jade {
    return _jade;
}

+ (EGMaterial*)obsidian {
    return _obsidian;
}

+ (EGMaterial*)pearl {
    return _pearl;
}

+ (EGMaterial*)ruby {
    return _ruby;
}

+ (EGMaterial*)turquoise {
    return _turquoise;
}

+ (EGMaterial*)brass {
    return _brass;
}

+ (EGMaterial*)bronze {
    return _bronze;
}

+ (EGMaterial*)chrome {
    return _chrome;
}

+ (EGMaterial*)copper {
    return _copper;
}

+ (EGMaterial*)gold {
    return _gold;
}

+ (EGMaterial*)silver {
    return _silver;
}

+ (EGMaterial*)blackPlastic {
    return _blackPlastic;
}

+ (EGMaterial*)cyanPlastic {
    return _cyanPlastic;
}

+ (EGMaterial*)greenPlastic {
    return _greenPlastic;
}

+ (EGMaterial*)redPlastic {
    return _redPlastic;
}

+ (EGMaterial*)whitePlastic {
    return _whitePlastic;
}

+ (EGMaterial*)yellowPlastic {
    return _yellowPlastic;
}

+ (EGMaterial*)blackRubber {
    return _blackRubber;
}

+ (EGMaterial*)cyanRubber {
    return _cyanRubber;
}

+ (EGMaterial*)greenRubber {
    return _greenRubber;
}

+ (EGMaterial*)redRubber {
    return _redRubber;
}

+ (EGMaterial*)whiteRubber {
    return _whiteRubber;
}

+ (EGMaterial*)yellowRubber {
    return _yellowRubber;
}

+ (EGMaterial*)wood {
    return _wood;
}

+ (EGMaterial*)stone {
    return _stone;
}

+ (EGMaterial*)steel {
    return _steel;
}

+ (EGMaterial*)grass {
    return _grass;
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
    hash = hash * 31 + [[NSNumber numberWithDouble:self.shininess] hash];
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


