#import "TRLevelView.h"

#import "TRLevel.h"
#import "TRCityView.h"
#import "TRRailroadView.h"
#import "TRTrainView.h"
#import "TRTreeView.h"
#import "EGContext.h"
#import "EGMapIso.h"
#import "GEMat4.h"
#import "EGCameraIso.h"
#import "TRRailroadBuilderProcessor.h"
#import "TRRailroad.h"
#import "TRSwitchProcessor.h"
#import "TRWeather.h"
#import "TRPrecipitationView.h"
#import "EGDirector.h"
@implementation TRLevelView{
    TRLevel* _level;
    NSString* _name;
    TRCityView* _cityView;
    TRRailroadView* _railroadView;
    TRTrainView* _trainView;
    TRTreeView* _treeView;
    TRCallRepairerView* _callRepairerView;
    id _precipitationView;
    EGEnvironment* _environment;
    id<EGCamera> _camera;
    TRRailroadBuilderProcessor* _railroadBuilderProcessor;
    TRSwitchProcessor* _switchProcessor;
}
static ODClassType* _TRLevelView_type;
@synthesize level = _level;
@synthesize name = _name;
@synthesize environment = _environment;
@synthesize camera = _camera;

+ (id)levelViewWithLevel:(TRLevel*)level {
    return [[TRLevelView alloc] initWithLevel:level];
}

- (id)initWithLevel:(TRLevel*)level {
    self = [super init];
    if(self) {
        _level = level;
        _name = @"Level";
        _environment = [EGEnvironment environmentWithAmbientColor:GEVec4Make(0.7, 0.7, 0.7, 1.0) lights:(@[[EGDirectLight applyColor:GEVec4Make(0.6, 0.6, 0.6, 1.0) direction:geVec3Normalize(GEVec3Make(-0.15, 0.35, -0.3)) shadowsProjectionMatrix:^GEMat4*() {
    GEMat4* m;
    if(GEVec2iEq(_level.map.size, GEVec2iMake(5, 5))) {
        m = [GEMat4 orthoLeft:-2.4 right:7.3 bottom:-2.2 top:3.9 zNear:-2.0 zFar:5.5];
    } else {
        if(GEVec2iEq(_level.map.size, GEVec2iMake(5, 3))) m = [GEMat4 orthoLeft:-2.0 right:5.7 bottom:-2.0 top:2.7 zNear:-2.0 zFar:4.0];
        else @throw @"Define shadow matrix for this map size";
    }
    return m;
}()]])];
        _camera = [EGCameraIso cameraIsoWithTilesOnScreen:_level.map.size zReserve:0.5 center:GEVec2Make(0.0, 0.0)];
        _railroadBuilderProcessor = [TRRailroadBuilderProcessor railroadBuilderProcessorWithBuilder:_level.railroad.builder];
        _switchProcessor = [TRSwitchProcessor switchProcessorWithLevel:_level];
        [self _init];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _TRLevelView_type = [ODClassType classTypeWithCls:[TRLevelView class]];
}

- (void)_init {
    [EGGlobal.context clear];
    EGGlobal.context.environment = _environment;
    _trainView = [TRTrainView trainViewWithLevel:_level];
    _treeView = [TRTreeView treeViewWithForest:_level.forest];
    _railroadView = [TRRailroadView railroadViewWithLevel:_level];
    _cityView = [TRCityView cityViewWithLevel:_level];
    _callRepairerView = [TRCallRepairerView callRepairerViewWithLevel:_level];
    _precipitationView = [_level.rules.weatherRules.precipitation mapF:^TRPrecipitationView*(TRPrecipitation* _) {
        return [TRPrecipitationView applyPrecipitation:_];
    }];
}

- (void)prepare {
    [_treeView prepare];
    [_railroadView prepare];
}

- (void)draw {
    [_railroadView drawBackground];
    [_cityView draw];
    [_trainView draw];
    if(!([EGGlobal.context.renderTarget isShadow])) [_railroadView drawForeground];
    [_treeView draw];
    if(!([EGGlobal.context.renderTarget isShadow])) {
        [_trainView drawSmoke];
        [_precipitationView forEach:^void(TRPrecipitationView* _) {
            [((TRPrecipitationView*)(_)) draw];
        }];
        [_cityView drawExpected];
        [_callRepairerView draw];
    }
}

- (void)updateWithDelta:(CGFloat)delta {
    [[_level trains] forEach:^void(TRTrain* _) {
        [_trainView updateWithDelta:delta train:_];
    }];
    [[_level dyingTrains] forEach:^void(TRTrain* _) {
        [_trainView updateWithDelta:delta train:_];
    }];
}

- (BOOL)processEvent:(EGEvent*)event {
    return [_callRepairerView processEvent:event] || [_railroadView processEvent:event] || [_switchProcessor processEvent:event] || [_railroadBuilderProcessor processEvent:event];
}

- (void)reshapeWithViewport:(GERect)viewport {
    EGGlobal.matrix.value = [_camera matrixModel];
    [_callRepairerView reshapeWithViewport:viewport];
    [_railroadView reshape];
}

- (BOOL)isProcessorActive {
    return !([[EGDirector current] isPaused]);
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


