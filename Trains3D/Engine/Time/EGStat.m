#import "EGStat.h"

#import "EGContext.h"
#import "EGMaterial.h"
@implementation EGStat{
    CGFloat _accumDelta;
    NSUInteger _framesCount;
    CGFloat __frameRate;
    EGText* _text;
}
static ODClassType* _EGStat_type;

+ (id)stat {
    return [[EGStat alloc] init];
}

- (id)init {
    self = [super init];
    if(self) _text = [EGText applyFont:[EGGlobal mainFontWithSize:18] text:@"" position:GEVec3Make(-0.98, -0.99, 0.0) alignment:egTextAlignmentLeft() color:GEVec4Make(1.0, 1.0, 1.0, 1.0)];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGStat_type = [ODClassType classTypeWithCls:[EGStat class]];
}

- (CGFloat)frameRate {
    return __frameRate;
}

- (void)draw {
    [EGBlendFunction.standard applyDraw:^void() {
        [_text draw];
    }];
}

- (void)tickWithDelta:(CGFloat)delta {
    _accumDelta += delta;
    _framesCount++;
    if(_accumDelta > 1.0) {
        __frameRate = _framesCount / _accumDelta;
        [_text setText:[NSString stringWithFormat:@"%ld", (long)floatRound(__frameRate)]];
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


