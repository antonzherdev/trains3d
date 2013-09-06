#import "TRLevelView.h"

#import "EGCameraIso.h"
#import "EG.h"
#import "EGMapIso.h"
#import "TRLevel.h"
#import "TRLevelBackgroundView.h"
#import "TRCityView.h"
#import "TRRailroadView.h"
#import "TRTrainView.h"
#import "EGMatrix.h"
@implementation TRLevelView{
    TRLevel* _level;
    TRLevelBackgroundView* _backgroundView;
    TRCityView* _cityView;
    TRRailroadView* _railroadView;
    TRTrainView* _trainView;
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
        _backgroundView = [TRLevelBackgroundView levelBackgroundViewWithMap:_level.map];
        _cityView = [TRCityView cityView];
        _railroadView = [TRRailroadView railroadView];
        _trainView = [TRTrainView trainView];
        _environment = [EGEnvironment environmentWithAmbientColor:EGColorMake(((float)(0.4)), ((float)(0.4)), ((float)(0.4)), 1.0) lights:(@[[EGDirectLight directLightWithColor:EGColorMake(1.0, 1.0, 1.0, 1.0) direction:EGVec3Make(((float)(-0.2)), ((float)(0.2)), ((float)(-0.5)))]])];
        _camera = [EGCameraIso cameraIsoWithTilesOnScreen:_level.map.size center:EGVec2Make(0.0, 0.0)];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _TRLevelView_type = [ODClassType classTypeWithCls:[TRLevelView class]];
}

- (void)drawView {
    [_backgroundView draw];
    [[_level cities] forEach:^void(TRCity* city) {
        [_cityView drawCity:city];
    }];
    [_railroadView drawRailroad:_level.railroad];
    [_trainView drawTrains:[_level trains]];
}

- (void)updateWithDelta:(CGFloat)delta {
    [[_level trains] forEach:^void(TRTrain* _) {
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


