#import "TRModels.h"

#import "PGMesh.h"
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
static PGMesh*_railTies = nil;
static PGMesh*_railGravel = nil;
static PGMesh*_rails = nil;
static PGMesh*_railTurnTies = nil;
static PGMesh*_railTurnGravel = nil;
static PGMesh*_railsTurn = nil;
static PGMesh *_switchStraight = nil;
static PGMesh *_switchTurn = nil;
static PGMeshDataModel *_light = nil;
static PGMesh *_city = nil;
static PGMesh *_engineBlack = nil;
static PGMesh *_engine = nil;
static PGMesh *_engineShadow = nil;
static PGMesh *_carBlack = nil;
static PGMesh *_car = nil;
static PGMesh *_carShadow = nil;
static PGMesh *_damage = nil;
static CNPArray *_lightGreenGlow = nil;
static CNPArray *_lightRedGlow = nil;
static CNPArray *_lightIndex = nil;
static PGMesh *_expressCar = nil;
static PGMesh *_expressCarBlack = nil;
static PGMesh *_expressCarShadow = nil;
static PGMesh *_expressEngine = nil;
static PGMesh *_expressEngineBlack = nil;
static PGMesh *_expressEngineShadow = nil;

static CNClassType* _TR3D_type;

+ (id)r3D {
    return [[TRModels alloc] init];
}

- (id)init {
    self = [super init];

    return self;
}

+ (void)initialize {
    [super initialize];
    _TR3D_type = [CNClassType classTypeWithCls:[TRModels class]];
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

- (CNType*)type {
    return _TR3D_type;
}

+ (PGMesh*)railTies {
    return _railTies;
}

+ (PGMesh*)railGravel {
    return _railGravel;
}

+ (PGMesh*)rails {
    return _rails;
}

+ (PGMesh*)railTurnTies {
    return _railTurnTies;
}

+ (PGMesh*)railTurnGravel {
    return _railTurnGravel;
}

+ (PGMesh*)railsTurn {
    return _railsTurn;
}

+ (PGMesh *)switchStraight {
    return _switchStraight;
}

+ (PGMesh *)switchTurn {
    return _switchTurn;
}

+ (PGMeshDataModel *)light {
    return _light;
}


+ (CNType*)type {
    return _TR3D_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

+ (PGMesh *)city {
    return _city;
}

+ (PGMesh *)car {
    return _car;
}

+ (PGMesh *)carBlack {
    return _carBlack;
}

+ (PGMesh *)engine {
    return _engine;
}

+ (PGMesh *)engineBlack {
    return _engineBlack;
}

+ (PGMesh *)damage {
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

+ (PGMesh *)carShadow {
    return _carShadow;
}

+ (PGMesh *)engineShadow {
    return _engineShadow;
}

+ (PGMesh *)expressCar {
    return _expressCar;
}

+ (PGMesh *)expressCarBlack {
    return _expressCarBlack;
}

+ (PGMesh *)expressCarShadow {
    return _expressCarShadow;
}

+ (PGMesh *)expressEngine {
    return _expressEngine;
}

+ (PGMesh *)expressEngineBlack {
    return _expressEngineBlack;
}

+ (PGMesh *)expressEngineShadow {
    return _expressEngineShadow;
}

@end


