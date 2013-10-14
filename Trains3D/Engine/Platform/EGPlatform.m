#import "EGPlatform.h"

@implementation EGPlatform{
    BOOL _shadows;
}
static EGPlatform* _EGPlatform_MacOS;
static EGPlatform* _EGPlatform_iOS;
static NSArray* _EGPlatform_values;
@synthesize shadows = _shadows;

+ (id)platformWithOrdinal:(NSUInteger)ordinal name:(NSString*)name shadows:(BOOL)shadows {
    return [[EGPlatform alloc] initWithOrdinal:ordinal name:name shadows:shadows];
}

- (id)initWithOrdinal:(NSUInteger)ordinal name:(NSString*)name shadows:(BOOL)shadows {
    self = [super initWithOrdinal:ordinal name:name];
    if(self) _shadows = shadows;
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGPlatform_MacOS = [EGPlatform platformWithOrdinal:0 name:@"MacOS" shadows:YES];
    _EGPlatform_iOS = [EGPlatform platformWithOrdinal:1 name:@"iOS" shadows:YES];
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


