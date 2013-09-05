#import "TRTrainView.h"

#import "EG.h"
#import "EGMesh.h"
#import "EGMaterial.h"
#import "EGMath.h"
#import "TRTrain.h"
#import "TRTypes.h"
#import "TRRailPoint.h"
#import "TR3D.h"
#import "EGMatrix.h"
#import "EGTexture.h"
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

- (void)drawTrains:(id<CNSeq>)trains {
    if([trains isEmpty]) return ;
    [trains forEach:^void(TRTrain* _) {
        [self drawTrain:_];
    }];
    [_smokeView begin];
    [trains forEach:^void(TRTrain* train) {
        if(train.viewData == nil) train.viewData = [TRSmoke smokeWithTrain:train];
        [_smokeView drawSmoke:train.viewData];
    }];
    [_smokeView end];
}

- (void)drawTrain:(TRTrain*)train {
    [train.cars forEach:^void(TRCar* car) {
        EGVec2 h = car.head.point;
        EGVec2 t = car.tail.point;
        [EG.matrix applyModify:^EGMatrixModel*(EGMatrixModel* _) {
            return [[_ modifyW:^EGMatrix*(EGMatrix* w) {
                EGVec2 mid = egVec2Mid(h, t);
                return [w translateX:((float)(mid.x)) y:((float)(mid.y)) z:((float)(0.05))];
            }] modifyM:^EGMatrix*(EGMatrix* m) {
                CGFloat angle = (([train isBack]) ? 90 : -90) + 180.0 / M_PI * egVec2Angle(egVec2Sub(t, h));
                return [m rotateAngle:((float)(angle)) x:0.0 y:1.0 z:0.0];
            }];
        } f:^void() {
            EGMaterial* material = [self trainMaterialForColor:train.color.color];
            if(car.carType == TRCarType.car) {
                [material drawMesh:TR3D.car];
                [_blackMaterial drawMesh:TR3D.carBlack];
            } else {
                [material drawMesh:TR3D.engine];
                [material drawMesh:TR3D.engineFloor];
                [_blackMaterial drawMesh:TR3D.engineBlack];
            }
        }];
    }];
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


