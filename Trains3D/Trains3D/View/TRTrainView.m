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
        glTranslatef(mid.x, mid.y, 0);
        NSInteger angle = 90 + 180.0 / M_PI * egpToAngle(egpSub(t, h));
        glRotatef(angle, 0, 0, -1);
        glRotatef(90, 1, 0, 0);
        egDrawJasModel(Car);
        glPopMatrix();
    }];
}

@end


