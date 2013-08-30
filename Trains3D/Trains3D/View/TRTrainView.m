#import "TRTrainView.h"

#import "EG.h"
#import "EGMesh.h"
#import "EGMaterial.h"
#import "EGContext.h"
#import "TRTrain.h"
#import "TRTypes.h"
#import "TRRailPoint.h"
#import "TR3D.h"
@implementation TRTrainView{
    EGStandardMaterial* _blackMaterial;
}
static ODType* _TRTrainView_type;
@synthesize blackMaterial = _blackMaterial;

+ (id)trainView {
    return [[TRTrainView alloc] init];
}

- (id)init {
    self = [super init];
    if(self) _blackMaterial = [EGStandardMaterial standardMaterialWithDiffuse:[EGColorSource applyColor:EGColorMake(0.0, 0.0, 0.0, 1.0)] specular:EGColorMake(0.1, 0.1, 0.1, 1.0)];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _TRTrainView_type = [ODType typeWithCls:[TRTrainView class]];
}

- (EGMaterial2*)trainMaterialForColor:(EGColor)color {
    return [EGStandardMaterial standardMaterialWithDiffuse:[EGColorSource applyColor:color] specular:EGColorMake(0.2, 0.2, 0.2, 1.0)];
}

- (void)drawTrain:(TRTrain*)train {
    [train.cars forEach:^void(TRCar* car) {
        EGPoint h = car.head.point;
        EGPoint t = car.tail.point;
        [EG keepMWF:^void() {
            EGPoint mid = egPointMid(h, t);
            [[EG worldMatrix] translateX:mid.x y:mid.y z:0.05];
            CGFloat angle = (([train isBack]) ? 90 : -90) + 180.0 / M_PI * egPointAngle(egPointSub(t, h));
            [[EG modelMatrix] rotateAngle:angle x:0.0 y:1.0 z:0.0];
            if(car.carType == TRCarType.car) {
                [TR3D.car drawWithMaterial:[EGMaterial2 applyColor:train.color.color]];
                [TR3D.carBlack drawWithMaterial:_blackMaterial];
            } else {
                [TR3D.engine drawWithMaterial:[EGMaterial2 applyColor:train.color.color]];
                [TR3D.engineFloor drawWithMaterial:[EGMaterial2 applyColor:train.color.color]];
                [TR3D.carBlack drawWithMaterial:_blackMaterial];
            }
        }];
    }];
}

- (ODType*)type {
    return _TRTrainView_type;
}

+ (ODType*)type {
    return _TRTrainView_type;
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


