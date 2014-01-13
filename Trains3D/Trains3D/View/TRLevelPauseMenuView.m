#import "TRLevelPauseMenuView.h"

#import "TRLevel.h"
#import "EGContext.h"
#import "EGCamera2D.h"
#import "EGDirector.h"
#import "EGMaterial.h"
#import "EGSprite.h"
#import "TRStrings.h"
#import "TRGameDirector.h"
#import "EGSharePlat.h"
#import "EGTexture.h"
#import "EGPlatformPlat.h"
#import "EGPlatform.h"
#import "TRLevelChooseMenu.h"
#import "TRScore.h"
#import "EGGameCenter.h"
#import "EGInApp.h"
@implementation TRLevelPauseMenuView{
    TRLevel* _level;
    NSString* _name;
    TRPauseMenuView* _menuView;
    TRHelpView* _helpView;
    TRWinMenu* _winView;
    TRLooseMenu* _looseView;
    TRRateMenu* _rateView;
    TRSlowMotionShopMenu* _slowMotionShopView;
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
        _rateView = [TRRateMenu rateMenu];
        _slowMotionShopView = [TRSlowMotionShopMenu slowMotionShopMenu];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _TRLevelPauseMenuView_type = [ODClassType classTypeWithCls:[TRLevelPauseMenuView class]];
}

- (void)reshapeWithViewport:(GERect)viewport {
    _camera = [EGCamera2D camera2DWithSize:geVec2DivF(GEVec2Make(geRectWidth(viewport), geRectHeight(viewport)), EGGlobal.context.scale)];
    [_menuView reshapeWithViewport:viewport];
    [_helpView reshapeWithViewport:viewport];
    [_winView reshapeWithViewport:viewport];
    [_looseView reshapeWithViewport:viewport];
    [_rateView reshapeWithViewport:viewport];
    [_slowMotionShopView reshapeWithViewport:viewport];
}

- (TRPauseView*)view {
    if(_level.slowMotionShop) {
        return _slowMotionShopView;
    } else {
        if(_level.rate) {
            return _rateView;
        } else {
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
    return [EGRecognizers applyRecognizer:[EGRecognizer applyTp:[EGTap apply] on:^BOOL(id<EGEvent> _) {
        return [[self view] tapEvent:_];
    }]];
}

- (void)prepare {
}

- (EGEnvironment*)environment {
    return EGEnvironment.aDefault;
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


@implementation TRMenuView{
    EGFont* __font;
    GEVec2 _position;
    GEVec2 _size;
}
static ODClassType* _TRMenuView_type;

+ (id)menuView {
    return [[TRMenuView alloc] init];
}

- (id)init {
    self = [super init];
    
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
        void(^__l)(GERect) = [self drawBack];
        void(^__r)(GERect) = [EGButton drawTextFont:^EGFont*() {
            return [weakSelf font];
        } color:GEVec4Make(0.0, 0.0, 0.0, 1.0) text:text];
        return ^void(GERect _) {
            __l(_);
            __r(_);
        };
    }() onClick:onClick];
}

- (void(^)(GERect))drawBack {
    return ^void(GERect rect) {
        [EGD2D drawSpriteMaterial:[EGColorSource applyColor:GEVec4Make(1.0, 1.0, 1.0, 0.9)] at:GEVec3Make(0.0, 0.0, 0.0) rect:rect];
    };
}

- (id<CNSeq>)buttons {
    @throw @"Method buttons is abstract";
}

- (BOOL)tapEvent:(id<EGEvent>)event {
    return [[self buttons] existsWhere:^BOOL(EGButton* _) {
        return [((EGButton*)(_)) tapEvent:event];
    }];
}

- (void)draw {
    NSInteger width = [self columnWidth];
    NSInteger delta = [self buttonHeight];
    NSInteger height = delta * [[self buttons] count];
    _size = GEVec2Make(((float)(width)), ((float)(height + [self headerHeight])));
    _position = geRectMoveToCenterForSize(geRectApplyXYSize(0.0, 0.0, _size), geVec2iDivF([EGGlobal.context viewport].size, EGGlobal.context.scale)).p;
    __block GEVec2 p = geVec2AddVec2(_position, GEVec2Make(0.0, ((float)(height - delta))));
    [[[self buttons] chain] forEach:^void(EGButton* button) {
        ((EGButton*)(button)).rect = GERectMake(p, GEVec2Make(((float)(width)), ((float)(delta - 0.2))));
        p = geVec2SubVec2(p, GEVec2Make(0.0, ((float)(delta))));
    }];
    [[self buttons] forEach:^void(EGButton* _) {
        [((EGButton*)(_)) draw];
    }];
    CGFloat hh = [self headerHeight];
    if(hh > 0) [self drawHeaderRect:GERectMake(geVec2AddVec2(_position, GEVec2Make(0.0, _size.y - hh)), GEVec2Make(_size.x, ((float)(hh))))];
}

- (CGFloat)headerHeight {
    return 0.0;
}

- (NSInteger)buttonHeight {
    return 50;
}

- (void)reshapeWithViewport:(GERect)viewport {
    __font = [EGGlobal mainFontWithSize:24];
    [__font beReadyForText:[TRStr.Loc menuButtonsCharacterSet]];
    [self reshape];
}

- (void)reshape {
}

- (void)drawHeaderRect:(GERect)rect {
}

- (NSInteger)columnWidth {
    return 400;
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


@implementation TRPauseMenuView{
    TRLevel* _level;
    EGButton* _resumeButton;
    EGButton* _restartButton;
    EGButton* _chooseLevelButton;
    EGButton* _leaderboardButton;
    EGButton* _supportButton;
    EGButton* _buyButton;
    EGButton* _shareButton;
    id<CNSeq> _buttons;
    EGSprite* _soundSprite;
}
static ODClassType* _TRPauseMenuView_type;
@synthesize level = _level;
@synthesize buttons = _buttons;
@synthesize soundSprite = _soundSprite;

+ (id)pauseMenuViewWithLevel:(TRLevel*)level {
    return [[TRPauseMenuView alloc] initWithLevel:level];
}

- (id)initWithLevel:(TRLevel*)level {
    self = [super init];
    __weak TRPauseMenuView* _weakSelf = self;
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
        _leaderboardButton = [self buttonText:[TRStr.Loc leaderboard] onClick:^void() {
            [TRGameDirector.instance showLeaderboardLevel:_weakSelf.level];
        }];
        _supportButton = [self buttonText:[TRStr.Loc supportButton] onClick:^void() {
            [TRGameDirector.instance showSupportChangeLevel:NO];
        }];
        _buyButton = [self buttonText:[TRStr.Loc buyButton] onClick:^void() {
            [TRGameDirector.instance openShop];
        }];
        _shareButton = [self buttonText:[TRStr.Loc shareButton] onClick:^void() {
            [TRGameDirector.instance share];
        }];
        _buttons = [[(@[_resumeButton, _restartButton, _chooseLevelButton, _leaderboardButton, _supportButton]) addSeq:(([EGShareDialog isSupported]) ? (@[_shareButton]) : (@[]))] addSeq:(@[_buyButton])];
        _soundSprite = [EGSprite sprite];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _TRPauseMenuView_type = [ODClassType classTypeWithCls:[TRPauseMenuView class]];
}

- (void)draw {
    [super draw];
    [_soundSprite setMaterial:[EGColorSource applyTexture:[[EGGlobal scaledTextureForName:@"Pause" format:@"png"] regionX:(([TRGameDirector.instance soundEnabled]) ? 64.0 : 96.0) y:0.0 width:32.0 height:32.0]]];
    [_soundSprite setPosition:GEVec2Make(8.0, 8.0)];
    [_soundSprite adjustSize];
    [EGBlendFunction.premultiplied applyDraw:^void() {
        [_soundSprite draw];
    }];
}

- (NSInteger)buttonHeight {
    if(egPlatform().isPhone) return 45;
    else return 50;
}

- (BOOL)tapEvent:(id<EGEvent>)event {
    BOOL r = [super tapEvent:event];
    if(r) return YES;
    if([_soundSprite containsVec2:[event location]]) {
        [TRGameDirector.instance setSoundEnabled:!([TRGameDirector.instance soundEnabled])];
        [[EGDirector current] redraw];
        return YES;
    } else {
        return NO;
    }
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
    EGButton* _leaderboardButton;
    EGButton* _restartButton;
    EGButton* _chooseLevelButton;
    EGButton* _shareButton;
    id __score;
    CNNotificationObserver* _obs;
    EGText* _headerText;
    EGText* _resultText;
    EGText* _bestScoreText;
    EGText* _topText;
}
static ODClassType* _TRWinMenu_type;
@synthesize level = _level;
@synthesize _score = __score;

+ (id)winMenuWithLevel:(TRLevel*)level {
    return [[TRWinMenu alloc] initWithLevel:level];
}

- (id)initWithLevel:(TRLevel*)level {
    self = [super init];
    __weak TRWinMenu* _weakSelf = self;
    if(self) {
        _level = level;
        _nextButton = [self buttonText:[TRStr.Loc goToNextLevel:_level] onClick:^void() {
            [TRGameDirector.instance nextLevel];
        }];
        _leaderboardButton = [self buttonText:[TRStr.Loc leaderboard] onClick:^void() {
            [TRGameDirector.instance showLeaderboardLevel:_weakSelf.level];
        }];
        _restartButton = [self buttonText:[TRStr.Loc replayLevel:_level] onClick:^void() {
            [TRGameDirector.instance restartLevel];
        }];
        _chooseLevelButton = [self buttonText:[TRStr.Loc chooseLevel] onClick:^void() {
            [TRGameDirector.instance chooseLevel];
        }];
        _shareButton = [self buttonText:[TRStr.Loc shareButton] onClick:^void() {
            [TRGameDirector.instance share];
        }];
        __score = [CNOption none];
        _obs = [TRGameDirector.playerScoreRetrieveNotification observeBy:^void(TRGameDirector* _, EGLocalPlayerScore* score) {
            _weakSelf._score = [CNOption applyValue:score];
            [[EGDirector current] redraw];
        }];
        _headerText = [EGText applyFont:nil text:[TRStr.Loc victory] position:GEVec3Make(0.0, 0.0, 0.0) alignment:egTextAlignmentApplyXY(0.0, 0.0) color:GEVec4Make(0.0, 0.0, 0.0, 1.0)];
        _resultText = [EGText applyFont:nil text:@"" position:GEVec3Make(0.0, 0.0, 0.0) alignment:egTextAlignmentApplyXY(-1.0, 0.0) color:GEVec4Make(0.0, 0.0, 0.0, 1.0)];
        _bestScoreText = [EGText applyFont:nil text:@"" position:GEVec3Make(0.0, 0.0, 0.0) alignment:egTextAlignmentApplyXY(1.0, 0.0) color:GEVec4Make(0.0, 0.0, 0.0, 1.0)];
        _topText = [EGText applyFont:nil text:@"" position:GEVec3Make(0.0, 0.0, 0.0) alignment:egTextAlignmentApplyXY(1.0, 0.0) color:GEVec4Make(0.0, 0.0, 0.0, 1.0)];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _TRWinMenu_type = [ODClassType classTypeWithCls:[TRWinMenu class]];
}

- (id<CNSeq>)buttons {
    return [[((_level.number < 16) ? (@[_nextButton]) : (@[])) addSeq:(@[_leaderboardButton, _restartButton, _chooseLevelButton])] addSeq:(([EGShareDialog isSupported]) ? (@[_shareButton]) : (@[]))];
}

- (CGFloat)headerHeight {
    return 100.0;
}

- (NSInteger)buttonHeight {
    if(egPlatform().isPhone) return 40;
    else return 50;
}

- (void)drawHeaderRect:(GERect)rect {
    [EGD2D drawSpriteMaterial:(([__score isDefined]) ? [EGColorSource applyColor:[TRLevelChooseMenu rankColorScore:[__score get]]] : [EGColorSource applyColor:GEVec4Make(0.85, 0.9, 0.75, 1.0)]) at:GEVec3Make(0.0, 0.0, 0.0) rect:rect];
    [_headerText setPosition:geVec3ApplyVec2(geRectPXY(rect, 0.5, 0.75))];
    [_headerText draw];
    [_resultText setText:[NSString stringWithFormat:@"%@: %@", [TRStr.Loc result], [TRStr.Loc formatCost:[_level.score score]]]];
    [_resultText setPosition:geVec3ApplyVec2(geRectPXY(rect, 0.03, 0.4))];
    [_resultText draw];
    NSInteger bs = 0;
    if([__score isDefined]) {
        EGLocalPlayerScore* s = [__score get];
        bs = ((NSInteger)(s.value));
        [_topText setPosition:geVec3ApplyVec2(geRectPXY(rect, 0.97, 0.2))];
        [_topText setText:[TRStr.Loc topScore:s]];
        [_topText draw];
    } else {
        bs = [TRGameDirector.instance bestScoreLevelNumber:_level.number];
    }
    [_bestScoreText setPosition:geVec3ApplyVec2(geRectPXY(rect, 0.97, 0.4))];
    [_bestScoreText setText:[NSString stringWithFormat:@"%@: %@", [TRStr.Loc best], [TRStr.Loc formatCost:bs]]];
    [_bestScoreText draw];
}

- (void)reshape {
    [_headerText setFont:[EGGlobal mainFontWithSize:36]];
    EGFont* f = [EGGlobal mainFontWithSize:18];
    [_resultText setFont:f];
    [_bestScoreText setFont:f];
    [_topText setFont:f];
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


@implementation TRRateMenu{
    EGButton* _rateButton;
    EGButton* _supportButton;
    EGButton* _laterButton;
    EGButton* _closeButton;
    EGText* _headerText;
}
static ODClassType* _TRRateMenu_type;

+ (id)rateMenu {
    return [[TRRateMenu alloc] init];
}

- (id)init {
    self = [super init];
    if(self) {
        _rateButton = [self buttonText:[TRStr.Loc rateNow] onClick:^void() {
            [TRGameDirector.instance showRate];
        }];
        _supportButton = [self buttonText:[TRStr.Loc rateProblem] onClick:^void() {
            [TRGameDirector.instance showSupportChangeLevel:YES];
        }];
        _laterButton = [self buttonText:[TRStr.Loc rateLater] onClick:^void() {
            [TRGameDirector.instance rateLater];
        }];
        _closeButton = [self buttonText:[TRStr.Loc rateClose] onClick:^void() {
            [TRGameDirector.instance rateClose];
        }];
        _headerText = [EGText applyFont:nil text:[TRStr.Loc rateText] position:GEVec3Make(0.0, 0.0, 0.0) alignment:egTextAlignmentApplyXY(-1.0, 0.0) color:GEVec4Make(0.0, 0.0, 0.0, 1.0)];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _TRRateMenu_type = [ODClassType classTypeWithCls:[TRRateMenu class]];
}

- (id<CNSeq>)buttons {
    return (@[_rateButton, _supportButton, _closeButton, _laterButton]);
}

- (CGFloat)headerHeight {
    return 140.0;
}

- (NSInteger)columnWidth {
    return 520;
}

- (NSInteger)buttonHeight {
    if(egPlatform().isPhone) return 40;
    else return 50;
}

- (void)drawHeaderRect:(GERect)rect {
    [EGD2D drawSpriteMaterial:[EGColorSource applyColor:GEVec4Make(0.85, 1.0, 0.75, 0.9)] at:GEVec3Make(0.0, 0.0, 0.0) rect:rect];
    [_headerText setPosition:geVec3ApplyVec2(geVec2AddVec2(rect.p, geVec2MulVec2(rect.size, GEVec2Make(0.05, 0.5))))];
    [_headerText draw];
}

- (void)reshape {
    [_headerText setFont:[EGGlobal mainFontWithSize:14]];
}

- (ODClassType*)type {
    return [TRRateMenu type];
}

+ (ODClassType*)type {
    return _TRRateMenu_type;
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


@implementation TRLooseMenu{
    TRLevel* _level;
    EGButton* _restartButton;
    EGButton* _supportButton;
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
        _supportButton = [self buttonText:[TRStr.Loc supportButton] onClick:^void() {
            [TRGameDirector.instance showSupportChangeLevel:NO];
        }];
        _chooseLevelButton = [self buttonText:[TRStr.Loc chooseLevel] onClick:^void() {
            [TRGameDirector.instance chooseLevel];
        }];
        _buttons = (@[_restartButton, _chooseLevelButton, _supportButton]);
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
    [_headerText setPosition:geVec3ApplyVec2(geVec2AddVec2(rect.p, geVec2MulVec2(rect.size, GEVec2Make(0.05, 0.7))))];
    [_headerText draw];
    [_detailsText setPosition:geVec3ApplyVec2(geVec2AddVec2(rect.p, geVec2MulVec2(rect.size, GEVec2Make(0.5, 0.35))))];
    [_detailsText draw];
}

- (void)reshape {
    [_headerText setFont:[EGGlobal mainFontWithSize:36]];
    [_detailsText setFont:[EGGlobal mainFontWithSize:16]];
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
    EGText* _tapText;
    EGSprite* _helpBackSprite;
    BOOL __allowClose;
}
static ODClassType* _TRHelpView_type;
@synthesize level = _level;
@synthesize _allowClose = __allowClose;

+ (id)helpViewWithLevel:(TRLevel*)level {
    return [[TRHelpView alloc] initWithLevel:level];
}

- (id)initWithLevel:(TRLevel*)level {
    self = [super init];
    if(self) {
        _level = level;
        _helpText = [EGText applyFont:nil text:@"" position:GEVec3Make(0.0, 0.0, 0.0) alignment:egTextAlignmentApplyXY(-1.0, 1.0) color:GEVec4Make(0.0, 0.0, 0.0, 1.0)];
        _tapText = [EGText applyFont:nil text:[NSString stringWithFormat:@"(%@)", [TRStr.Loc tapToContinue]] position:GEVec3Make(0.0, 0.0, 0.0) alignment:egTextAlignmentApplyXY(0.0, -1.0) color:GEVec4Make(0.0, 0.0, 0.0, 1.0)];
        _helpBackSprite = [EGSprite applyMaterial:[EGColorSource applyColor:GEVec4Make(1.0, 1.0, 1.0, 0.8)] rect:geRectApplyXYWidthHeight(0.0, 0.0, 0.0, 0.0)];
        __allowClose = NO;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _TRHelpView_type = [ODClassType classTypeWithCls:[TRHelpView class]];
}

- (void)reshapeWithViewport:(GERect)viewport {
    [_helpText setFont:[EGGlobal mainFontWithSize:((egPlatform().isPhone) ? 14 : 16)]];
    [_tapText setFont:[EGGlobal mainFontWithSize:12]];
}

- (void)draw {
    TRHelp* help = [[_level help] get];
    [_helpText setText:help.text];
    GEVec2 size = geVec2AddVec2(geVec2MulVec2([_helpText measureC], GEVec2Make(1.1, 1.4)), GEVec2Make(0.0, [_tapText measureC].y));
    GERect rect = geVec2RectInCenterWithSize(size, geVec2iDivF([EGGlobal.context viewport].size, EGGlobal.context.scale));
    [_helpBackSprite setRect:rect];
    [_helpBackSprite draw];
    [_helpText setPosition:geVec3ApplyVec2(geVec2AddVec2(geRectCenter(rect), geVec2MulVec2(rect.size, GEVec2Make(-0.45, 0.45))))];
    [_tapText setPosition:geVec3ApplyVec2(geVec2AddVec2(geRectCenter(rect), geVec2MulVec2(rect.size, GEVec2Make(0.0, -0.4))))];
    [_helpText draw];
    [_tapText draw];
    __weak TRHelpView* ws = self;
    delay(1.0, ^void() {
        ws._allowClose = YES;
    });
}

- (BOOL)tapEvent:(id<EGEvent>)event {
    if(__allowClose) {
        [_level clearHelp];
        [[EGDirector current] resume];
    }
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


@implementation TRSlowMotionShopMenu{
    EGTexture* _shop;
    EGFont* _shareFont;
    GEVec2 _buttonSize;
    id<CNSeq> _curButtons;
}
static ODClassType* _TRSlowMotionShopMenu_type;
@synthesize shop = _shop;
@synthesize shareFont = _shareFont;

+ (id)slowMotionShopMenu {
    return [[TRSlowMotionShopMenu alloc] init];
}

- (id)init {
    self = [super init];
    if(self) {
        _shop = [EGGlobal scaledTextureForName:@"Shop" format:@"png"];
        _shareFont = [EGGlobal mainFontWithSize:18];
        _buttonSize = GEVec2Make(150.0, 150.0);
        _curButtons = (@[]);
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _TRSlowMotionShopMenu_type = [ODClassType classTypeWithCls:[TRSlowMotionShopMenu class]];
}

- (void)reshapeWithViewport:(GERect)viewport {
    [_shareFont beReadyForText:@"0123456789,.FacebookTwitter"];
}

- (void)drawBuyButtonCount:(NSUInteger)count price:(NSString*)price rect:(GERect)rect {
    [self drawSnailColor:GEVec3Make(0.95, 1.0, 0.95) count:count rect:rect];
    [_shareFont drawText:price at:geVec3ApplyVec2(geVec2AddVec2(geRectPXY(rect, 0.5, 0.1), GEVec2Make(0.0, 16.0))) alignment:egTextAlignmentApplyXY(0.0, 0.0) color:GEVec4Make(0.1, 0.1, 0.1, 1.0)];
}

- (void)drawShareButtonColor:(GEVec3)color texture:(EGTexture*)texture name:(NSString*)name count:(NSUInteger)count rect:(GERect)rect {
    [self drawSnailColor:color count:count rect:rect];
    GEVec2 pos = geRectPXY(rect, 0.1, 0.1);
    [EGD2D drawSpriteMaterial:[EGColorSource applyTexture:texture] at:geVec3ApplyVec2Z(pos, 0.0) rect:geRectApplyXYWidthHeight(0.0, 0.0, 32.0, 32.0)];
    [_shareFont drawText:name at:geVec3ApplyVec2(geVec2AddVec2(pos, GEVec2Make(36.0, 16.0))) alignment:egTextAlignmentApplyXY(-1.0, 0.0) color:GEVec4Make(0.1, 0.1, 0.1, 1.0)];
}

- (void)drawButtonBackgroundColor:(GEVec3)color rect:(GERect)rect {
    [EGD2D drawSpriteMaterial:[EGColorSource applyColor:geVec4ApplyVec3W(color, 0.9)] at:geVec3ApplyVec2Z(rect.p, 0.0) rect:geRectApplyXYSize(0.0, 0.0, geVec2SubVec2(rect.size, GEVec2Make(2.0, 2.0)))];
}

- (void)drawSnailColor:(GEVec3)color count:(NSUInteger)count rect:(GERect)rect {
    if(count != 10 && count != 20 && count != 50 && count != 200) return ;
    [self drawButtonBackgroundColor:color rect:rect];
    GEVec2 pos = geRectPXY(rect, 0.5, 0.6);
    GEVec2 snailPos = ((count == 10) ? GEVec2Make(0.0, 128.0) : ((count == 20) ? GEVec2Make(128.0, 128.0) : ((count == 50) ? GEVec2Make(128.0, 64.0) : GEVec2Make(0.0, 64.0))));
    [EGD2D drawSpriteMaterial:[EGColorSource applyTexture:[_shop regionX:snailPos.x y:snailPos.y width:128.0 height:64.0]] at:geVec3ApplyVec2Z(pos, 0.0) rect:geRectApplyXYWidthHeight(-64.0, -32.0, 128.0, 64.0)];
}

- (void)drawCloseButtonRect:(GERect)rect {
    [self drawButtonBackgroundColor:GEVec3Make(0.95, 0.95, 0.95) rect:rect];
    [EGD2D drawSpriteMaterial:[EGColorSource applyTexture:[_shop regionX:0.0 y:0.0 width:64.0 height:64.0]] at:geVec3ApplyVec2(geRectPXY(rect, 0.5, 0.5)) rect:geRectApplyXYWidthHeight(-32.0, -32.0, 64.0, 64.0)];
}

- (void)draw {
    id<CNSeq> buttons = [[(@[tuple(^BOOL() {
    return [TRGameDirector.instance isShareToFacebookAvailable];
}, [EGButton buttonWithOnDraw:^void(GERect _) {
    [self drawShareButtonColor:GEVec3Make(0.92, 0.95, 1.0) texture:[_shop regionX:128.0 y:0.0 width:32.0 height:32.0] name:@"Facebook" count:((NSUInteger)(TRGameDirector.facebookShareRate)) rect:_];
} onClick:^void() {
    [TRGameDirector.instance shareToFacebook];
}]), tuple(^BOOL() {
    return [TRGameDirector.instance isShareToTwitterAvailable];
}, [EGButton buttonWithOnDraw:^void(GERect _) {
    [self drawShareButtonColor:GEVec3Make(0.92, 0.95, 1.0) texture:[_shop regionX:160.0 y:0.0 width:32.0 height:32.0] name:@"Twitter" count:((NSUInteger)(TRGameDirector.twitterShareRate)) rect:_];
} onClick:^void() {
    [TRGameDirector.instance shareToTwitter];
}])]) addSeq:[[[[TRGameDirector.instance slowMotionPrices] chain] map:^CNTuple*(CNTuple* item) {
        return tuple(^BOOL() {
            return YES;
        }, [EGButton buttonWithOnDraw:^void(GERect rect) {
            [self drawBuyButtonCount:unumui(((CNTuple*)(item)).a) price:[[((CNTuple*)(item)).b mapF:^NSString*(EGInAppProduct* _) {
                return ((EGInAppProduct*)(_)).price;
            }] getOrValue:@""] rect:rect];
        } onClick:^void() {
            [((CNTuple*)(item)).b forEach:^void(EGInAppProduct* _) {
                [TRGameDirector.instance buySlowMotionsProduct:_];
            }];
        }]);
    }] toArray]] addSeq:(@[tuple(^BOOL() {
    return YES;
}, [EGButton buttonWithOnDraw:^void(GERect _) {
    [self drawCloseButtonRect:_];
} onClick:^void() {
    [TRGameDirector.instance closeShop];
}])])];
    _curButtons = [[[[buttons chain] filter:^BOOL(CNTuple* _) {
        return ((BOOL(^)())(((CNTuple*)(_)).a))();
    }] map:^EGButton*(CNTuple* _) {
        return ((CNTuple*)(_)).b;
    }] toArray];
    GEVec2 size = geVec2MulVec2(GEVec2Make(((float)(((NSUInteger)(([_curButtons count] + 1) / 2)))), 2.0), _buttonSize);
    __block GEVec2 pos = geVec2AddVec2(geVec2DivI(geVec2SubVec2(geVec2iDivF([EGGlobal.context viewport].size, EGGlobal.context.scale), size), 2), GEVec2Make(0.0, _buttonSize.y));
    __block NSInteger row = 0;
    [_curButtons forEach:^void(EGButton* btn) {
        ((EGButton*)(btn)).rect = GERectMake(pos, _buttonSize);
        if(row == 0) {
            row++;
            pos = geVec2AddVec2(pos, GEVec2Make(0.0, -_buttonSize.y));
        } else {
            row = 0;
            pos = geVec2AddVec2(pos, GEVec2Make(_buttonSize.x, _buttonSize.y));
        }
        [((EGButton*)(btn)) draw];
    }];
}

- (BOOL)tapEvent:(id<EGEvent>)event {
    return [[_curButtons findWhere:^BOOL(EGButton* _) {
        return [((EGButton*)(_)) tapEvent:event];
    }] isDefined];
}

- (ODClassType*)type {
    return [TRSlowMotionShopMenu type];
}

+ (ODClassType*)type {
    return _TRSlowMotionShopMenu_type;
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


