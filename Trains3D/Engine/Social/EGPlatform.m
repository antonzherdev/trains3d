#import "EGPlatform.h"

#import "CNChain.h"
@implementation EGOSType{
    BOOL _shadows;
    BOOL _touch;
}
@synthesize shadows = _shadows;
@synthesize touch = _touch;

+ (instancetype)typeWithOrdinal:(NSUInteger)ordinal name:(NSString*)name shadows:(BOOL)shadows touch:(BOOL)touch {
    return [[EGOSType alloc] initWithOrdinal:ordinal name:name shadows:shadows touch:touch];
}

- (instancetype)initWithOrdinal:(NSUInteger)ordinal name:(NSString*)name shadows:(BOOL)shadows touch:(BOOL)touch {
    self = [super initWithOrdinal:ordinal name:name];
    if(self) {
        _shadows = shadows;
        _touch = touch;
    }
    
    return self;
}

+ (void)load {
    [super load];
    EGOSType_MacOS_Desc = [EGOSType typeWithOrdinal:0 name:@"MacOS" shadows:YES touch:NO];
    EGOSType_iOS_Desc = [EGOSType typeWithOrdinal:1 name:@"iOS" shadows:YES touch:YES];
    EGOSType_Values[0] = EGOSType_MacOS_Desc;
    EGOSType_Values[1] = EGOSType_iOS_Desc;
}

+ (NSArray*)values {
    return (@[EGOSType_MacOS_Desc, EGOSType_iOS_Desc]);
}

@end

@implementation EGInterfaceIdiom{
    BOOL _isPhone;
    BOOL _isPad;
    BOOL _isComputer;
}
@synthesize isPhone = _isPhone;
@synthesize isPad = _isPad;
@synthesize isComputer = _isComputer;

+ (instancetype)interfaceIdiomWithOrdinal:(NSUInteger)ordinal name:(NSString*)name isPhone:(BOOL)isPhone isPad:(BOOL)isPad isComputer:(BOOL)isComputer {
    return [[EGInterfaceIdiom alloc] initWithOrdinal:ordinal name:name isPhone:isPhone isPad:isPad isComputer:isComputer];
}

- (instancetype)initWithOrdinal:(NSUInteger)ordinal name:(NSString*)name isPhone:(BOOL)isPhone isPad:(BOOL)isPad isComputer:(BOOL)isComputer {
    self = [super initWithOrdinal:ordinal name:name];
    if(self) {
        _isPhone = isPhone;
        _isPad = isPad;
        _isComputer = isComputer;
    }
    
    return self;
}

+ (void)load {
    [super load];
    EGInterfaceIdiom_phone_Desc = [EGInterfaceIdiom interfaceIdiomWithOrdinal:0 name:@"phone" isPhone:YES isPad:NO isComputer:NO];
    EGInterfaceIdiom_pad_Desc = [EGInterfaceIdiom interfaceIdiomWithOrdinal:1 name:@"pad" isPhone:NO isPad:YES isComputer:NO];
    EGInterfaceIdiom_computer_Desc = [EGInterfaceIdiom interfaceIdiomWithOrdinal:2 name:@"computer" isPhone:NO isPad:NO isComputer:YES];
    EGInterfaceIdiom_Values[0] = EGInterfaceIdiom_phone_Desc;
    EGInterfaceIdiom_Values[1] = EGInterfaceIdiom_pad_Desc;
    EGInterfaceIdiom_Values[2] = EGInterfaceIdiom_computer_Desc;
}

+ (NSArray*)values {
    return (@[EGInterfaceIdiom_phone_Desc, EGInterfaceIdiom_pad_Desc, EGInterfaceIdiom_computer_Desc]);
}

@end

@implementation EGDeviceType

+ (instancetype)deviceTypeWithOrdinal:(NSUInteger)ordinal name:(NSString*)name {
    return [[EGDeviceType alloc] initWithOrdinal:ordinal name:name];
}

- (instancetype)initWithOrdinal:(NSUInteger)ordinal name:(NSString*)name {
    self = [super initWithOrdinal:ordinal name:name];
    
    return self;
}

+ (void)load {
    [super load];
    EGDeviceType_iPhone_Desc = [EGDeviceType deviceTypeWithOrdinal:0 name:@"iPhone"];
    EGDeviceType_iPad_Desc = [EGDeviceType deviceTypeWithOrdinal:1 name:@"iPad"];
    EGDeviceType_iPodTouch_Desc = [EGDeviceType deviceTypeWithOrdinal:2 name:@"iPodTouch"];
    EGDeviceType_Simulator_Desc = [EGDeviceType deviceTypeWithOrdinal:3 name:@"Simulator"];
    EGDeviceType_Mac_Desc = [EGDeviceType deviceTypeWithOrdinal:4 name:@"Mac"];
    EGDeviceType_Values[0] = EGDeviceType_iPhone_Desc;
    EGDeviceType_Values[1] = EGDeviceType_iPad_Desc;
    EGDeviceType_Values[2] = EGDeviceType_iPodTouch_Desc;
    EGDeviceType_Values[3] = EGDeviceType_Simulator_Desc;
    EGDeviceType_Values[4] = EGDeviceType_Mac_Desc;
}

+ (NSArray*)values {
    return (@[EGDeviceType_iPhone_Desc, EGDeviceType_iPad_Desc, EGDeviceType_iPodTouch_Desc, EGDeviceType_Simulator_Desc, EGDeviceType_Mac_Desc]);
}

@end

@implementation EGOS
static CNClassType* _EGOS_type;
@synthesize tp = _tp;
@synthesize version = _version;
@synthesize jailbreak = _jailbreak;

+ (instancetype)sWithTp:(EGOSTypeR)tp version:(EGVersion*)version jailbreak:(BOOL)jailbreak {
    return [[EGOS alloc] initWithTp:tp version:version jailbreak:jailbreak];
}

- (instancetype)initWithTp:(EGOSTypeR)tp version:(EGVersion*)version jailbreak:(BOOL)jailbreak {
    self = [super init];
    if(self) {
        _tp = tp;
        _version = version;
        _jailbreak = jailbreak;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGOS class]) _EGOS_type = [CNClassType classTypeWithCls:[EGOS class]];
}

- (BOOL)isIOS {
    return _tp == EGOSType_iOS;
}

- (BOOL)isIOSLessVersion:(NSString*)version {
    return _tp == EGOSType_iOS && [_version lessThan:version];
}

- (NSString*)description {
    return [NSString stringWithFormat:@"OS(%@, %@, %d)", EGOSType_Values[_tp], _version, _jailbreak];
}

- (BOOL)isEqual:(id)to {
    if(self == to) return YES;
    if(to == nil || !([to isKindOfClass:[EGOS class]])) return NO;
    EGOS* o = ((EGOS*)(to));
    return _tp == o.tp && [_version isEqual:o.version] && _jailbreak == o.jailbreak;
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [EGOSType_Values[_tp] hash];
    hash = hash * 31 + [_version hash];
    hash = hash * 31 + _jailbreak;
    return hash;
}

- (CNClassType*)type {
    return [EGOS type];
}

+ (CNClassType*)type {
    return _EGOS_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation EGDevice
static CNClassType* _EGDevice_type;
@synthesize tp = _tp;
@synthesize interfaceIdiom = _interfaceIdiom;
@synthesize version = _version;
@synthesize screenSize = _screenSize;

+ (instancetype)deviceWithTp:(EGDeviceTypeR)tp interfaceIdiom:(EGInterfaceIdiomR)interfaceIdiom version:(EGVersion*)version screenSize:(GEVec2)screenSize {
    return [[EGDevice alloc] initWithTp:tp interfaceIdiom:interfaceIdiom version:version screenSize:screenSize];
}

- (instancetype)initWithTp:(EGDeviceTypeR)tp interfaceIdiom:(EGInterfaceIdiomR)interfaceIdiom version:(EGVersion*)version screenSize:(GEVec2)screenSize {
    self = [super init];
    if(self) {
        _tp = tp;
        _interfaceIdiom = interfaceIdiom;
        _version = version;
        _screenSize = screenSize;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGDevice class]) _EGDevice_type = [CNClassType classTypeWithCls:[EGDevice class]];
}

- (BOOL)isIPhoneLessVersion:(NSString*)version {
    return _tp == EGDeviceType_iPhone && [_version lessThan:version];
}

- (BOOL)isIPodTouchLessVersion:(NSString*)version {
    return _tp == EGDeviceType_iPodTouch && [_version lessThan:version];
}

- (NSString*)description {
    return [NSString stringWithFormat:@"Device(%@, %@, %@, %@)", EGDeviceType_Values[_tp], EGInterfaceIdiom_Values[_interfaceIdiom], _version, geVec2Description(_screenSize)];
}

- (BOOL)isEqual:(id)to {
    if(self == to) return YES;
    if(to == nil || !([to isKindOfClass:[EGDevice class]])) return NO;
    EGDevice* o = ((EGDevice*)(to));
    return _tp == o.tp && _interfaceIdiom == o.interfaceIdiom && [_version isEqual:o.version] && geVec2IsEqualTo(_screenSize, o.screenSize);
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [EGDeviceType_Values[_tp] hash];
    hash = hash * 31 + [EGInterfaceIdiom_Values[_interfaceIdiom] hash];
    hash = hash * 31 + [_version hash];
    hash = hash * 31 + geVec2Hash(_screenSize);
    return hash;
}

- (CNClassType*)type {
    return [EGDevice type];
}

+ (CNClassType*)type {
    return _EGDevice_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation EGPlatform
static CNClassType* _EGPlatform_type;
@synthesize os = _os;
@synthesize device = _device;
@synthesize text = _text;
@synthesize shadows = _shadows;
@synthesize touch = _touch;
@synthesize interfaceIdiom = _interfaceIdiom;
@synthesize isPhone = _isPhone;
@synthesize isPad = _isPad;
@synthesize isComputer = _isComputer;

+ (instancetype)platformWithOs:(EGOS*)os device:(EGDevice*)device text:(NSString*)text {
    return [[EGPlatform alloc] initWithOs:os device:device text:text];
}

- (instancetype)initWithOs:(EGOS*)os device:(EGDevice*)device text:(NSString*)text {
    self = [super init];
    if(self) {
        _os = os;
        _device = device;
        _text = text;
        _shadows = EGOSType_Values[os.tp].shadows;
        _touch = EGOSType_Values[os.tp].touch;
        _interfaceIdiom = device.interfaceIdiom;
        _isPhone = EGInterfaceIdiom_Values[_interfaceIdiom].isPhone;
        _isPad = EGInterfaceIdiom_Values[_interfaceIdiom].isPad;
        _isComputer = EGInterfaceIdiom_Values[_interfaceIdiom].isComputer;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGPlatform class]) _EGPlatform_type = [CNClassType classTypeWithCls:[EGPlatform class]];
}

- (GEVec2)screenSize {
    return _device.screenSize;
}

- (CGFloat)screenSizeRatio {
    return ((CGFloat)([self screenSize].x / [self screenSize].y));
}

- (NSString*)description {
    return [NSString stringWithFormat:@"Platform(%@, %@, %@)", _os, _device, _text];
}

- (BOOL)isEqual:(id)to {
    if(self == to) return YES;
    if(to == nil || !([to isKindOfClass:[EGPlatform class]])) return NO;
    EGPlatform* o = ((EGPlatform*)(to));
    return [_os isEqual:o.os] && [_device isEqual:o.device] && [_text isEqual:o.text];
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [_os hash];
    hash = hash * 31 + [_device hash];
    hash = hash * 31 + [_text hash];
    return hash;
}

- (CNClassType*)type {
    return [EGPlatform type];
}

+ (CNClassType*)type {
    return _EGPlatform_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation EGVersion
static CNClassType* _EGVersion_type;
@synthesize parts = _parts;

+ (instancetype)versionWithParts:(NSArray*)parts {
    return [[EGVersion alloc] initWithParts:parts];
}

- (instancetype)initWithParts:(NSArray*)parts {
    self = [super init];
    if(self) _parts = parts;
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGVersion class]) _EGVersion_type = [CNClassType classTypeWithCls:[EGVersion class]];
}

+ (EGVersion*)applyStr:(NSString*)str {
    return [EGVersion versionWithParts:[[[[str splitBy:@"."] chain] mapF:^id(NSString* _) {
        return numi([_ toInt]);
    }] toArray]];
}

- (NSInteger)compareTo:(EGVersion*)to {
    id<CNIterator> i = [_parts iterator];
    id<CNIterator> j = [((EGVersion*)(to)).parts iterator];
    while([i hasNext] && [j hasNext]) {
        NSInteger vi = unumi([i next]);
        NSInteger vj = unumi([j next]);
        if(vi != vj) return intCompareTo(vi, vj);
    }
    return 0;
}

- (BOOL)lessThan:(NSString*)than {
    return [self compareTo:[EGVersion applyStr:than]] < 0;
}

- (BOOL)moreThan:(NSString*)than {
    return [self compareTo:[EGVersion applyStr:than]] > 0;
}

- (NSString*)description {
    return [NSString stringWithFormat:@"Version(%@)", _parts];
}

- (BOOL)isEqual:(id)to {
    if(self == to) return YES;
    if(to == nil || !([to isKindOfClass:[EGVersion class]])) return NO;
    EGVersion* o = ((EGVersion*)(to));
    return [_parts isEqual:o.parts];
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [_parts hash];
    return hash;
}

- (CNClassType*)type {
    return [EGVersion type];
}

+ (CNClassType*)type {
    return _EGVersion_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

