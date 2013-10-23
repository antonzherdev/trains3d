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


