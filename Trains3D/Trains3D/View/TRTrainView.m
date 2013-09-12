#import "TRTrainView.h"

#import "TRSmoke.h"
#import "EGMaterial.h"
#import "TRTrain.h"
#import "EG.h"
#import "EGFigure.h"
#import "EGMatrix.h"
#import "TRTypes.h"
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

- (void)drawTrains:(id<CNSeq>)trains {
    if([trains isEmpty]) return ;
    [trains forEach:^void(TRTrain* train) {
        [self drawTrain:train];
        if(train.viewData == nil) train.viewData = [TRSmoke smokeWithTrain:train];
        [_smokeView drawSystem:train.viewData];
    }];
}

- (void)drawTrain:(TRTrain*)train {
    [[train cars] forEach:^void(TRCar* car) {
        [EG.matrix applyModify:^EGMatrixModel*(EGMatrixModel* _) {
            return [[_ modifyW:^EGMatrix*(EGMatrix* w) {
                EGVec2 mid = [car.position.line mid];
                return [w translateX:mid.x y:mid.y z:0.05];
            }] modifyM:^EGMatrix*(EGMatrix* m) {
                return [m rotateAngle:((float)([car.position.line degreeAngle] - 90)) x:0.0 y:1.0 z:0.0];
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


