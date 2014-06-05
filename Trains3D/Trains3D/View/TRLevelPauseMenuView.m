#import "TRLevelPauseMenuView.h"

#import "TRLevel.h"
#import "TRHelpView.h"
#import "TRWinLooseView.h"
#import "TRRateView.h"
#import "TRShopView.h"
#import "CNReact.h"
#import "PGContext.h"
#import "PGCamera2D.h"
#import "PGDirector.h"
#import "PGMaterial.h"
#import "PGD2D.h"
#import "PGSprite.h"
#import "TRStrings.h"
#import "PGFont.h"
#import "PGButton.h"
#import "CNObserver.h"
#import "CNChain.h"
#import "TRGameDirector.h"
#import "PGGameCenterPlat.h"
#import "PGSharePlat.h"
#import "PGPlatformPlat.h"
#import "PGPlatform.h"
@implementation TRLevelPauseMenuView
static CNClassType* _TRLevelPauseMenuView_type;
@synthesize level = _level;
@synthesize name = _name;

+ (instancetype)levelPauseMenuViewWithLevel:(TRLevel*)level {
    return [[TRLevelPauseMenuView alloc] initWithLevel:level];
}

- (instancetype)initWithLevel:(TRLevel*)level {
    self = [super init];
    if(self) {
        _level = level;
        _name = @"LevelPauseMenu";
        __lazy_menuView = [CNLazy lazyWithF:^TRPauseMenuView*() {
            return [TRPauseMenuView pauseMenuViewWithLevel:level];
        }];
        __lazy_helpView = [CNLazy lazyWithF:^TRHelpView*() {
            return [TRHelpView helpViewWithLevel:level];
        }];
        __lazy_winView = [CNLazy lazyWithF:^TRWinMenu*() {
            return [TRWinMenu winMenuWithLevel:level];
        }];
        __lazy_looseView = [CNLazy lazyWithF:^TRLooseMenu*() {
            return [TRLooseMenu looseMenuWithLevel:level];
        }];
        __lazy_rateView = [CNLazy lazyWithF:^TRRateMenu*() {
            return [TRRateMenu rateMenu];
        }];
        __lazy_slowMotionShopView = [CNLazy lazyWithF:^TRShopMenu*() {
            return [TRShopMenu shopMenu];
        }];
        __camera = [[PGGlobal context]->_scaledViewSize mapF:^PGCamera2D*(id _) {
            return [PGCamera2D camera2DWithSize:uwrap(PGVec2, _)];
        }];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [TRLevelPauseMenuView class]) _TRLevelPauseMenuView_type = [CNClassType classTypeWithCls:[TRLevelPauseMenuView class]];
}

- (TRPauseMenuView*)menuView {
    return [__lazy_menuView get];
}

- (TRHelpView*)helpView {
    return [__lazy_helpView get];
}

- (TRWinMenu*)winView {
    return [__lazy_winView get];
}

- (TRLooseMenu*)looseView {
    return [__lazy_looseView get];
}

- (TRRateMenu*)rateView {
    return [__lazy_rateView get];
}

- (TRShopMenu*)slowMotionShopView {
    return [__lazy_slowMotionShopView get];
}

- (id<PGCamera>)camera {
    return [__camera value];
}

- (TRPauseView*)view {
    if(_level->_rewindShop != 0) {
        return ((TRPauseView*)([self slowMotionShopView]));
    } else {
        if(_level->_rate) {
            return ((TRPauseView*)([self rateView]));
        } else {
            if([_level->_help value] != nil) {
                return ((TRPauseView*)([self helpView]));
            } else {
                if([_level->_result value] == nil) {
                    return ((TRPauseView*)(((TRMenuView*)([self menuView]))));
                } else {
                    if(((TRLevelResult*)(nonnil([_level->_result value])))->_win) return ((TRPauseView*)(((TRMenuView*)([self winView]))));
                    else return ((TRPauseView*)(((TRMenuView*)([self looseView]))));
                }
            }
        }
    }
}

- (void)draw {
    if(!(unumb([[PGDirector current]->_isPaused value]))) return ;
    PGEnablingState* __il__1__tmp__il__0self = [PGGlobal context]->_blend;
    {
        BOOL __il__1__il__0changed = [__il__1__tmp__il__0self enable];
        {
            [[PGGlobal context] setBlendFunction:[PGBlendFunction standard]];
            {
                PGEnablingState* __tmp__il__1rp0self = [PGGlobal context]->_depthTest;
                {
                    BOOL __il__1rp0changed = [__tmp__il__1rp0self disable];
                    {
                        [PGD2D drawSpriteMaterial:[PGColorSource applyColor:PGVec4Make(0.0, 0.0, 0.0, 0.5)] at:PGVec3Make(0.0, 0.0, 0.0) rect:PGRectMake((PGVec2Make(0.0, 0.0)), pgVec2ApplyVec2i([[PGGlobal context] viewport].size))];
                        [[self view] draw];
                    }
                    if(__il__1rp0changed) [__tmp__il__1rp0self enable];
                }
            }
        }
        if(__il__1__il__0changed) [__il__1__tmp__il__0self disable];
    }
}

- (void)updateWithDelta:(CGFloat)delta {
    if([self isActive]) [[PGDirector current] pause];
}

- (BOOL)isActive {
    return unumb([[PGDirector current]->_isPaused value]) || [_level->_help value] != nil || [_level->_result value] != nil;
}

- (BOOL)isProcessorActive {
    return unumb([[PGDirector current]->_isPaused value]);
}

- (PGRecognizers*)recognizers {
    return [PGRecognizers applyRecognizer:[PGRecognizer applyTp:[PGTap apply] on:^BOOL(id<PGEvent> _) {
        return [[self view] tapEvent:_];
    }]];
}

- (NSString*)description {
    return [NSString stringWithFormat:@"LevelPauseMenuView(%@)", _level];
}

- (CNClassType*)type {
    return [TRLevelPauseMenuView type];
}

+ (CNClassType*)type {
    return _TRLevelPauseMenuView_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation TRPauseView
static CNClassType* _TRPauseView_type;

+ (instancetype)pauseView {
    return [[TRPauseView alloc] init];
}

- (instancetype)init {
    self = [super init];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [TRPauseView class]) _TRPauseView_type = [CNClassType classTypeWithCls:[TRPauseView class]];
}

- (void)draw {
    @throw @"Method draw is abstract";
}

- (BOOL)tapEvent:(id<PGEvent>)event {
    @throw @"Method tap is abstract";
}

- (NSString*)description {
    return @"PauseView";
}

- (CNClassType*)type {
    return [TRPauseView type];
}

+ (CNClassType*)type {
    return _TRPauseView_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation TRMenuView
static CNClassType* _TRMenuView_type;
@synthesize headerRect = _headerRect;

+ (instancetype)menuView {
    return [[TRMenuView alloc] init];
}

- (instancetype)init {
    self = [super init];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [TRMenuView class]) _TRMenuView_type = [CNClassType classTypeWithCls:[TRMenuView class]];
}

- (NSArray*)buttons {
    @throw @"Method buttons is abstract";
}

- (void)_init {
    __weak TRMenuView* _weakSelf = self;
    PGFont* font = [[PGGlobal mainFontWithSize:24] beReadyForText:[[TRStr Loc] menuButtonsCharacterSet]];
    NSArray* btns = [self buttons];
    NSInteger delta = [self buttonHeight];
    NSInteger height = delta * [btns count];
    NSInteger cw = [self columnWidth];
    PGVec2 size = PGVec2Make(((float)(cw)), ((float)(height + [self headerHeight])));
    __block CNReact* pos = [[PGGlobal context]->_scaledViewSize mapF:^id(id vps) {
        return wrap(PGVec3, (pgVec3ApplyVec2((pgVec2AddVec2((pgRectMoveToCenterForSize((pgRectApplyXYSize(0.0, 0.0, size)), (uwrap(PGVec2, vps))).p), (PGVec2Make(0.0, ((float)(height - delta)))))))));
    }];
    _headerRect = [pos mapF:^id(id p) {
        TRMenuView* _self = _weakSelf;
        if(_self != nil) return wrap(PGRect, (pgRectApplyXYWidthHeight((uwrap(PGVec3, p).x), (uwrap(PGVec3, p).y + delta), ((float)(cw)), ((float)([_self headerHeight])))));
        else return nil;
    }];
    NSArray* a = [[[btns chain] mapF:^CNTuple*(CNTuple* t) {
        PGButton* b = [PGButton applyFont:[CNReact applyValue:font] text:[CNReact applyValue:((CNTuple*)(t))->_a] textColor:[CNReact applyValue:wrap(PGVec4, (PGVec4Make(0.0, 0.0, 0.0, 1.0)))] backgroundMaterial:[CNReact applyValue:[PGColorSource applyColor:PGVec4Make(1.0, 1.0, 1.0, 0.9)]] position:pos rect:[CNReact applyValue:wrap(PGRect, (pgRectApplyXYWidthHeight(0.0, 0.0, ((float)(cw)), ((float)(delta - 1)))))]];
        pos = [pos mapF:^id(id _) {
            return wrap(PGVec3, (pgVec3SubVec3((uwrap(PGVec3, _)), (PGVec3Make(0.0, ((float)(delta)), 0.0)))));
        }];
        return tuple(b, [[b tap] observeF:^void(id _) {
            ((void(^)())(((CNTuple*)(t))->_b))();
        }]);
    }] toArray];
    __buttons = [[[a chain] mapF:^PGButton*(CNTuple* _) {
        return ((CNTuple*)(_))->_a;
    }] toArray];
    __buttonObservers = [[[a chain] mapF:^CNObserver*(CNTuple* _) {
        return ((CNTuple*)(_))->_b;
    }] toArray];
    if([self headerHeight] > 0) _headerSprite = [PGSprite spriteWithVisible:[CNReact applyValue:@YES] material:((CNReact*)(nonnil([self headerMaterial]))) position:[CNReact applyValue:wrap(PGVec3, (PGVec3Make(0.0, 0.0, 0.0)))] rect:_headerRect];
}

- (BOOL)tapEvent:(id<PGEvent>)event {
    return [__buttons existsWhere:^BOOL(PGButton* _) {
        return [((PGButton*)(_)) tapEvent:event];
    }];
}

- (void)draw {
    for(PGButton* _ in __buttons) {
        [((PGButton*)(_)) draw];
    }
    if([self headerHeight] > 0) {
        [((PGSprite*)(_headerSprite)) draw];
        [self drawHeader];
    }
}

- (CGFloat)headerHeight {
    return 0.0;
}

- (NSInteger)buttonHeight {
    return 50;
}

- (void)drawHeader {
}

- (NSInteger)columnWidth {
    return 400;
}

- (CNReact*)headerMaterial {
    return nil;
}

- (NSString*)description {
    return @"MenuView";
}

- (CNClassType*)type {
    return [TRMenuView type];
}

+ (CNClassType*)type {
    return _TRMenuView_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation TRPauseMenuView
static CNClassType* _TRPauseMenuView_type;
@synthesize level = _level;

+ (instancetype)pauseMenuViewWithLevel:(TRLevel*)level {
    return [[TRPauseMenuView alloc] initWithLevel:level];
}

- (instancetype)initWithLevel:(TRLevel*)level {
    self = [super init];
    if(self) {
        _level = level;
        _soundSprite = [PGSprite applyMaterial:[[TRGameDirector instance]->_soundEnabled mapF:^PGColorSource*(id e) {
            return [[[PGGlobal scaledTextureForName:@"Pause" format:PGTextureFormat_RGBA4] regionX:((unumb(e)) ? 64.0 : 96.0) y:0.0 width:32.0 height:32.0] colorSource];
        }] position:[[PGGlobal context]->_scaledViewSize mapF:^id(id _) {
            return wrap(PGVec3, (PGVec3Make((uwrap(PGVec2, _).x - 16), 56.0, 0.0)));
        }]];
        _ssObs = [_soundSprite->_tap observeF:^void(id _) {
            CNVar* se = [TRGameDirector instance]->_soundEnabled;
            [se setValue:numb(!(unumb([se value])))];
            [[PGDirector current] redraw];
        }];
        [self _init];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [TRPauseMenuView class]) _TRPauseMenuView_type = [CNClassType classTypeWithCls:[TRPauseMenuView class]];
}

- (NSArray*)buttons {
    __weak TRPauseMenuView* _weakSelf = self;
    return [[[[(@[tuple([[TRStr Loc] resumeGame], ^void() {
    [[PGDirector current] resume];
}), tuple([[TRStr Loc] restartLevel:_level->_number], ^void() {
    [[TRGameDirector instance] restartLevel];
}), tuple([[TRStr Loc] chooseLevel], ^void() {
    [[TRGameDirector instance] chooseLevel];
})]) addSeq:(([PGGameCenter isSupported]) ? ((NSArray*)((@[tuple([[TRStr Loc] leaderboard], ^void() {
    TRPauseMenuView* _self = _weakSelf;
    if(_self != nil) [[TRGameDirector instance] showLeaderboardLevel:_self->_level];
})]))) : ((NSArray*)((@[]))))] addSeq:(@[tuple([[TRStr Loc] supportButton], ^void() {
    [[TRGameDirector instance] showSupportChangeLevel:NO];
})])] addSeq:(([PGShareDialog isSupported]) ? ((NSArray*)((@[tuple([[TRStr Loc] shareButton], ^void() {
    [[TRGameDirector instance] share];
})]))) : ((NSArray*)((@[]))))] addSeq:(@[tuple([[TRStr Loc] buyButton], ^void() {
    [[TRGameDirector instance] openShop];
})])];
}

- (void)draw {
    [super draw];
    PGEnablingState* __il__1__tmp__il__0self = [PGGlobal context]->_blend;
    {
        BOOL __il__1__il__0changed = [__il__1__tmp__il__0self enable];
        {
            [[PGGlobal context] setBlendFunction:[PGBlendFunction premultiplied]];
            [_soundSprite draw];
        }
        if(__il__1__il__0changed) [__il__1__tmp__il__0self disable];
    }
}

- (NSInteger)buttonHeight {
    if(egPlatform()->_isPhone) return 45;
    else return 50;
}

- (BOOL)tapEvent:(id<PGEvent>)event {
    return [super tapEvent:event] || [_soundSprite tapEvent:event];
}

- (NSString*)description {
    return [NSString stringWithFormat:@"PauseMenuView(%@)", _level];
}

- (CNClassType*)type {
    return [TRPauseMenuView type];
}

+ (CNClassType*)type {
    return _TRPauseMenuView_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

