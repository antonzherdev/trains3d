#import "TRTrainView.h"

#import "PGContext.h"
#import "TRSmoke.h"
#import "CNFuture.h"
#import "PGMatrixModel.h"
#import "PGMat4.h"
#import "CNChain.h"
#import "PGProgress.h"
#import "TRModels.h"
#import "PGVertexArray.h"
#import "PGMesh.h"
@implementation TRSmokeView
static CNClassType* _TRSmokeView_type;

+ (instancetype)smokeViewWithSystem:(TRSmoke*)system {
    return [[TRSmokeView alloc] initWithSystem:system];
}

- (instancetype)initWithSystem:(TRSmoke*)system {
    self = [super initWithSystem:system material:[PGColorSource applyTexture:[PGGlobal textureForFile:@"Smoke" format:PGTextureFormat_RGBA4 filter:PGTextureFilter_mipmapNearest]] blendFunc:[PGBlendFunction premultiplied]];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [TRSmokeView class]) _TRSmokeView_type = [CNClassType classTypeWithCls:[TRSmokeView class]];
}

- (NSString*)description {
    return @"SmokeView";
}

- (CNClassType*)type {
    return [TRSmokeView type];
}

+ (CNClassType*)type {
    return _TRSmokeView_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation TRTrainView
static CNClassType* _TRTrainView_type;
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
        _smoke = [TRSmoke smokeWithTrain:train];
        _smokeView = [TRSmokeView smokeViewWithSystem:_smoke];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [TRTrainView class]) _TRTrainView_type = [CNClassType classTypeWithCls:[TRTrainView class]];
}

- (void)updateWithDelta:(CGFloat)delta {
    [_smoke updateWithDelta:delta];
}

- (void)complete {
    [_smokeView prepare];
}

- (void)draw {
    CNTry* __il__0__tr = [[_train state] waitResultPeriod:1.0];
    if(__il__0__tr != nil) {
        if([((CNTry*)(__il__0__tr)) isSuccess]) {
            TRTrainState* state = [((CNTry*)(__il__0__tr)) get];
            if([((TRTrainState*)(state)) isDying]) for(TRCarState* car in [((TRTrainState*)(state)) carStates]) {
                TRCarTypeR tp = ((TRCarState*)(car))->_carType;
                {
                    PGMatrixStack* __tmp__il__0rt_0r_1self = [PGGlobal matrix];
                    {
                        [__tmp__il__0rt_0r_1self push];
                        {
                            PGMMatrixModel* _ = [__tmp__il__0rt_0r_1self value];
                            [_ modifyM:^PGMat4*(PGMat4* m) {
                                return [[[((TRCarState*)(car)) matrix] translateX:0.0 y:0.0 z:((float)(-[TRCarType value:tp].height / 2 + 0.04))] mulMatrix:[m rotateAngle:90.0 x:0.0 y:1.0 z:0.0]];
                            }];
                        }
                        [_models drawTrainState:state carType:tp];
                        [__tmp__il__0rt_0r_1self pop];
                    }
                }
            }
            else for(TRLiveCarState* car in ((TRLiveTrainState*)(state))->_carStates) {
                PGMatrixStack* __tmp__il__0rf_0rself = [PGGlobal matrix];
                {
                    [__tmp__il__0rf_0rself push];
                    {
                        PGMMatrixModel* _ = [__tmp__il__0rf_0rself value];
                        [[_ modifyW:^PGMat4*(PGMat4* w) {
                            PGVec2 mid = ((TRLiveCarState*)(car))->_midPoint;
                            return [w translateX:mid.x y:mid.y z:0.04];
                        }] modifyM:^PGMat4*(PGMat4* m) {
                            return [m rotateAngle:pgLine2DegreeAngle(((TRLiveCarState*)(car))->_line) + 90 x:0.0 y:1.0 z:0.0];
                        }];
                    }
                    [_models drawTrainState:state carType:((TRLiveCarState*)(car))->_carType];
                    [__tmp__il__0rf_0rself pop];
                }
            }
        }
    }
}

- (void)drawSmoke {
    [_smokeView draw];
}

- (NSString*)description {
    return [NSString stringWithFormat:@"TrainView(%@, %@)", _models, _train];
}

- (CNClassType*)type {
    return [TRTrainView type];
}

+ (CNClassType*)type {
    return _TRTrainView_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation TRTrainModels
static NSArray* _TRTrainModels_crazyColors;
static CNClassType* _TRTrainModels_type;

+ (instancetype)trainModels {
    return [[TRTrainModels alloc] init];
}

- (instancetype)init {
    self = [super init];
    if(self) {
        _engineModel = [TRCarModel applyColorMesh:[TRModels engine] blackMesh:[TRModels engineBlack] shadowMesh:[TRModels engineShadow] texture:[PGGlobal compressedTextureForFile:@"Engine"] normalMap:[PGGlobal compressedTextureForFile:@"engine_normals"]];
        _carModel = [TRCarModel applyColorMesh:[TRModels car] blackMesh:[TRModels carBlack] shadowMesh:[TRModels carShadow] texture:[PGGlobal compressedTextureForFile:@"Car"] normalMap:nil];
        _expressEngineModel = [TRCarModel applyColorMesh:[TRModels expressEngine] blackMesh:[TRModels expressEngineBlack] shadowMesh:[TRModels expressEngineShadow] texture:[PGGlobal compressedTextureForFile:@"ExpressEngine"] normalMap:nil];
        _expressCarModel = [TRCarModel applyColorMesh:[TRModels expressCar] blackMesh:[TRModels expressCarBlack] shadowMesh:[TRModels expressCarShadow] texture:[PGGlobal compressedTextureForFile:@"ExpressCar"] normalMap:nil];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [TRTrainModels class]) {
        _TRTrainModels_type = [CNClassType classTypeWithCls:[TRTrainModels class]];
        _TRTrainModels_crazyColors = [[[[[[[TRCityColor values] chain] excludeCollection:(@[[TRCityColor value:TRCityColor_grey]])] mapF:^id(TRCityColor* cityColor) {
            return wrap(PGVec4, [TRCityColor value:((TRCityColorR)([cityColor ordinal] + 1))].color);
        }] neighboursRing] mapF:^id(CNTuple* colors) {
            return [PGProgress progressVec4:uwrap(PGVec4, ((CNTuple*)(colors))->_a) vec42:uwrap(PGVec4, ((CNTuple*)(colors))->_b)];
        }] toArray];
    }
}

+ (PGVec4)crazyColorTime:(CGFloat)time {
    CGFloat f = floatFraction(time / 2) * [_TRTrainModels_crazyColors count] - 0.0001;
    PGVec4(^cc)(float) = [_TRTrainModels_crazyColors applyIndex:((NSInteger)(f))];
    return cc(((float)(floatFraction(f))));
}

- (void)drawTrainState:(TRTrainState*)trainState carType:(TRCarTypeR)carType {
    PGVec4 color = ((trainState->_train->_trainType == TRTrainType_crazy) ? [TRTrainModels crazyColorTime:trainState->_time] : [TRCityColor value:trainState->_train->_color].trainColor);
    if(carType == TRCarType_car) {
        [_carModel drawColor:color];
    } else {
        if(carType == TRCarType_engine) {
            [_engineModel drawColor:color];
        } else {
            if(carType == TRCarType_expressEngine) {
                [_expressEngineModel drawColor:color];
            } else {
                if(carType == TRCarType_expressCar) [_expressCarModel drawColor:color];
            }
        }
    }
}

- (NSString*)description {
    return @"TrainModels";
}

- (CNClassType*)type {
    return [TRTrainModels type];
}

+ (CNClassType*)type {
    return _TRTrainModels_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation TRCarModel
static PGStandardMaterial* _TRCarModel_blackMaterial;
static CNClassType* _TRCarModel_type;
@synthesize colorVao = _colorVao;
@synthesize blackVao = _blackVao;
@synthesize shadowVao = _shadowVao;
@synthesize texture = _texture;
@synthesize normalMap = _normalMap;

+ (instancetype)carModelWithColorVao:(PGVertexArray*)colorVao blackVao:(PGVertexArray*)blackVao shadowVao:(PGVertexArray*)shadowVao texture:(PGTexture*)texture normalMap:(PGTexture*)normalMap {
    return [[TRCarModel alloc] initWithColorVao:colorVao blackVao:blackVao shadowVao:shadowVao texture:texture normalMap:normalMap];
}

- (instancetype)initWithColorVao:(PGVertexArray*)colorVao blackVao:(PGVertexArray*)blackVao shadowVao:(PGVertexArray*)shadowVao texture:(PGTexture*)texture normalMap:(PGTexture*)normalMap {
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
        _TRCarModel_type = [CNClassType classTypeWithCls:[TRCarModel class]];
        _TRCarModel_blackMaterial = [PGStandardMaterial applyDiffuse:[PGColorSource applyColor:PGVec4Make(0.0, 0.0, 0.0, 1.0)]];
    }
}

+ (PGStandardMaterial*)trainMaterialForDiffuse:(PGColorSource*)diffuse normalMap:(PGTexture*)normalMap {
    return [PGStandardMaterial standardMaterialWithDiffuse:diffuse specularColor:PGVec4Make(0.1, 0.1, 0.1, 1.0) specularSize:0.1 normalMap:({
        PGTexture* _ = normalMap;
        ((_ != nil) ? [PGNormalMap normalMapWithTexture:_ tangent:NO] : nil);
    })];
}

+ (TRCarModel*)applyColorMesh:(PGMesh*)colorMesh blackMesh:(PGMesh*)blackMesh shadowMesh:(PGMesh*)shadowMesh texture:(PGTexture*)texture normalMap:(PGTexture*)normalMap {
    PGStandardMaterial* defMat;
    {
        PGStandardMaterial* __tmp_0;
        {
            PGTexture* _ = texture;
            if(_ != nil) __tmp_0 = [TRCarModel trainMaterialForDiffuse:[PGColorSource colorSourceWithColor:PGVec4Make(1.0, 0.0, 0.0, 1.0) texture:((PGTexture*)(_)) blendMode:PGBlendMode_multiply alphaTestLevel:-1.0] normalMap:normalMap];
            else __tmp_0 = nil;
        }
        if(__tmp_0 != nil) defMat = ((PGStandardMaterial*)(__tmp_0));
        else defMat = [TRCarModel trainMaterialForDiffuse:[PGColorSource applyColor:PGVec4Make(1.0, 1.0, 1.0, 1.0)] normalMap:normalMap];
    }
    return [TRCarModel carModelWithColorVao:[colorMesh vaoMaterial:defMat shadow:NO] blackVao:[blackMesh vaoMaterial:_TRCarModel_blackMaterial shadow:NO] shadowVao:[shadowMesh vaoShadowMaterial:[PGColorSource applyColor:PGVec4Make(1.0, 1.0, 1.0, 1.0)]] texture:texture normalMap:normalMap];
}

- (void)drawColor:(PGVec4)color {
    if([[PGGlobal context]->_renderTarget isShadow]) {
        [_shadowVao draw];
    } else {
        [_colorVao drawParam:[TRCarModel trainMaterialForDiffuse:[PGColorSource colorSourceWithColor:color texture:_texture blendMode:PGBlendMode_multiply alphaTestLevel:-1.0] normalMap:_normalMap]];
        [_blackVao draw];
    }
}

- (NSString*)description {
    return [NSString stringWithFormat:@"CarModel(%@, %@, %@, %@, %@)", _colorVao, _blackVao, _shadowVao, _texture, _normalMap];
}

- (CNClassType*)type {
    return [TRCarModel type];
}

+ (PGStandardMaterial*)blackMaterial {
    return _TRCarModel_blackMaterial;
}

+ (CNClassType*)type {
    return _TRCarModel_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

