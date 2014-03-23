#import "TRLevelView.h"

#import "TRLevel.h"
#import "TRCityView.h"
#import "TRRailroadView.h"
#import "TRTrainView.h"
#import "TRTreeView.h"
#import "EGDirector.h"
#import "TRTrain.h"
#import "TRRailroadBuilder.h"
#import "EGCameraIso.h"
#import "EGContext.h"
#import "TRWeather.h"
#import "TRGameDirector.h"
#import "GEMat4.h"
#import "ATObserver.h"
#import "TRRailroadBuilderProcessor.h"
#import "TRSwitchProcessor.h"
#import "EGSprite.h"
#import "EGPlatformPlat.h"
#import "EGPlatform.h"
#import "ATReact.h"
#import "TRStrings.h"
#import "TRRailroad.h"
#import "GL.h"
#import "EGMatrixModel.h"
#import "TRRainView.h"
#import "TRSnowView.h"
@implementation TRLevelView
static ODClassType* _TRLevelView_type;
@synthesize level = _level;
@synthesize name = _name;
@synthesize trainModels = _trainModels;
@synthesize trainsView = _trainsView;
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
        _trainsView = [NSMutableArray mutableArray];
        _onTrainAdd = [TRLevel.runTrainNotification observeSender:_level by:^void(TRTrain* train) {
            [[EGDirector current] onGLThreadF:^void() {
                TRLevelView* _self = _weakSelf;
                [_self->_trainsView appendItem:[TRTrainView trainViewWithModels:_self->_trainModels train:train]];
            }];
        }];
        _onTrainRemove = [TRLevel.removeTrainNotification observeSender:_level by:^void(TRTrain* train) {
            [[EGDirector current] onGLThreadF:^void() {
                TRLevelView* _self = _weakSelf;
                [_self->_trainsView mutableFilterBy:^BOOL(TRTrainView* _) {
                    return !([((TRTrainView*)(_)).train isEqual:train]);
                }];
            }];
        }];
        _modeChangeObs = [TRRailroadBuilder.modeNotification observeSender:_level.builder by:^void(TRRailroadBuilderMode* mode) {
            TRLevelView* _self = _weakSelf;
            _self->__move.panEnabled = mode == TRRailroadBuilderMode.simple;
        }];
        _environment = [EGEnvironment environmentWithAmbientColor:GEVec4Make(0.7, 0.7, 0.7, 1.0) lights:(@[[EGDirectLight directLightWithColor:geVec4ApplyVec3W((geVec3AddVec3((GEVec3Make(0.2, 0.2, 0.2)), (geVec3MulK((GEVec3Make(0.4, 0.4, 0.4)), ((float)(_level.rules.weatherRules.sunny)))))), 1.0) direction:geVec3Normalize((GEVec3Make(-0.15, 0.35, -0.3))) hasShadows:_level.rules.weatherRules.sunny > 0.0 && [TRGameDirector.instance showShadows] shadowsProjectionMatrix:^GEMat4*() {
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
    return m;
}()]])];
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
    _precipitationView = [_level.rules.weatherRules.precipitation mapF:^TRPrecipitationView*(TRPrecipitation* _) {
        return [TRPrecipitationView applyWeather:_level.weather precipitation:_];
    }];
    EGCameraReserve cameraReserves = ((egPlatform().isPad) ? ((geVec2iRatio((uwrap(GEVec2i, [EGGlobal.context.viewSize value]))) < 4.0 / 3 + 0.01) ? EGCameraReserveMake(0.0, 0.0, 0.5, 0.1) : EGCameraReserveMake(0.0, 0.0, 0.2, 0.1)) : ((egPlatform().isPhone) ? (([egPlatform() isIOSLessVersion:@"7"] < 0) ? EGCameraReserveMake(0.0, 0.0, 0.3, 0.1) : EGCameraReserveMake(0.0, 0.0, 0.2, 0.1)) : EGCameraReserveMake(0.0, 0.0, 0.1, 0.0)));
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
}

- (void)prepare {
    [_treeView prepare];
    [_railroadView prepare];
}

- (void)complete {
    [_treeView complete];
    [_trainsView forEach:^void(TRTrainView* _) {
        [((TRTrainView*)(_)) complete];
    }];
    [_precipitationView forEach:^void(TRPrecipitationView* _) {
        [((TRPrecipitationView*)(_)) complete];
    }];
}

- (void)draw {
    [[_level.railroad state] waitAndOnSuccessAwait:1.0 f:^void(TRRailroadState* rrState) {
        [_railroadView drawBackgroundRrState:rrState];
        [_cityView draw];
        egPushGroupMarker(@"Trains");
        [_trainsView forEach:^void(TRTrainView* _) {
            [((TRTrainView*)(_)) draw];
        }];
        egPopGroupMarker();
        if(!([EGGlobal.context.renderTarget isShadow])) [_railroadView drawLightGlowsRrState:rrState];
        [_treeView draw];
        if(!([EGGlobal.context.renderTarget isShadow])) {
            [_railroadView drawForegroundRrState:rrState];
            egPushGroupMarker(@"Smoke");
            [_trainsView forEach:^void(TRTrainView* _) {
                [((TRTrainView*)(_)) drawSmoke];
            }];
            egPopGroupMarker();
            [_cityView drawExpected];
            [_callRepairerView drawRrState:rrState];
            [_precipitationView forEach:^void(TRPrecipitationView* _) {
                [((TRPrecipitationView*)(_)) draw];
            }];
        }
    }];
}

- (id<EGCamera>)camera {
    return [__move camera];
}

- (EGCameraIsoMove*)cameraMove {
    return __move;
}

- (void)updateWithDelta:(CGFloat)delta {
    [_railroadView updateWithDelta:delta];
    [_precipitationView forEach:^void(TRPrecipitationView* _) {
        [((TRPrecipitationView*)(_)) updateWithDelta:delta];
    }];
    [_trainsView forEach:^void(TRTrainView* _) {
        [((TRTrainView*)(_)) updateWithDelta:delta];
    }];
}

- (EGRecognizers*)recognizers {
    return [[[[[__move recognizers] addRecognizers:[_callRepairerView recognizers]] addRecognizers:[_railroadView recognizers]] addRecognizers:[_switchProcessor recognizers]] addRecognizers:[_railroadBuilderProcessor recognizers]];
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

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    TRLevelView* o = ((TRLevelView*)(other));
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
        return [TRRainView rainViewWithWeather:weather strength:precipitation.strength];
    } else {
        if(precipitation.tp == TRPrecipitationType.snow) return [TRSnowView snowViewWithWeather:weather strength:precipitation.strength];
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


