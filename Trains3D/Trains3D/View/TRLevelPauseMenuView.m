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
#import "EGSprite.h"
#import "EGFont.h"
#import "TRStrings.h"
#import "ATSignal.h"
#import "EGTexture.h"
#import "TRGameDirector.h"
#import "ATObserver.h"
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
        __lazy_slowMotionShopView = [CNLazy lazyWithF:^TRSlowMotionShopMenu*() {
            return [TRSlowMotionShopMenu slowMotionShopMenu];
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

- (TRSlowMotionShopMenu*)slowMotionShopView {
    return [__lazy_slowMotionShopView get];
}

- (id<EGCamera>)camera {
    return [__camera value];
}

- (TRPauseView*)view {
    if(_level.slowMotionShop) {
        return [self slowMotionShopView];
    } else {
        if(_level.rate) {
            return [self rateView];
        } else {
            if(!([[_level.help value] isEmpty])) {
                return [self helpView];
            } else {
                if([[_level.result value] isEmpty]) {
                    return [self menuView];
                } else {
                    if(((TRLevelResult*)([[_level.result value] get])).win) return [self winView];
                    else return [self looseView];
                }
            }
        }
    }
}

- (void)draw {
    if(!([[EGDirector current] isPaused])) return ;
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
    return [[EGDirector current] isPaused] || !([[_level.help value] isEmpty]) || !([[_level.result value] isEmpty]);
}

- (BOOL)isProcessorActive {
    return [[EGDirector current] isPaused];
}

- (EGRecognizers*)recognizers {
    return [EGRecognizers applyRecognizer:[EGRecognizer applyTp:[EGTap apply] on:^BOOL(id<EGEvent> _) {
        return [[self view] tapEvent:_];
    }]];
}

- (void)prepare {
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

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    TRLevelPauseMenuView* o = ((TRLevelPauseMenuView*)(other));
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

- (void)reshapeWithViewport:(GERect)viewport {
    @throw @"Method reshapeWith is abstract";
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


@implementation TRMenuView
static ODClassType* _TRMenuView_type;
@synthesize font = _font;
@synthesize headerRect = _headerRect;

+ (instancetype)menuView {
    return [[TRMenuView alloc] init];
}

- (instancetype)init {
    self = [super init];
    if(self) {
        _font = [[EGGlobal mainFontWithSize:24] beReadyForText:[TRStr.Loc menuButtonsCharacterSet]];
        _headerSprite = (([self headerHeight] > 0) ? [CNOption applyValue:[EGSprite spriteWithVisible:[ATReact applyValue:@YES] material:[self headerMaterial] position:[ATReact applyValue:wrap(GEVec3, (GEVec3Make(0.0, 0.0, 0.0)))] rect:[_headerRect mapF:^id(id _) {
            return wrap(GERect, (geRectMulF((uwrap(GERect, _)), [[EGDirector current] scale])));
        }]]] : [CNOption none]);
        [self _init];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [TRMenuView class]) _TRMenuView_type = [ODClassType classTypeWithCls:[TRMenuView class]];
}

- (id<CNImSeq>)buttons {
    @throw @"Method buttons is abstract";
}

- (void)_init {
    id<CNImSeq> btns = [self buttons];
    NSInteger delta = [self buttonHeight];
    NSInteger height = delta * [btns count];
    _size = GEVec2Make(((float)([self columnWidth])), ((float)(height + [self headerHeight])));
    __block ATReact* pos = [EGGlobal.context.scaledViewSize mapF:^id(id vps) {
        return wrap(GEVec3, (geVec3ApplyVec2((geVec2AddVec2((geRectMoveToCenterForSize((geRectApplyXYSize(0.0, 0.0, _size)), (uwrap(GEVec2, vps))).p), (GEVec2Make(0.0, ((float)(height - delta)))))))));
    }];
    _headerRect = [pos mapF:^id(id p) {
        return wrap(GERect, (geRectApplyXYWidthHeight((uwrap(GEVec3, p).x), (uwrap(GEVec3, p).y + delta), ((float)([self columnWidth])), ((float)([self headerHeight])))));
    }];
    __buttons = [[[[self buttons] chain] map:^EGButton*(CNTuple* t) {
        EGButton* b = [EGButton applyVisible:[ATReact applyValue:@YES] font:[ATReact applyValue:_font] text:[ATReact applyValue:((CNTuple*)(t)).a] textColor:[ATReact applyValue:wrap(GEVec4, (GEVec4Make(0.0, 0.0, 0.0, 1.0)))] backgroundMaterial:[ATReact applyValue:[EGColorSource applyColor:GEVec4Make(1.0, 1.0, 1.0, 0.9)]] position:pos rect:nil];
        [[b tap] observeF:^void(id _) {
            ((void(^)())(((CNTuple*)(t)).b))();
        }];
        pos = [pos mapF:^id(id _) {
            return wrap(GEVec3, (geVec3SubVec3((uwrap(GEVec3, _)), (GEVec3Make(0.0, ((float)([self buttonHeight])), 0.0)))));
        }];
        return b;
    }] toArray];
}

- (BOOL)tapEvent:(id<EGEvent>)event {
    return [__buttons existsWhere:^BOOL(EGButton* _) {
        return [((EGButton*)(_)) tapEvent:event];
    }];
}

- (void)draw {
    [__buttons forEach:^void(EGButton* _) {
        [((EGButton*)(_)) draw];
    }];
    if([self headerHeight] > 0) {
        [((EGSprite*)([_headerSprite get])) draw];
        [self drawHeader];
    }
}

- (CGFloat)headerHeight {
    return 0.0;
}

- (NSInteger)buttonHeight {
    return 50;
}

- (void)reshapeWithViewport:(GERect)viewport {
    [self reshape];
}

- (void)reshape {
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
        _soundSprite = [EGSprite applyMaterial:[ATReact applyValue:[[[EGGlobal scaledTextureForName:@"Pause" format:EGTextureFormat.RGBA4] regionX:(([TRGameDirector.instance soundEnabled]) ? 64.0 : 96.0) y:0.0 width:32.0 height:32.0] colorSource]] position:[EGGlobal.context.scaledViewSize mapF:^id(id _) {
            return wrap(GEVec3, (GEVec3Make((uwrap(GEVec2, _).x - 32), 40.0, 0.0)));
        }]];
        _ssObs = [_soundSprite.tap observeF:^void(id _) {
            [TRGameDirector.instance setSoundEnabled:!([TRGameDirector.instance soundEnabled])];
            [[EGDirector current] redraw];
        }];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [TRPauseMenuView class]) _TRPauseMenuView_type = [ODClassType classTypeWithCls:[TRPauseMenuView class]];
}

- (id<CNImSeq>)buttons {
    return [(@[tuple([TRStr.Loc resumeGame], ^void() {
    [[EGDirector current] resume];
}), tuple([TRStr.Loc restartLevel:_level.number], ^void() {
    [TRGameDirector.instance restartLevel];
}), tuple([TRStr.Loc chooseLevel], ^void() {
    [TRGameDirector.instance chooseLevel];
})]) addSeq:(([EGGameCenter isSupported]) ? (@[tuple([TRStr.Loc leaderboard], ^void() {
    [TRGameDirector.instance showLeaderboardLevel:_level];
})]) : [[[(@[]) addItem:(@[tuple([TRStr.Loc supportButton], ^void() {
    [TRGameDirector.instance showSupportChangeLevel:NO];
})])] addItem:(([EGShareDialog isSupported]) ? (@[tuple([TRStr.Loc shareButton], ^void() {
    [TRGameDirector.instance share];
})]) : (@[]))] addItem:(@[tuple([TRStr.Loc buyButton], ^void() {
    [TRGameDirector.instance openShop];
})])])];
}

- (void)draw {
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

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    TRPauseMenuView* o = ((TRPauseMenuView*)(other));
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


