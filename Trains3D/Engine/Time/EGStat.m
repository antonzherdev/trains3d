#import "EGStat.h"

#import "CNReact.h"
#import "EGText.h"
#import "EGContext.h"
#import "EGMaterial.h"
@implementation EGStat
static CNClassType* _EGStat_type;

+ (instancetype)stat {
    return [[EGStat alloc] init];
}

- (instancetype)init {
    self = [super init];
    if(self) {
        _accumDelta = 0.0;
        _framesCount = 0;
        __frameRate = 0.0;
        _textVar = [CNVar applyInitial:@""];
        _text = [EGText applyFont:[CNReact applyValue:[EGGlobal mainFontWithSize:18]] text:_textVar position:[CNReact applyValue:wrap(GEVec3, (GEVec3Make(-0.98, -0.99, 0.0)))] alignment:[CNReact applyValue:wrap(EGTextAlignment, egTextAlignmentLeft())] color:[CNReact applyValue:wrap(GEVec4, (GEVec4Make(1.0, 1.0, 1.0, 1.0)))]];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGStat class]) _EGStat_type = [CNClassType classTypeWithCls:[EGStat class]];
}

- (CGFloat)frameRate {
    return __frameRate;
}

- (void)draw {
    EGEnablingState* __il__0__tmp__il__0self = EGGlobal.context.blend;
    {
        BOOL __il__0__il__0changed = [__il__0__tmp__il__0self enable];
        {
            [EGGlobal.context setBlendFunction:EGBlendFunction.standard];
            [_text draw];
        }
        if(__il__0__il__0changed) [__il__0__tmp__il__0self disable];
    }
}

- (void)tickWithDelta:(CGFloat)delta {
    _accumDelta += delta;
    _framesCount++;
    if(_accumDelta > 1.0) {
        __frameRate = _framesCount / _accumDelta;
        [_textVar setValue:[NSString stringWithFormat:@"%ld", (long)floatRound(__frameRate)]];
        _accumDelta = 0.0;
        _framesCount = 0;
    }
}

- (NSString*)description {
    return @"Stat";
}

- (CNClassType*)type {
    return [EGStat type];
}

+ (CNClassType*)type {
    return _EGStat_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

