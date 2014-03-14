#import "TRLevelMenuView.h"

#import "TRLevel.h"
#import "EGTexture.h"
#import "EGContext.h"
#import "EGSprite.h"
#import "EGPlatformPlat.h"
#import "EGPlatform.h"
#import "EGMaterial.h"
#import "ATReact.h"
#import "TRRailroadBuilder.h"
#import "TRGameDirector.h"
#import "TRStrings.h"
#import "TRScore.h"
#import "EGSchedule.h"
#import "EGProgress.h"
#import "EGCamera2D.h"
#import "EGDirector.h"
@implementation TRLevelMenuView
static ODClassType* _TRLevelMenuView_type;
@synthesize level = _level;
@synthesize name = _name;
@synthesize levelText = _levelText;

+ (instancetype)levelMenuViewWithLevel:(TRLevel*)level {
    return [[TRLevelMenuView alloc] initWithLevel:level];
}

- (instancetype)initWithLevel:(TRLevel*)level {
    self = [super init];
    __weak TRLevelMenuView* _weakSelf = self;
    if(self) {
        _level = level;
        _name = @"LevelMenu";
        _t = [EGGlobal scaledTextureForName:@"Pause" format:EGTextureFormat.RGBA4];
        _pauseSprite = [EGSprite applyMaterial:[ATReact applyValue:[EGColorSource applyTexture:((egPlatform().isPhone) ? [_t regionX:0.0 y:0.0 width:32.0 height:32.0] : [_t regionX:96.0 y:32.0 width:32.0 height:32.0])]] position:[EGGlobal.context.scaledViewSize mapF:^id(id _) {
            return wrap(GEVec3, (GEVec3Make((uwrap(GEVec2, _).x - ((egPlatform().isPhone) ? 32 : 36)), 4.0, 0.0)));
        }]];
        _slowSprite = [EGSprite applyMaterial:[ATReact applyValue:[EGColorSource applyTexture:[_t regionX:64.0 y:32.0 width:32.0 height:32.0]]] position:[EGGlobal.context.scaledViewSize mapF:^id(id _) {
            return wrap(GEVec3, (GEVec3Make((uwrap(GEVec2, _).x - ((egPlatform().isPhone) ? 36 : 40)), (uwrap(GEVec2, _).y - 34), 0.0)));
        }]];
        __hammerSprite = [EGSprite applyVisible:[_level.scale mapF:^id(id _) {
            return numb(unumf(_) > 1.0);
        }] material:[[_level.builder mode] mapF:^EGColorSource*(ATVar* m) {
            TRLevelMenuView* _self = _weakSelf;
            return [EGColorSource applyColor:(([m isEqual:TRRailroadBuilderMode.build]) ? GEVec4Make(0.45, 0.9, 0.6, 0.95) : geVec4ApplyF(1.0)) texture:[_self->_t regionX:32.0 y:0.0 width:32.0 height:32.0]];
        }] position:[EGGlobal.context.scaledViewSize mapF:^id(id _) {
            return wrap(GEVec3, (GEVec3Make(0.0, (uwrap(GEVec2, _).y - 32), 0.0)));
        }]];
        __clearSprite = [EGSprite applyMaterial:[[_level.builder mode] mapF:^EGColorSource*(ATVar* m) {
            TRLevelMenuView* _self = _weakSelf;
            return [EGColorSource applyColor:(([m isEqual:TRRailroadBuilderMode.clear]) ? GEVec4Make(0.45, 0.9, 0.6, 0.95) : geVec4ApplyF(1.0)) texture:[_self->_t regionX:0.0 y:64.0 width:32.0 height:32.0]];
        }] position:[ATReact applyValue:wrap(GEVec3, (GEVec3Make(0.0, 0.0, 0.0)))]];
        _shadow = [EGTextShadow textShadowWithColor:GEVec4Make(0.05, 0.05, 0.05, 0.5) shift:GEVec2Make(1.0, -1.0)];
        _slowMotionCountText = [EGText textWithVisible:[[TRGameDirector.instance slowMotionsCount] mapF:^id(id _) {
            return numb(unumi(_) > 0);
        }] font:[ATReact applyValue:[[EGGlobal mainFontWithSize:24] beReadyForText:[NSString stringWithFormat:@"$0123456789'%@", [TRStr.Loc levelNumber:1]]]] text:[[TRGameDirector.instance slowMotionsCount] mapF:^NSString*(id _) {
            return [NSString stringWithFormat:@"%@", _];
        }] position:[_slowSprite.position mapF:^id(id _) {
            return wrap(GEVec3, (geVec3AddVec3((uwrap(GEVec3, _)), (geVec3ApplyVec2((GEVec2Make(1.0, 18.0)))))));
        }] alignment:[ATReact applyValue:wrap(EGTextAlignment, (egTextAlignmentApplyXY(1.0, 0.0)))] color:[ATReact applyValue:wrap(GEVec4, [self color])] shadow:[ATReact applyValue:_shadow]];
        _scoreText = [EGText textWithVisible:[ATReact applyValue:@YES] font:[ATReact applyValue:[EGGlobal mainFontWithSize:24]] text:[[_level.score money] mapF:^NSString*(id _) {
            TRLevelMenuView* _self = _weakSelf;
            return [_self formatScore:unumi(_)];
        }] position:[ATReact applyA:EGGlobal.context.scaledViewSize b:_level.scale f:^id(id viewSize, id scale) {
            if(unumf(scale) > 1.0) return wrap(GEVec3, (GEVec3Make(32.0, (uwrap(GEVec2, viewSize).y - 24), 0.0)));
            else return wrap(GEVec3, (GEVec3Make(10.0, (uwrap(GEVec2, viewSize).y - 24), 0.0)));
        }] alignment:[ATReact applyValue:wrap(EGTextAlignment, egTextAlignmentBaselineX(-1.0))] color:[ATReact applyValue:wrap(GEVec4, [self color])] shadow:[ATReact applyValue:_shadow]];
        _currentNotificationText = [ATVar applyInitial:@""];
        _notificationText = [EGText textWithVisible:[_notificationAnimation isRunning] font:[ATReact applyValue:[[EGGlobal mainFontWithSize:((egPlatform().isPhone) ? (([egPlatform() screenSizeRatio] > 4.0 / 3.0) ? 14 : 12) : 18)] beReadyForText:[TRStr.Loc notificationsCharSet]]] text:_currentNotificationText position:[ATReact applyA:_scoreText.text b:_scoreText.position f:^id(NSString* _, id scorePos) {
            TRLevelMenuView* _self = _weakSelf;
            return wrap(GEVec3, (GEVec3Make(([_self->_scoreText measureC].x + uwrap(GEVec3, scorePos).x + 5), (uwrap(GEVec3, scorePos).y + 2), 0.0)));
        }] alignment:[ATReact applyValue:wrap(EGTextAlignment, egTextAlignmentBaselineX(((egPlatform().isPhone) ? -1.0 : 0.0)))] color:[ATReact applyValue:wrap(GEVec4, [self color])] shadow:[ATReact applyValue:_shadow]];
        _levelText = [CNOption applyValue:[EGText textWithVisible:[ATReact applyValue:@YES] font:[ATReact applyValue:[EGGlobal mainFontWithSize:24]] text:[ATReact applyValue:[TRStr.Loc startLevelNumber:_level.number]] position:[EGGlobal.context.scaledViewSize mapF:^id(id _) {
            return wrap(GEVec3, (GEVec3Make((uwrap(GEVec2, _).x / 2), (uwrap(GEVec2, _).y - 24), 0.0)));
        }] alignment:[ATReact applyValue:wrap(EGTextAlignment, egTextAlignmentBaselineX(0.0))] color:[[_levelAnimation time] mapF:^id(id _) {
            TRLevelMenuView* _self = _weakSelf;
            return wrap(GEVec4, _self->_notificationProgress(((float)(unumf(_)))));
        }] shadow:[ATReact applyValue:_shadow]]];
        _notificationProgress = ^id() {
            float(^__l)(float) = [EGProgress gapT1:0.7 t2:1.0];
            GEVec4(^__r)(float) = ^GEVec4(float _) {
                return geVec4ApplyF(0.95 - _);
            };
            return ^GEVec4(float _) {
                return __r(__l(_));
            };
        }();
        __camera = [EGGlobal.context.scaledViewSize mapF:^EGCamera2D*(id _) {
            return [EGCamera2D camera2DWithSize:uwrap(GEVec2, _)];
        }];
        _notificationAnimation = [EGCounter applyLength:2.0];
        _levelAnimation = [EGFinisher finisherWithCounter:[EGCounter applyLength:5.0] finish:^void() {
            TRLevelMenuView* _self = _weakSelf;
            _self->_levelText = [CNOption none];
        }];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [TRLevelMenuView class]) _TRLevelMenuView_type = [ODClassType classTypeWithCls:[TRLevelMenuView class]];
}

- (id<EGCamera>)camera {
    return [__camera value];
}

- (GEVec4)color {
    return geVec4ApplyF(0.95);
}

- (void)draw {
    [EGGlobal.context.depthTest disabledF:^void() {
        [EGBlendFunction.premultiplied applyDraw:^void() {
            [_scoreText draw];
            [_pauseSprite draw];
            [__clearSprite draw];
            [_levelText forEach:^void(EGText* _) {
                [((EGText*)(_)) draw];
            }];
            [_notificationText draw];
            if([_level.slowMotionCounter isRunning]) {
                [EGBlendFunction.standard applyDraw:^void() {
                    [EGD2D drawCircleBackColor:GEVec4Make(0.6, 0.6, 0.6, 0.95) strokeColor:GEVec4Make(0.0, 0.0, 0.0, 0.5) at:geVec3AddVec3((uwrap(GEVec3, [_slowSprite.position value])), (geVec3ApplyVec2((geVec2DivI((uwrap(GERect, [_slowSprite.rect value]).size), 2))))) radius:22.0 relative:GEVec2Make(0.0, 0.0) segmentColor:geVec4ApplyF(0.95) start:M_PI_2 end:M_PI_2 - 2 * [_level.slowMotionCounter time] * M_PI];
                }];
            } else {
                [_slowMotionCountText draw];
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
                [_currentNotificationText setValue:[[_level.notifications take] get]];
                [_notificationAnimation restart];
            }
        }
    }
}

- (EGRecognizers*)recognizers {
    return [EGRecognizers applyRecognizer:[EGRecognizer applyTp:[EGTap apply] on:^BOOL(id<EGEvent> event) {
        GEVec2 p = [event locationInViewport];
        if([_pauseSprite containsViewportVec2:p]) {
            if([[EGDirector current] isPaused]) [[EGDirector current] resume];
            else [[EGDirector current] pause];
        } else {
            if([_slowSprite containsViewportVec2:p] && !(unumb([[_level.slowMotionCounter isRunning] value]))) {
                [TRGameDirector.instance runSlowMotionLevel:_level];
            } else {
                if(_level.scale > 1.0 && [__hammerSprite containsViewportVec2:p]) {
                    [_level.builder modeBuildFlip];
                } else {
                    if([__clearSprite containsViewportVec2:p]) [_level.builder modeClearFlip];
                }
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

- (void)reshapeWithViewport:(GERect)viewport {
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


