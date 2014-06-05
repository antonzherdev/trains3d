#import "TRLevelMenuView.h"

#import "TRLevel.h"
#import "PGContext.h"
#import "PGSchedule.h"
#import "PGProgress.h"
#import "PGSprite.h"
#import "PGPlatformPlat.h"
#import "PGPlatform.h"
#import "PGMaterial.h"
#import "CNReact.h"
#import "TRHistory.h"
#import "PGText.h"
#import "TRGameDirector.h"
#import "TRStrings.h"
#import "TRScore.h"
#import "PGCamera2D.h"
#import "math.h"
#import "PGD2D.h"
#import "PGDirector.h"
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
        _t = [PGGlobal scaledTextureForName:@"Pause" format:PGTextureFormat_RGBA4];
        _notificationAnimation = [PGCounter applyLength:2.0];
        _levelAnimation = [PGCounter applyLength:5.0];
        _notificationProgress = ({
            float(^__l)(float) = [PGProgress trapeziumT1:0.1];
            PGVec4(^__r)(float) = ^PGVec4(float _) {
                return pgVec4ApplyF(0.95 * _);
            };
            ^PGVec4(float _) {
                return __r(__l(_));
            };
        });
        _pauseSprite = [PGSprite applyMaterial:[CNReact applyValue:[PGColorSource applyTexture:((egPlatform()->_isPhone) ? [_t regionX:0.0 y:0.0 width:32.0 height:32.0] : [_t regionX:96.0 y:32.0 width:32.0 height:32.0])]] position:[[PGGlobal context]->_scaledViewSize mapF:^id(id _) {
            return wrap(PGVec3, (PGVec3Make((uwrap(PGVec2, _).x - ((egPlatform()->_isPhone) ? 16 : 20)), (((egPlatform()->_isComputer) ? uwrap(PGVec2, _).y - 18 : 20.0)), 0.0)));
        }]];
        _rewindSprite = [PGSprite applyVisible:level->_history->_canRewind material:[CNReact applyValue:[PGColorSource applyTexture:[_t regionX:32.0 y:64.0 width:32.0 height:32.0]]] position:[[PGGlobal context]->_scaledViewSize mapF:^id(id _) {
            return wrap(PGVec3, (PGVec3Make(((uwrap(PGVec2, _).x - ((egPlatform()->_isPhone) ? 20 : 24)) - ((egPlatform()->_isComputer) ? 70 : 0)), (uwrap(PGVec2, _).y - 18), 0.0)));
        }]];
        _rewindCountText = [PGText textWithVisible:[CNReact applyA:_rewindSprite->_visible b:[TRGameDirector instance]->_rewindsCount f:^id(id v, id count) {
            return numb(unumb(v) && unumi(count) > 0);
        }] font:[CNReact applyValue:[PGGlobal mainFontWithSize:24]] text:[[TRGameDirector instance]->_rewindsCount mapF:^NSString*(id _) {
            return [NSString stringWithFormat:@"%@", _];
        }] position:[_rewindSprite->_position mapF:^id(id _) {
            return wrap(PGVec3, (pgVec3AddVec3((uwrap(PGVec3, _)), (PGVec3Make(-12.0, 1.0, 0.0)))));
        }] alignment:[CNReact applyValue:wrap(PGTextAlignment, (pgTextAlignmentApplyXY(1.0, 0.0)))] color:[CNReact applyValue:wrap(PGVec4, [self color])] shadow:[CNReact applyValue:_shadow]];
        _slowSprite = [PGSprite applyVisible:[[[TRGameDirector instance] slowMotionsCount] mapF:^id(id _) {
            return numb(unumi(_) > 0);
        }] material:[CNReact applyValue:[PGColorSource applyTexture:[_t regionX:64.0 y:32.0 width:32.0 height:32.0]]] position:[[PGGlobal context]->_scaledViewSize mapF:^id(id _) {
            return wrap(PGVec3, (PGVec3Make((((uwrap(PGVec2, _).x - 50) - ((egPlatform()->_isPhone) ? 20 : 24)) - ((egPlatform()->_isComputer) ? 70 : 0)), (uwrap(PGVec2, _).y - 18), 0.0)));
        }]];
        _slowMotionCountText = [PGText textWithVisible:_slowSprite->_visible font:[CNReact applyValue:[PGGlobal mainFontWithSize:24]] text:[[[TRGameDirector instance] slowMotionsCount] mapF:^NSString*(id _) {
            return [NSString stringWithFormat:@"%@", _];
        }] position:[_slowSprite->_position mapF:^id(id _) {
            return wrap(PGVec3, (pgVec3AddVec3((uwrap(PGVec3, _)), (PGVec3Make(-16.0, 1.0, 0.0)))));
        }] alignment:[CNReact applyValue:wrap(PGTextAlignment, (pgTextAlignmentApplyXY(1.0, 0.0)))] color:[CNReact applyValue:wrap(PGVec4, [self color])] shadow:[CNReact applyValue:_shadow]];
        __hammerSprite = [PGSprite applyVisible:[level->_scale mapF:^id(id _) {
            return numb(unumf(_) > 1.0);
        }] material:[level->_builder->_mode mapF:^PGColorSource*(TRRailroadBuilderMode* m) {
            TRLevelMenuView* _self = _weakSelf;
            if(_self != nil) return [PGColorSource applyColor:((((TRRailroadBuilderModeR)([m ordinal] + 1)) == TRRailroadBuilderMode_build) ? PGVec4Make(0.45, 0.9, 0.6, 0.95) : pgVec4ApplyF(1.0)) texture:[_self->_t regionX:32.0 y:0.0 width:32.0 height:32.0]];
            else return nil;
        }] position:[[PGGlobal context]->_scaledViewSize mapF:^id(id _) {
            return wrap(PGVec3, (PGVec3Make(16.0, (uwrap(PGVec2, _).y - 16), 0.0)));
        }]];
        __clearSprite = [PGSprite applyMaterial:[level->_builder->_mode mapF:^PGColorSource*(TRRailroadBuilderMode* m) {
            TRLevelMenuView* _self = _weakSelf;
            if(_self != nil) return [PGColorSource applyColor:((((TRRailroadBuilderModeR)([m ordinal] + 1)) == TRRailroadBuilderMode_clear) ? PGVec4Make(0.45, 0.9, 0.6, 0.95) : pgVec4ApplyF(1.0)) texture:[_self->_t regionX:0.0 y:64.0 width:32.0 height:32.0]];
            else return nil;
        }] position:((egPlatform()->_isComputer) ? [[PGGlobal context]->_scaledViewSize mapF:^id(id _) {
            return wrap(PGVec3, (PGVec3Make((uwrap(PGVec2, _).x - 56), (uwrap(PGVec2, _).y - 19), 0.0)));
        }] : ((CNReact*)([CNVal valWithValue:wrap(PGVec3, (PGVec3Make(16.0, 16.0, 0.0)))])))];
        _shadow = [PGTextShadow textShadowWithColor:PGVec4Make(0.05, 0.05, 0.05, 0.5) shift:PGVec2Make(1.0, -1.0)];
        _scoreText = [PGText textWithVisible:[CNReact applyValue:@YES] font:[CNReact applyValue:[[PGGlobal mainFontWithSize:24] beReadyForText:[NSString stringWithFormat:@"-$0123456789'%@", [[TRStr Loc] levelNumber:1]]]] text:[level->_score->_money mapF:^NSString*(id _) {
            TRLevelMenuView* _self = _weakSelf;
            if(_self != nil) return [_self formatScore:unumi(_)];
            else return nil;
        }] position:[CNReact applyA:[PGGlobal context]->_scaledViewSize b:level->_scale f:^id(id viewSize, id scale) {
            if(unumf(scale) > 1.0) return wrap(PGVec3, (PGVec3Make(32.0, (uwrap(PGVec2, viewSize).y - 24), 0.0)));
            else return wrap(PGVec3, (PGVec3Make(10.0, (uwrap(PGVec2, viewSize).y - 24), 0.0)));
        }] alignment:[CNReact applyValue:wrap(PGTextAlignment, pgTextAlignmentBaselineX(-1.0))] color:[CNReact applyValue:wrap(PGVec4, [self color])] shadow:[CNReact applyValue:_shadow]];
        _notificationFont = [CNVal valWithValue:[[PGGlobal mainFontWithSize:((egPlatform()->_isPhone) ? (([egPlatform() screenSizeRatio] > 4.0 / 3.0) ? 14 : 12) : 18)] beReadyForText:[[TRStr Loc] notificationsCharSet]]];
        _remainingTrainsText = [PGText textWithVisible:[[level remainingTrainsCount] mapF:^id(id _) {
            return numb(unumi(_) > 0);
        }] font:_notificationFont text:[[level remainingTrainsCount] mapF:^NSString*(id _) {
            return [NSString stringWithFormat:@"%@", _];
        }] position:((egPlatform()->_isPhone) ? [CNReact applyA:_scoreText->_position b:[_scoreText sizeInPoints] f:^id(id pos, id size) {
            return wrap(PGVec3, (PGVec3Make((uwrap(PGVec2, size).x + uwrap(PGVec3, pos).x + 10), (uwrap(PGVec3, pos).y + 5), 0.0)));
        }] : [CNReact applyA:_scoreText->_position b:[_scoreText sizeInPoints] f:^id(id pos, id size) {
            return wrap(PGVec3, (PGVec3Make((uwrap(PGVec2, size).x + uwrap(PGVec3, pos).x + 20), (uwrap(PGVec3, pos).y + 2), 0.0)));
        }]) alignment:[CNReact applyValue:wrap(PGTextAlignment, pgTextAlignmentBaselineX(-1.0))] color:[CNReact applyValue:wrap(PGVec4, [self color])] shadow:[CNReact applyValue:_shadow]];
        _remainingTrainsDeltaX = ((egPlatform()->_isPhone) ? 12 : 15);
        _remainingTrainsDeltaY = ((egPlatform()->_isComputer) ? 5 : ((egPlatform()->_isPhone) ? 5 : 7));
        _remainingTrainsSprite = [PGSprite applyVisible:_remainingTrainsText->_visible material:[CNReact applyValue:[PGColorSource applyTexture:[_t regionX:96.0 y:((egPlatform()->_isPhone) ? 96.0 : 64.0) width:32.0 height:32.0]]] position:[CNReact applyA:_remainingTrainsText->_position b:[_remainingTrainsText sizeInPoints] f:^id(id p, id s) {
            TRLevelMenuView* _self = _weakSelf;
            if(_self != nil) return wrap(PGVec3, (pgVec3AddVec3((uwrap(PGVec3, p)), (PGVec3Make((uwrap(PGVec2, s).x + _self->_remainingTrainsDeltaX), ((float)(_self->_remainingTrainsDeltaY)), 0.0)))));
            else return nil;
        }]];
        _currentNotificationText = [CNVar applyInitial:@""];
        _notificationText = [PGText textWithVisible:[_notificationAnimation isRunning] font:_notificationFont text:_currentNotificationText position:((egPlatform()->_isPhone) ? [CNReact applyA:_remainingTrainsText->_position b:[_remainingTrainsText sizeInPoints] f:^id(id pos, id size) {
            return wrap(PGVec3, (PGVec3Make((uwrap(PGVec2, size).x + uwrap(PGVec3, pos).x + 28), (uwrap(PGVec3, pos).y), 0.0)));
        }] : [[PGGlobal context]->_scaledViewSize mapF:^id(id _) {
            return wrap(PGVec3, (PGVec3Make((uwrap(PGVec2, _).x / 2), (uwrap(PGVec2, _).y - 24), 0.0)));
        }]) alignment:[CNReact applyValue:wrap(PGTextAlignment, pgTextAlignmentBaselineX(((egPlatform()->_isPhone) ? -1.0 : 0.0)))] color:[[_notificationAnimation time] mapF:^id(id _) {
            TRLevelMenuView* _self = _weakSelf;
            if(_self != nil) return wrap(PGVec4, _self->_notificationProgress(((float)(unumf(_)))));
            else return nil;
        }] shadow:[CNReact applyValue:_shadow]];
        _levelText = [PGText textWithVisible:[CNReact applyValue:@YES] font:[CNReact applyValue:[PGGlobal mainFontWithSize:24]] text:[CNReact applyValue:[[TRStr Loc] startLevelNumber:level->_number]] position:[[PGGlobal context]->_scaledViewSize mapF:^id(id _) {
            return wrap(PGVec3, (PGVec3Make((uwrap(PGVec2, _).x / 2), (uwrap(PGVec2, _).y - 24), 0.0)));
        }] alignment:[CNReact applyValue:wrap(PGTextAlignment, pgTextAlignmentBaselineX(0.0))] color:[[_levelAnimation time] mapF:^id(id _) {
            TRLevelMenuView* _self = _weakSelf;
            if(_self != nil) return wrap(PGVec4, _self->_notificationProgress(((float)(unumf(_)))));
            else return nil;
        }] shadow:[CNReact applyValue:_shadow]];
        __camera = [[PGGlobal context]->_scaledViewSize mapF:^PGCamera2D*(id _) {
            return [PGCamera2D camera2DWithSize:uwrap(PGVec2, _)];
        }];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [TRLevelMenuView class]) _TRLevelMenuView_type = [CNClassType classTypeWithCls:[TRLevelMenuView class]];
}

- (id<PGCamera>)camera {
    return [__camera value];
}

- (PGVec4)color {
    return pgVec4ApplyF(0.95);
}

- (void)draw {
    PGEnablingState* __tmp__il__0self = [PGGlobal context]->_depthTest;
    {
        BOOL __il__0changed = [__tmp__il__0self disable];
        PGEnablingState* __il__0rp0__tmp__il__0self = [PGGlobal context]->_blend;
        {
            BOOL __il__0rp0__il__0changed = [__il__0rp0__tmp__il__0self enable];
            {
                [[PGGlobal context] setBlendFunction:[PGBlendFunction premultiplied]];
                {
                    [_scoreText draw];
                    [_remainingTrainsSprite draw];
                    [_remainingTrainsText draw];
                    [_pauseSprite draw];
                    [__clearSprite draw];
                    [__hammerSprite draw];
                    [((PGText*)(_levelText)) draw];
                    [_notificationText draw];
                    if(unumb([[_level->_slowMotionCounter isRunning] value])) {
                        PGEnablingState* __il__0rp0rp0_8t_0__tmp__il__0self = [PGGlobal context]->_blend;
                        {
                            BOOL __il__0rp0rp0_8t_0__il__0changed = [__il__0rp0rp0_8t_0__tmp__il__0self enable];
                            {
                                [[PGGlobal context] setBlendFunction:[PGBlendFunction standard]];
                                [PGD2D drawCircleBackColor:PGVec4Make(0.6, 0.6, 0.6, 0.95) strokeColor:PGVec4Make(0.0, 0.0, 0.0, 0.5) at:uwrap(PGVec3, [_slowSprite->_position value]) radius:22.0 relative:PGVec2Make(0.0, 0.0) segmentColor:pgVec4ApplyF(0.95) start:M_PI_2 end:M_PI_2 - 2.0 * unumf([[_level->_slowMotionCounter time] value]) * M_PI];
                            }
                            if(__il__0rp0rp0_8t_0__il__0changed) [__il__0rp0rp0_8t_0__tmp__il__0self disable];
                        }
                    } else {
                        [_slowMotionCountText draw];
                        [_slowSprite draw];
                    }
                    if(unumb([[_level->_history->_rewindCounter isRunning] value])) {
                        PGEnablingState* __il__0rp0rp0_9t_0__tmp__il__0self = [PGGlobal context]->_blend;
                        {
                            BOOL __il__0rp0rp0_9t_0__il__0changed = [__il__0rp0rp0_9t_0__tmp__il__0self enable];
                            {
                                [[PGGlobal context] setBlendFunction:[PGBlendFunction standard]];
                                [PGD2D drawCircleBackColor:PGVec4Make(0.6, 0.6, 0.6, 0.95) strokeColor:PGVec4Make(0.0, 0.0, 0.0, 0.5) at:uwrap(PGVec3, [_rewindSprite->_position value]) radius:22.0 relative:PGVec2Make(0.0, 0.0) segmentColor:pgVec4ApplyF(0.95) start:M_PI_2 end:M_PI_2 - 2.0 * unumf([[_level->_history->_rewindCounter time] value]) * M_PI];
                            }
                            if(__il__0rp0rp0_9t_0__il__0changed) ((void)([__il__0rp0rp0_9t_0__tmp__il__0self disable]));
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
    return [[TRStr Loc] formatCost:score];
}

- (void)updateWithDelta:(CGFloat)delta {
    if(_levelText != nil) {
        [_levelAnimation updateWithDelta:delta];
        if(!(unumb([[_levelAnimation isRunning] value]))) _levelText = nil;
    } else {
        if(unumb([[_notificationAnimation isRunning] value])) {
            [_notificationAnimation updateWithDelta:(([_level->_notifications isEmpty]) ? delta : 5 * delta)];
        } else {
            NSString* not = [_level->_notifications take];
            if(not != nil) {
                [_currentNotificationText setValue:not];
                [_notificationAnimation restart];
            }
        }
    }
}

- (PGRecognizers*)recognizers {
    return [PGRecognizers applyRecognizer:[PGRecognizer applyTp:[PGTap apply] on:^BOOL(id<PGEvent> event) {
        PGVec2 p = [event locationInViewport];
        if([_pauseSprite containsViewportVec2:p]) {
            [[PGDirector current] pause];
        } else {
            if([_slowSprite containsViewportVec2:p] && !(unumb([[_level->_slowMotionCounter isRunning] value]))) {
                [[TRGameDirector instance] runSlowMotionLevel:_level];
            } else {
                if([_rewindSprite containsViewportVec2:p] && !(unumb([[_level->_history->_rewindCounter isRunning] value]))) {
                    [[TRGameDirector instance] runRewindLevel:_level];
                } else {
                    if([__hammerSprite containsViewportVec2:p]) {
                        [_level->_builder modeBuildFlip];
                    } else {
                        if([__clearSprite containsViewportVec2:p]) [_level->_builder modeClearFlip];
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
    return !(unumb([[PGDirector current]->_isPaused value]));
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

