#import "TRTrainView.h"

#import "TRLevel.h"
#import "TRSmoke.h"
#import "EGMaterial.h"
#import "EGMesh.h"
#import "TRModels.h"
#import "TRTrain.h"
#import "TRCity.h"
#import "EGContext.h"
#import "TRCar.h"
#import "GEFigure.h"
#import "GEMat4.h"
#import "EGDynamicWorld.h"
@implementation TRTrainView{
    TRLevel* _level;
    TRSmokeView* _smokeView;
    EGStandardMaterial* _blackMaterial;
    EGStandardMaterial* _defMat;
    EGVertexArray* _vaoCar;
    EGVertexArray* _vaoCarBlack;
    EGVertexArray* _vaoEngine;
    EGVertexArray* _vaoEngineFloor;
    EGVertexArray* _vaoEngineBlack;
}
static ODClassType* _TRTrainView_type;
@synthesize level = _level;
@synthesize smokeView = _smokeView;
@synthesize blackMaterial = _blackMaterial;

+ (id)trainViewWithLevel:(TRLevel*)level {
    return [[TRTrainView alloc] initWithLevel:level];
}

- (id)initWithLevel:(TRLevel*)level {
    self = [super init];
    if(self) {
        _level = level;
        _smokeView = [TRSmokeView smokeView];
        _blackMaterial = [EGStandardMaterial standardMaterialWithDiffuse:[EGColorSource applyColor:GEVec4Make(0.0, 0.0, 0.0, 1.0)] specularColor:GEVec4Make(0.1, 0.1, 0.1, 1.0) specularSize:1.0];
        _defMat = [self trainMaterialForColor:GEVec4Make(1.0, 1.0, 1.0, 1.0)];
        _vaoCar = [TRModels.car vaoMaterial:_defMat shadow:YES];
        _vaoCarBlack = [TRModels.carBlack vaoMaterial:_blackMaterial shadow:YES];
        _vaoEngine = [TRModels.engine vaoMaterial:_defMat shadow:YES];
        _vaoEngineFloor = [TRModels.engineFloor vaoMaterial:_defMat shadow:YES];
        _vaoEngineBlack = [TRModels.engineBlack vaoMaterial:_blackMaterial shadow:YES];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _TRTrainView_type = [ODClassType classTypeWithCls:[TRTrainView class]];
}

- (EGStandardMaterial*)trainMaterialForColor:(GEVec4)color {
    return [EGStandardMaterial standardMaterialWithDiffuse:[EGColorSource applyColor:color] specularColor:GEVec4Make(0.1, 0.1, 0.1, 1.0) specularSize:0.1];
}

- (void)draw {
    [self drawTrains:[_level trains]];
    [self drawDyingTrains:[_level dyingTrains]];
}

- (void)drawSmoke {
    [self drawSmokeTrains:[_level trains]];
    [self drawSmokeTrains:[_level dyingTrains]];
}

- (void)drawTrains:(id<CNSeq>)trains {
    if([trains isEmpty]) return ;
    [trains forEach:^void(TRTrain* train) {
        [self drawTrain:train];
        if(train.viewData == nil) train.viewData = [TRSmoke smokeWithTrain:train weather:_level.weather];
    }];
}

- (void)drawSmokeTrains:(id<CNSeq>)trains {
    [trains forEach:^void(TRTrain* train) {
        [_smokeView drawSystem:train.viewData];
    }];
}

- (void)drawTrain:(TRTrain*)train {
    EGStandardMaterial* material = [self trainMaterialForColor:train.color.color];
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
    if(car.carType == TRCarType.car) [self drawCarMaterial:material];
    else [self drawEngineMaterial:material];
}

- (void)drawCarMaterial:(EGMaterial*)material {
    [_vaoCar drawParam:material];
    [_vaoCarBlack draw];
}

- (void)drawEngineMaterial:(EGMaterial*)material {
    [_vaoEngine drawParam:material];
    [_vaoEngineFloor drawParam:material];
    [_vaoEngineBlack draw];
}

- (void)drawDyingTrains:(id<CNSeq>)dyingTrains {
    if([dyingTrains isEmpty]) return ;
    [dyingTrains forEach:^void(TRTrain* train) {
        [self drawDyingTrain:train];
    }];
}

- (void)drawDyingTrain:(TRTrain*)dyingTrain {
    EGStandardMaterial* material = [self trainMaterialForColor:dyingTrain.color.color];
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

+ (ODClassType*)type {
    return _TRTrainView_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    TRTrainView* o = ((TRTrainView*)(other));
    return [self.level isEqual:o.level];
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.level hash];
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"level=%@", self.level];
    [description appendString:@">"];
    return description;
}

@end


