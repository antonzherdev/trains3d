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
    [train.color gl];
    [train.cars forEach:^void(TRCar* car) {
        glPushMatrix();
        CGPoint h = trRailPointPoint(car.head);
        CGPoint t = trRailPointPoint(car.tail);
        CGPoint mid = egpMidpoint(h, t);
        egTranslate(mid.x, mid.y, 0);
        CGFloat angle = 90 + 180.0 / M_PI * egpToAngle(egpSub(t, h));
        egRotate(angle, 0, 0, 1);
        egRotate(90, 1, 0, 0);
        egDrawJasModel(Car);
        glPopMatrix();
    }];
}

@end


