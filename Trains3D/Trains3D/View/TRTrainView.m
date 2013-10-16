#import "TRTrainView.h"

#import "TRLevel.h"
#import "EGMaterial.h"
#import "EGTexture.h"
#import "GL.h"
#import "EGContext.h"
#import "EGMesh.h"
#import "TRModels.h"
#import "TRTrain.h"
#import "TRSmoke.h"
#import "TRCar.h"
#import "GEFigure.h"
#import "GEMat4.h"
#import "TRCity.h"
#import "EGDynamicWorld.h"
@implementation TRTrainView{
    TRLevel* _level;
    EGMaterial* _blackMaterial;
    EGTexture* _carTexture;
    EGStandardMaterial* _defMat;
    EGStandardMaterial* _defMatTex;
    EGVertexArray* _vaoCar;
    EGVertexArray* _vaoCarBlack;
    EGVertexArray* _vaoCarShadow;
    EGVertexArray* _vaoEngine;
    EGVertexArray* _vaoEngineBlack;
    EGVertexArray* _vaoEngineShadow;
}
static ODClassType* _TRTrainView_type;
@synthesize level = _level;
@synthesize blackMaterial = _blackMaterial;

+ (id)trainViewWithLevel:(TRLevel*)level {
    return [[TRTrainView alloc] initWithLevel:level];
}

- (id)initWithLevel:(TRLevel*)level {
    self = [super init];
    if(self) {
        _level = level;
        _blackMaterial = [EGStandardMaterial applyColor:GEVec4Make(0.0, 0.0, 0.0, 1.0)];
        _carTexture = [EGGlobal textureForFile:@"Car.png" magFilter:GL_LINEAR minFilter:GL_LINEAR_MIPMAP_NEAREST];
        _defMat = [self trainMaterialForDiffuse:[EGColorSource applyColor:GEVec4Make(1.0, 1.0, 1.0, 1.0)]];
        _defMatTex = [self trainMaterialForDiffuse:[EGColorSource applyColor:GEVec4Make(1.0, 1.0, 1.0, 1.0) texture:_carTexture]];
        _vaoCar = [TRModels.car vaoMaterial:_defMatTex shadow:NO];
        _vaoCarBlack = [TRModels.carBlack vaoMaterial:_blackMaterial shadow:NO];
        _vaoCarShadow = [TRModels.carShadow vaoShadowMaterial:[EGColorSource applyColor:GEVec4Make(1.0, 1.0, 1.0, 1.0)]];
        _vaoEngine = [TRModels.engine vaoMaterial:_defMat shadow:NO];
        _vaoEngineBlack = [TRModels.engineBlack vaoMaterial:_blackMaterial shadow:NO];
        _vaoEngineShadow = [TRModels.engineShadow vaoShadowMaterial:[EGColorSource applyColor:GEVec4Make(1.0, 1.0, 1.0, 1.0)]];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _TRTrainView_type = [ODClassType classTypeWithCls:[TRTrainView class]];
}

- (EGStandardMaterial*)trainMaterialForDiffuse:(EGColorSource*)diffuse {
    return [EGStandardMaterial standardMaterialWithDiffuse:diffuse specularColor:GEVec4Make(0.1, 0.1, 0.1, 1.0) specularSize:0.1];
}

- (void)draw {
    egPushGroupMarker(@"Trains");
    [self drawTrains:[_level trains]];
    [self drawDyingTrains:[_level dyingTrains]];
    egPopGroupMarker();
}

- (void)drawSmoke {
    egPushGroupMarker(@"Smoke");
    [self drawSmokeTrains:[_level trains]];
    [self drawSmokeTrains:[_level dyingTrains]];
    egPopGroupMarker();
}

- (void)drawTrains:(id<CNSeq>)trains {
    if([trains isEmpty]) return ;
    [trains forEach:^void(TRTrain* train) {
        [self drawTrain:train];
    }];
}

- (void)drawSmokeTrains:(id<CNSeq>)trains {
    [trains forEach:^void(TRTrain* train) {
        TRSmokeView* smoke = ((TRSmokeView*)(train.viewData));
        if(train.viewData == nil) {
            smoke = [TRSmokeView smokeViewWithSystem:[TRSmoke smokeWithTrain:train weather:_level.weather]];
            train.viewData = smoke;
        }
        [smoke draw];
    }];
}

- (void)drawTrain:(TRTrain*)train {
    [[train cars] forEach:^void(TRCar* car) {
        [EGGlobal.matrix applyModify:^EGMatrixModel*(EGMatrixModel* _) {
            return [[_ modifyW:^GEMat4*(GEMat4* w) {
                GEVec2 mid = [[car position].line mid];
                return [w translateX:mid.x y:mid.y z:0.04];
            }] modifyM:^GEMat4*(GEMat4* m) {
                return [m rotateAngle:((float)([[car position].line degreeAngle] + 90)) x:0.0 y:1.0 z:0.0];
            }];
        } f:^void() {
            [self doDrawCar:car color:train.color.color];
        }];
    }];
}

- (void)doDrawCar:(TRCar*)car color:(GEVec4)color {
    if(car.carType == TRCarType.car) [self drawCarColor:color];
    else [self drawEngineColor:color];
}

- (void)drawCarColor:(GEVec4)color {
    if([EGGlobal.context.renderTarget isShadow]) {
        [_vaoCarShadow draw];
    } else {
        [_vaoCar drawParam:[self trainMaterialForDiffuse:[EGColorSource applyColor:color texture:_carTexture]]];
        [_vaoCarBlack draw];
    }
}

- (void)drawEngineColor:(GEVec4)color {
    if([EGGlobal.context.renderTarget isShadow]) {
        [_vaoEngineShadow draw];
    } else {
        [_vaoEngine drawParam:[self trainMaterialForDiffuse:[EGColorSource applyColor:color]]];
        [_vaoEngineBlack draw];
    }
}

- (void)drawDyingTrains:(id<CNSeq>)dyingTrains {
    if([dyingTrains isEmpty]) return ;
    [dyingTrains forEach:^void(TRTrain* train) {
        [self drawDyingTrain:train];
    }];
}

- (void)drawDyingTrain:(TRTrain*)dyingTrain {
    [[dyingTrain cars] forEach:^void(TRCar* car) {
        [EGGlobal.matrix applyModify:^EGMatrixModel*(EGMatrixModel* _) {
            return [_ modifyM:^GEMat4*(GEMat4* m) {
                return [[[car dynamicBody].matrix translateX:0.0 y:0.0 z:((float)(-car.carType.height / 2 + 0.04))] mulMatrix:[m rotateAngle:90.0 x:0.0 y:1.0 z:0.0]];
            }];
        } f:^void() {
            [self doDrawCar:car color:dyingTrain.color.color];
        }];
    }];
}

- (void)updateWithDelta:(CGFloat)delta train:(TRTrain*)train {
    [((TRSmokeView*)(train.viewData)).system updateWithDelta:delta];
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


