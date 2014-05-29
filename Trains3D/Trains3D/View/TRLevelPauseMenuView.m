#import "TRLevelPauseMenuView.h"

#import "TRLevel.h"
#import "TRHelpView.h"
#import "TRWinLooseView.h"
#import "TRRateView.h"
#import "TRShopView.h"
#import "CNReact.h"
#import "EGContext.h"
#import "EGCamera2D.h"
#import "EGDirector.h"
#import "EGMaterial.h"
#import "EGD2D.h"
#import "EGSprite.h"
#import "TRStrings.h"
#import "EGFont.h"
#import "EGButton.h"
#import "CNObserver.h"
#import "CNChain.h"
#import "TRGameDirector.h"
#import "EGGameCenterPlat.h"
#import "EGSharePlat.h"
#import "EGPlatformPlat.h"
#import "EGPlatform.h"
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
        __camera = [EGGlobal.context.scaledViewSize mapF:^EGCamera2D*(id _) {
            return [EGCamera2D camera2DWithSize:uwrap(GEVec2, _)];
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

- (id<EGCamera>)camera {
    return [__camera value];
}

- (TRPauseView*)view {
    if(_level.rewindShop != 0) {
        return ((TRPauseView*)([self slowMotionShopView]));
    } else {
        if(_level.rate) {
            return ((TRPauseView*)([self rateView]));
        } else {
            if([_level.help value] != nil) {
                return ((TRPauseView*)([self helpView]));
            } else {
                if([_level.result value] == nil) {
                    return ((TRPauseView*)(((TRMenuView*)([self menuView]))));
                } else {
                    if(((TRLevelResult*)(nonnil([_level.result value]))).win) return ((TRPauseView*)(((TRMenuView*)([self winView]))));
                    else return ((TRPauseView*)(((TRMenuView*)([self looseView]))));
                }
            }
        }
    }
}

- (void)draw {
    if(!(unumb([[EGDirector current].isPaused value]))) return ;
    EGEnablingState* __il__1__tmp__il__0self = EGGlobal.context.blend;
    {
        BOOL __il__1__il__0changed = [__il__1__tmp__il__0self enable];
        {
            [EGGlobal.context setBlendFunction:EGBlendFunction.standard];
            {
                EGEnablingState* __tmp__il__1rp0self = EGGlobal.context.depthTest;
                {
                    BOOL __il__1rp0changed = [__tmp__il__1rp0self disable];
                    {
                        [EGD2D drawSpriteMaterial:[EGColorSource applyColor:GEVec4Make(0.0, 0.0, 0.0, 0.5)] at:GEVec3Make(0.0, 0.0, 0.0) rect:GERectMake((GEVec2Make(0.0, 0.0)), geVec2ApplyVec2i([EGGlobal.context viewport].size))];
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
    if([self isActive]) [[EGDirector current] pause];
}

- (BOOL)isActive {
    return unumb([[EGDirector current].isPaused value]) || [_level.help value] != nil || [_level.result value] != nil;
}

- (BOOL)isProcessorActive {
    return unumb([[EGDirector current].isPaused value]);
}

- (EGRecognizers*)recognizers {
    return [EGRecognizers applyRecognizer:[EGRecognizer applyTp:[EGTap apply] on:^BOOL(id<EGEvent> _) {
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

- (BOOL)tapEvent:(id<EGEvent>)event {
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
    EGFont* font = [[EGGlobal mainFontWithSize:24] beReadyForText:[TRStr.Loc menuButtonsCharacterSet]];
    NSArray* btns = [self buttons];
    NSInteger delta = [self buttonHeight];
    NSInteger height = delta * [btns count];
    NSInteger cw = [self columnWidth];
    GEVec2 size = GEVec2Make(((float)(cw)), ((float)(height + [self headerHeight])));
    __block CNReact* pos = [EGGlobal.context.scaledViewSize mapF:^id(id vps) {
        return wrap(GEVec3, (geVec3ApplyVec2((geVec2AddVec2((geRectMoveToCenterForSize((geRectApplyXYSize(0.0, 0.0, size)), (uwrap(GEVec2, vps))).p), (GEVec2Make(0.0, ((float)(height - delta)))))))));
    }];
    _headerRect = [pos mapF:^id(id p) {
        TRMenuView* _self = _weakSelf;
        if(_self != nil) return wrap(GERect, (geRectApplyXYWidthHeight((uwrap(GEVec3, p).x), (uwrap(GEVec3, p).y + delta), ((float)(cw)), ((float)([_self headerHeight])))));
        else return nil;
    }];
    NSArray* a = [[[btns chain] mapF:^CNTuple*(CNTuple* t) {
        EGButton* b = [EGButton applyFont:[CNReact applyValue:font] text:[CNReact applyValue:((CNTuple*)(t)).a] textColor:[CNReact applyValue:wrap(GEVec4, (GEVec4Make(0.0, 0.0, 0.0, 1.0)))] backgroundMaterial:[CNReact applyValue:[EGColorSource applyColor:GEVec4Make(1.0, 1.0, 1.0, 0.9)]] position:pos rect:[CNReact applyValue:wrap(GERect, (geRectApplyXYWidthHeight(0.0, 0.0, ((float)(cw)), ((float)(delta - 1)))))]];
        pos = [pos mapF:^id(id _) {
            return wrap(GEVec3, (geVec3SubVec3((uwrap(GEVec3, _)), (GEVec3Make(0.0, ((float)(delta)), 0.0)))));
        }];
        return tuple(b, [[b tap] observeF:^void(id _) {
            ((void(^)())(((CNTuple*)(t)).b))();
        }]);
    }] toArray];
    __buttons = [[[a chain] mapF:^EGButton*(CNTuple* _) {
        return ((CNTuple*)(_)).a;
    }] toArray];
    __buttonObservers = [[[a chain] mapF:^CNObserver*(CNTuple* _) {
        return ((CNTuple*)(_)).b;
    }] toArray];
    if([self headerHeight] > 0) _headerSprite = [EGSprite spriteWithVisible:[CNReact applyValue:@YES] material:((CNReact*)(nonnil([self headerMaterial]))) position:[CNReact applyValue:wrap(GEVec3, (GEVec3Make(0.0, 0.0, 0.0)))] rect:_headerRect];
}

- (BOOL)tapEvent:(id<EGEvent>)event {
    return [__buttons existsWhere:^BOOL(EGButton* _) {
        return [((EGButton*)(_)) tapEvent:event];
    }];
}

- (void)draw {
    for(EGButton* _ in __buttons) {
        [((EGButton*)(_)) draw];
    }
    if([self headerHeight] > 0) {
        [((EGSprite*)(_headerSprite)) draw];
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
        _soundSprite = [EGSprite applyMaterial:[TRGameDirector.instance.soundEnabled mapF:^EGColorSource*(id e) {
            return [[[EGGlobal scaledTextureForName:@"Pause" format:EGTextureFormat_RGBA4] regionX:((unumb(e)) ? 64.0 : 96.0) y:0.0 width:32.0 height:32.0] colorSource];
        }] position:[EGGlobal.context.scaledViewSize mapF:^id(id _) {
            return wrap(GEVec3, (GEVec3Make((uwrap(GEVec2, _).x - 16), 56.0, 0.0)));
        }]];
        _ssObs = [_soundSprite.tap observeF:^void(id _) {
            CNVar* se = TRGameDirector.instance.soundEnabled;
            [se setValue:numb(!(unumb([se value])))];
            [[EGDirector current] redraw];
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
    return [[[[(@[tuple([TRStr.Loc resumeGame], ^void() {
    [[EGDirector current] resume];
}), tuple([TRStr.Loc restartLevel:_level.number], ^void() {
    [TRGameDirector.instance restartLevel];
}), tuple([TRStr.Loc chooseLevel], ^void() {
    [TRGameDirector.instance chooseLevel];
})]) addSeq:(([EGGameCenter isSupported]) ? ((NSArray*)((@[tuple([TRStr.Loc leaderboard], ^void() {
    TRPauseMenuView* _self = _weakSelf;
    if(_self != nil) [TRGameDirector.instance showLeaderboardLevel:_self->_level];
})]))) : ((NSArray*)((@[]))))] addSeq:(@[tuple([TRStr.Loc supportButton], ^void() {
    [TRGameDirector.instance showSupportChangeLevel:NO];
})])] addSeq:(([EGShareDialog isSupported]) ? ((NSArray*)((@[tuple([TRStr.Loc shareButton], ^void() {
    [TRGameDirector.instance share];
})]))) : ((NSArray*)((@[]))))] addSeq:(@[tuple([TRStr.Loc buyButton], ^void() {
    [TRGameDirector.instance openShop];
})])];
}

- (void)draw {
    [super draw];
    EGEnablingState* __il__1__tmp__il__0self = EGGlobal.context.blend;
    {
        BOOL __il__1__il__0changed = [__il__1__tmp__il__0self enable];
        {
            [EGGlobal.context setBlendFunction:EGBlendFunction.premultiplied];
            [_soundSprite draw];
        }
        if(__il__1__il__0changed) [__il__1__tmp__il__0self disable];
    }
}

- (NSInteger)buttonHeight {
    if(egPlatform().isPhone) return 45;
    else return 50;
}

- (BOOL)tapEvent:(id<EGEvent>)event {
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

