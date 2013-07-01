#import "TRLevelView.h"

@implementation TRLevelView{
    TRLevelBackgroundView* _backgroundView;
    TRCityView* _cityView;
}

+ (id)levelView {
    return [[TRLevelView alloc] init];
}

- (id)init {
    self = [super init];
    if(self) {
        _backgroundView = [TRLevelBackgroundView levelBackgroundView];
        _cityView = [TRCityView cityView];
    }
    
    return self;
}

- (void)drawController:(TRLevel*)controller viewSize:(CGSize)viewSize {
    EGMapSize mapSize = controller.mapSize;
    egCameraIsoFocus(viewSize, mapSize, CGPointMake(0, 0));
    [_backgroundView drawLevel:controller];
    [controller.cities forEach:^void(TRCity* city) {
        [_cityView drawCity:city];
    }];
    glColor3f(1.0, 1.0, 1.0);
    egMapSsoDrawLayout(mapSize);
}

@end


