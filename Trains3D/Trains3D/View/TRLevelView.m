#import "TRLevelView.h"

@implementation TRLevelView{
    TRLevel* _level;
    TRLevelBackgroundView* _backgroundView;
    TRCityView* _cityView;
    TRRailroadView* _railroadView;
    id _camera;
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
        _camera = [EGCameraIso cameraIsoWithTilesOnScreen:_level.mapSize center:CGPointMake(0, 0)];
    }
    
    return self;
}

- (void)drawView {
    [_backgroundView drawLevel:_level];
    [_level.cities forEach:^void(TRCity* city) {
        [_cityView drawCity:city];
    }];
    [_railroadView drawRailroad:_level.railroad];
    glColor3f(1.0, 1.0, 1.0);
    egMapSsoDrawLayout(_level.mapSize);
}

@end


