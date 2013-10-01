#import "TRLevelView.h"

#import "TRLevel.h"
#import "TRCityView.h"
#import "TRRailroadView.h"
#import "TRTrainView.h"
#import "TRTreeView.h"
#import "TRCallRepairerView.h"
#import "EGContext.h"
#import "GEMat4.h"
#import "EGMapIso.h"
#import "EGCameraIso.h"
@implementation TRLevelView{
    TRLevel* _level;
    TRCityView* _cityView;
    TRRailroadView* _railroadView;
    TRTrainView* _trainView;
    TRTreeView* _treeView;
    TRCallRepairerView* _callRepairerView;
    EGEnvironment* _environment;
    id<EGCamera> _camera;
}
static ODClassType* _TRLevelView_type;
@synthesize level = _level;
@synthesize environment = _environment;
@synthesize camera = _camera;

+ (id)levelViewWithLevel:(TRLevel*)level {
    return [[TRLevelView alloc] initWithLevel:level];
}

- (id)initWithLevel:(TRLevel*)level {
    self = [super init];
    if(self) {
        _level = level;
        _cityView = [TRCityView cityView];
        _railroadView = [TRRailroadView railroadViewWithRailroad:_level.railroad];
        _trainView = [TRTrainView trainViewWithLevel:_level];
        _treeView = [TRTreeView treeViewWithForest:_level.forest];
        _callRepairerView = [TRCallRepairerView callRepairerViewWithLevel:_level];
        _environment = [EGEnvironment environmentWithAmbientColor:GEVec4Make(0.4, 0.4, 0.4, 1.0) lights:(@[[EGDirectLight applyColor:GEVec4Make(1.0, 1.0, 1.0, 1.0) direction:geVec3Normalize(GEVec3Make(-0.15, 0.25, -0.5)) shadowsProjectionMatrix:[GEMat4 orthoLeft:-3.0 right:8.0 bottom:-2.0 top:2.0 zNear:0.0 zFar:10.0]]])];
        _camera = [EGCameraIso cameraIsoWithTilesOnScreen:_level.map.size zReserve:0.3 center:GEVec2Make(0.0, 0.0)];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _TRLevelView_type = [ODClassType classTypeWithCls:[TRLevelView class]];
}

- (void)draw {
    BOOL shadows = EGGlobal.context.isShadowsDrawing;
    if(!(shadows)) [_railroadView drawBackground];
    if(!(shadows)) [[_level cities] forEach:^void(TRCity* city) {
        [_cityView drawCity:city];
    }];
    if(!(shadows)) [_trainView draw];
    if(!(shadows)) [_railroadView drawForeground];
    [_treeView draw];
    if(!(shadows)) {
        [_trainView drawSmoke];
        [_callRepairerView draw];
    }
}

- (id<EGCamera>)cameraWithViewport:(GERect)viewport {
    return _camera;
}

- (void)updateWithDelta:(CGFloat)delta {
    [[_level trains] forEach:^void(TRTrain* _) {
        [_trainView updateWithDelta:delta train:_];
    }];
    [[_level dyingTrains] forEach:^void(TRTrain* _) {
        [_trainView updateWithDelta:delta train:_];
    }];
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


