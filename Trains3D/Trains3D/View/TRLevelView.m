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
    glEnable(GL_LIGHTING);
    glEnable(GL_LIGHT0);
    glEnable(GL_COLOR_MATERIAL);
    glEnable(GL_NORMALIZE);
    glShadeModel(GL_SMOOTH);
    egAmbientColor(0.5, 0.5, 0.5);
    egLightColor(GL_LIGHT0, 0.8, 0.8, 0.8);
    egLightDirection(GL_LIGHT0, 0.2, -0.2, 0.5);
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
    glDisable(GL_LIGHTING);
    glDisable(GL_LIGHT0);
    glDisable(GL_COLOR_MATERIAL);
    glDisable(GL_NORMALIZE);
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


