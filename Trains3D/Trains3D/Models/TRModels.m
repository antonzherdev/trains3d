#import "TRModels.h"

#import "EGMesh.h"
#import "TR3DRail.h"
#import "TR3DRailTurn.h"
#import "TR3DSwitch.h"
#import "TR3DLight.h"
#import "TR3DCity.h"
#import "TR3DCar.h"
#import "TR3DExpressCar.h"
#import "TR3DEngine.h"
#import "TR3DExpressEngine.h"
#import "TR3DDamage.h"



@implementation TRModels
static EGMesh*_railTies = nil;
static EGMesh*_railGravel = nil;
static EGMesh*_rails = nil;
static EGMesh*_railTurnTies = nil;
static EGMesh*_railTurnGravel = nil;
static EGMesh*_railsTurn = nil;
static EGMesh *_switchStraight = nil;
static EGMesh *_switchTurn = nil;
static EGMeshDataModel *_light = nil;
static EGMesh *_city = nil;
static EGMesh *_engineBlack = nil;
static EGMesh *_engine = nil;
static EGMesh *_engineShadow = nil;
static EGMesh *_carBlack = nil;
static EGMesh *_car = nil;
static EGMesh *_carShadow = nil;
static EGMesh *_damage = nil;
static CNPArray *_lightGreenGlow = nil;
static CNPArray *_lightRedGlow = nil;
static CNPArray *_lightIndex = nil;
static EGMesh *_expressCar = nil;
static EGMesh *_expressCarBlack = nil;
static EGMesh *_expressCarShadow = nil;
static EGMesh *_expressEngine = nil;
static EGMesh *_expressEngineBlack = nil;
static EGMesh *_expressEngineShadow = nil;

static ODClassType* _TR3D_type;

+ (id)r3D {
    return [[TRModels alloc] init];
}

- (id)init {
    self = [super init];

    return self;
}

+ (void)initialize {
    [super initialize];
    _TR3D_type = [ODClassType classTypeWithCls:[TRModels class]];
    _railTies = egJasModel(RailTies);
    _railGravel = egJasModel(RailGravel);
    _rails = egJasModel(Rails);
    _railTurnTies = egJasModel(RailTurnTies);
    _railTurnGravel = egJasModel(RailTurnGravel);
    _railsTurn = egJasModel(RailsTurn);
    _switchStraight = egJasModel(SwitchStraight);
    _switchTurn = egJasModel(SwitchTurn);
    _light = egMeshDataModel(Light);
    _lightGreenGlow = egJasVbo(LightGreenGlow);
    _lightRedGlow = egJasVbo(LightRedGlow);
    _lightIndex = egJasIbo(LightGreenGlow);
    _city = egJasModel(City);
    _damage = egJasModel(Damage);

    _engine = egJasModel(Engine);
    _engineBlack = egJasModel(EngineBlack);
    _engineShadow = egJasModel(EngineShadow);


    _car = egJasModel(Car);
    _carBlack = egJasModel(CarBlack);
    _carShadow = egJasModel(CarShadow);

    _expressCar = egJasModel(ExpressCar);
    _expressCarBlack = egJasModel(ExpressCarBlack);
    _expressCarShadow = egJasModel(ExpressCarShadow);

    _expressEngine = egJasModel(ExpressEngine);
    _expressEngineBlack = egJasModel(ExpressEngineBlack);
    _expressEngineShadow = egJasModel(ExpressEngine);
}

- (ODType*)type {
    return _TR3D_type;
}

+ (EGMesh*)railTies {
    return _railTies;
}

+ (EGMesh*)railGravel {
    return _railGravel;
}

+ (EGMesh*)rails {
    return _rails;
}

+ (EGMesh*)railTurnTies {
    return _railTurnTies;
}

+ (EGMesh*)railTurnGravel {
    return _railTurnGravel;
}

+ (EGMesh*)railsTurn {
    return _railsTurn;
}

+ (EGMesh *)switchStraight {
    return _switchStraight;
}

+ (EGMesh *)switchTurn {
    return _switchTurn;
}

+ (EGMeshDataModel *)light {
    return _light;
}


+ (ODType*)type {
    return _TR3D_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

+ (EGMesh *)city {
    return _city;
}

+ (EGMesh *)car {
    return _car;
}

+ (EGMesh *)carBlack {
    return _carBlack;
}

+ (EGMesh *)engine {
    return _engine;
}

+ (EGMesh *)engineBlack {
    return _engineBlack;
}

+ (EGMesh *)damage {
    return _damage;
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

+ (CNPArray *)lightGreenGlow {
    return _lightGreenGlow;
}

+ (CNPArray *)lightRedGlow {
    return _lightRedGlow;
}

+ (CNPArray *)lightGlowIndex {
    return _lightIndex;
}

+ (EGMesh *)carShadow {
    return _carShadow;
}

+ (EGMesh *)engineShadow {
    return _engineShadow;
}

+ (EGMesh *)expressCar {
    return _expressCar;
}

+ (EGMesh *)expressCarBlack {
    return _expressCarBlack;
}

+ (EGMesh *)expressCarShadow {
    return _expressCarShadow;
}

+ (EGMesh *)expressEngine {
    return _expressEngine;
}

+ (EGMesh *)expressEngineBlack {
    return _expressEngineBlack;
}

+ (EGMesh *)expressEngineShadow {
    return _expressEngineShadow;
}

@end


