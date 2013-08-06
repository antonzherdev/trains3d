#import "TRLevelView.h"

#import "EGCameraIso.h"
#import "EG.h"
#import "EGGL.h"
#import "EGMapIso.h"
#import "TRLevel.h"
#import "TRLevelBackgroundView.h"
#import "TRCityView.h"
@implementation TRLevelView{
    TRLevel* _level;
    TRLevelBackgroundView* _backgroundView;
    TRCityView* _cityView;
    TRRailroadView* _railroadView;
    TRTrainView* _trainView;
    id<EGCamera> _camera;
}
@synthesize level = _level;
@synthesize camera = _camera;

+ (id)levelViewWithLevel:(TRLevel*)level {
    return [[TRLevelView alloc] initWithLevel:level];
}

- (id)initWithLevel:(TRLevel*)level {
    self = [super init];
    if(self) {
        _level = level;
        _backgroundView = [TRLevelBackgroundView levelBackgroundView];
        _cityView = [TRCityView cityView];
        _railroadView = [TRRailroadView railroadView];
        _trainView = [TRTrainView trainView];
        _camera = [EGCameraIso cameraIsoWithTilesOnScreen:_level.map.size center:EGPointMake(0, 0)];
    }
    
    return self;
}

- (void)drawView {
    [_backgroundView drawLevel:_level];
    [[_level cities] forEach:^void(TRCity* city) {
        [_cityView drawCity:city];
    }];
    [_railroadView drawRailroad:_level.railroad];
    [[_level trains] forEach:^void(TRTrain* train) {
        [_trainView drawTrain:train];
    }];
    egColor3(1.0, 1.0, 1.0);
    [_level.map drawLayout];
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end


