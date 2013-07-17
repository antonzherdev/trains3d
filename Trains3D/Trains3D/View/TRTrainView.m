#import "TRTrainView.h"

#import "EGGL.h"
#import "EGModel.h"
#import "TRTrain.h"
#import "TRTypes.h"
@implementation TRTrainView

+ (id)trainView {
    return [[TRTrainView alloc] init];
}

- (id)init {
    self = [super init];
    
    return self;
}

- (void)drawTrain:(TRTrain*)train {
    [train.color set];
    [train.cars forEach:^void(TRCar* car) {
        glPushMatrix();
        EGPoint h = trRailPointPoint(car.head);
        EGPoint t = trRailPointPoint(car.tail);
        EGPoint mid = egPointMid(h, t);
        egTranslate(mid.x, mid.y, 0);
        double angle = 90 + 180.0 / M_PI * egPointAngle(egPointSub(t, h));
        egRotate(angle, 0, 0, 1);
        egRotate(90, 1, 0, 0);
        egDrawJasModel(Car);
        glPopMatrix();
    }];
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end


