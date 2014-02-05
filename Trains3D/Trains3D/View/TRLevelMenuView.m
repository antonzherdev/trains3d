#import "TRLevelMenuView.h"

#import "TRLevel.h"
#import "EGSprite.h"
#import "EGProgress.h"
#import "EGPlatformPlat.h"
#import "EGPlatform.h"
#import "EGSchedule.h"
#import "EGContext.h"
#import "EGCamera2D.h"
#import "TRStrings.h"
#import "EGTexture.h"
#import "EGMaterial.h"
#import "TRRailroadBuilder.h"
#import "TRScore.h"
#import "TRGameDirector.h"
#import "TRNotification.h"
#import "EGDirector.h"
@implementation TRLevelMenuView{
    TRLevel* _level;
    NSString* _name;
    EGSprite* _pauseSprite;
    EGSprite* _slowSprite;
    EGSprite* _hammerSprite;
    EGText* _slowMotionCountText;
    GEVec4(^_notificationProgress)(float);
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
        _slowSprite = [EGSprite sprite];
        _hammerSprite = [EGSprite sprite];
        _slowMotionCountText = [EGText applyFont:nil text:@"" position:GEVec3Make(0.0, 0.0, 0.0) alignment:egTextAlignmentApplyXY(1.0, 0.0) color:[self color]];
        _notificationProgress = ^id() {
            float(^__l)(float) = [EGProgress gapT1:0.7 t2:1.0];
            GEVec4(^__r)(float) = ^GEVec4(float _) {
                return geVec4ApplyF(0.95 - _);
            };
            return ^GEVec4(float _) {
                return __r(__l(_));
            };
        }();
        _scoreText = [EGText applyFont:nil text:@"" position:GEVec3Make(10.0, 40.0, 0.0) alignment:egTextAlignmentBaselineX(-1.0) color:[self color]];
        _notificationText = [EGText applyFont:nil text:@"" position:GEVec3Make(0.0, 0.0, 0.0) alignment:egTextAlignmentBaselineX(((egPlatform().isPhone) ? -1.0 : 0.0)) color:[self color]];
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
    GEVec2 s = geVec2DivF(viewport.size, EGGlobal.context.scale);
    _camera = [EGCamera2D camera2DWithSize:s];
    EGFont* font = [EGGlobal mainFontWithSize:24];
    [font beReadyForText:@"$0123456789'"];
    [font beReadyForText:[TRStr.Loc levelNumber:1]];
    EGFont* notificationFont = [EGGlobal mainFontWithSize:((egPlatform().isPhone) ? (([egPlatform() screenSizeRatio] > 4.0 / 3.0) ? 14 : 12) : 18)];
    [notificationFont beReadyForText:[TRStr.Loc notificationsCharSet]];
    [_notificationText setFont:font];
    EGTextShadow* sh = [EGTextShadow textShadowWithColor:GEVec4Make(0.05, 0.05, 0.05, 0.5) shift:GEVec2Make(1.0, -1.0)];
    [_scoreText setFont:font];
    _scoreText.shadow = [CNOption applyValue:sh];
    [_notificationText setFont:notificationFont];
    _notificationText.shadow = [CNOption applyValue:sh];
    [_notificationText setPosition:GEVec3Make(s.x / 2, s.y - 22, 0.0)];
    _scoreText.shadow = [CNOption applyValue:sh];
    [_levelText forEach:^void(EGText* _) {
        [((EGText*)(_)) setFont:font];
        ((EGText*)(_)).shadow = [CNOption applyValue:sh];
        [((EGText*)(_)) setPosition:GEVec3Make(s.x / 2, s.y - 24, 0.0)];
    }];
    BOOL ph = egPlatform().isPhone;
    [_pauseSprite setPosition:GEVec2Make(s.x - ((ph) ? 32 : 36), 4.0)];
    EGTexture* t = [EGGlobal scaledTextureForName:@"Pause" format:@"png"];
    [_pauseSprite setMaterial:[EGColorSource applyTexture:((ph) ? [t regionX:0.0 y:0.0 width:32.0 height:32.0] : [t regionX:96.0 y:32.0 width:32.0 height:32.0])]];
    [_pauseSprite adjustSize];
    [_slowSprite setPosition:GEVec2Make(s.x - ((ph) ? 36 : 40), s.y - 34)];
    [_slowSprite setMaterial:[EGColorSource applyTexture:[t regionX:64.0 y:32.0 width:32.0 height:32.0]]];
    [_slowSprite adjustSize];
    [_slowMotionCountText setFont:[EGGlobal mainFontWithSize:24]];
    [[_slowMotionCountText font] beReadyForText:@"0123456789"];
    [_slowMotionCountText setPosition:geVec3ApplyVec2(geVec2AddVec2([_slowSprite position], GEVec2Make(1.0, 18.0)))];
    _slowMotionCountText.shadow = [CNOption applyValue:sh];
    [_hammerSprite setPosition:GEVec2Make(0.0, s.y - 32)];
    [_hammerSprite setMaterial:[EGColorSource applyColor:GEVec4Make(0.1, 0.1, 0.1, 1.0) texture:[t regionX:32.0 y:0.0 width:32.0 height:32.0]]];
    [_hammerSprite adjustSize];
}

- (GEVec4)color {
    return geVec4ApplyF(0.95);
}

- (void)draw {
    [EGGlobal.context.depthTest disabledF:^void() {
        [EGBlendFunction.premultiplied applyDraw:^void() {
            GEVec2 s = geVec2iDivF([EGGlobal.context viewport].size, EGGlobal.context.scale);
            if(_level.scale > 1.0) {
                [_hammerSprite setMaterial:[[_hammerSprite material] setColor:(([_level.builder buildMode]) ? GEVec4Make(0.45, 0.9, 0.6, 0.95) : [self color])]];
                [_hammerSprite draw];
                [_scoreText setPosition:GEVec3Make(32.0, s.y - 24, 0.0)];
            } else {
                [_scoreText setPosition:GEVec3Make(10.0, s.y - 24, 0.0)];
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
                if(egPlatform().isPhone) [_notificationText setPosition:GEVec3Make(unumf4([_scoreX applyX:[_scoreText text]]) + [_scoreText position].x + 5, s.y - 22, 0.0)];
                _notificationText.color = _notificationProgress(((float)(t)));
                [_notificationText draw];
            }];
            if([_level.slowMotionCounter isRunning]) {
                [EGBlendFunction.standard applyDraw:^void() {
                    [EGD2D drawCircleBackColor:GEVec4Make(0.6, 0.6, 0.6, 0.95) strokeColor:GEVec4Make(0.0, 0.0, 0.0, 0.5) at:geVec3ApplyVec2(geVec2AddVec2([_slowSprite position], geVec2DivI([_slowSprite size], 2))) radius:22.0 relative:GEVec2Make(0.0, 0.0) segmentColor:geVec4ApplyF(0.95) start:M_PI_2 end:M_PI_2 - 2 * [_level.slowMotionCounter time] * M_PI];
                }];
            } else {
                NSInteger slowMotionsCount = [TRGameDirector.instance slowMotionsCount];
                if(slowMotionsCount > 0) {
                    [_slowMotionCountText setText:[NSString stringWithFormat:@"%ld", (long)[TRGameDirector.instance slowMotionsCount]]];
                    [_slowMotionCountText draw];
                }
                [_slowSprite draw];
            }
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
            if([_slowSprite containsVec2:p] && [_level.slowMotionCounter isStopped]) {
                [TRGameDirector.instance runSlowMotionLevel:_level];
            } else {
                if(_level.scale > 1.0 && [_hammerSprite containsVec2:p]) [_level.builder setBuildMode:!([_level.builder buildMode])];
            }
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


