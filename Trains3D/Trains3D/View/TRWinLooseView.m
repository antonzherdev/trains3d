#import "TRWinLooseView.h"

#import "TRLevel.h"
#import "ATReact.h"
#import "TRGameDirector.h"
#import "EGDirector.h"
#import "EGText.h"
#import "TRStrings.h"
#import "EGGameCenterPlat.h"
#import "EGSharePlat.h"
#import "EGPlatformPlat.h"
#import "EGPlatform.h"
#import "EGGameCenter.h"
#import "TRLevelChooseMenu.h"
#import "EGMaterial.h"
#import "EGContext.h"
#import "TRScore.h"
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
        _gcScore = [ATVar applyInitial:nil];
        _obs = [TRGameDirector.playerScoreRetrieveNotification observeBy:^void(TRGameDirector* _, EGLocalPlayerScore* score) {
            TRWinMenu* _self = _weakSelf;
            [_self->_gcScore setValue:score];
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

- (NSArray*)buttons {
    __weak TRWinMenu* _weakSelf = self;
    return [[[((_level.number < 16) ? ((NSArray*)((@[tuple([TRStr.Loc goToNextLevel:_level.number], ^void() {
    [TRGameDirector.instance nextLevel];
})]))) : ((NSArray*)((@[])))) addSeq:(([EGGameCenter isSupported]) ? ((NSArray*)((@[tuple([TRStr.Loc leaderboard], ^void() {
    TRWinMenu* _self = _weakSelf;
    [TRGameDirector.instance showLeaderboardLevel:_self->_level];
})]))) : ((NSArray*)((@[]))))] addSeq:(@[tuple([TRStr.Loc replayLevel:_level.number], ^void() {
    [TRGameDirector.instance restartLevel];
}), tuple([TRStr.Loc chooseLevel], ^void() {
    [TRGameDirector.instance chooseLevel];
})])] addSeq:(([EGShareDialog isSupported]) ? ((NSArray*)((@[tuple([TRStr.Loc shareButton], ^void() {
    [TRGameDirector.instance share];
})]))) : ((NSArray*)((@[]))))];
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
    return [_gcScore mapF:^EGColorSource*(EGLocalPlayerScore* gcs) {
        return [EGColorSource applyColor:({
            id __tmp;
            {
                EGLocalPlayerScore* _ = gcs;
                if(_ != nil) __tmp = wrap(GEVec4, [TRLevelChooseMenu rankColorScore:_]);
                else __tmp = nil;
            }
            ((__tmp != nil) ? uwrap(GEVec4, __tmp) : GEVec4Make(0.85, 0.9, 0.75, 1.0));
        })];
    }];
}

- (void)_init {
    __weak TRWinMenu* _weakSelf = self;
    [super _init];
    _headerText = [EGText applyFont:[ATReact applyValue:[EGGlobal mainFontWithSize:36]] text:[ATReact applyValue:[TRStr.Loc victory]] position:[self.headerRect mapF:^id(id _) {
        return wrap(GEVec3, (geVec3ApplyVec2((geRectPXY((uwrap(GERect, _)), 0.5, 0.75)))));
    }] alignment:[ATReact applyValue:wrap(EGTextAlignment, (egTextAlignmentApplyXY(0.0, 0.0)))] color:[ATReact applyValue:wrap(GEVec4, (GEVec4Make(0.0, 0.0, 0.0, 1.0)))]];
    _resultText = [EGText applyFont:[ATReact applyValue:[EGGlobal mainFontWithSize:18]] text:[_level.score.money mapF:^NSString*(id _) {
        return [NSString stringWithFormat:@"%@: %@", [TRStr.Loc result], [TRStr.Loc formatCost:unumi(_)]];
    }] position:[self.headerRect mapF:^id(id _) {
        return wrap(GEVec3, (geVec3ApplyVec2((geRectPXY((uwrap(GERect, _)), 0.03, 0.4)))));
    }] alignment:[ATReact applyValue:wrap(EGTextAlignment, (egTextAlignmentApplyXY(-1.0, 0.0)))] color:[ATReact applyValue:wrap(GEVec4, (GEVec4Make(0.0, 0.0, 0.0, 1.0)))]];
    _bestScoreText = [EGText applyFont:[ATReact applyValue:[EGGlobal mainFontWithSize:18]] text:[_gcScore mapF:^NSString*(EGLocalPlayerScore* gcs) {
        TRWinMenu* _self = _weakSelf;
        long bs = ((gcs != nil) ? ((EGLocalPlayerScore*)(nonnil(gcs))).value : ((long)([TRGameDirector.instance bestScoreLevelNumber:_self->_level.number])));
        return [NSString stringWithFormat:@"%@: %@", [TRStr.Loc best], [TRStr.Loc formatCost:((NSInteger)(bs))]];
    }] position:[self.headerRect mapF:^id(id _) {
        return wrap(GEVec3, (geVec3ApplyVec2((geRectPXY((uwrap(GERect, _)), 0.97, 0.4)))));
    }] alignment:[ATReact applyValue:wrap(EGTextAlignment, (egTextAlignmentApplyXY(1.0, 0.0)))] color:[ATReact applyValue:wrap(GEVec4, (GEVec4Make(0.0, 0.0, 0.0, 1.0)))]];
    _topText = [EGText applyVisible:[_gcScore mapF:^id(EGLocalPlayerScore* _) {
        return numb(_ != nil);
    }] font:[ATReact applyValue:[EGGlobal mainFontWithSize:18]] text:[_gcScore mapF:^NSString*(EGLocalPlayerScore* gcs) {
        NSString* __tmp_3;
        {
            EGLocalPlayerScore* _ = gcs;
            if(_ != nil) __tmp_3 = [TRStr.Loc topScore:_];
            else __tmp_3 = nil;
        }
        if(__tmp_3 != nil) return ((NSString*)(__tmp_3));
        else return @"";
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

- (NSArray*)buttons {
    __weak TRLooseMenu* _weakSelf = self;
    return (@[tuple([TRStr.Loc rewind], ^void() {
    TRLooseMenu* _self = _weakSelf;
    [[EGDirector current] resume];
    [TRGameDirector.instance runRewindLevel:_self->_level];
}), tuple([TRStr.Loc replayLevel:_level.number], ^void() {
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

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"level=%@", self.level];
    [description appendString:@">"];
    return description;
}

@end


