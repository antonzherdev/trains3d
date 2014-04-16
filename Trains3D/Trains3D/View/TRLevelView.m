#import "TRLevelView.h"

#import "TRLevel.h"
#import "TRCityView.h"
#import "TRRailroadView.h"
#import "TRTrainView.h"
#import "TRTreeView.h"
#import "ATObserver.h"
#import "EGDirector.h"
#import "TRTrain.h"
#import "TRGameDirector.h"
#import "TRStrings.h"
#import "TRRailroadBuilder.h"
#import "EGCameraIso.h"
#import "EGContext.h"
#import "TRWeather.h"
#import "GEMat4.h"
#import "TRRailroadBuilderProcessor.h"
#import "TRSwitchProcessor.h"
#import "EGD2D.h"
#import "EGPlatformPlat.h"
#import "EGPlatform.h"
#import "ATReact.h"
#import "TRRailroad.h"
#import "GL.h"
#import "EGMatrixModel.h"
#import "TRRainView.h"
#import "TRSnowView.h"
#import "EGProgress.h"
#import "EGSprite.h"
#import "EGSchedule.h"
#import "TRHistory.h"
#import "EGTexture.h"
#import "EGMaterial.h"
@implementation TRLevelView
static ODClassType* _TRLevelView_type;
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
        _trainsView = (@[]);
        _onTrainAdd = [_level.trainWasAdded observeF:^void(TRTrain* train) {
            [[EGDirector current] onGLThreadF:^void() {
                TRLevelView* _self = _weakSelf;
                if(_self != nil) {
                    NSArray* newTrains = [_self->_trainsView addItem:[TRTrainView trainViewWithModels:_self->_trainModels train:train]];
                    memoryBarrier();
                    _self->_trainsView = newTrains;
                }
            }];
            if(((TRTrain*)(train)).trainType == TRTrainType.crazy) [TRGameDirector.instance showHelpKey:@"help.crazy" text:[TRStr.Loc helpCrazy] after:2.0];
        }];
        _onTrainRemove = [_level.trainWasRemoved observeF:^void(TRTrain* train) {
            [[EGDirector current] onGLThreadF:^void() {
                TRLevelView* _self = _weakSelf;
                if(_self != nil) {
                    NSArray* newTrains = [[[_self->_trainsView chain] filter:^BOOL(TRTrainView* _) {
                        return !([((TRTrainView*)(_)).train isEqual:train]);
                    }] toArray];
                    memoryBarrier();
                    _self->_trainsView = newTrains;
                }
            }];
        }];
        _modeChangeObs = [TRRailroadBuilder.modeNotification observeSender:_level.builder by:^void(TRRailroadBuilderMode* mode) {
            TRLevelView* _self = _weakSelf;
            if(_self != nil) _self->__move.panEnabled = mode == TRRailroadBuilderMode.simple;
        }];
        _environment = [EGEnvironment environmentWithAmbientColor:GEVec4Make(0.7, 0.7, 0.7, 1.0) lights:(@[[EGDirectLight directLightWithColor:geVec4ApplyVec3W((geVec3AddVec3((GEVec3Make(0.2, 0.2, 0.2)), (geVec3MulK((GEVec3Make(0.4, 0.4, 0.4)), ((float)(_level.rules.weatherRules.sunny)))))), 1.0) direction:geVec3Normalize((GEVec3Make(-0.15, 0.35, -0.3))) hasShadows:_level.rules.weatherRules.sunny > 0.0 && [TRGameDirector.instance showShadows] shadowsProjectionMatrix:({
    GEMat4* m;
    if(GEVec2iEq(_level.map.size, (GEVec2iMake(7, 5)))) {
        m = [GEMat4 orthoLeft:-2.5 right:8.8 bottom:-2.9 top:4.6 zNear:-3.0 zFar:6.3];
    } else {
        if(GEVec2iEq(_level.map.size, (GEVec2iMake(5, 5)))) {
            m = [GEMat4 orthoLeft:-2.4 right:7.3 bottom:-2.4 top:3.9 zNear:-2.0 zFar:5.9];
        } else {
            if(GEVec2iEq(_level.map.size, (GEVec2iMake(5, 3)))) m = [GEMat4 orthoLeft:-2.0 right:5.9 bottom:-2.2 top:2.7 zNear:-2.0 zFar:4.5];
            else @throw @"Define shadow matrix for this map size";
        }
    }
    m;
})]])];
        _railroadBuilderProcessor = [TRRailroadBuilderProcessor railroadBuilderProcessorWithBuilder:_level.builder];
        _switchProcessor = [TRSwitchProcessor switchProcessorWithLevel:_level];
        if([self class] == [TRLevelView class]) [self _init];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [TRLevelView class]) _TRLevelView_type = [ODClassType classTypeWithCls:[TRLevelView class]];
}

- (void)_init {
    [EGGlobal.context clear];
    EGGlobal.context.environment = _environment;
    [EGD2D install];
    _treeView = [TRTreeView treeViewWithForest:_level.forest];
    _cityView = [TRCityView cityViewWithLevel:_level];
    _callRepairerView = [TRCallRepairerView callRepairerViewWithLevel:_level];
    _trainModels = [TRTrainModels trainModels];
    {
        TRPrecipitation* _ = _level.rules.weatherRules.precipitation;
        if(_ != nil) _precipitationView = [TRPrecipitationView applyWeather:_level.weather precipitation:_];
        else _precipitationView = nil;
    }
    EGCameraReserve cameraReserves;
    if(egPlatform().isPad) {
        if(geVec2iRatio((uwrap(GEVec2i, [EGGlobal.context.viewSize value]))) < 4.0 / 3 + 0.01) cameraReserves = EGCameraReserveMake(0.0, 0.0, 0.5, 0.1);
        else cameraReserves = EGCameraReserveMake(0.0, 0.0, 0.2, 0.1);
    } else {
        if(egPlatform().isPhone) {
            if([egPlatform() isIOSLessVersion:@"7"] < 0) cameraReserves = EGCameraReserveMake(0.0, 0.0, 0.3, 0.1);
            else cameraReserves = EGCameraReserveMake(0.0, 0.0, 0.2, 0.1);
        } else {
            cameraReserves = EGCameraReserveMake(0.0, 0.0, 0.3, 0.0);
        }
    }
    [_level.cameraReserves setValue:wrap(EGCameraReserve, cameraReserves)];
    [_level.viewRatio connectTo:[EGGlobal.context.viewSize mapF:^id(id _) {
        return numf4((geVec2iRatio((uwrap(GEVec2i, _)))));
    }]];
    __move = [EGCameraIsoMove cameraIsoMoveWithBase:[EGCameraIso applyTilesOnScreen:geVec2ApplyVec2i(_level.map.size) reserve:cameraReserves viewportRatio:1.6] minScale:1.0 maxScale:2.0 panFingers:1 tapFingers:2];
    _railroadView = [TRRailroadView railroadViewWithLevelView:self level:_level];
    [_level.scale connectTo:__move.scale];
    _moveScaleObserver = [__move.scale observeF:^void(id s) {
        if(unumf(s) > 1.0) [TRGameDirector.instance showHelpKey:@"help.zoom" text:[TRStr.Loc helpInZoom]];
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
    CNTry* __inline__0___tr = [[_level.railroad state] waitResultPeriod:1.0];
    if(__inline__0___tr != nil) {
        if([__inline__0___tr isSuccess]) {
            TRRailroadState* rrState = [__inline__0___tr get];
            {
                [_railroadView drawBackgroundRrState:rrState];
                [_cityView draw];
                egPushGroupMarker(@"Trains");
                for(TRTrainView* _ in _trainsView) {
                    [((TRTrainView*)(_)) draw];
                }
                egPopGroupMarker();
                if(!([EGGlobal.context.renderTarget isShadow])) [_railroadView drawLightGlowsRrState:rrState];
                if(!([EGGlobal.context.renderTarget isShadow])) [_railroadView drawSwitchesRrState:rrState];
                [_treeView draw];
                if(!([EGGlobal.context.renderTarget isShadow])) {
                    [_railroadView drawForegroundRrState:rrState];
                    egPushGroupMarker(@"Smoke");
                    for(TRTrainView* _ in _trainsView) {
                        [((TRTrainView*)(_)) drawSmoke];
                    }
                    egPopGroupMarker();
                    [_rewindButtonView draw];
                    [_cityView drawExpected];
                    [_callRepairerView drawRrState:rrState];
                    [((TRPrecipitationView*)(_precipitationView)) draw];
                }
            }
        }
    }
}

- (id<EGCamera>)camera {
    return [__move camera];
}

- (EGCameraIsoMove*)cameraMove {
    return __move;
}

- (void)updateWithDelta:(CGFloat)delta {
    [_railroadView updateWithDelta:delta];
    [((TRPrecipitationView*)(_precipitationView)) updateWithDelta:delta];
    for(TRTrainView* _ in _trainsView) {
        [((TRTrainView*)(_)) updateWithDelta:delta];
    }
}

- (EGRecognizers*)recognizers {
    return [[[[[[__move recognizers] addRecognizers:[_callRepairerView recognizers]] addRecognizers:[_rewindButtonView recognizers]] addRecognizers:[_railroadView recognizers]] addRecognizers:[_switchProcessor recognizers]] addRecognizers:[_railroadBuilderProcessor recognizers]];
}

- (void)reshapeWithViewport:(GERect)viewport {
    float r = viewport.size.x / viewport.size.y;
    [__move setViewportRatio:((CGFloat)(r))];
    [EGGlobal.matrix setValue:[[self camera] matrixModel]];
}

- (GERect)viewportWithViewSize:(GEVec2)viewSize {
    return [EGLayer viewportWithViewSize:viewSize viewportLayout:geRectApplyXYWidthHeight(0.0, 0.0, 1.0, 1.0) viewportRatio:((float)([[self camera] viewportRatio]))];
}

- (BOOL)isProcessorActive {
    return !(unumb([[EGDirector current].isPaused value]));
}

- (ODClassType*)type {
    return [TRLevelView type];
}

+ (ODClassType*)type {
    return _TRLevelView_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"level=%@", self.level];
    [description appendString:@">"];
    return description;
}

@end


@implementation TRPrecipitationView
static ODClassType* _TRPrecipitationView_type;

+ (instancetype)precipitationView {
    return [[TRPrecipitationView alloc] init];
}

- (instancetype)init {
    self = [super init];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [TRPrecipitationView class]) _TRPrecipitationView_type = [ODClassType classTypeWithCls:[TRPrecipitationView class]];
}

+ (TRPrecipitationView*)applyWeather:(TRWeather*)weather precipitation:(TRPrecipitation*)precipitation {
    if(precipitation.tp == TRPrecipitationType.rain) {
        return ((TRPrecipitationView*)([TRRainView rainViewWithWeather:weather strength:precipitation.strength]));
    } else {
        if(precipitation.tp == TRPrecipitationType.snow) return ((TRPrecipitationView*)([TRSnowView snowViewWithWeather:weather strength:precipitation.strength]));
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

- (ODClassType*)type {
    return [TRPrecipitationView type];
}

+ (ODClassType*)type {
    return _TRPrecipitationView_type;
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


@implementation TRRewindButtonView
static ODClassType* _TRRewindButtonView_type;
@synthesize level = _level;

+ (instancetype)rewindButtonViewWithLevel:(TRLevel*)level {
    return [[TRRewindButtonView alloc] initWithLevel:level];
}

- (instancetype)initWithLevel:(TRLevel*)level {
    self = [super init];
    __weak TRRewindButtonView* _weakSelf = self;
    if(self) {
        _level = level;
        _empty = YES;
        _buttonPos = [ATVar applyInitial:wrap(GEVec3, (GEVec3Make(0.0, 0.0, 0.0)))];
        _animation = [EGProgress trapeziumT1:0.1 t2:0.5];
        _button = [EGSprite applyVisible:[ATReact applyA:[_level.rewindButton.animation isRunning] b:_level.history.canRewind f:^id(id a, id b) {
            return numb(unumb(a) && unumb(b));
        }] material:[[_level.rewindButton.animation time] mapF:^EGColorSource*(id time) {
            TRRewindButtonView* _self = _weakSelf;
            if(_self != nil) return [EGColorSource applyColor:geVec4ApplyF(((CGFloat)(_self->_animation(((float)(unumf(time))))))) texture:[[EGGlobal scaledTextureForName:@"Pause" format:EGTextureFormat.RGBA4] regionX:64.0 y:64.0 width:32.0 height:32.0]];
            else return nil;
        }] position:[_level.rewindButton.position mapF:^id(id _) {
            return wrap(GEVec3, (geVec3ApplyVec2((uwrap(GEVec2, _)))));
        }]];
        _buttonObs = [_button.tap observeF:^void(id _) {
            TRRewindButtonView* _self = _weakSelf;
            if(_self != nil) [TRGameDirector.instance runRewindLevel:_self->_level];
        }];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [TRRewindButtonView class]) _TRRewindButtonView_type = [ODClassType classTypeWithCls:[TRRewindButtonView class]];
}

- (void)draw {
    if(unumb([_button.visible value])) {
        EGEnablingState* __tmp_0_0self = EGGlobal.context.depthTest;
        {
            BOOL __inline__0_0_changed = [__tmp_0_0self disable];
            EGEnablingState* __inline__0_0___tmp_0self = EGGlobal.context.blend;
            {
                BOOL __inline__0_0___inline__0_changed = [__inline__0_0___tmp_0self enable];
                {
                    [EGGlobal.context setBlendFunction:EGBlendFunction.premultiplied];
                    [_button draw];
                }
                if(__inline__0_0___inline__0_changed) [__inline__0_0___tmp_0self disable];
            }
            if(__inline__0_0_changed) [__tmp_0_0self enable];
        }
    }
}

- (EGRecognizers*)recognizers {
    return [EGRecognizers applyRecognizer:[_button recognizer]];
}

- (BOOL)isProcessorActive {
    return !(unumb([[EGDirector current].isPaused value]));
}

- (ODClassType*)type {
    return [TRRewindButtonView type];
}

+ (ODClassType*)type {
    return _TRRewindButtonView_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"level=%@", self.level];
    [description appendString:@">"];
    return description;
}

@end


