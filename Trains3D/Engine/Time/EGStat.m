#import "EGStat.h"

#import "EGText2.h"
#import "EGContext.h"
@implementation EGStat{
    CGFloat _accumDelta;
    NSUInteger _framesCount;
    NSUInteger __frameRate;
    EGFont* _font;
}
static ODClassType* _EGStat_type;
@synthesize font = _font;

+ (id)stat {
    return [[EGStat alloc] init];
}

- (id)init {
    self = [super init];
    if(self) _font = [EGGlobal fontWithName:@"helvetica" size:14];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGStat_type = [ODClassType classTypeWithCls:[EGStat class]];
}

- (NSUInteger)frameRate {
    return __frameRate;
}

- (void)draw {
    [_font drawText:[NSString stringWithFormat:@"%li", lround(((CGFloat)(__frameRate)))] at:GEVec2Make(-1.0, -1.0) color:GEVec4Make(1.0, 1.0, 1.0, 1.0)];
}

- (void)tickWithDelta:(CGFloat)delta {
    _accumDelta += delta;
    _framesCount++;
    if(_accumDelta > 0.1) {
        __frameRate = ((NSUInteger)(_framesCount / _accumDelta));
        _accumDelta = 0.0;
        _framesCount = 0;
    }
}

- (ODClassType*)type {
    return [EGStat type];
}

+ (ODClassType*)type {
    return _EGStat_type;
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


