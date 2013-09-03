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
    TRSmokeView* _smokeView;
    EGStandardMaterial* _blackMaterial;
}
static ODClassType* _TRTrainView_type;
@synthesize smokeView = _smokeView;
@synthesize blackMaterial = _blackMaterial;

+ (id)trainView {
    return [[TRTrainView alloc] init];
}

- (id)init {
    self = [super init];
    if(self) {
        _smokeView = [TRSmokeView smokeView];
        _blackMaterial = [EGStandardMaterial standardMaterialWithDiffuse:[EGColorSource applyColor:EGColorMake(0.0, 0.0, 0.0, 1.0)] specularColor:EGColorMake(0.1, 0.1, 0.1, 1.0) specularSize:1.0];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _TRTrainView_type = [ODClassType classTypeWithCls:[TRTrainView class]];
}

- (EGMaterial*)trainMaterialForColor:(EGColor)color {
    return [EGStandardMaterial standardMaterialWithDiffuse:[EGColorSource applyColor:color] specularColor:EGColorMake(0.3, 0.3, 0.3, 1.0) specularSize:1.0];
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
            EGMaterial* material = [self trainMaterialForColor:train.color.color];
            if(car.carType == TRCarType.car) {
                [TR3D.car drawWithMaterial:material];
                [TR3D.carBlack drawWithMaterial:_blackMaterial];
            } else {
                [TR3D.engine drawWithMaterial:material];
                [TR3D.engineFloor drawWithMaterial:material];
                [TR3D.carBlack drawWithMaterial:_blackMaterial];
            }
        }];
    }];
    if(train.viewData == nil) train.viewData = [TRSmoke smokeWithTrain:train];
    [_smokeView drawSmoke:train.viewData];
}

- (void)updateWithDelta:(CGFloat)delta train:(TRTrain*)train {
    [((TRSmoke*)(train.viewData)) updateWithDelta:delta];
}

- (ODClassType*)type {
    return [TRTrainView type];
}

+ (ODClassType*)type {
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


