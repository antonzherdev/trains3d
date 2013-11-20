#import "TRLevelPauseMenuView.h"

#import "TRLevel.h"
#import "EGCamera2D.h"
#import "EGDirector.h"
#import "EGMaterial.h"
#import "EGContext.h"
#import "EGSprite.h"
#import "TRStrings.h"
#import "TRGameDirector.h"
#import "TRLevelMenuView.h"
@implementation TRLevelPauseMenuView{
    TRLevel* _level;
    NSString* _name;
    TRPauseMenuView* _menuView;
    TRHelpView* _helpView;
    TRWinMenu* _winView;
    TRLooseMenu* _looseView;
    id<EGCamera> _camera;
}
static ODClassType* _TRLevelPauseMenuView_type;
@synthesize level = _level;
@synthesize name = _name;
@synthesize camera = _camera;

+ (id)levelPauseMenuViewWithLevel:(TRLevel*)level {
    return [[TRLevelPauseMenuView alloc] initWithLevel:level];
}

- (id)initWithLevel:(TRLevel*)level {
    self = [super init];
    if(self) {
        _level = level;
        _name = @"LevelPauseMenu";
        _menuView = [TRPauseMenuView pauseMenuViewWithLevel:_level];
        _helpView = [TRHelpView helpViewWithLevel:_level];
        _winView = [TRWinMenu winMenuWithLevel:_level];
        _looseView = [TRLooseMenu looseMenuWithLevel:_level];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _TRLevelPauseMenuView_type = [ODClassType classTypeWithCls:[TRLevelPauseMenuView class]];
}

- (void)reshapeWithViewport:(GERect)viewport {
    _camera = [EGCamera2D camera2DWithSize:GEVec2Make(geRectWidth(viewport), geRectHeight(viewport))];
    [_menuView reshapeWithViewport:viewport];
    [_helpView reshapeWithViewport:viewport];
    [_winView reshapeWithViewport:viewport];
    [_looseView reshapeWithViewport:viewport];
}

- (TRPauseView*)view {
    if(!([[_level help] isEmpty])) {
        return _helpView;
    } else {
        if([[_level result] isEmpty]) {
            return _menuView;
        } else {
            if(((TRLevelResult*)([[_level result] get])).win) return _winView;
            else return _looseView;
        }
    }
}

- (void)draw {
    if(!([[EGDirector current] isPaused])) return ;
    [EGBlendFunction.standard applyDraw:^void() {
        [EGGlobal.context.depthTest disabledF:^void() {
            [EGD2D drawSpriteMaterial:[EGColorSource applyColor:GEVec4Make(0.0, 0.0, 0.0, 0.5)] at:GEVec3Make(0.0, 0.0, 0.0) rect:GERectMake(GEVec2Make(0.0, 0.0), geVec2ApplyVec2i([EGGlobal.context viewport].size))];
            [[self view] draw];
        }];
    }];
}

- (void)updateWithDelta:(CGFloat)delta {
    if([self isActive]) [[EGDirector current] pause];
}

- (BOOL)isActive {
    return [[EGDirector current] isPaused] || !([[_level help] isEmpty]) || !([[_level result] isEmpty]);
}

- (BOOL)isProcessorActive {
    return [[EGDirector current] isPaused];
}

- (EGRecognizers*)recognizers {
    return [EGRecognizers applyRecognizer:[EGRecognizer applyTp:[EGTap apply] on:^BOOL(EGEvent* _) {
        return [[self view] tapEvent:_];
    }]];
}

- (void)prepare {
}

- (EGEnvironment*)environment {
    return EGEnvironment.aDefault;
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

+ (id)pauseView {
    return [[TRPauseView alloc] init];
}

- (id)init {
    self = [super init];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _TRPauseView_type = [ODClassType classTypeWithCls:[TRPauseView class]];
}

- (void)reshapeWithViewport:(GERect)viewport {
    @throw @"Method reshapeWith is abstract";
}

- (void)draw {
    @throw @"Method draw is abstract";
}

- (BOOL)tapEvent:(EGEvent*)event {
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


@implementation TRMenuView{
    EGFont* __font;
    EGSprite* _menuBackSprite;
}
static ODClassType* _TRMenuView_type;

+ (id)menuView {
    return [[TRMenuView alloc] init];
}

- (id)init {
    self = [super init];
    if(self) _menuBackSprite = [EGSprite applyMaterial:[EGColorSource applyColor:GEVec4Make(0.9, 0.9, 0.9, 1.0)] rect:geRectApplyXYWidthHeight(0.0, 0.0, 350.0, 150.0)];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _TRMenuView_type = [ODClassType classTypeWithCls:[TRMenuView class]];
}

- (EGFont*)font {
    return __font;
}

- (EGButton*)buttonText:(NSString*)text onClick:(void(^)())onClick {
    __weak TRMenuView* weakSelf = self;
    return [EGButton buttonWithOnDraw:^id() {
        void(^__l)(GERect) = [self drawLine];
        void(^__r)(GERect) = [EGButton drawTextFont:^EGFont*() {
            return [weakSelf font];
        } color:GEVec4Make(0.0, 0.0, 0.0, 1.0) text:text];
        return ^void(GERect _) {
            __l(_);
            __r(_);
        };
    }() onClick:onClick];
}

- (void(^)(GERect))drawLine {
    return ^void(GERect rect) {
        [EGD2D drawLineMaterial:[EGColorSource applyColor:GEVec4Make(0.3, 0.3, 0.3, 1.0)] p0:geRectP1(rect) p1:geRectP3(rect)];
    };
}

- (id<CNSeq>)buttons {
    @throw @"Method buttons is abstract";
}

- (BOOL)tapEvent:(EGEvent*)event {
    return [[self buttons] existsWhere:^BOOL(EGButton* _) {
        return [((EGButton*)(_)) tapEvent:event];
    }];
}

- (void)draw {
    [_menuBackSprite draw];
    [[self buttons] forEach:^void(EGButton* _) {
        [((EGButton*)(_)) draw];
    }];
    CGFloat hh = [self headerHeight] * EGGlobal.context.scale;
    if(hh > 0) [self drawHeaderRect:GERectMake(geVec2AddVec2([_menuBackSprite position], GEVec2Make(0.0, [_menuBackSprite size].y - hh)), GEVec2Make([_menuBackSprite size].x, ((float)(hh))))];
}

- (CGFloat)headerHeight {
    return 0.0;
}

- (void)reshapeWithViewport:(GERect)viewport {
    CGFloat s = EGGlobal.context.scale;
    CGFloat width = 400 * s;
    CGFloat delta = 50 * s;
    CGFloat height = delta * [[self buttons] count];
    __font = [EGGlobal fontWithName:@"lucida_grande" size:24];
    [_menuBackSprite setSize:GEVec2Make(((float)(width)), ((float)(height + [self headerHeight] * s)))];
    [_menuBackSprite setPosition:geRectMoveToCenterForSize([_menuBackSprite rect], viewport.size).p0];
    __block GEVec2 p = geVec2AddVec2([_menuBackSprite position], GEVec2Make(0.0, ((float)(height - delta))));
    [[[self buttons] chain] forEach:^void(EGButton* button) {
        ((EGButton*)(button)).rect = GERectMake(p, GEVec2Make(((float)(width)), ((float)(delta))));
        p = geVec2SubVec2(p, GEVec2Make(0.0, ((float)(delta))));
    }];
    [self reshape];
}

- (void)reshape {
}

- (void)drawHeaderRect:(GERect)rect {
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


@implementation TRPauseMenuView{
    TRLevel* _level;
    EGButton* _resumeButton;
    EGButton* _restartButton;
    EGButton* _chooseLevelButton;
    id<CNSeq> _buttons;
}
static ODClassType* _TRPauseMenuView_type;
@synthesize level = _level;
@synthesize buttons = _buttons;

+ (id)pauseMenuViewWithLevel:(TRLevel*)level {
    return [[TRPauseMenuView alloc] initWithLevel:level];
}

- (id)initWithLevel:(TRLevel*)level {
    self = [super init];
    if(self) {
        _level = level;
        _resumeButton = [self buttonText:[TRStr.Loc resumeGame] onClick:^void() {
            [[EGDirector current] resume];
        }];
        _restartButton = [self buttonText:[TRStr.Loc restartLevel:_level] onClick:^void() {
            [TRGameDirector.instance restartLevel];
        }];
        _chooseLevelButton = [self buttonText:[TRStr.Loc chooseLevel] onClick:^void() {
            [TRGameDirector.instance chooseLevel];
        }];
        _buttons = (@[_resumeButton, _restartButton, _chooseLevelButton]);
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _TRPauseMenuView_type = [ODClassType classTypeWithCls:[TRPauseMenuView class]];
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


@implementation TRWinMenu{
    TRLevel* _level;
    EGButton* _nextButton;
    EGButton* _restartButton;
    EGButton* _chooseLevelButton;
    id<CNSeq> _buttons;
    EGText* _headerText;
}
static ODClassType* _TRWinMenu_type;
@synthesize level = _level;
@synthesize buttons = _buttons;

+ (id)winMenuWithLevel:(TRLevel*)level {
    return [[TRWinMenu alloc] initWithLevel:level];
}

- (id)initWithLevel:(TRLevel*)level {
    self = [super init];
    if(self) {
        _level = level;
        _nextButton = [self buttonText:[TRStr.Loc goToNextLevel:_level] onClick:^void() {
            [TRGameDirector.instance nextLevel];
        }];
        _restartButton = [self buttonText:[TRStr.Loc replayLevel:_level] onClick:^void() {
            [TRGameDirector.instance restartLevel];
        }];
        _chooseLevelButton = [self buttonText:[TRStr.Loc chooseLevel] onClick:^void() {
            [TRGameDirector.instance chooseLevel];
        }];
        _buttons = (@[_nextButton, _restartButton, _chooseLevelButton]);
        _headerText = [EGText applyFont:nil text:[TRStr.Loc victory] position:GEVec3Make(0.0, 0.0, 0.0) alignment:egTextAlignmentApplyXY(0.0, 0.0) color:GEVec4Make(0.0, 0.0, 0.0, 1.0)];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _TRWinMenu_type = [ODClassType classTypeWithCls:[TRWinMenu class]];
}

- (CGFloat)headerHeight {
    return 75.0;
}

- (void)drawHeaderRect:(GERect)rect {
    [EGD2D drawSpriteMaterial:[EGColorSource applyColor:GEVec4Make(0.85, 0.9, 0.75, 1.0)] at:GEVec3Make(0.0, 0.0, 0.0) rect:rect];
    [_headerText setPosition:geVec3ApplyVec2(geRectCenter(rect))];
    [_headerText draw];
}

- (void)reshape {
    [_headerText setFont:[EGGlobal fontWithName:@"lucida_grande" size:36]];
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


@implementation TRLooseMenu{
    TRLevel* _level;
    EGButton* _restartButton;
    EGButton* _chooseLevelButton;
    id<CNSeq> _buttons;
    EGText* _headerText;
    EGText* _detailsText;
}
static ODClassType* _TRLooseMenu_type;
@synthesize level = _level;
@synthesize buttons = _buttons;

+ (id)looseMenuWithLevel:(TRLevel*)level {
    return [[TRLooseMenu alloc] initWithLevel:level];
}

- (id)initWithLevel:(TRLevel*)level {
    self = [super init];
    if(self) {
        _level = level;
        _restartButton = [self buttonText:[TRStr.Loc replayLevel:_level] onClick:^void() {
            [TRGameDirector.instance restartLevel];
            [[EGDirector current] resume];
        }];
        _chooseLevelButton = [self buttonText:[TRStr.Loc chooseLevel] onClick:^void() {
            [TRGameDirector.instance chooseLevel];
        }];
        _buttons = (@[_restartButton, _chooseLevelButton]);
        _headerText = [EGText applyFont:nil text:[TRStr.Loc defeat] position:GEVec3Make(0.0, 0.0, 0.0) alignment:egTextAlignmentApplyXY(-1.0, 0.0) color:GEVec4Make(0.0, 0.0, 0.0, 1.0)];
        _detailsText = [EGText applyFont:nil text:[TRStr.Loc moneyOver] position:GEVec3Make(0.0, 0.0, 0.0) alignment:egTextAlignmentApplyXY(0.0, 0.0) color:GEVec4Make(0.0, 0.0, 0.0, 1.0)];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _TRLooseMenu_type = [ODClassType classTypeWithCls:[TRLooseMenu class]];
}

- (CGFloat)headerHeight {
    return 75.0;
}

- (void)drawHeaderRect:(GERect)rect {
    [EGD2D drawSpriteMaterial:[EGColorSource applyColor:GEVec4Make(1.0, 0.85, 0.75, 1.0)] at:GEVec3Make(0.0, 0.0, 0.0) rect:rect];
    [_headerText setPosition:geVec3ApplyVec2(geVec2AddVec2(rect.p0, geVec2MulVec2(rect.size, GEVec2Make(0.05, 0.7))))];
    [_headerText draw];
    [_detailsText setPosition:geVec3ApplyVec2(geVec2AddVec2(rect.p0, geVec2MulVec2(rect.size, GEVec2Make(0.5, 0.35))))];
    [_detailsText draw];
}

- (void)reshape {
    [_headerText setFont:[EGGlobal fontWithName:@"lucida_grande" size:36]];
    [_detailsText setFont:[EGGlobal fontWithName:@"lucida_grande" size:16]];
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


@implementation TRHelpView{
    TRLevel* _level;
    EGText* _helpText;
    EGSprite* _helpBackSprite;
}
static ODClassType* _TRHelpView_type;
@synthesize level = _level;

+ (id)helpViewWithLevel:(TRLevel*)level {
    return [[TRHelpView alloc] initWithLevel:level];
}

- (id)initWithLevel:(TRLevel*)level {
    self = [super init];
    if(self) {
        _level = level;
        _helpText = [EGText applyFont:nil text:@"" position:GEVec3Make(0.0, 0.0, 0.0) alignment:egTextAlignmentApplyXY(-1.0, 0.0) color:GEVec4Make(0.0, 0.0, 0.0, 1.0)];
        _helpBackSprite = [EGSprite applyMaterial:[EGColorSource applyColor:TRLevelMenuView.backgroundColor] rect:geRectApplyXYWidthHeight(0.0, 0.0, 0.0, 0.0)];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _TRHelpView_type = [ODClassType classTypeWithCls:[TRHelpView class]];
}

- (void)reshapeWithViewport:(GERect)viewport {
    [_helpText setFont:[EGGlobal fontWithName:@"lucida_grande" size:16]];
}

- (void)draw {
    TRHelp* help = [[_level help] get];
    [_helpText setText:help.text];
    GEVec2 size = geVec2MulVec2([_helpText measureC], GEVec2Make(1.1, 1.4));
    GERect rect = geVec2RectInCenterWithSize(size, geVec2ApplyVec2i([EGGlobal.context viewport].size));
    [_helpBackSprite setRect:rect];
    [_helpBackSprite draw];
    [_helpText setPosition:geVec3ApplyVec2(geVec2SubVec2(geRectCenter(rect), GEVec2Make(rect.size.x * 0.45, 0.0)))];
    [_helpText draw];
}

- (BOOL)tapEvent:(EGEvent*)event {
    [_level clearHelp];
    [[EGDirector current] resume];
    return YES;
}

- (ODClassType*)type {
    return [TRHelpView type];
}

+ (ODClassType*)type {
    return _TRHelpView_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    TRHelpView* o = ((TRHelpView*)(other));
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


