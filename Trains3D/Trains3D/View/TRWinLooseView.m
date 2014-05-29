#import "TRWinLooseView.h"

#import "TRLevel.h"
#import "CNReact.h"
#import "CNObserver.h"
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
static CNClassType* _TRWinMenu_type;
@synthesize level = _level;

+ (instancetype)winMenuWithLevel:(TRLevel*)level {
    return [[TRWinMenu alloc] initWithLevel:level];
}

- (instancetype)initWithLevel:(TRLevel*)level {
    self = [super init];
    __weak TRWinMenu* _weakSelf = self;
    if(self) {
        _level = level;
        _gcScore = [CNVar varWithInitial:nil];
        _obs = [TRGameDirector.instance.playerScoreRetrieved observeF:^void(EGLocalPlayerScore* score) {
            TRWinMenu* _self = _weakSelf;
            if(_self != nil) {
                [_self->_gcScore setValue:score];
                [[EGDirector current] redraw];
            }
        }];
        [self _init];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [TRWinMenu class]) _TRWinMenu_type = [CNClassType classTypeWithCls:[TRWinMenu class]];
}

- (NSArray*)buttons {
    __weak TRWinMenu* _weakSelf = self;
    return [[[((_level.number < 16) ? ((NSArray*)((@[tuple([TRStr.Loc goToNextLevel:_level.number], ^void() {
    [TRGameDirector.instance nextLevel];
})]))) : ((NSArray*)((@[])))) addSeq:(([EGGameCenter isSupported]) ? ((NSArray*)((@[tuple([TRStr.Loc leaderboard], ^void() {
    TRWinMenu* _self = _weakSelf;
    if(_self != nil) [TRGameDirector.instance showLeaderboardLevel:_self->_level];
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

- (CNReact*)headerMaterial {
    return [_gcScore mapF:^EGColorSource*(EGLocalPlayerScore* gcs) {
        return [EGColorSource applyColor:({
            id __tmprp0;
            {
                EGLocalPlayerScore* _ = gcs;
                if(_ != nil) __tmprp0 = wrap(GEVec4, [TRLevelChooseMenu rankColorScore:_]);
                else __tmprp0 = nil;
            }
            ((__tmprp0 != nil) ? uwrap(GEVec4, __tmprp0) : GEVec4Make(0.85, 0.9, 0.75, 1.0));
        })];
    }];
}

- (void)_init {
    __weak TRWinMenu* _weakSelf = self;
    [super _init];
    _headerText = [EGText applyFont:[CNReact applyValue:[EGGlobal mainFontWithSize:36]] text:[CNReact applyValue:[TRStr.Loc victory]] position:[self.headerRect mapF:^id(id _) {
        return wrap(GEVec3, (geVec3ApplyVec2((geRectPXY((uwrap(GERect, _)), 0.5, 0.75)))));
    }] alignment:[CNReact applyValue:wrap(EGTextAlignment, (egTextAlignmentApplyXY(0.0, 0.0)))] color:[CNReact applyValue:wrap(GEVec4, (GEVec4Make(0.0, 0.0, 0.0, 1.0)))]];
    _resultText = [EGText applyFont:[CNReact applyValue:[EGGlobal mainFontWithSize:18]] text:[_level.score.money mapF:^NSString*(id _) {
        return [NSString stringWithFormat:@"%@: %@", [TRStr.Loc result], [TRStr.Loc formatCost:unumi(_)]];
    }] position:[self.headerRect mapF:^id(id _) {
        return wrap(GEVec3, (geVec3ApplyVec2((geRectPXY((uwrap(GERect, _)), 0.03, 0.4)))));
    }] alignment:[CNReact applyValue:wrap(EGTextAlignment, (egTextAlignmentApplyXY(-1.0, 0.0)))] color:[CNReact applyValue:wrap(GEVec4, (GEVec4Make(0.0, 0.0, 0.0, 1.0)))]];
    _bestScoreText = [EGText applyFont:[CNReact applyValue:[EGGlobal mainFontWithSize:18]] text:[_gcScore mapF:^NSString*(EGLocalPlayerScore* gcs) {
        TRWinMenu* _self = _weakSelf;
        if(_self != nil) {
            long bs = ((gcs != nil) ? ((EGLocalPlayerScore*)(nonnil(gcs))).value : ((long)([TRGameDirector.instance bestScoreLevelNumber:_self->_level.number])));
            return [NSString stringWithFormat:@"%@: %@", [TRStr.Loc best], [TRStr.Loc formatCost:((NSInteger)(bs))]];
        } else {
            return nil;
        }
    }] position:[self.headerRect mapF:^id(id _) {
        return wrap(GEVec3, (geVec3ApplyVec2((geRectPXY((uwrap(GERect, _)), 0.97, 0.4)))));
    }] alignment:[CNReact applyValue:wrap(EGTextAlignment, (egTextAlignmentApplyXY(1.0, 0.0)))] color:[CNReact applyValue:wrap(GEVec4, (GEVec4Make(0.0, 0.0, 0.0, 1.0)))]];
    _topText = [EGText applyVisible:[_gcScore mapF:^id(EGLocalPlayerScore* _) {
        return numb(_ != nil);
    }] font:[CNReact applyValue:[EGGlobal mainFontWithSize:18]] text:[_gcScore mapF:^NSString*(EGLocalPlayerScore* gcs) {
        NSString* __tmp_3p2r;
        {
            EGLocalPlayerScore* _ = gcs;
            if(_ != nil) __tmp_3p2r = [TRStr.Loc topScore:_];
            else __tmp_3p2r = nil;
        }
        if(__tmp_3p2r != nil) return ((NSString*)(__tmp_3p2r));
        else return @"";
    }] position:[self.headerRect mapF:^id(id _) {
        return wrap(GEVec3, (geVec3ApplyVec2((geRectPXY((uwrap(GERect, _)), 0.97, 0.2)))));
    }] alignment:[CNReact applyValue:wrap(EGTextAlignment, (egTextAlignmentApplyXY(1.0, 0.0)))] color:[CNReact applyValue:wrap(GEVec4, (GEVec4Make(0.0, 0.0, 0.0, 1.0)))]];
}

- (NSString*)description {
    return [NSString stringWithFormat:@"WinMenu(%@)", _level];
}

- (CNClassType*)type {
    return [TRWinMenu type];
}

+ (CNClassType*)type {
    return _TRWinMenu_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation TRLooseMenu
static CNClassType* _TRLooseMenu_type;
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
    if(self == [TRLooseMenu class]) _TRLooseMenu_type = [CNClassType classTypeWithCls:[TRLooseMenu class]];
}

- (NSArray*)buttons {
    __weak TRLooseMenu* _weakSelf = self;
    return (@[tuple([TRStr.Loc rewind], ^void() {
    TRLooseMenu* _self = _weakSelf;
    if(_self != nil) {
        [[EGDirector current] resume];
        [TRGameDirector.instance runRewindLevel:_self->_level];
    }
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

- (CNReact*)headerMaterial {
    return [CNReact applyValue:[EGColorSource applyColor:GEVec4Make(1.0, 0.85, 0.75, 1.0)]];
}

- (void)_init {
    [super _init];
    _headerText = [EGText applyFont:[CNReact applyValue:[EGGlobal mainFontWithSize:36]] text:[CNReact applyValue:[TRStr.Loc defeat]] position:[self.headerRect mapF:^id(id _) {
        return wrap(GEVec3, (geVec3ApplyVec2((geRectPXY((uwrap(GERect, _)), 0.05, 0.7)))));
    }] alignment:[CNReact applyValue:wrap(EGTextAlignment, (egTextAlignmentApplyXY(-1.0, 0.0)))] color:[CNReact applyValue:wrap(GEVec4, (GEVec4Make(0.0, 0.0, 0.0, 1.0)))]];
    _detailsText = [EGText applyFont:[CNReact applyValue:[EGGlobal mainFontWithSize:16]] text:[CNReact applyValue:[TRStr.Loc moneyOver]] position:[self.headerRect mapF:^id(id _) {
        return wrap(GEVec3, (geVec3ApplyVec2((geRectPXY((uwrap(GERect, _)), 0.5, 0.35)))));
    }] alignment:[CNReact applyValue:wrap(EGTextAlignment, (egTextAlignmentApplyXY(0.0, 0.0)))] color:[CNReact applyValue:wrap(GEVec4, (GEVec4Make(0.0, 0.0, 0.0, 1.0)))]];
}

- (NSString*)description {
    return [NSString stringWithFormat:@"LooseMenu(%@)", _level];
}

- (CNClassType*)type {
    return [TRLooseMenu type];
}

+ (CNClassType*)type {
    return _TRLooseMenu_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

