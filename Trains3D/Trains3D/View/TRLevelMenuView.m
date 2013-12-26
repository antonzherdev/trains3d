#import "TRLevelMenuView.h"

#import "TRLevel.h"
#import "EGSprite.h"
#import "EGProgress.h"
#import "GL.h"
#import "EGPlatform.h"
#import "EGSchedule.h"
#import "EGContext.h"
#import "EGCamera2D.h"
#import "EGTexture.h"
#import "EGMaterial.h"
#import "TRRailroad.h"
#import "TRScore.h"
#import "TRStrings.h"
#import "TRNotification.h"
#import "EGDirector.h"
@implementation TRLevelMenuView{
    TRLevel* _level;
    NSString* _name;
    EGSprite* _pauseSprite;
    EGSprite* _hammerSprite;
    GEVec4(^_notificationProgress)(float);
    NSInteger _width;
    id<EGCamera> _camera;
    EGText* _scoreText;
    EGText* _notificationText;
    id _levelText;
    CNCache* _scoreX;
    EGCounter* _notificationAnimation;
    EGFinisher* _levelAnimation;
}
static ODClassType* _TRLevelMenuView_type;
@synthesize level = _level;
@synthesize name = _name;
@synthesize notificationProgress = _notificationProgress;
@synthesize camera = _camera;
@synthesize scoreText = _scoreText;
@synthesize levelText = _levelText;

+ (id)levelMenuViewWithLevel:(TRLevel*)level {
    return [[TRLevelMenuView alloc] initWithLevel:level];
}

- (id)initWithLevel:(TRLevel*)level {
    self = [super init];
    __weak TRLevelMenuView* _weakSelf = self;
    if(self) {
        _level = level;
        _name = @"LevelMenu";
        _pauseSprite = [EGSprite sprite];
        _hammerSprite = [EGSprite sprite];
        _notificationProgress = ^id() {
            float(^__l)(float) = [EGProgress gapT1:0.7 t2:1.0];
            GEVec4(^__r)(float) = ^GEVec4(float _) {
                return geVec4ApplyF(0.95 - _);
            };
            return ^GEVec4(float _) {
                return __r(__l(_));
            };
        }();
        _width = 0;
        _scoreText = [EGText applyFont:nil text:@"" position:GEVec3Make(10.0, 8.0, 0.0) alignment:egTextAlignmentBaselineX(-1.0) color:[self color]];
        _notificationText = [EGText applyFont:nil text:@"" position:GEVec3Make(0.0, 0.0, 0.0) alignment:egTextAlignmentBaselineX(((egInterfaceIdiom().isPhone) ? -1.0 : 0.0)) color:[self color]];
        _levelText = [CNOption applyValue:[EGText applyFont:nil text:@"" position:GEVec3Make(0.0, 0.0, 0.0) alignment:egTextAlignmentBaselineX(0.0) color:[self color]]];
        _scoreX = [CNCache cacheWithF:^id(NSString* _) {
            return numf4([_weakSelf.scoreText measureC].x);
        }];
        _notificationAnimation = [EGCounter apply];
        _levelAnimation = [EGFinisher finisherWithCounter:[EGCounter applyLength:5.0] finish:^void() {
            _weakSelf.levelText = [CNOption none];
        }];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _TRLevelMenuView_type = [ODClassType classTypeWithCls:[TRLevelMenuView class]];
}

- (void)reshapeWithViewport:(GERect)viewport {
    _camera = [EGCamera2D camera2DWithSize:GEVec2Make(geRectWidth(viewport) / EGGlobal.context.scale, 32.0)];
    EGFont* font = [EGGlobal fontWithName:@"lucida_grande" size:24];
    EGFont* notificationFont = [EGGlobal fontWithName:@"lucida_grande" size:((egInterfaceIdiom().isPhone) ? 14 : 16)];
    [_notificationText setFont:font];
    _width = ((NSInteger)(viewport.size.x / EGGlobal.context.scale));
    EGTextShadow* sh = [EGTextShadow textShadowWithColor:GEVec4Make(0.05, 0.05, 0.05, 0.5) shift:GEVec2Make(1.0, -1.0)];
    [_scoreText setFont:font];
    _scoreText.shadow = [CNOption applyValue:sh];
    [_notificationText setFont:notificationFont];
    _notificationText.shadow = [CNOption applyValue:sh];
    [_notificationText setPosition:GEVec3Make(((float)(_width / 2)), 10.0, 0.0)];
    _scoreText.shadow = [CNOption applyValue:sh];
    [_levelText forEach:^void(EGText* _) {
        [((EGText*)(_)) setFont:font];
        ((EGText*)(_)).shadow = [CNOption applyValue:sh];
        [((EGText*)(_)) setPosition:GEVec3Make(((float)(_width / 2)), 10.0, 0.0)];
    }];
    [_pauseSprite setPosition:GEVec2Make(((float)(_width - 32)), 0.0)];
    EGTexture* t = [EGGlobal scaledTextureForName:@"Pause" format:@"png"];
    [_pauseSprite setMaterial:[EGColorSource applyTexture:[t regionX:0.0 y:0.0 width:32.0 height:32.0]]];
    [_pauseSprite adjustSize];
    [_hammerSprite setPosition:GEVec2Make(0.0, 0.0)];
    [_hammerSprite setMaterial:[EGColorSource applyColor:GEVec4Make(0.1, 0.1, 0.1, 1.0) texture:[t regionX:32.0 y:0.0 width:32.0 height:32.0]]];
    [_hammerSprite adjustSize];
}

- (GEVec4)color {
    return geVec4ApplyF(0.95);
}

- (void)draw {
    [EGGlobal.context.depthTest disabledF:^void() {
        [EGBlendFunction.premultiplied applyDraw:^void() {
            if(_level.scale > 1.0) {
                [_hammerSprite setMaterial:[[_hammerSprite material] setColor:(([_level.railroad.builder buildMode]) ? GEVec4Make(0.45, 0.9, 0.6, 0.95) : [self color])]];
                [_hammerSprite draw];
                [_scoreText setPosition:GEVec3Make(32.0, 8.0, 0.0)];
            } else {
                [_scoreText setPosition:GEVec3Make(10.0, 8.0, 0.0)];
            }
            [_scoreText setText:[self formatScore:[_level.score score]]];
            [_scoreText draw];
            [_pauseSprite draw];
            [_levelAnimation forF:^void(CGFloat t) {
                [_levelText forEach:^void(EGText* _) {
                    [((EGText*)(_)) setText:[TRStr.Loc startLevelNumber:_level.number]];
                    ((EGText*)(_)).color = _notificationProgress(((float)(t / 3.0)));
                    [((EGText*)(_)) draw];
                }];
            }];
            [_notificationAnimation forF:^void(CGFloat t) {
                if(egInterfaceIdiom().isPhone) [_notificationText setPosition:GEVec3Make(unumf4([_scoreX applyX:[_scoreText text]]) + [_scoreText position].x + 5, 10.0, 0.0)];
                _notificationText.color = _notificationProgress(((float)(t)));
                [_notificationText draw];
            }];
        }];
    }];
}

- (NSString*)formatScore:(NSInteger)score {
    return [TRStr.Loc formatCost:score];
}

- (void)updateWithDelta:(CGFloat)delta {
    if([_levelAnimation isRunning]) {
        [_levelAnimation updateWithDelta:delta];
    } else {
        if([_notificationAnimation isRunning]) {
            [_notificationAnimation updateWithDelta:(([_level.notifications isEmpty]) ? delta : 5 * delta)];
        } else {
            if(!([_level.notifications isEmpty])) {
                [_notificationText setText:[[_level.notifications take] get]];
                _notificationAnimation = [EGCounter applyLength:2.0];
            }
        }
    }
}

- (EGRecognizers*)recognizers {
    return [EGRecognizers applyRecognizer:[EGRecognizer applyTp:[EGTap apply] on:^BOOL(id<EGEvent> event) {
        GEVec2 p = [event location];
        if([_pauseSprite containsVec2:p]) {
            if([[EGDirector current] isPaused]) [[EGDirector current] resume];
            else [[EGDirector current] pause];
        } else {
            if(_level.scale > 1.0 && [_hammerSprite containsVec2:p]) [_level.railroad.builder setBuildMode:!([_level.railroad.builder buildMode])];
        }
        return NO;
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

- (BOOL)isProcessorActive {
    return !([[EGDirector current] isPaused]);
}

- (ODClassType*)type {
    return [TRLevelMenuView type];
}

+ (ODClassType*)type {
    return _TRLevelMenuView_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    TRLevelMenuView* o = ((TRLevelMenuView*)(other));
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


