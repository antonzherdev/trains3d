#import "TRTrainView.h"

#import "TRSmoke.h"
#import "EGMaterial.h"
#import "TRTrain.h"
#import "TRCity.h"
#import "EGContext.h"
#import "TRCar.h"
#import "GEFigure.h"
#import "GEMat4.h"
#import "TRModels.h"
#import "EGDynamicWorld.h"
@implementation TRTrainView{
    TRSmokeView* _smokeView;
    EGStandardMaterial* _blackMaterial;
}
static ODType* _TRTrainView_type;
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
    EGMaterial* material = [self trainMaterialForColor:train.color.color];
    [[train cars] forEach:^void(TRCar* car) {
        [EGGlobal.matrix applyModify:^EGMatrixModel*(EGMatrixModel* _) {
            return [[_ modifyW:^GEMat4*(GEMat4* w) {
                GEVec2 mid = [[car position].line mid];
                return [w translateX:mid.x y:mid.y z:0.04];
            }] modifyM:^GEMat4*(GEMat4* m) {
                return [m rotateAngle:((float)([[car position].line degreeAngle] + 90)) x:0.0 y:1.0 z:0.0];
            }];
        } f:^void() {
            [self doDrawCar:car material:material];
        }];
    }];
}

- (void)doDrawCar:(TRCar*)car material:(EGMaterial*)material {
    if(car.carType == TRCarType.car) {
        [material drawMesh:TRModels.car];
        [_blackMaterial drawMesh:TRModels.carBlack];
    } else {
        [material drawMesh:TRModels.engine];
        [material drawMesh:TRModels.engineFloor];
        [_blackMaterial drawMesh:TRModels.engineBlack];
    }
}

- (void)drawDyingTrains:(id<CNSeq>)dyingTrains {
    if([dyingTrains isEmpty]) return ;
    [dyingTrains forEach:^void(TRTrain* train) {
        [_smokeView drawSystem:train.viewData];
        [self drawDyingTrain:train];
    }];
}

- (void)drawDyingTrain:(TRTrain*)dyingTrain {
    EGMaterial* material = [self trainMaterialForColor:dyingTrain.color.color];
    [[dyingTrain cars] forEach:^void(TRCar* car) {
        [EGGlobal.matrix applyModify:^EGMatrixModel*(EGMatrixModel* _) {
            return [_ modifyM:^GEMat4*(GEMat4* m) {
                return [[[car dynamicBody].matrix translateX:0.0 y:0.0 z:((float)(-car.carType.height / 2 + 0.04))] mulMatrix:[m rotateAngle:90.0 x:0.0 y:1.0 z:0.0]];
            }];
        } f:^void() {
            [self doDrawCar:car material:material];
        }];
    }];
}

- (void)updateWithDelta:(CGFloat)delta train:(TRTrain*)train {
    [((TRSmoke*)(train.viewData)) updateWithDelta:delta];
}

- (ODClassType*)type {
    return [TRTrainView type];
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


