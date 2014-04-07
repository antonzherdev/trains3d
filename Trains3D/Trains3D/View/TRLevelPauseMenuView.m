#import "TRLevelPauseMenuView.h"

#import "TRLevel.h"
#import "TRHelpView.h"
#import "TRWinLooseView.h"
#import "TRRateView.h"
#import "TRShopView.h"
#import "ATReact.h"
#import "EGContext.h"
#import "EGCamera2D.h"
#import "EGDirector.h"
#import "EGMaterial.h"
#import "EGD2D.h"
#import "EGSprite.h"
#import "TRStrings.h"
#import "EGFont.h"
#import "EGButton.h"
#import "ATObserver.h"
#import "TRGameDirector.h"
#import "EGTexture.h"
#import "EGGameCenterPlat.h"
#import "EGSharePlat.h"
#import "EGPlatformPlat.h"
#import "EGPlatform.h"
@implementation TRLevelPauseMenuView
static ODClassType* _TRLevelPauseMenuView_type;
@synthesize level = _level;
@synthesize name = _name;

+ (instancetype)levelPauseMenuViewWithLevel:(TRLevel*)level {
    return [[TRLevelPauseMenuView alloc] initWithLevel:level];
}

- (instancetype)initWithLevel:(TRLevel*)level {
    self = [super init];
    __weak TRLevelPauseMenuView* _weakSelf = self;
    if(self) {
        _level = level;
        _name = @"LevelPauseMenu";
        __lazy_menuView = [CNLazy lazyWithF:^TRPauseMenuView*() {
            TRLevelPauseMenuView* _self = _weakSelf;
            return [TRPauseMenuView pauseMenuViewWithLevel:_self->_level];
        }];
        __lazy_helpView = [CNLazy lazyWithF:^TRHelpView*() {
            TRLevelPauseMenuView* _self = _weakSelf;
            return [TRHelpView helpViewWithLevel:_self->_level];
        }];
        __lazy_winView = [CNLazy lazyWithF:^TRWinMenu*() {
            TRLevelPauseMenuView* _self = _weakSelf;
            return [TRWinMenu winMenuWithLevel:_self->_level];
        }];
        __lazy_looseView = [CNLazy lazyWithF:^TRLooseMenu*() {
            TRLevelPauseMenuView* _self = _weakSelf;
            return [TRLooseMenu looseMenuWithLevel:_self->_level];
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
    if(self == [TRLevelPauseMenuView class]) _TRLevelPauseMenuView_type = [ODClassType classTypeWithCls:[TRLevelPauseMenuView class]];
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
    [EGBlendFunction.standard applyDraw:^void() {
        [EGGlobal.context.depthTest disabledF:^void() {
            [EGD2D drawSpriteMaterial:[EGColorSource applyColor:GEVec4Make(0.0, 0.0, 0.0, 0.5)] at:GEVec3Make(0.0, 0.0, 0.0) rect:GERectMake((GEVec2Make(0.0, 0.0)), geVec2ApplyVec2i([EGGlobal.context viewport].size))];
            [[self view] draw];
        }];
    }];
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

- (void)prepare {
}

- (void)complete {
}

- (EGEnvironment*)environment {
    return EGEnvironment.aDefault;
}

- (void)reshapeWithViewport:(GERect)viewport {
}

- (GERect)viewportWithViewSize:(GEVec2)viewSize {
    return [EGLayer viewportWithViewSize:viewSize viewportLayout:geRectApplyXYWidthHeight(0.0, 0.0, 1.0, 1.0) viewportRatio:((float)([[self camera] viewportRatio]))];
}

- (ODClassType*)type {
    return [TRLevelPauseMenuView type];
}

+ (ODClassType*)type {
    return _TRLevelPauseMenuView_type;
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


@implementation TRPauseView
static ODClassType* _TRPauseView_type;

+ (instancetype)pauseView {
    return [[TRPauseView alloc] init];
}

- (instancetype)init {
    self = [super init];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [TRPauseView class]) _TRPauseView_type = [ODClassType classTypeWithCls:[TRPauseView class]];
}

- (void)draw {
    @throw @"Method draw is abstract";
}

- (BOOL)tapEvent:(id<EGEvent>)event {
    @throw @"Method tap is abstract";
}

- (ODClassType*)type {
    return [TRPauseView type];
}

+ (ODClassType*)type {
    return _TRPauseView_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendString:@">"];
    return description;
}

@end


@implementation TRMenuView
static ODClassType* _TRMenuView_type;
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
    if(self == [TRMenuView class]) _TRMenuView_type = [ODClassType classTypeWithCls:[TRMenuView class]];
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
    __block ATReact* pos = [EGGlobal.context.scaledViewSize mapF:^id(id vps) {
        return wrap(GEVec3, (geVec3ApplyVec2((geVec2AddVec2((geRectMoveToCenterForSize((geRectApplyXYSize(0.0, 0.0, size)), (uwrap(GEVec2, vps))).p), (GEVec2Make(0.0, ((float)(height - delta)))))))));
    }];
    _headerRect = [pos mapF:^id(id p) {
        TRMenuView* _self = _weakSelf;
        return wrap(GERect, (geRectApplyXYWidthHeight((uwrap(GEVec3, p).x), (uwrap(GEVec3, p).y + delta), ((float)(cw)), ((float)([_self headerHeight])))));
    }];
    NSArray* a = [[[btns chain] map:^CNTuple*(CNTuple* t) {
        EGButton* b = [EGButton applyFont:[ATReact applyValue:font] text:[ATReact applyValue:((CNTuple*)(t)).a] textColor:[ATReact applyValue:wrap(GEVec4, (GEVec4Make(0.0, 0.0, 0.0, 1.0)))] backgroundMaterial:[ATReact applyValue:[EGColorSource applyColor:GEVec4Make(1.0, 1.0, 1.0, 0.9)]] position:pos rect:[ATReact applyValue:wrap(GERect, (geRectApplyXYWidthHeight(0.0, 0.0, ((float)(cw)), ((float)(delta - 1)))))]];
        pos = [pos mapF:^id(id _) {
            return wrap(GEVec3, (geVec3SubVec3((uwrap(GEVec3, _)), (GEVec3Make(0.0, ((float)(delta)), 0.0)))));
        }];
        return tuple(b, [[b tap] observeF:^void(id _) {
            ((void(^)())(((CNTuple*)(t)).b))();
        }]);
    }] toArray];
    __buttons = [[[a chain] map:^EGButton*(CNTuple* _) {
        return ((CNTuple*)(_)).a;
    }] toArray];
    __buttonObservers = [[[a chain] map:^ATObserver*(CNTuple* _) {
        return ((CNTuple*)(_)).b;
    }] toArray];
    if([self headerHeight] > 0) _headerSprite = [EGSprite spriteWithVisible:[ATReact applyValue:@YES] material:((ATReact*)(nonnil([self headerMaterial]))) position:[ATReact applyValue:wrap(GEVec3, (GEVec3Make(0.0, 0.0, 0.0)))] rect:_headerRect];
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
        [_headerSprite draw];
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

- (ATReact*)headerMaterial {
    return nil;
}

- (ODClassType*)type {
    return [TRMenuView type];
}

+ (ODClassType*)type {
    return _TRMenuView_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendString:@">"];
    return description;
}

@end


@implementation TRPauseMenuView
static ODClassType* _TRPauseMenuView_type;
@synthesize level = _level;

+ (instancetype)pauseMenuViewWithLevel:(TRLevel*)level {
    return [[TRPauseMenuView alloc] initWithLevel:level];
}

- (instancetype)initWithLevel:(TRLevel*)level {
    self = [super init];
    if(self) {
        _level = level;
        _soundSprite = [EGSprite applyMaterial:[TRGameDirector.instance.soundEnabled mapF:^EGColorSource*(id e) {
            return [[[EGGlobal scaledTextureForName:@"Pause" format:EGTextureFormat.RGBA4] regionX:((unumb(e)) ? 64.0 : 96.0) y:0.0 width:32.0 height:32.0] colorSource];
        }] position:[EGGlobal.context.scaledViewSize mapF:^id(id _) {
            return wrap(GEVec3, (GEVec3Make((uwrap(GEVec2, _).x - 16), 56.0, 0.0)));
        }]];
        _ssObs = [_soundSprite.tap observeF:^void(id _) {
            ATVar* se = TRGameDirector.instance.soundEnabled;
            [se setValue:numb(!(unumb([se value])))];
            [[EGDirector current] redraw];
        }];
        [self _init];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [TRPauseMenuView class]) _TRPauseMenuView_type = [ODClassType classTypeWithCls:[TRPauseMenuView class]];
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
    [TRGameDirector.instance showLeaderboardLevel:_self->_level];
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
    [EGBlendFunction.premultiplied applyDraw:^void() {
        [_soundSprite draw];
    }];
}

- (NSInteger)buttonHeight {
    if(egPlatform().isPhone) return 45;
    else return 50;
}

- (BOOL)tapEvent:(id<EGEvent>)event {
    return [super tapEvent:event] || [_soundSprite tapEvent:event];
}

- (ODClassType*)type {
    return [TRPauseMenuView type];
}

+ (ODClassType*)type {
    return _TRPauseMenuView_type;
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


