#import "TRTrainView.h"

#import "EGTexture.h"
#import "EGContext.h"
#import "EGMaterial.h"
#import "TRSmoke.h"
#import "TRTrain.h"
#import "TRCar.h"
#import "GEMat4.h"
#import "EGMatrixModel.h"
#import "TRCity.h"
#import "EGProgress.h"
#import "TRModels.h"
#import "EGVertexArray.h"
#import "EGMesh.h"
@implementation TRSmokeView{
    TRSmoke* _system;
}
static ODClassType* _TRSmokeView_type;
@synthesize system = _system;

+ (instancetype)smokeViewWithSystem:(TRSmoke*)system {
    return [[TRSmokeView alloc] initWithSystem:system];
}

- (instancetype)initWithSystem:(TRSmoke*)system {
    self = [super initWithSystem:system maxCount:202 material:[EGColorSource applyTexture:[EGGlobal textureForFile:@"Smoke" format:EGTextureFormat.RGBA4 filter:EGTextureFilter.mipmapNearest]] blendFunc:EGBlendFunction.premultiplied];
    if(self) _system = system;
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [TRSmokeView class]) _TRSmokeView_type = [ODClassType classTypeWithCls:[TRSmokeView class]];
}

- (ODClassType*)type {
    return [TRSmokeView type];
}

+ (ODClassType*)type {
    return _TRSmokeView_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    TRSmokeView* o = ((TRSmokeView*)(other));
    return [self.system isEqual:o.system];
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.system hash];
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"system=%@", self.system];
    [description appendString:@">"];
    return description;
}

@end


@implementation TRTrainView{
    TRTrainModels* _models;
    TRTrain* _train;
    TRSmoke* _smoke;
    TRSmokeView* _smokeView;
}
static ODClassType* _TRTrainView_type;
@synthesize models = _models;
@synthesize train = _train;
@synthesize smoke = _smoke;
@synthesize smokeView = _smokeView;

+ (instancetype)trainViewWithModels:(TRTrainModels*)models train:(TRTrain*)train {
    return [[TRTrainView alloc] initWithModels:models train:train];
}

- (instancetype)initWithModels:(TRTrainModels*)models train:(TRTrain*)train {
    self = [super init];
    if(self) {
        _models = models;
        _train = train;
        _smoke = [[TRSmoke smokeWithTrain:_train] actor];
        _smokeView = [TRSmokeView smokeViewWithSystem:_smoke];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [TRTrainView class]) _TRTrainView_type = [ODClassType classTypeWithCls:[TRTrainView class]];
}

- (void)updateWithDelta:(CGFloat)delta {
    [_smoke updateWithDelta:delta];
}

- (void)prepare {
    [_smokeView prepare];
}

- (void)draw {
    [[_train state] waitAndOnSuccessAwait:1.0 f:^void(TRTrainState* state) {
        if([((TRTrainState*)(state)) isDying]) [[((TRTrainState*)(state)) carStates] forEach:^void(TRCarState* car) {
            TRCarType* tp = ((TRCarState*)(car)).carType;
            [EGGlobal.matrix applyModify:^void(EGMMatrixModel* _) {
                [_ modifyM:^GEMat4*(GEMat4* m) {
                    return [[[((TRCarState*)(car)) matrix] translateX:0.0 y:0.0 z:((float)(-tp.height / 2 + 0.04))] mulMatrix:[m rotateAngle:90.0 x:0.0 y:1.0 z:0.0]];
                }];
            } f:^void() {
                [_models drawTrainState:state carType:tp];
            }];
        }];
        else [((TRLiveTrainState*)(state)).carStates forEach:^void(TRLiveCarState* car) {
            [EGGlobal.matrix applyModify:^void(EGMMatrixModel* _) {
                [[_ modifyW:^GEMat4*(GEMat4* w) {
                    GEVec2 mid = ((TRLiveCarState*)(car)).midPoint;
                    return [w translateX:mid.x y:mid.y z:0.04];
                }] modifyM:^GEMat4*(GEMat4* m) {
                    return [m rotateAngle:geLine2DegreeAngle(((TRLiveCarState*)(car)).line) + 90 x:0.0 y:1.0 z:0.0];
                }];
            } f:^void() {
                [_models drawTrainState:state carType:((TRLiveCarState*)(car)).carType];
            }];
        }];
    }];
}

- (void)drawSmoke {
    [_smokeView draw];
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
    return [self.models isEqual:o.models] && [self.train isEqual:o.train];
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.models hash];
    hash = hash * 31 + [self.train hash];
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"models=%@", self.models];
    [description appendFormat:@", train=%@", self.train];
    [description appendString:@">"];
    return description;
}

@end


@implementation TRTrainModels{
    TRCarModel* _engineModel;
    TRCarModel* _carModel;
    TRCarModel* _expressEngineModel;
    TRCarModel* _expressCarModel;
}
static id<CNImSeq> _TRTrainModels_crazyColors;
static ODClassType* _TRTrainModels_type;

+ (instancetype)trainModels {
    return [[TRTrainModels alloc] init];
}

- (instancetype)init {
    self = [super init];
    if(self) {
        _engineModel = [TRCarModel applyColorMesh:TRModels.engine blackMesh:TRModels.engineBlack shadowMesh:TRModels.engineShadow texture:[CNOption applyValue:[EGGlobal compressedTextureForFile:@"Engine"]] normalMap:[CNOption applyValue:[EGGlobal compressedTextureForFile:@"engine_normals"]]];
        _carModel = [TRCarModel applyColorMesh:TRModels.car blackMesh:TRModels.carBlack shadowMesh:TRModels.carShadow texture:[CNOption applyValue:[EGGlobal compressedTextureForFile:@"Car"]] normalMap:[CNOption none]];
        _expressEngineModel = [TRCarModel applyColorMesh:TRModels.expressEngine blackMesh:TRModels.expressEngineBlack shadowMesh:TRModels.expressEngineShadow texture:[CNOption applyValue:[EGGlobal compressedTextureForFile:@"ExpressEngine"]] normalMap:[CNOption none]];
        _expressCarModel = [TRCarModel applyColorMesh:TRModels.expressCar blackMesh:TRModels.expressCarBlack shadowMesh:TRModels.expressCarShadow texture:[CNOption applyValue:[EGGlobal compressedTextureForFile:@"ExpressCar"]] normalMap:[CNOption none]];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [TRTrainModels class]) {
        _TRTrainModels_type = [ODClassType classTypeWithCls:[TRTrainModels class]];
        _TRTrainModels_crazyColors = [[[[[[[TRCityColor values] chain] exclude:(@[TRCityColor.grey])] map:^id(TRCityColor* cityColor) {
            return wrap(GEVec4, ((TRCityColor*)(cityColor)).color);
        }] neighborsRing] map:^id(CNTuple* colors) {
            return [EGProgress progressVec4:uwrap(GEVec4, ((CNTuple*)(colors)).a) vec42:uwrap(GEVec4, ((CNTuple*)(colors)).b)];
        }] toArray];
    }
}

+ (GEVec4)crazyColorTime:(CGFloat)time {
    CGFloat f = floatFraction(time / 2) * [_TRTrainModels_crazyColors count] - 0.0001;
    GEVec4(^cc)(float) = [_TRTrainModels_crazyColors applyIndex:((NSInteger)(f))];
    return cc(((float)(floatFraction(f))));
}

- (void)drawTrainState:(TRTrainState*)trainState carType:(TRCarType*)carType {
    GEVec4 color = ((trainState.train.trainType == TRTrainType.crazy) ? [TRTrainModels crazyColorTime:trainState.time] : trainState.train.color.trainColor);
    if(carType == TRCarType.car) {
        [_carModel drawColor:color];
    } else {
        if(carType == TRCarType.engine) {
            [_engineModel drawColor:color];
        } else {
            if(carType == TRCarType.expressEngine) {
                [_expressEngineModel drawColor:color];
            } else {
                if(carType == TRCarType.expressCar) [_expressCarModel drawColor:color];
            }
        }
    }
}

- (ODClassType*)type {
    return [TRTrainModels type];
}

+ (ODClassType*)type {
    return _TRTrainModels_type;
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


@implementation TRCarModel{
    EGVertexArray* _colorVao;
    EGVertexArray* _blackVao;
    EGVertexArray* _shadowVao;
    id _texture;
    id _normalMap;
}
static EGColorSource* _TRCarModel_blackMaterial;
static ODClassType* _TRCarModel_type;
@synthesize colorVao = _colorVao;
@synthesize blackVao = _blackVao;
@synthesize shadowVao = _shadowVao;
@synthesize texture = _texture;
@synthesize normalMap = _normalMap;

+ (instancetype)carModelWithColorVao:(EGVertexArray*)colorVao blackVao:(EGVertexArray*)blackVao shadowVao:(EGVertexArray*)shadowVao texture:(id)texture normalMap:(id)normalMap {
    return [[TRCarModel alloc] initWithColorVao:colorVao blackVao:blackVao shadowVao:shadowVao texture:texture normalMap:normalMap];
}

- (instancetype)initWithColorVao:(EGVertexArray*)colorVao blackVao:(EGVertexArray*)blackVao shadowVao:(EGVertexArray*)shadowVao texture:(id)texture normalMap:(id)normalMap {
    self = [super init];
    if(self) {
        _colorVao = colorVao;
        _blackVao = blackVao;
        _shadowVao = shadowVao;
        _texture = texture;
        _normalMap = normalMap;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [TRCarModel class]) {
        _TRCarModel_type = [ODClassType classTypeWithCls:[TRCarModel class]];
        _TRCarModel_blackMaterial = [EGColorSource applyColor:GEVec4Make(0.0, 0.0, 0.0, 1.0)];
    }
}

+ (EGStandardMaterial*)trainMaterialForDiffuse:(EGColorSource*)diffuse normalMap:(id)normalMap {
    return [EGStandardMaterial standardMaterialWithDiffuse:diffuse specularColor:GEVec4Make(0.1, 0.1, 0.1, 1.0) specularSize:0.1 normalMap:(([normalMap isDefined]) ? [CNOption applyValue:[EGNormalMap normalMapWithTexture:[normalMap get] tangent:NO]] : [CNOption none])];
}

+ (TRCarModel*)applyColorMesh:(EGMesh*)colorMesh blackMesh:(EGMesh*)blackMesh shadowMesh:(EGMesh*)shadowMesh texture:(id)texture normalMap:(id)normalMap {
    EGStandardMaterial* defMat = (([texture isDefined]) ? [TRCarModel trainMaterialForDiffuse:[EGColorSource colorSourceWithColor:GEVec4Make(1.0, 0.0, 0.0, 1.0) texture:[CNOption applyValue:[texture get]] blendMode:EGBlendMode.multiply alphaTestLevel:-1.0] normalMap:normalMap] : [TRCarModel trainMaterialForDiffuse:[EGColorSource applyColor:GEVec4Make(1.0, 1.0, 1.0, 1.0)] normalMap:normalMap]);
    return [TRCarModel carModelWithColorVao:[colorMesh vaoMaterial:defMat shadow:NO] blackVao:[blackMesh vaoMaterial:_TRCarModel_blackMaterial shadow:NO] shadowVao:[shadowMesh vaoShadowMaterial:[EGColorSource applyColor:GEVec4Make(1.0, 1.0, 1.0, 1.0)]] texture:texture normalMap:normalMap];
}

- (void)drawColor:(GEVec4)color {
    if([EGGlobal.context.renderTarget isShadow]) {
        [_shadowVao draw];
    } else {
        [_colorVao drawParam:[TRCarModel trainMaterialForDiffuse:[EGColorSource colorSourceWithColor:color texture:_texture blendMode:EGBlendMode.multiply alphaTestLevel:-1.0] normalMap:_normalMap]];
        [_blackVao draw];
    }
}

- (ODClassType*)type {
    return [TRCarModel type];
}

+ (EGColorSource*)blackMaterial {
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
    return [self.colorVao isEqual:o.colorVao] && [self.blackVao isEqual:o.blackVao] && [self.shadowVao isEqual:o.shadowVao] && [self.texture isEqual:o.texture] && [self.normalMap isEqual:o.normalMap];
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.colorVao hash];
    hash = hash * 31 + [self.blackVao hash];
    hash = hash * 31 + [self.shadowVao hash];
    hash = hash * 31 + [self.texture hash];
    hash = hash * 31 + [self.normalMap hash];
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"colorVao=%@", self.colorVao];
    [description appendFormat:@", blackVao=%@", self.blackVao];
    [description appendFormat:@", shadowVao=%@", self.shadowVao];
    [description appendFormat:@", texture=%@", self.texture];
    [description appendFormat:@", normalMap=%@", self.normalMap];
    [description appendString:@">"];
    return description;
}

@end


