#import "EGPlatform.h"

@implementation EGPlatform{
    BOOL _shadows;
    BOOL _touch;
}
static EGPlatform* _EGPlatform_MacOS;
static EGPlatform* _EGPlatform_iOS;
static NSArray* _EGPlatform_values;
@synthesize shadows = _shadows;
@synthesize touch = _touch;

+ (id)platformWithOrdinal:(NSUInteger)ordinal name:(NSString*)name shadows:(BOOL)shadows touch:(BOOL)touch {
    return [[EGPlatform alloc] initWithOrdinal:ordinal name:name shadows:shadows touch:touch];
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
    _EGPlatform_MacOS = [EGPlatform platformWithOrdinal:0 name:@"MacOS" shadows:YES touch:NO];
    _EGPlatform_iOS = [EGPlatform platformWithOrdinal:1 name:@"iOS" shadows:YES touch:YES];
    _EGPlatform_values = (@[_EGPlatform_MacOS, _EGPlatform_iOS]);
}

+ (EGPlatform*)MacOS {
    return _EGPlatform_MacOS;
}

+ (EGPlatform*)iOS {
    return _EGPlatform_iOS;
}

+ (NSArray*)values {
    return _EGPlatform_values;
}

@end


@implementation EGInterfaceIdiom
static EGInterfaceIdiom* _EGInterfaceIdiom_phone;
static EGInterfaceIdiom* _EGInterfaceIdiom_pad;
static EGInterfaceIdiom* _EGInterfaceIdiom_computer;
static NSArray* _EGInterfaceIdiom_values;

+ (id)interfaceIdiomWithOrdinal:(NSUInteger)ordinal name:(NSString*)name {
    return [[EGInterfaceIdiom alloc] initWithOrdinal:ordinal name:name];
}

- (id)initWithOrdinal:(NSUInteger)ordinal name:(NSString*)name {
    self = [super initWithOrdinal:ordinal name:name];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGInterfaceIdiom_phone = [EGInterfaceIdiom interfaceIdiomWithOrdinal:0 name:@"phone"];
    _EGInterfaceIdiom_pad = [EGInterfaceIdiom interfaceIdiomWithOrdinal:1 name:@"pad"];
    _EGInterfaceIdiom_computer = [EGInterfaceIdiom interfaceIdiomWithOrdinal:2 name:@"computer"];
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


