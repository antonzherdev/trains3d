#import "TRWinLooseView.h"

#import "TRLevel.h"
#import "CNReact.h"
#import "CNObserver.h"
#import "TRGameDirector.h"
#import "PGDirector.h"
#import "PGText.h"
#import "TRStrings.h"
#import "PGGameCenterPlat.h"
#import "PGSharePlat.h"
#import "PGPlatformPlat.h"
#import "PGPlatform.h"
#import "PGGameCenter.h"
#import "TRLevelChooseMenu.h"
#import "PGMaterial.h"
#import "PGContext.h"
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
        _gcScore = [CNVar applyInitial:nil];
        _obs = [[TRGameDirector instance]->_playerScoreRetrieved observeF:^void(PGLocalPlayerScore* score) {
            TRWinMenu* _self = _weakSelf;
            if(_self != nil) {
                [_self->_gcScore setValue:score];
                [[PGDirector current] redraw];
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
    return [[[((_level->_number < 16) ? ((NSArray*)((@[tuple([[TRStr Loc] goToNextLevel:_level->_number], ^void(PGRect rect) {
    [[TRGameDirector instance] nextLevel];
})]))) : ((NSArray*)((@[])))) addSeq:(([PGGameCenter isSupported]) ? ((NSArray*)((@[tuple([[TRStr Loc] leaderboard], ^void(PGRect rect) {
    TRWinMenu* _self = _weakSelf;
    if(_self != nil) [[TRGameDirector instance] showLeaderboardLevel:_self->_level];
})]))) : ((NSArray*)((@[]))))] addSeq:(@[tuple([[TRStr Loc] replayLevel:_level->_number], ^void(PGRect rect) {
    [[TRGameDirector instance] restartLevel];
}), tuple([[TRStr Loc] chooseLevel], ^void(PGRect rect) {
    [[TRGameDirector instance] chooseLevel];
})])] addSeq:(([PGShareDialog isSupported]) ? ((NSArray*)((@[tuple([[TRStr Loc] shareButton], ^void(PGRect rect) {
    [[TRGameDirector instance] shareRect:rect];
})]))) : ((NSArray*)((@[]))))];
}

- (CGFloat)headerHeight {
    return 100.0;
}

- (NSInteger)buttonHeight {
    if(egPlatform()->_isPhone) return 40;
    else return 50;
}

- (void)drawHeader {
    [_headerText draw];
    [_resultText draw];
    [_topText draw];
    [_bestScoreText draw];
}

- (CNReact*)headerMaterial {
    return [_gcScore mapF:^PGColorSource*(PGLocalPlayerScore* gcs) {
        return [PGColorSource applyColor:({
            id __tmprp0;
            {
                PGLocalPlayerScore* _ = gcs;
                if(_ != nil) __tmprp0 = wrap(PGVec4, [TRLevelChooseMenu rankColorScore:_]);
                else __tmprp0 = nil;
            }
            ((__tmprp0 != nil) ? uwrap(PGVec4, __tmprp0) : PGVec4Make(0.85, 0.9, 0.75, 1.0));
        })];
    }];
}

- (void)_init {
    __weak TRWinMenu* _weakSelf = self;
    [super _init];
    _headerText = [PGText applyFont:[CNReact applyValue:[PGGlobal mainFontWithSize:36]] text:[CNReact applyValue:[[TRStr Loc] victory]] position:[self.headerRect mapF:^id(id _) {
        return wrap(PGVec3, (pgVec3ApplyVec2((pgRectPXY((uwrap(PGRect, _)), 0.5, 0.75)))));
    }] alignment:[CNReact applyValue:wrap(PGTextAlignment, (pgTextAlignmentApplyXY(0.0, 0.0)))] color:[CNReact applyValue:wrap(PGVec4, (PGVec4Make(0.0, 0.0, 0.0, 1.0)))]];
    _resultText = [PGText applyFont:[CNReact applyValue:[PGGlobal mainFontWithSize:18]] text:[_level->_score->_money mapF:^NSString*(id _) {
        return [NSString stringWithFormat:@"%@: %@", [[TRStr Loc] result], [[TRStr Loc] formatCost:unumi(_)]];
    }] position:[self.headerRect mapF:^id(id _) {
        return wrap(PGVec3, (pgVec3ApplyVec2((pgRectPXY((uwrap(PGRect, _)), 0.03, 0.4)))));
    }] alignment:[CNReact applyValue:wrap(PGTextAlignment, (pgTextAlignmentApplyXY(-1.0, 0.0)))] color:[CNReact applyValue:wrap(PGVec4, (PGVec4Make(0.0, 0.0, 0.0, 1.0)))]];
    _bestScoreText = [PGText applyFont:[CNReact applyValue:[PGGlobal mainFontWithSize:18]] text:[_gcScore mapF:^NSString*(PGLocalPlayerScore* gcs) {
        TRWinMenu* _self = _weakSelf;
        if(_self != nil) {
            long bs = ((gcs != nil) ? ((PGLocalPlayerScore*)(nonnil(gcs)))->_value : ((long)([[TRGameDirector instance] bestScoreLevelNumber:_self->_level->_number])));
            return [NSString stringWithFormat:@"%@: %@", [[TRStr Loc] best], [[TRStr Loc] formatCost:((NSInteger)(bs))]];
        } else {
            return nil;
        }
    }] position:[self.headerRect mapF:^id(id _) {
        return wrap(PGVec3, (pgVec3ApplyVec2((pgRectPXY((uwrap(PGRect, _)), 0.97, 0.4)))));
    }] alignment:[CNReact applyValue:wrap(PGTextAlignment, (pgTextAlignmentApplyXY(1.0, 0.0)))] color:[CNReact applyValue:wrap(PGVec4, (PGVec4Make(0.0, 0.0, 0.0, 1.0)))]];
    _topText = [PGText applyVisible:[_gcScore mapF:^id(PGLocalPlayerScore* _) {
        return numb(_ != nil);
    }] font:[CNReact applyValue:[PGGlobal mainFontWithSize:18]] text:[_gcScore mapF:^NSString*(PGLocalPlayerScore* gcs) {
        NSString* __tmp_3p2r;
        {
            PGLocalPlayerScore* _ = gcs;
            if(_ != nil) __tmp_3p2r = [[TRStr Loc] topScore:_];
            else __tmp_3p2r = nil;
        }
        if(__tmp_3p2r != nil) return __tmp_3p2r;
        else return @"";
    }] position:[self.headerRect mapF:^id(id _) {
        return wrap(PGVec3, (pgVec3ApplyVec2((pgRectPXY((uwrap(PGRect, _)), 0.97, 0.2)))));
    }] alignment:[CNReact applyValue:wrap(PGTextAlignment, (pgTextAlignmentApplyXY(1.0, 0.0)))] color:[CNReact applyValue:wrap(PGVec4, (PGVec4Make(0.0, 0.0, 0.0, 1.0)))]];
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
    return (@[tuple([[TRStr Loc] rewind], ^void(PGRect rect) {
    TRLooseMenu* _self = _weakSelf;
    if(_self != nil) {
        [[PGDirector current] resume];
        [[TRGameDirector instance] runRewindLevel:_self->_level];
    }
}), tuple([[TRStr Loc] replayLevel:_level->_number], ^void(PGRect rect) {
    [[TRGameDirector instance] restartLevel];
    [[PGDirector current] resume];
}), tuple([[TRStr Loc] chooseLevel], ^void(PGRect rect) {
    [[TRGameDirector instance] chooseLevel];
}), tuple([[TRStr Loc] supportButton], ^void(PGRect rect) {
    [[TRGameDirector instance] showSupportChangeLevel:NO];
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
    return [CNReact applyValue:[PGColorSource applyColor:PGVec4Make(1.0, 0.85, 0.75, 1.0)]];
}

- (void)_init {
    [super _init];
    _headerText = [PGText applyFont:[CNReact applyValue:[PGGlobal mainFontWithSize:36]] text:[CNReact applyValue:[[TRStr Loc] defeat]] position:[self.headerRect mapF:^id(id _) {
        return wrap(PGVec3, (pgVec3ApplyVec2((pgRectPXY((uwrap(PGRect, _)), 0.05, 0.7)))));
    }] alignment:[CNReact applyValue:wrap(PGTextAlignment, (pgTextAlignmentApplyXY(-1.0, 0.0)))] color:[CNReact applyValue:wrap(PGVec4, (PGVec4Make(0.0, 0.0, 0.0, 1.0)))]];
    _detailsText = [PGText applyFont:[CNReact applyValue:[PGGlobal mainFontWithSize:16]] text:[CNReact applyValue:[[TRStr Loc] moneyOver]] position:[self.headerRect mapF:^id(id _) {
        return wrap(PGVec3, (pgVec3ApplyVec2((pgRectPXY((uwrap(PGRect, _)), 0.5, 0.35)))));
    }] alignment:[CNReact applyValue:wrap(PGTextAlignment, (pgTextAlignmentApplyXY(0.0, 0.0)))] color:[CNReact applyValue:wrap(PGVec4, (PGVec4Make(0.0, 0.0, 0.0, 1.0)))]];
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

