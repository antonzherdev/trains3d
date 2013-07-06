#import "TRTrainView.h"

#import "EGGL.h"
#import "EGModel.h"
#import "TRTrain.h"
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
        CGPoint mid = egpMidpoint(car.head, car.tail);
        glTranslatef(mid.x, mid.y, 0);
        glRotatef(90, 1, 0, 0);
        egDrawJasModel(Car);
        glPopMatrix();
    }];
}

@end


