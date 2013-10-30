#import "TRTrainView.h"

#import "TRLevel.h"
#import "TRModels.h"
#import "GL.h"
#import "EGContext.h"
#import "TRTrain.h"
#import "TRSmoke.h"
#import "TRCar.h"
#import "GEFigure.h"
#import "GEMat4.h"
#import "TRCity.h"
#import "EGDynamicWorld.h"
#import "EGMaterial.h"
#import "EGMesh.h"
@implementation TRTrainView{
    TRLevel* _level;
    TRCarModel* _engineModel;
    TRCarModel* _carModel;
    TRCarModel* _expressEngineModel;
    TRCarModel* _expressCarModel;
}
static ODClassType* _TRTrainView_type;
@synthesize level = _level;

+ (id)trainViewWithLevel:(TRLevel*)level {
    return [[TRTrainView alloc] initWithLevel:level];
}

- (id)initWithLevel:(TRLevel*)level {
    self = [super init];
    if(self) {
        _level = level;
        _engineModel = [TRCarModel applyColorMesh:TRModels.engine blackMesh:TRModels.engineBlack shadowMesh:TRModels.engineShadow];
        _carModel = [TRCarModel applyColorMesh:TRModels.car blackMesh:TRModels.carBlack shadowMesh:TRModels.carShadow texture:[CNOption applyValue:[EGGlobal textureForFile:@"Car.png" magFilter:GL_LINEAR minFilter:GL_LINEAR_MIPMAP_NEAREST]]];
        _expressEngineModel = [TRCarModel applyColorMesh:TRModels.expressEngine blackMesh:TRModels.expressEngineBlack shadowMesh:TRModels.expressEngineShadow];
        _expressCarModel = [TRCarModel applyColorMesh:TRModels.expressCar blackMesh:TRModels.expressCarBlack shadowMesh:TRModels.expressCarShadow texture:[CNOption applyValue:[EGGlobal textureForFile:@"ExpressCar.png" magFilter:GL_LINEAR minFilter:GL_LINEAR_MIPMAP_NEAREST]]];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _TRTrainView_type = [ODClassType classTypeWithCls:[TRTrainView class]];
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
        TRSmokeView* smoke = ((TRSmokeView*)(((TRTrain*)(train)).viewData));
        if(((TRTrain*)(train)).viewData == nil) {
            smoke = [TRSmokeView smokeViewWithSystem:[TRSmoke smokeWithTrain:train weather:_level.weather]];
            ((TRTrain*)(train)).viewData = smoke;
        }
        [smoke draw];
    }];
}

- (void)drawTrain:(TRTrain*)train {
    [[train cars] forEach:^void(TRCar* car) {
        [EGGlobal.matrix applyModify:^EGMatrixModel*(EGMatrixModel* _) {
            return [[_ modifyW:^GEMat4*(GEMat4* w) {
                GEVec2 mid = [[((TRCar*)(car)) position].line mid];
                return [w translateX:mid.x y:mid.y z:0.04];
            }] modifyM:^GEMat4*(GEMat4* m) {
                return [m rotateAngle:((float)([[((TRCar*)(car)) position].line degreeAngle] + 90)) x:0.0 y:1.0 z:0.0];
            }];
        } f:^void() {
            [self doDrawCar:car color:train.color.trainColor];
        }];
    }];
}

- (void)doDrawCar:(TRCar*)car color:(GEVec4)color {
    TRCarType* tp = car.carType;
    if(tp == TRCarType.car) {
        [_carModel drawColor:color];
    } else {
        if(tp == TRCarType.engine) {
            [_engineModel drawColor:color];
        } else {
            if(tp == TRCarType.expressEngine) {
                [_expressEngineModel drawColor:color];
            } else {
                if(tp == TRCarType.expressCar) [_expressCarModel drawColor:color];
            }
        }
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
                return [[[((TRCar*)(car)) dynamicBody].matrix translateX:0.0 y:0.0 z:((float)(-((TRCar*)(car)).carType.height / 2 + 0.04))] mulMatrix:[m rotateAngle:90.0 x:0.0 y:1.0 z:0.0]];
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


@implementation TRCarModel{
    EGVertexArray* _colorVao;
    EGVertexArray* _blackVao;
    EGVertexArray* _shadowVao;
    id _texture;
}
static EGMaterial* _TRCarModel_blackMaterial;
static ODClassType* _TRCarModel_type;
@synthesize colorVao = _colorVao;
@synthesize blackVao = _blackVao;
@synthesize shadowVao = _shadowVao;
@synthesize texture = _texture;

+ (id)carModelWithColorVao:(EGVertexArray*)colorVao blackVao:(EGVertexArray*)blackVao shadowVao:(EGVertexArray*)shadowVao texture:(id)texture {
    return [[TRCarModel alloc] initWithColorVao:colorVao blackVao:blackVao shadowVao:shadowVao texture:texture];
}

- (id)initWithColorVao:(EGVertexArray*)colorVao blackVao:(EGVertexArray*)blackVao shadowVao:(EGVertexArray*)shadowVao texture:(id)texture {
    self = [super init];
    if(self) {
        _colorVao = colorVao;
        _blackVao = blackVao;
        _shadowVao = shadowVao;
        _texture = texture;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _TRCarModel_type = [ODClassType classTypeWithCls:[TRCarModel class]];
    _TRCarModel_blackMaterial = [EGStandardMaterial applyColor:GEVec4Make(0.0, 0.0, 0.0, 1.0)];
}

+ (EGStandardMaterial*)trainMaterialForDiffuse:(EGColorSource*)diffuse {
    return [EGStandardMaterial standardMaterialWithDiffuse:diffuse specularColor:GEVec4Make(0.1, 0.1, 0.1, 1.0) specularSize:0.1];
}

+ (TRCarModel*)applyColorMesh:(EGMesh*)colorMesh blackMesh:(EGMesh*)blackMesh shadowMesh:(EGMesh*)shadowMesh {
    return [TRCarModel applyColorMesh:colorMesh blackMesh:blackMesh shadowMesh:shadowMesh texture:[CNOption none]];
}

+ (TRCarModel*)applyColorMesh:(EGMesh*)colorMesh blackMesh:(EGMesh*)blackMesh shadowMesh:(EGMesh*)shadowMesh texture:(id)texture {
    EGStandardMaterial* defMat = (([texture isDefined]) ? [TRCarModel trainMaterialForDiffuse:[EGColorSource colorSourceWithColor:GEVec4Make(1.0, 0.0, 0.0, 1.0) texture:[CNOption applyValue:[texture get]] blendMode:EGBlendMode.darken alphaTestLevel:-1.0]] : [TRCarModel trainMaterialForDiffuse:[EGColorSource applyColor:GEVec4Make(1.0, 1.0, 1.0, 1.0)]]);
    return [TRCarModel carModelWithColorVao:[colorMesh vaoMaterial:defMat shadow:NO] blackVao:[blackMesh vaoMaterial:_TRCarModel_blackMaterial shadow:NO] shadowVao:[shadowMesh vaoShadowMaterial:[EGColorSource applyColor:GEVec4Make(1.0, 1.0, 1.0, 1.0)]] texture:texture];
}

- (void)drawColor:(GEVec4)color {
    if([EGGlobal.context.renderTarget isShadow]) {
        [_shadowVao draw];
    } else {
        [_colorVao drawParam:[TRCarModel trainMaterialForDiffuse:[EGColorSource colorSourceWithColor:color texture:_texture blendMode:EGBlendMode.darken alphaTestLevel:-1.0]]];
        [_blackVao draw];
    }
}

- (ODClassType*)type {
    return [TRCarModel type];
}

+ (EGMaterial*)blackMaterial {
    return _TRCarModel_blackMaterial;
}

+ (ODClassType*)type {
    return _TRCarModel_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    TRCarModel* o = ((TRCarModel*)(other));
    return [self.colorVao isEqual:o.colorVao] && [self.blackVao isEqual:o.blackVao] && [self.shadowVao isEqual:o.shadowVao] && [self.texture isEqual:o.texture];
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.colorVao hash];
    hash = hash * 31 + [self.blackVao hash];
    hash = hash * 31 + [self.shadowVao hash];
    hash = hash * 31 + [self.texture hash];
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"colorVao=%@", self.colorVao];
    [description appendFormat:@", blackVao=%@", self.blackVao];
    [description appendFormat:@", shadowVao=%@", self.shadowVao];
    [description appendFormat:@", texture=%@", self.texture];
    [description appendString:@">"];
    return description;
}

@end


