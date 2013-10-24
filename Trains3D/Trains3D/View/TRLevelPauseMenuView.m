#import "TRLevelPauseMenuView.h"

#import "TRLevel.h"
#import "EGCamera2D.h"
#import "EGContext.h"
#import "EGDirector.h"
#import "EGMaterial.h"
#import "EGSprite.h"
#import "TRStrings.h"
#import "TRSceneFactory.h"
#import "TRLevelMenuView.h"
@implementation TRLevelPauseMenuView{
    TRLevel* _level;
    NSString* _name;
    TRPauseMenuView* _menuView;
    TRHelpView* _helpView;
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
}

- (id<TRPauseView>)view {
    if([[_level help] isEmpty]) return _menuView;
    else return _helpView;
}

- (void)draw {
    if(!([[EGGlobal director] isPaused])) return ;
    [EGBlendFunction.standard applyDraw:^void() {
        [EGGlobal.context.depthTest disabledF:^void() {
            [EGD2D drawSpriteMaterial:[EGColorSource applyColor:GEVec4Make(0.0, 0.0, 0.0, 0.5)] at:GEVec3Make(0.0, 0.0, 0.0) rect:GERectMake(GEVec2Make(0.0, 0.0), geVec2ApplyVec2i([EGGlobal.context viewport].size))];
            [[self view] draw];
        }];
    }];
}

- (BOOL)isProcessorActive {
    return [[EGGlobal director] isPaused];
}

- (BOOL)processEvent:(EGEvent*)event {
    return [event tapProcessor:[self view]];
}

- (void)prepare {
}

- (EGEnvironment*)environment {
    return EGEnvironment.aDefault;
}

- (void)updateWithDelta:(CGFloat)delta {
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


@implementation TRPauseMenuView{
    TRLevel* _level;
    EGSprite* _menuBackSprite;
    EGFont* _font;
    EGButton* _resumeButton;
    EGButton* _chooseLevelButton;
    EGButton* _restartButton;
    EGButton* _chooseLevel;
}
static ODClassType* _TRPauseMenuView_type;
@synthesize level = _level;
@synthesize font = _font;

+ (id)pauseMenuViewWithLevel:(TRLevel*)level {
    return [[TRPauseMenuView alloc] initWithLevel:level];
}

- (id)initWithLevel:(TRLevel*)level {
    self = [super init];
    if(self) {
        _level = level;
        _menuBackSprite = [EGSprite applyMaterial:[EGColorSource applyColor:GEVec4Make(0.9, 0.9, 0.9, 1.0)] size:GEVec2Make(350.0, 150.0)];
        _resumeButton = [self buttonText:[TRStr.Loc resumeGame] onClick:^void() {
            [[EGGlobal director] resume];
        }];
        _chooseLevelButton = [self buttonText:[TRStr.Loc chooseLevel] onClick:^void() {
            [[EGGlobal director] resume];
        }];
        _restartButton = [self buttonText:[TRStr.Loc restartLevel:_level] onClick:^void() {
            [TRSceneFactory restartLevel];
            [[EGGlobal director] resume];
        }];
        _chooseLevel = [self buttonText:[TRStr.Loc resumeGame] onClick:^void() {
            [[EGGlobal director] resume];
        }];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _TRPauseMenuView_type = [ODClassType classTypeWithCls:[TRPauseMenuView class]];
}

- (void)reshapeWithViewport:(GERect)viewport {
    CGFloat s = EGGlobal.context.scale;
    CGFloat width = 350 * s;
    CGFloat height = 150 * s;
    CGFloat delta = 50 * s;
    _font = [EGGlobal fontWithName:@"lucida_grande" size:24];
    _menuBackSprite.size = GEVec2Make(((float)(width)), ((float)(height)));
    GEVec2 p = geRectMoveToCenterForSize([_menuBackSprite rect], viewport.size).p0;
    _menuBackSprite.position = p;
    _chooseLevelButton.rect = GERectMake(p, GEVec2Make(((float)(width)), ((float)(delta))));
    _restartButton.rect = GERectMake(geVec2AddVec2(p, GEVec2Make(0.0, ((float)(delta)))), GEVec2Make(((float)(width)), ((float)(delta))));
    _resumeButton.rect = GERectMake(geVec2AddVec2(p, GEVec2Make(0.0, ((float)(2 * delta)))), GEVec2Make(((float)(width)), ((float)(delta))));
}

- (void)draw {
    [_menuBackSprite draw];
    [_resumeButton draw];
    [_restartButton draw];
    [_chooseLevelButton draw];
}

- (BOOL)tapEvent:(EGEvent*)event {
    return [_resumeButton tapEvent:event] || [_restartButton tapEvent:event];
}

- (EGButton*)buttonText:(NSString*)text onClick:(void(^)())onClick {
    return [EGButton buttonWithOnDraw:^id() {
        void(^__l)(GERect) = [self drawLine];
        void(^__r)(GERect) = [EGButton drawTextFont:^EGFont*() {
            return [self font];
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
}
static ODClassType* _TRWinMenu_type;
@synthesize level = _level;

+ (id)winMenuWithLevel:(TRLevel*)level {
    return [[TRWinMenu alloc] initWithLevel:level];
}

- (id)initWithLevel:(TRLevel*)level {
    self = [super init];
    if(self) _level = level;
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _TRWinMenu_type = [ODClassType classTypeWithCls:[TRWinMenu class]];
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


@implementation TRHelpView{
    TRLevel* _level;
    EGFont* _helpFont;
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
        _helpBackSprite = [EGSprite applyMaterial:[EGColorSource applyColor:TRLevelMenuView.backgroundColor] size:GEVec2Make(0.0, 0.0)];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _TRHelpView_type = [ODClassType classTypeWithCls:[TRHelpView class]];
}

- (void)reshapeWithViewport:(GERect)viewport {
    _helpFont = [EGGlobal fontWithName:@"lucida_grande" size:16];
}

- (void)draw {
    TRHelp* help = [[_level help] get];
    GEVec2 size = geVec2MulVec2([_helpFont measureCText:help.text], GEVec2Make(1.1, 1.4));
    GERect rect = geVec2RectInCenterWithSize(size, geVec2ApplyVec2i([EGGlobal.context viewport].size));
    [_helpBackSprite setRect:rect];
    [_helpBackSprite draw];
    [_helpFont drawText:help.text color:GEVec4Make(0.0, 0.0, 0.0, 1.0) at:geVec3ApplyVec2(geVec2SubVec2(geRectCenter(rect), GEVec2Make(rect.size.x * 0.45, 0.0))) alignment:egTextAlignmentApplyXY(-1.0, 0.0)];
}

- (BOOL)tapEvent:(EGEvent*)event {
    [_level clearHelp];
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


