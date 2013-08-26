#import "TRTrainView.h"
#import "TR3DCar.h"
#import "TR3DEngine.h"

#import "EGMesh.h"
#import "EGMaterial.h"
#import "TRTrain.h"
#import "TRTypes.h"
#import "TRRailPoint.h"
@implementation TRTrainView

+ (id)trainView {
    return [[TRTrainView alloc] init];
}

- (id)init {
    self = [super init];
    
    return self;
}

- (void)drawTrain:(TRTrain*)train {
    [train.cars forEach:^void(TRCar* car) {
        EGPoint h = car.head.point;
        EGPoint t = car.tail.point;
        glPushMatrix();
        EGPoint mid = egPointMid(h, t);
        egTranslate(mid.x, mid.y, 0.05);
        CGFloat angle = (([train isBack]) ? 90 : -90) + 180.0 / M_PI * egPointAngle(egPointSub(t, h));
        egRotate(angle, 0.0, 0.0, 1.0);
        egRotate(90.0, 1.0, 0.0, 0.0);
        if(car.carType == TRCarType.car) {
            [train.color setMaterial];
            egDrawJasModel(Car);
            [EGMaterial.blackMetal set];
            egDrawJasModel(CarBlack);
        } else {
            [train.color setMaterial];
            egDrawJasModel(Engine);
            egDrawJasModel(EngineFloor);
            [EGMaterial.blackMetal set];
            egDrawJasModel(EngineBlack);
        }
        glPopMatrix();
    }];
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    return YES;
}

- (NSUInteger)hash {
    return 0;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendString:@">"];
    return description;
}

@end


