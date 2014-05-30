#import "TRLevelMenuView.h"

#import "TRLevel.h"
#import "EGContext.h"
#import "EGSchedule.h"
#import "EGProgress.h"
#import "EGSprite.h"
#import "EGPlatformPlat.h"
#import "EGPlatform.h"
#import "EGMaterial.h"
#import "CNReact.h"
#import "TRHistory.h"
#import "EGText.h"
#import "TRGameDirector.h"
#import "TRStrings.h"
#import "TRScore.h"
#import "EGCamera2D.h"
#import "math.h"
#import "EGD2D.h"
#import "EGDirector.h"
@implementation TRLevelMenuView
static CNClassType* _TRLevelMenuView_type;
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
        _t = [EGGlobal scaledTextureForName:@"Pause" format:EGTextureFormat_RGBA4];
        _notificationAnimation = [EGCounter applyLength:2.0];
        _levelAnimation = [EGCounter applyLength:5.0];
        _notificationProgress = ({
            float(^__l)(float) = [EGProgress trapeziumT1:0.1];
            GEVec4(^__r)(float) = ^GEVec4(float _) {
                return geVec4ApplyF(0.95 * _);
            };
            ^GEVec4(float _) {
                return __r(__l(_));
            };
        });
        _pauseSprite = [EGSprite applyMaterial:[CNReact applyValue:[EGColorSource applyTexture:((egPlatform().isPhone) ? [_t regionX:0.0 y:0.0 width:32.0 height:32.0] : [_t regionX:96.0 y:32.0 width:32.0 height:32.0])]] position:[EGGlobal.context.scaledViewSize mapF:^id(id _) {
            return wrap(GEVec3, (GEVec3Make((uwrap(GEVec2, _).x - ((egPlatform().isPhone) ? 16 : 20)), (((egPlatform().isComputer) ? uwrap(GEVec2, _).y - 18 : 20.0)), 0.0)));
        }]];
        _rewindSprite = [EGSprite applyVisible:level.history.canRewind material:[CNReact applyValue:[EGColorSource applyTexture:[_t regionX:32.0 y:64.0 width:32.0 height:32.0]]] position:[EGGlobal.context.scaledViewSize mapF:^id(id _) {
            return wrap(GEVec3, (GEVec3Make(((uwrap(GEVec2, _).x - ((egPlatform().isPhone) ? 20 : 24)) - ((egPlatform().isComputer) ? 70 : 0)), (uwrap(GEVec2, _).y - 18), 0.0)));
        }]];
        _rewindCountText = [EGText textWithVisible:[CNReact applyA:_rewindSprite.visible b:TRGameDirector.instance.rewindsCount f:^id(id v, id count) {
            return numb(unumb(v) && unumi(count) > 0);
        }] font:[CNReact applyValue:[EGGlobal mainFontWithSize:24]] text:[TRGameDirector.instance.rewindsCount mapF:^NSString*(id _) {
            return [NSString stringWithFormat:@"%@", _];
        }] position:[_rewindSprite.position mapF:^id(id _) {
            return wrap(GEVec3, (geVec3AddVec3((uwrap(GEVec3, _)), (GEVec3Make(-12.0, 1.0, 0.0)))));
        }] alignment:[CNReact applyValue:wrap(EGTextAlignment, (egTextAlignmentApplyXY(1.0, 0.0)))] color:[CNReact applyValue:wrap(GEVec4, [self color])] shadow:[CNReact applyValue:_shadow]];
        _slowSprite = [EGSprite applyVisible:[[TRGameDirector.instance slowMotionsCount] mapF:^id(id _) {
            return numb(unumi(_) > 0);
        }] material:[CNReact applyValue:[EGColorSource applyTexture:[_t regionX:64.0 y:32.0 width:32.0 height:32.0]]] position:[EGGlobal.context.scaledViewSize mapF:^id(id _) {
            return wrap(GEVec3, (GEVec3Make((((uwrap(GEVec2, _).x - 50) - ((egPlatform().isPhone) ? 20 : 24)) - ((egPlatform().isComputer) ? 70 : 0)), (uwrap(GEVec2, _).y - 18), 0.0)));
        }]];
        _slowMotionCountText = [EGText textWithVisible:_slowSprite.visible font:[CNReact applyValue:[EGGlobal mainFontWithSize:24]] text:[[TRGameDirector.instance slowMotionsCount] mapF:^NSString*(id _) {
            return [NSString stringWithFormat:@"%@", _];
        }] position:[_slowSprite.position mapF:^id(id _) {
            return wrap(GEVec3, (geVec3AddVec3((uwrap(GEVec3, _)), (GEVec3Make(-16.0, 1.0, 0.0)))));
        }] alignment:[CNReact applyValue:wrap(EGTextAlignment, (egTextAlignmentApplyXY(1.0, 0.0)))] color:[CNReact applyValue:wrap(GEVec4, [self color])] shadow:[CNReact applyValue:_shadow]];
        __hammerSprite = [EGSprite applyVisible:[level.scale mapF:^id(id _) {
            return numb(unumf(_) > 1.0);
        }] material:[level.builder.mode mapF:^EGColorSource*(TRRailroadBuilderMode* m) {
            TRLevelMenuView* _self = _weakSelf;
            if(_self != nil) return [EGColorSource applyColor:((((TRRailroadBuilderModeR)([m ordinal])) + 1 == TRRailroadBuilderMode_build) ? GEVec4Make(0.45, 0.9, 0.6, 0.95) : geVec4ApplyF(1.0)) texture:[_self->_t regionX:32.0 y:0.0 width:32.0 height:32.0]];
            else return nil;
        }] position:[EGGlobal.context.scaledViewSize mapF:^id(id _) {
            return wrap(GEVec3, (GEVec3Make(16.0, (uwrap(GEVec2, _).y - 16), 0.0)));
        }]];
        __clearSprite = [EGSprite applyMaterial:[level.builder.mode mapF:^EGColorSource*(TRRailroadBuilderMode* m) {
            TRLevelMenuView* _self = _weakSelf;
            if(_self != nil) return [EGColorSource applyColor:((((TRRailroadBuilderModeR)([m ordinal])) + 1 == TRRailroadBuilderMode_clear) ? GEVec4Make(0.45, 0.9, 0.6, 0.95) : geVec4ApplyF(1.0)) texture:[_self->_t regionX:0.0 y:64.0 width:32.0 height:32.0]];
            else return nil;
        }] position:((egPlatform().isComputer) ? [EGGlobal.context.scaledViewSize mapF:^id(id _) {
            return wrap(GEVec3, (GEVec3Make((uwrap(GEVec2, _).x - 56), (uwrap(GEVec2, _).y - 18), 0.0)));
        }] : ((CNReact*)([CNVal valWithValue:wrap(GEVec3, (GEVec3Make(16.0, 16.0, 0.0)))])))];
        _shadow = [EGTextShadow textShadowWithColor:GEVec4Make(0.05, 0.05, 0.05, 0.5) shift:GEVec2Make(1.0, -1.0)];
        _scoreText = [EGText textWithVisible:[CNReact applyValue:@YES] font:[CNReact applyValue:[[EGGlobal mainFontWithSize:24] beReadyForText:[NSString stringWithFormat:@"-$0123456789'%@", [TRStr.Loc levelNumber:1]]]] text:[level.score.money mapF:^NSString*(id _) {
            TRLevelMenuView* _self = _weakSelf;
            if(_self != nil) return [_self formatScore:unumi(_)];
            else return nil;
        }] position:[CNReact applyA:EGGlobal.context.scaledViewSize b:level.scale f:^id(id viewSize, id scale) {
            if(unumf(scale) > 1.0) return wrap(GEVec3, (GEVec3Make(32.0, (uwrap(GEVec2, viewSize).y - 24), 0.0)));
            else return wrap(GEVec3, (GEVec3Make(10.0, (uwrap(GEVec2, viewSize).y - 24), 0.0)));
        }] alignment:[CNReact applyValue:wrap(EGTextAlignment, egTextAlignmentBaselineX(-1.0))] color:[CNReact applyValue:wrap(GEVec4, [self color])] shadow:[CNReact applyValue:_shadow]];
        _currentNotificationText = [CNVar applyInitial:@""];
        _notificationText = [EGText textWithVisible:[_notificationAnimation isRunning] font:[CNReact applyValue:[[EGGlobal mainFontWithSize:((egPlatform().isPhone) ? (([egPlatform() screenSizeRatio] > 4.0 / 3.0) ? 14 : 12) : 18)] beReadyForText:[TRStr.Loc notificationsCharSet]]] text:_currentNotificationText position:((egPlatform().isPhone) ? [CNReact applyA:_scoreText.position b:[_scoreText sizeInPoints] f:^id(id pos, id size) {
            return wrap(GEVec3, (GEVec3Make((uwrap(GEVec2, size).x + uwrap(GEVec3, pos).x + 5), (uwrap(GEVec3, pos).y + 2), 0.0)));
        }] : [EGGlobal.context.scaledViewSize mapF:^id(id _) {
            return wrap(GEVec3, (GEVec3Make((uwrap(GEVec2, _).x / 2), (uwrap(GEVec2, _).y - 24), 0.0)));
        }]) alignment:[CNReact applyValue:wrap(EGTextAlignment, egTextAlignmentBaselineX(((egPlatform().isPhone) ? -1.0 : 0.0)))] color:[[_notificationAnimation time] mapF:^id(id _) {
            TRLevelMenuView* _self = _weakSelf;
            if(_self != nil) return wrap(GEVec4, _self->_notificationProgress(((float)(unumf(_)))));
            else return nil;
        }] shadow:[CNReact applyValue:_shadow]];
        _levelText = [EGText textWithVisible:[CNReact applyValue:@YES] font:[CNReact applyValue:[EGGlobal mainFontWithSize:24]] text:[CNReact applyValue:[TRStr.Loc startLevelNumber:level.number]] position:[EGGlobal.context.scaledViewSize mapF:^id(id _) {
            return wrap(GEVec3, (GEVec3Make((uwrap(GEVec2, _).x / 2), (uwrap(GEVec2, _).y - 24), 0.0)));
        }] alignment:[CNReact applyValue:wrap(EGTextAlignment, egTextAlignmentBaselineX(0.0))] color:[[_levelAnimation time] mapF:^id(id _) {
            TRLevelMenuView* _self = _weakSelf;
            if(_self != nil) return wrap(GEVec4, _self->_notificationProgress(((float)(unumf(_)))));
            else return nil;
        }] shadow:[CNReact applyValue:_shadow]];
        __camera = [EGGlobal.context.scaledViewSize mapF:^EGCamera2D*(id _) {
            return [EGCamera2D camera2DWithSize:uwrap(GEVec2, _)];
        }];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [TRLevelMenuView class]) _TRLevelMenuView_type = [CNClassType classTypeWithCls:[TRLevelMenuView class]];
}

- (id<EGCamera>)camera {
    return [__camera value];
}

- (GEVec4)color {
    return geVec4ApplyF(0.95);
}

- (void)draw {
    EGEnablingState* __tmp__il__0self = EGGlobal.context.depthTest;
    {
        BOOL __il__0changed = [__tmp__il__0self disable];
        EGEnablingState* __il__0rp0__tmp__il__0self = EGGlobal.context.blend;
        {
            BOOL __il__0rp0__il__0changed = [__il__0rp0__tmp__il__0self enable];
            {
                [EGGlobal.context setBlendFunction:EGBlendFunction.premultiplied];
                {
                    [_scoreText draw];
                    [_pauseSprite draw];
                    [__clearSprite draw];
                    [__hammerSprite draw];
                    [((EGText*)(_levelText)) draw];
                    [_notificationText draw];
                    if(unumb([[_level.slowMotionCounter isRunning] value])) {
                        EGEnablingState* __il__0rp0rp0_6t_0__tmp__il__0self = EGGlobal.context.blend;
                        {
                            BOOL __il__0rp0rp0_6t_0__il__0changed = [__il__0rp0rp0_6t_0__tmp__il__0self enable];
                            {
                                [EGGlobal.context setBlendFunction:EGBlendFunction.standard];
                                [EGD2D drawCircleBackColor:GEVec4Make(0.6, 0.6, 0.6, 0.95) strokeColor:GEVec4Make(0.0, 0.0, 0.0, 0.5) at:uwrap(GEVec3, [_slowSprite.position value]) radius:22.0 relative:GEVec2Make(0.0, 0.0) segmentColor:geVec4ApplyF(0.95) start:M_PI_2 end:M_PI_2 - 2.0 * unumf([[_level.slowMotionCounter time] value]) * M_PI];
                            }
                            if(__il__0rp0rp0_6t_0__il__0changed) [__il__0rp0rp0_6t_0__tmp__il__0self disable];
                        }
                    } else {
                        [_slowMotionCountText draw];
                        [_slowSprite draw];
                    }
                    if(unumb([[_level.history.rewindCounter isRunning] value])) {
                        EGEnablingState* __il__0rp0rp0_7t_0__tmp__il__0self = EGGlobal.context.blend;
                        {
                            BOOL __il__0rp0rp0_7t_0__il__0changed = [__il__0rp0rp0_7t_0__tmp__il__0self enable];
                            {
                                [EGGlobal.context setBlendFunction:EGBlendFunction.standard];
                                [EGD2D drawCircleBackColor:GEVec4Make(0.6, 0.6, 0.6, 0.95) strokeColor:GEVec4Make(0.0, 0.0, 0.0, 0.5) at:uwrap(GEVec3, [_rewindSprite.position value]) radius:22.0 relative:GEVec2Make(0.0, 0.0) segmentColor:geVec4ApplyF(0.95) start:M_PI_2 end:M_PI_2 - 2.0 * unumf([[_level.history.rewindCounter time] value]) * M_PI];
                            }
                            if(__il__0rp0rp0_7t_0__il__0changed) ((void)([__il__0rp0rp0_7t_0__tmp__il__0self disable]));
                        }
                    } else {
                        [_rewindCountText draw];
                        [_rewindSprite draw];
                    }
                }
            }
            if(__il__0rp0__il__0changed) [__il__0rp0__tmp__il__0self disable];
        }
        if(__il__0changed) [__tmp__il__0self enable];
    }
}

- (NSString*)formatScore:(NSInteger)score {
    return [TRStr.Loc formatCost:score];
}

- (void)updateWithDelta:(CGFloat)delta {
    if(_levelText != nil) {
        [_levelAnimation updateWithDelta:delta];
        if(!(unumb([[_levelAnimation isRunning] value]))) _levelText = nil;
    } else {
        if(unumb([[_notificationAnimation isRunning] value])) {
            [_notificationAnimation updateWithDelta:(([_level.notifications isEmpty]) ? delta : 5 * delta)];
        } else {
            NSString* not = [_level.notifications take];
            if(not != nil) {
                [_currentNotificationText setValue:not];
                [_notificationAnimation restart];
            }
        }
    }
}

- (EGRecognizers*)recognizers {
    return [EGRecognizers applyRecognizer:[EGRecognizer applyTp:[EGTap apply] on:^BOOL(id<EGEvent> event) {
        GEVec2 p = [event locationInViewport];
        if([_pauseSprite containsViewportVec2:p]) {
            [[EGDirector current] pause];
        } else {
            if([_slowSprite containsViewportVec2:p] && !(unumb([[_level.slowMotionCounter isRunning] value]))) {
                [TRGameDirector.instance runSlowMotionLevel:_level];
            } else {
                if([_rewindSprite containsViewportVec2:p] && !(unumb([[_level.history.rewindCounter isRunning] value]))) {
                    [TRGameDirector.instance runRewindLevel:_level];
                } else {
                    if([__hammerSprite containsViewportVec2:p]) {
                        [_level.builder modeBuildFlip];
                    } else {
                        if([__clearSprite containsViewportVec2:p]) [_level.builder modeClearFlip];
                    }
                }
            }
        }
        return NO;
    }]];
}

- (NSString*)description {
    return [NSString stringWithFormat:@"LevelMenuView(%@)", _level];
}

- (BOOL)isProcessorActive {
    return !(unumb([[EGDirector current].isPaused value]));
}

- (CNClassType*)type {
    return [TRLevelMenuView type];
}

+ (CNClassType*)type {
    return _TRLevelMenuView_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

