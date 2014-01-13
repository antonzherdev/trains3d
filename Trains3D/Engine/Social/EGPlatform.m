#import "EGPlatform.h"

@implementation EGOSType{
    BOOL _shadows;
    BOOL _touch;
}
static EGOSType* _EGOSType_MacOS;
static EGOSType* _EGOSType_iOS;
static NSArray* _EGOSType_values;
@synthesize shadows = _shadows;
@synthesize touch = _touch;

+ (id)typeWithOrdinal:(NSUInteger)ordinal name:(NSString*)name shadows:(BOOL)shadows touch:(BOOL)touch {
    return [[EGOSType alloc] initWithOrdinal:ordinal name:name shadows:shadows touch:touch];
}

- (id)initWithOrdinal:(NSUInteger)ordinal name:(NSString*)name shadows:(BOOL)shadows touch:(BOOL)touch {
    self = [super initWithOrdinal:ordinal name:name];
    if(self) {
        _shadows = shadows;
        _touch = touch;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGOSType_MacOS = [EGOSType typeWithOrdinal:0 name:@"MacOS" shadows:YES touch:NO];
    _EGOSType_iOS = [EGOSType typeWithOrdinal:1 name:@"iOS" shadows:YES touch:YES];
    _EGOSType_values = (@[_EGOSType_MacOS, _EGOSType_iOS]);
}

+ (EGOSType*)MacOS {
    return _EGOSType_MacOS;
}

+ (EGOSType*)iOS {
    return _EGOSType_iOS;
}

+ (NSArray*)values {
    return _EGOSType_values;
}

@end


@implementation EGInterfaceIdiom{
    BOOL _isPhone;
    BOOL _isPad;
    BOOL _isComputer;
}
static EGInterfaceIdiom* _EGInterfaceIdiom_phone;
static EGInterfaceIdiom* _EGInterfaceIdiom_pad;
static EGInterfaceIdiom* _EGInterfaceIdiom_computer;
static NSArray* _EGInterfaceIdiom_values;
@synthesize isPhone = _isPhone;
@synthesize isPad = _isPad;
@synthesize isComputer = _isComputer;

+ (id)interfaceIdiomWithOrdinal:(NSUInteger)ordinal name:(NSString*)name isPhone:(BOOL)isPhone isPad:(BOOL)isPad isComputer:(BOOL)isComputer {
    return [[EGInterfaceIdiom alloc] initWithOrdinal:ordinal name:name isPhone:isPhone isPad:isPad isComputer:isComputer];
}

- (id)initWithOrdinal:(NSUInteger)ordinal name:(NSString*)name isPhone:(BOOL)isPhone isPad:(BOOL)isPad isComputer:(BOOL)isComputer {
    self = [super initWithOrdinal:ordinal name:name];
    if(self) {
        _isPhone = isPhone;
        _isPad = isPad;
        _isComputer = isComputer;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGInterfaceIdiom_phone = [EGInterfaceIdiom interfaceIdiomWithOrdinal:0 name:@"phone" isPhone:YES isPad:NO isComputer:NO];
    _EGInterfaceIdiom_pad = [EGInterfaceIdiom interfaceIdiomWithOrdinal:1 name:@"pad" isPhone:NO isPad:YES isComputer:NO];
    _EGInterfaceIdiom_computer = [EGInterfaceIdiom interfaceIdiomWithOrdinal:2 name:@"computer" isPhone:NO isPad:NO isComputer:YES];
    _EGInterfaceIdiom_values = (@[_EGInterfaceIdiom_phone, _EGInterfaceIdiom_pad, _EGInterfaceIdiom_computer]);
}

+ (EGInterfaceIdiom*)phone {
    return _EGInterfaceIdiom_phone;
}

+ (EGInterfaceIdiom*)pad {
    return _EGInterfaceIdiom_pad;
}

+ (EGInterfaceIdiom*)computer {
    return _EGInterfaceIdiom_computer;
}

+ (NSArray*)values {
    return _EGInterfaceIdiom_values;
}

@end


@implementation EGPlatform{
    EGOSType* _os;
    EGInterfaceIdiom* _interfaceIdiom;
    EGVersion* _version;
    GEVec2 _screenSize;
    NSString* _text;
    BOOL _shadows;
    BOOL _touch;
    BOOL _isPhone;
    BOOL _isPad;
    BOOL _isComputer;
}
static ODClassType* _EGPlatform_type;
@synthesize os = _os;
@synthesize interfaceIdiom = _interfaceIdiom;
@synthesize version = _version;
@synthesize screenSize = _screenSize;
@synthesize text = _text;
@synthesize shadows = _shadows;
@synthesize touch = _touch;
@synthesize isPhone = _isPhone;
@synthesize isPad = _isPad;
@synthesize isComputer = _isComputer;

+ (id)platformWithOs:(EGOSType*)os interfaceIdiom:(EGInterfaceIdiom*)interfaceIdiom version:(EGVersion*)version screenSize:(GEVec2)screenSize text:(NSString*)text {
    return [[EGPlatform alloc] initWithOs:os interfaceIdiom:interfaceIdiom version:version screenSize:screenSize text:text];
}

- (id)initWithOs:(EGOSType*)os interfaceIdiom:(EGInterfaceIdiom*)interfaceIdiom version:(EGVersion*)version screenSize:(GEVec2)screenSize text:(NSString*)text {
    self = [super init];
    if(self) {
        _os = os;
        _interfaceIdiom = interfaceIdiom;
        _version = version;
        _screenSize = screenSize;
        _text = text;
        _shadows = _os.shadows;
        _touch = _os.touch;
        _isPhone = _interfaceIdiom.isPhone;
        _isPad = _interfaceIdiom.isPad;
        _isComputer = _interfaceIdiom.isComputer;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGPlatform_type = [ODClassType classTypeWithCls:[EGPlatform class]];
}

- (CGFloat)screenSizeRatio {
    return ((CGFloat)(_screenSize.x / _screenSize.y));
}

- (ODClassType*)type {
    return [EGPlatform type];
}

+ (ODClassType*)type {
    return _EGPlatform_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGPlatform* o = ((EGPlatform*)(other));
    return self.os == o.os && self.interfaceIdiom == o.interfaceIdiom && [self.version isEqual:o.version] && GEVec2Eq(self.screenSize, o.screenSize) && [self.text isEqual:o.text];
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.os ordinal];
    hash = hash * 31 + [self.interfaceIdiom ordinal];
    hash = hash * 31 + [self.version hash];
    hash = hash * 31 + GEVec2Hash(self.screenSize);
    hash = hash * 31 + [self.text hash];
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"os=%@", self.os];
    [description appendFormat:@", interfaceIdiom=%@", self.interfaceIdiom];
    [description appendFormat:@", version=%@", self.version];
    [description appendFormat:@", screenSize=%@", GEVec2Description(self.screenSize)];
    [description appendFormat:@", text=%@", self.text];
    [description appendString:@">"];
    return description;
}

@end


@implementation EGVersion{
    id<CNSeq> _parts;
}
static ODClassType* _EGVersion_type;
@synthesize parts = _parts;

+ (id)versionWithParts:(id<CNSeq>)parts {
    return [[EGVersion alloc] initWithParts:parts];
}

- (id)initWithParts:(id<CNSeq>)parts {
    self = [super init];
    if(self) _parts = parts;
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGVersion_type = [ODClassType classTypeWithCls:[EGVersion class]];
}

+ (EGVersion*)applyStr:(NSString*)str {
    return [EGVersion versionWithParts:[[[[str splitBy:@"."] chain] map:^id(NSString* _) {
        return numi([_ toInt]);
    }] toArray]];
}

- (NSInteger)compareTo:(EGVersion*)to {
    id<CNIterator> i = [_parts iterator];
    id<CNIterator> j = [to.parts iterator];
    while([i hasNext] && [j hasNext]) {
        NSInteger vi = unumi([i next]);
        NSInteger vj = unumi([j next]);
        if(vi != vj) return intCompareTo(vi, vj);
    }
    return 0;
}

- (ODClassType*)type {
    return [EGVersion type];
}

+ (ODClassType*)type {
    return _EGVersion_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGVersion* o = ((EGVersion*)(other));
    return [self.parts isEqual:o.parts];
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.parts hash];
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"parts=%@", self.parts];
    [description appendString:@">"];
    return description;
}

@end

