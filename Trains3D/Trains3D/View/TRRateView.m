#import "TRRateView.h"

#import "EGContext.h"
#import "ATReact.h"
#import "TRStrings.h"
#import "TRGameDirector.h"
#import "EGPlatformPlat.h"
#import "EGPlatform.h"
#import "EGMaterial.h"
@implementation TRRateMenu
static ODClassType* _TRRateMenu_type;

+ (instancetype)rateMenu {
    return [[TRRateMenu alloc] init];
}

- (instancetype)init {
    self = [super init];
    if(self) _headerText = [EGText applyFont:[ATReact applyValue:[EGGlobal mainFontWithSize:14]] text:[ATReact applyValue:[TRStr.Loc rateText]] position:[ATReact applyValue:[self.headerRect mapF:^id(id _) {
        return wrap(GEVec2, (geRectPXY((uwrap(GERect, _)), 0.05, 0.5)));
    }]] alignment:[ATReact applyValue:wrap(EGTextAlignment, (egTextAlignmentApplyXY(-1.0, 0.0)))] color:[ATReact applyValue:wrap(GEVec4, (GEVec4Make(0.0, 0.0, 0.0, 1.0)))]];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [TRRateMenu class]) _TRRateMenu_type = [ODClassType classTypeWithCls:[TRRateMenu class]];
}

- (id<CNImSeq>)buttons {
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

- (ATReact*)headerMaterial {
    return [ATReact applyValue:[EGColorSource applyColor:GEVec4Make(0.85, 1.0, 0.75, 0.9)]];
}

- (void)drawHeader {
    [_headerText draw];
}

- (ODClassType*)type {
    return [TRRateMenu type];
}

+ (ODClassType*)type {
    return _TRRateMenu_type;
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


