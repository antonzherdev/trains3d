#import "TRRateView.h"

#import "EGText.h"
#import "TRStrings.h"
#import "TRGameDirector.h"
#import "EGPlatformPlat.h"
#import "EGPlatform.h"
#import "CNReact.h"
#import "EGMaterial.h"
#import "EGContext.h"
@implementation TRRateMenu
static CNClassType* _TRRateMenu_type;

+ (instancetype)rateMenu {
    return [[TRRateMenu alloc] init];
}

- (instancetype)init {
    self = [super init];
    if(self) [self _init];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [TRRateMenu class]) _TRRateMenu_type = [CNClassType classTypeWithCls:[TRRateMenu class]];
}

- (NSArray*)buttons {
    return (@[tuple([TRStr.Loc rateNow], ^void() {
    [TRGameDirector.instance showRate];
}), tuple([TRStr.Loc rateProblem], ^void() {
    [TRGameDirector.instance showSupportChangeLevel:YES];
}), tuple([TRStr.Loc rateClose], ^void() {
    [TRGameDirector.instance rateClose];
}), tuple([TRStr.Loc rateLater], ^void() {
    [TRGameDirector.instance rateLater];
})]);
}

- (CGFloat)headerHeight {
    return 140.0;
}

- (NSInteger)columnWidth {
    return 520;
}

- (NSInteger)buttonHeight {
    if(egPlatform().isPhone) return 40;
    else return 50;
}

- (CNReact*)headerMaterial {
    return [CNReact applyValue:[EGColorSource applyColor:GEVec4Make(0.85, 1.0, 0.75, 0.9)]];
}

- (void)_init {
    [super _init];
    _headerText = [EGText applyFont:[CNReact applyValue:[EGGlobal mainFontWithSize:14]] text:[CNReact applyValue:[TRStr.Loc rateText]] position:[self.headerRect mapF:^id(id _) {
        return wrap(GEVec3, (geVec3ApplyVec2((geRectPXY((uwrap(GERect, _)), 0.05, 0.5)))));
    }] alignment:[CNReact applyValue:wrap(EGTextAlignment, (egTextAlignmentApplyXY(-1.0, 0.0)))] color:[CNReact applyValue:wrap(GEVec4, (GEVec4Make(0.0, 0.0, 0.0, 1.0)))]];
}

- (void)drawHeader {
    [_headerText draw];
}

- (NSString*)description {
    return @"RateMenu";
}

- (CNClassType*)type {
    return [TRRateMenu type];
}

+ (CNClassType*)type {
    return _TRRateMenu_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

