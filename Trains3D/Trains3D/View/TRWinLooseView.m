#import "TRWinLooseView.h"

#import "TRLevel.h"
#import "ATReact.h"
#import "TRGameDirector.h"
#import "EGDirector.h"
#import "TRStrings.h"
#import "EGGameCenterPlat.h"
#import "EGSharePlat.h"
#import "EGPlatformPlat.h"
#import "EGPlatform.h"
#import "TRLevelChooseMenu.h"
#import "EGMaterial.h"
#import "EGContext.h"
#import "TRScore.h"
#import "EGGameCenter.h"
@implementation TRWinMenu
static ODClassType* _TRWinMenu_type;
@synthesize level = _level;

+ (instancetype)winMenuWithLevel:(TRLevel*)level {
    return [[TRWinMenu alloc] initWithLevel:level];
}

- (instancetype)initWithLevel:(TRLevel*)level {
    self = [super init];
    __weak TRWinMenu* _weakSelf = self;
    if(self) {
        _level = level;
        _gcScore = [ATVar applyInitial:[CNOption none]];
        _obs = [TRGameDirector.playerScoreRetrieveNotification observeBy:^void(TRGameDirector* _, EGLocalPlayerScore* score) {
            TRWinMenu* _self = _weakSelf;
            [_self->_gcScore setValue:[CNOption applyValue:score]];
            [[EGDirector current] redraw];
        }];
        [self _init];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [TRWinMenu class]) _TRWinMenu_type = [ODClassType classTypeWithCls:[TRWinMenu class]];
}

- (id<CNImSeq>)buttons {
    __weak TRWinMenu* _weakSelf = self;
    return [[[((_level.number < 16) ? (@[tuple([TRStr.Loc goToNextLevel:_level.number], ^void() {
    [TRGameDirector.instance nextLevel];
})]) : (@[])) addSeq:(([EGGameCenter isSupported]) ? (@[tuple([TRStr.Loc leaderboard], ^void() {
    TRWinMenu* _self = _weakSelf;
    [TRGameDirector.instance showLeaderboardLevel:_self->_level];
})]) : (@[]))] addSeq:(@[tuple([TRStr.Loc replayLevel:_level.number], ^void() {
    [TRGameDirector.instance restartLevel];
}), tuple([TRStr.Loc chooseLevel], ^void() {
    [TRGameDirector.instance chooseLevel];
})])] addSeq:(([EGShareDialog isSupported]) ? (@[tuple([TRStr.Loc shareButton], ^void() {
    [TRGameDirector.instance share];
})]) : (@[]))];
}

- (CGFloat)headerHeight {
    return 100.0;
}

- (NSInteger)buttonHeight {
    if(egPlatform().isPhone) return 40;
    else return 50;
}

- (void)drawHeader {
    [_headerText draw];
    [_resultText draw];
    [_topText draw];
    [_bestScoreText draw];
}

- (ATReact*)headerMaterial {
    return [_gcScore mapF:^EGColorSource*(id gcs) {
        return [EGColorSource applyColor:(([gcs isDefined]) ? [TRLevelChooseMenu rankColorScore:[gcs get]] : GEVec4Make(0.85, 0.9, 0.75, 1.0))];
    }];
}

- (void)_init {
    __weak TRWinMenu* _weakSelf = self;
    [super _init];
    _headerText = [EGText applyFont:[ATReact applyValue:[EGGlobal mainFontWithSize:36]] text:[ATReact applyValue:[TRStr.Loc victory]] position:[self.headerRect mapF:^id(id _) {
        return wrap(GEVec3, (geVec3ApplyVec2((geRectPXY((uwrap(GERect, _)), 0.5, 0.75)))));
    }] alignment:[ATReact applyValue:wrap(EGTextAlignment, (egTextAlignmentApplyXY(0.0, 0.0)))] color:[ATReact applyValue:wrap(GEVec4, (GEVec4Make(0.0, 0.0, 0.0, 1.0)))]];
    _resultText = [EGText applyFont:[ATReact applyValue:[EGGlobal mainFontWithSize:18]] text:[[_level.score money] mapF:^NSString*(id _) {
        return [NSString stringWithFormat:@"%@: %@", [TRStr.Loc result], [TRStr.Loc formatCost:unumi(_)]];
    }] position:[self.headerRect mapF:^id(id _) {
        return wrap(GEVec3, (geVec3ApplyVec2((geRectPXY((uwrap(GERect, _)), 0.03, 0.4)))));
    }] alignment:[ATReact applyValue:wrap(EGTextAlignment, (egTextAlignmentApplyXY(-1.0, 0.0)))] color:[ATReact applyValue:wrap(GEVec4, (GEVec4Make(0.0, 0.0, 0.0, 1.0)))]];
    _bestScoreText = [EGText applyFont:[ATReact applyValue:[EGGlobal mainFontWithSize:18]] text:[_gcScore mapF:^NSString*(id gcs) {
        NSInteger bs = unumi([[gcs mapF:^id(EGLocalPlayerScore* _) {
            return numi(((NSInteger)(((EGLocalPlayerScore*)(_)).value)));
        }] getOrElseF:^id() {
            TRWinMenu* _self = _weakSelf;
            return numi([TRGameDirector.instance bestScoreLevelNumber:_self->_level.number]);
        }]);
        return [NSString stringWithFormat:@"%@: %@", [TRStr.Loc best], [TRStr.Loc formatCost:bs]];
    }] position:[self.headerRect mapF:^id(id _) {
        return wrap(GEVec3, (geVec3ApplyVec2((geRectPXY((uwrap(GERect, _)), 0.97, 0.4)))));
    }] alignment:[ATReact applyValue:wrap(EGTextAlignment, (egTextAlignmentApplyXY(1.0, 0.0)))] color:[ATReact applyValue:wrap(GEVec4, (GEVec4Make(0.0, 0.0, 0.0, 1.0)))]];
    _topText = [EGText applyVisible:[_gcScore mapF:^id(id _) {
        return numb([_ isDefined]);
    }] font:[ATReact applyValue:[EGGlobal mainFontWithSize:18]] text:[_gcScore mapF:^NSString*(id gcs) {
        return [[gcs mapF:^NSString*(EGLocalPlayerScore* _) {
            return [TRStr.Loc topScore:_];
        }] getOrValue:@""];
    }] position:[self.headerRect mapF:^id(id _) {
        return wrap(GEVec3, (geVec3ApplyVec2((geRectPXY((uwrap(GERect, _)), 0.97, 0.2)))));
    }] alignment:[ATReact applyValue:wrap(EGTextAlignment, (egTextAlignmentApplyXY(1.0, 0.0)))] color:[ATReact applyValue:wrap(GEVec4, (GEVec4Make(0.0, 0.0, 0.0, 1.0)))]];
}

- (ODClassType*)type {
    return [TRWinMenu type];
}

+ (ODClassType*)type {
    return _TRWinMenu_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    TRWinMenu* o = ((TRWinMenu*)(other));
    return [self.level isEqual:o.level];
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.level hash];
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"level=%@", self.level];
    [description appendString:@">"];
    return description;
}

@end


@implementation TRLooseMenu
static ODClassType* _TRLooseMenu_type;
@synthesize level = _level;

+ (instancetype)looseMenuWithLevel:(TRLevel*)level {
    return [[TRLooseMenu alloc] initWithLevel:level];
}

- (instancetype)initWithLevel:(TRLevel*)level {
    self = [super init];
    if(self) {
        _level = level;
        [self _init];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [TRLooseMenu class]) _TRLooseMenu_type = [ODClassType classTypeWithCls:[TRLooseMenu class]];
}

- (id<CNImSeq>)buttons {
    return (@[tuple([TRStr.Loc replayLevel:_level.number], ^void() {
    [TRGameDirector.instance restartLevel];
    [[EGDirector current] resume];
}), tuple([TRStr.Loc chooseLevel], ^void() {
    [TRGameDirector.instance chooseLevel];
}), tuple([TRStr.Loc supportButton], ^void() {
    [TRGameDirector.instance showSupportChangeLevel:NO];
})]);
}

- (CGFloat)headerHeight {
    return 75.0;
}

- (void)drawHeader {
    [_headerText draw];
    [_detailsText draw];
}

- (ATReact*)headerMaterial {
    return [ATReact applyValue:[EGColorSource applyColor:GEVec4Make(1.0, 0.85, 0.75, 1.0)]];
}

- (void)_init {
    [super _init];
    _headerText = [EGText applyFont:[ATReact applyValue:[EGGlobal mainFontWithSize:36]] text:[ATReact applyValue:[TRStr.Loc defeat]] position:[self.headerRect mapF:^id(id _) {
        return wrap(GEVec3, (geVec3ApplyVec2((geRectPXY((uwrap(GERect, _)), 0.05, 0.7)))));
    }] alignment:[ATReact applyValue:wrap(EGTextAlignment, (egTextAlignmentApplyXY(-1.0, 0.0)))] color:[ATReact applyValue:wrap(GEVec4, (GEVec4Make(0.0, 0.0, 0.0, 1.0)))]];
    _detailsText = [EGText applyFont:[ATReact applyValue:[EGGlobal mainFontWithSize:16]] text:[ATReact applyValue:[TRStr.Loc moneyOver]] position:[self.headerRect mapF:^id(id _) {
        return wrap(GEVec3, (geVec3ApplyVec2((geRectPXY((uwrap(GERect, _)), 0.5, 0.35)))));
    }] alignment:[ATReact applyValue:wrap(EGTextAlignment, (egTextAlignmentApplyXY(0.0, 0.0)))] color:[ATReact applyValue:wrap(GEVec4, (GEVec4Make(0.0, 0.0, 0.0, 1.0)))]];
}

- (ODClassType*)type {
    return [TRLooseMenu type];
}

+ (ODClassType*)type {
    return _TRLooseMenu_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    TRLooseMenu* o = ((TRLooseMenu*)(other));
    return [self.level isEqual:o.level];
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.level hash];
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"level=%@", self.level];
    [description appendString:@">"];
    return description;
}

@end


