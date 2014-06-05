#import "TRLevelView.h"

#import "TRLevel.h"
#import "TRCityView.h"
#import "TRRailroadView.h"
#import "TRTrainView.h"
#import "TRTreeView.h"
#import "CNObserver.h"
#import "PGDirector.h"
#import "TRGameDirector.h"
#import "TRStrings.h"
#import "CNChain.h"
#import "PGCameraIso.h"
#import "CNReact.h"
#import "PGContext.h"
#import "PGMat4.h"
#import "TRRailroadBuilderProcessor.h"
#import "TRSwitchProcessor.h"
#import "PGD2D.h"
#import "PGPlatformPlat.h"
#import "PGPlatform.h"
#import "TRRailroad.h"
#import "CNFuture.h"
#import "GL.h"
#import "PGMatrixModel.h"
#import "TRRainView.h"
#import "TRSnowView.h"
#import "PGProgress.h"
#import "PGSprite.h"
#import "PGSchedule.h"
#import "TRHistory.h"
#import "PGMaterial.h"
@implementation TRLevelView
static CNClassType* _TRLevelView_type;
@synthesize level = _level;
@synthesize name = _name;
@synthesize trainModels = _trainModels;
@synthesize environment = _environment;

+ (instancetype)levelViewWithLevel:(TRLevel*)level {
    return [[TRLevelView alloc] initWithLevel:level];
}

- (instancetype)initWithLevel:(TRLevel*)level {
    self = [super init];
    __weak TRLevelView* _weakSelf = self;
    if(self) {
        _level = level;
        _name = @"Level";
        _trainsView = ((NSArray*)((@[])));
        _onTrainAdd = [level->_trainWasAdded observeF:^void(TRTrain* train) {
            [[PGDirector current] onGLThreadF:^void() {
                TRLevelView* _self = _weakSelf;
                if(_self != nil) {
                    NSArray* newTrains = [_self->_trainsView addItem:[TRTrainView trainViewWithModels:_self->_trainModels train:train]];
                    _self->_trainsView = newTrains;
                }
            }];
            if(((TRTrain*)(train))->_trainType == TRTrainType_crazy) [[TRGameDirector instance] showHelpKey:@"help.crazy" text:[[TRStr Loc] helpCrazy] after:2.0];
        }];
        _onTrainRemove = [level->_trainWasRemoved observeF:^void(TRTrain* train) {
            [[PGDirector current] onGLThreadF:^void() {
                TRLevelView* _self = _weakSelf;
                if(_self != nil) {
                    NSArray* newTrains = [[[_self->_trainsView chain] filterWhen:^BOOL(TRTrainView* _) {
                        return !([((TRTrainView*)(_))->_train isEqual:train]);
                    }] toArray];
                    _self->_trainsView = newTrains;
                }
            }];
        }];
        _modeChangeObs = [level->_builder->_mode observeF:^void(TRRailroadBuilderMode* mode) {
            TRLevelView* _self = _weakSelf;
            if(_self != nil) _self->__move->_panEnabled = ((TRRailroadBuilderModeR)([mode ordinal] + 1)) == TRRailroadBuilderMode_simple;
        }];
        _environment = [PGEnvironment environmentWithAmbientColor:PGVec4Make(0.7, 0.7, 0.7, 1.0) lights:(@[[PGDirectLight directLightWithColor:pgVec4ApplyVec3W((pgVec3AddVec3((PGVec3Make(0.2, 0.2, 0.2)), (pgVec3MulK((PGVec3Make(0.4, 0.4, 0.4)), ((float)(level->_rules->_weatherRules->_sunny)))))), 1.0) direction:pgVec3Normalize((PGVec3Make(-0.15, 0.35, -0.3))) hasShadows:level->_rules->_weatherRules->_sunny > 0.0 && [[TRGameDirector instance] showShadows] shadowsProjectionMatrix:({
    PGMat4* m;
    if(pgVec2iIsEqualTo(level->_map->_size, (PGVec2iMake(7, 5)))) {
        m = [PGMat4 orthoLeft:-2.5 right:8.8 bottom:-2.9 top:4.6 zNear:-3.0 zFar:6.3];
    } else {
        if(pgVec2iIsEqualTo(level->_map->_size, (PGVec2iMake(5, 5)))) {
            m = [PGMat4 orthoLeft:-2.4 right:7.3 bottom:-2.4 top:3.9 zNear:-2.0 zFar:5.9];
        } else {
            if(pgVec2iIsEqualTo(level->_map->_size, (PGVec2iMake(5, 3)))) m = [PGMat4 orthoLeft:-2.0 right:5.9 bottom:-2.2 top:2.7 zNear:-2.0 zFar:4.5];
            else @throw @"Define shadow matrix for this map size";
        }
    }
    m;
})]])];
        _railroadBuilderProcessor = [TRRailroadBuilderProcessor railroadBuilderProcessorWithBuilder:level->_builder];
        _switchProcessor = [TRSwitchProcessor switchProcessorWithLevel:level];
        if([self class] == [TRLevelView class]) [self _init];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [TRLevelView class]) _TRLevelView_type = [CNClassType classTypeWithCls:[TRLevelView class]];
}

- (void)_init {
    [[PGGlobal context] clear];
    [PGGlobal context]->_environment = _environment;
    [PGD2D install];
    _treeView = [TRTreeView treeViewWithForest:_level->_forest];
    _cityView = [TRCityView cityViewWithLevel:_level];
    _callRepairerView = [TRCallRepairerView callRepairerViewWithLevel:_level];
    _trainModels = [TRTrainModels trainModels];
    if([[TRGameDirector instance] precipitations]) {
        TRPrecipitation* _ = _level->_rules->_weatherRules->_precipitation;
        if(_ != nil) _precipitationView = [TRPrecipitationView applyWeather:_level->_weather precipitation:_];
        else _precipitationView = nil;
    }
    PGCameraReserve cameraReserves;
    if(egPlatform()->_isPad) {
        if(pgVec2iRatio((uwrap(PGVec2i, [[PGGlobal context]->_viewSize value]))) < 4.0 / 3 + 0.01) cameraReserves = PGCameraReserveMake(0.0, 0.0, 0.5, 0.1);
        else cameraReserves = PGCameraReserveMake(0.0, 0.0, 0.2, 0.1);
    } else {
        if(egPlatform()->_isPhone) {
            if([egPlatform()->_os isIOSLessVersion:@"7"] < 0) cameraReserves = PGCameraReserveMake(0.0, 0.0, 0.3, 0.1);
            else cameraReserves = PGCameraReserveMake(0.0, 0.0, 0.2, 0.1);
        } else {
            cameraReserves = PGCameraReserveMake(0.0, 0.0, 0.3, 0.0);
        }
    }
    [_level->_cameraReserves setValue:wrap(PGCameraReserve, cameraReserves)];
    [_level->_viewRatio connectTo:[[PGGlobal context]->_viewSize mapF:^id(id _) {
        return numf4((pgVec2iRatio((uwrap(PGVec2i, _)))));
    }]];
    __move = [PGCameraIsoMove cameraIsoMoveWithBase:[PGCameraIso applyTilesOnScreen:pgVec2ApplyVec2i(_level->_map->_size) reserve:cameraReserves viewportRatio:1.6] minScale:1.0 maxScale:2.0 panFingers:1 tapFingers:2];
    _railroadView = [TRRailroadView railroadViewWithLevelView:self level:_level];
    [_level->_scale connectTo:__move->_scale];
    _moveScaleObserver = [__move->_scale observeF:^void(id s) {
        if(unumf(s) > 1.0) [[TRGameDirector instance] showHelpKey:@"help.zoom" text:[[TRStr Loc] helpInZoom]];
    }];
    _rewindButtonView = [TRRewindButtonView rewindButtonViewWithLevel:_level];
}

- (void)prepare {
    [_treeView prepare];
    [_railroadView prepare];
}

- (void)complete {
    [_treeView complete];
    for(TRTrainView* _ in _trainsView) {
        [((TRTrainView*)(_)) complete];
    }
    [((TRPrecipitationView*)(_precipitationView)) complete];
}

- (void)draw {
    CNTry* __il__0__tr = [[_level->_railroad state] waitResultPeriod:1.0];
    if(__il__0__tr != nil) {
        if([((CNTry*)(__il__0__tr)) isSuccess]) {
            TRRailroadState* rrState = [((CNTry*)(__il__0__tr)) get];
            {
                [_railroadView drawBackgroundRrState:rrState];
                CNTry* __il__0r_1__tr = [[_level cities] waitResultPeriod:1.0];
                if(__il__0r_1__tr != nil) {
                    if([((CNTry*)(__il__0r_1__tr)) isSuccess]) {
                        NSArray* cities = [((CNTry*)(__il__0r_1__tr)) get];
                        {
                            [_cityView drawCities:cities];
                            egPushGroupMarker(@"Trains");
                            for(TRTrainView* _ in _trainsView) {
                                [((TRTrainView*)(_)) draw];
                            }
                            egPopGroupMarker();
                            if(!([[PGGlobal context]->_renderTarget isShadow])) [_railroadView drawLightGlowsRrState:rrState];
                            if(!([[PGGlobal context]->_renderTarget isShadow])) [_railroadView drawSwitchesRrState:rrState];
                            [_treeView draw];
                            if(!([[PGGlobal context]->_renderTarget isShadow])) {
                                [_railroadView drawForegroundRrState:rrState];
                                egPushGroupMarker(@"Smoke");
                                for(TRTrainView* _ in _trainsView) {
                                    [((TRTrainView*)(_)) drawSmoke];
                                }
                                egPopGroupMarker();
                                [_rewindButtonView draw];
                                [_cityView drawExpectedCities:cities];
                                [_callRepairerView drawRrState:rrState cities:cities];
                                [((TRPrecipitationView*)(_precipitationView)) draw];
                            }
                        }
                    }
                }
            }
        }
    }
}

- (id<PGCamera>)camera {
    return [__move camera];
}

- (PGCameraIsoMove*)cameraMove {
    return __move;
}

- (void)updateWithDelta:(CGFloat)delta {
    [_railroadView updateWithDelta:delta];
    [((TRPrecipitationView*)(_precipitationView)) updateWithDelta:delta];
    for(TRTrainView* _ in _trainsView) {
        [((TRTrainView*)(_)) updateWithDelta:delta];
    }
}

- (PGRecognizers*)recognizers {
    return [[[[[[__move recognizers] addRecognizers:[_callRepairerView recognizers]] addRecognizers:[_rewindButtonView recognizers]] addRecognizers:[_railroadView recognizers]] addRecognizers:[_switchProcessor recognizers]] addRecognizers:[_railroadBuilderProcessor recognizers]];
}

- (void)reshapeWithViewport:(PGRect)viewport {
    float r = viewport.size.x / viewport.size.y;
    [__move setViewportRatio:((CGFloat)(r))];
    [[PGGlobal matrix] setValue:[[self camera] matrixModel]];
}

- (NSString*)description {
    return [NSString stringWithFormat:@"LevelView(%@)", _level];
}

- (BOOL)isProcessorActive {
    return !(unumb([[PGDirector current]->_isPaused value]));
}

- (CNClassType*)type {
    return [TRLevelView type];
}

+ (CNClassType*)type {
    return _TRLevelView_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation TRPrecipitationView
static CNClassType* _TRPrecipitationView_type;

+ (instancetype)precipitationView {
    return [[TRPrecipitationView alloc] init];
}

- (instancetype)init {
    self = [super init];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [TRPrecipitationView class]) _TRPrecipitationView_type = [CNClassType classTypeWithCls:[TRPrecipitationView class]];
}

+ (TRPrecipitationView*)applyWeather:(TRWeather*)weather precipitation:(TRPrecipitation*)precipitation {
    if(precipitation->_tp == TRPrecipitationType_rain) {
        return ((TRPrecipitationView*)([TRRainView rainViewWithWeather:weather strength:precipitation->_strength]));
    } else {
        if(precipitation->_tp == TRPrecipitationType_snow) return ((TRPrecipitationView*)([TRSnowView snowViewWithWeather:weather strength:precipitation->_strength]));
        else @throw @"Unknown precipitation type";
    }
}

- (void)draw {
    @throw @"Method draw is abstract";
}

- (void)complete {
    @throw @"Method complete is abstract";
}

- (void)updateWithDelta:(CGFloat)delta {
    @throw @"Method updateWith is abstract";
}

- (NSString*)description {
    return @"PrecipitationView";
}

- (CNClassType*)type {
    return [TRPrecipitationView type];
}

+ (CNClassType*)type {
    return _TRPrecipitationView_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation TRRewindButtonView
static CNClassType* _TRRewindButtonView_type;

+ (instancetype)rewindButtonViewWithLevel:(TRLevel*)level {
    return [[TRRewindButtonView alloc] initWithLevel:level];
}

- (instancetype)initWithLevel:(TRLevel*)level {
    self = [super init];
    __weak TRRewindButtonView* _weakSelf = self;
    if(self) {
        _empty = YES;
        _buttonPos = [CNVar applyInitial:wrap(PGVec3, (PGVec3Make(0.0, 0.0, 0.0)))];
        _animation = [PGProgress trapeziumT1:0.1 t2:0.5];
        _button = [PGSprite applyVisible:[CNReact applyA:[level->_rewindButton->_animation isRunning] b:level->_history->_canRewind f:^id(id a, id b) {
            return numb(unumb(a) && unumb(b));
        }] material:[[level->_rewindButton->_animation time] mapF:^PGColorSource*(id time) {
            TRRewindButtonView* _self = _weakSelf;
            if(_self != nil) return [PGColorSource applyColor:pgVec4ApplyF4(_self->_animation(((float)(unumf(time))))) texture:[[PGGlobal scaledTextureForName:@"Pause" format:PGTextureFormat_RGBA4] regionX:64.0 y:64.0 width:32.0 height:32.0]];
            else return nil;
        }] position:[level->_rewindButton->_position mapF:^id(id _) {
            return wrap(PGVec3, (pgVec3ApplyVec2((uwrap(PGVec2, _)))));
        }]];
        _buttonObs = [_button->_tap observeF:^void(id _) {
            [[TRGameDirector instance] runRewindLevel:level];
        }];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [TRRewindButtonView class]) _TRRewindButtonView_type = [CNClassType classTypeWithCls:[TRRewindButtonView class]];
}

- (void)draw {
    if(unumb([_button->_visible value])) {
        PGEnablingState* __tmp__il__0t_0self = [PGGlobal context]->_depthTest;
        {
            BOOL __il__0t_0changed = [__tmp__il__0t_0self disable];
            PGEnablingState* __il__0t_0rp0__tmp__il__0self = [PGGlobal context]->_blend;
            {
                BOOL __il__0t_0rp0__il__0changed = [__il__0t_0rp0__tmp__il__0self enable];
                {
                    [[PGGlobal context] setBlendFunction:[PGBlendFunction premultiplied]];
                    [_button draw];
                }
                if(__il__0t_0rp0__il__0changed) [__il__0t_0rp0__tmp__il__0self disable];
            }
            if(__il__0t_0changed) [__tmp__il__0t_0self enable];
        }
    }
}

- (PGRecognizers*)recognizers {
    return [PGRecognizers applyRecognizer:[_button recognizer]];
}

- (NSString*)description {
    return @"RewindButtonView";
}

- (CNClassType*)type {
    return [TRRewindButtonView type];
}

+ (CNClassType*)type {
    return _TRRewindButtonView_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

