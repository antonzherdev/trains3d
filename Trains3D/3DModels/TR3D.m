#import "TR3D.h"

#import "EGMesh.h"
#import "TR3DRail.h"
#import "TR3DRailTurn.h"
#import "TR3DSwitch.h"
#import "TR3DLight.h"
#import "TR3DCity.h"
#import "TR3DCar.h"
#import "TR3DEngine.h"


@implementation TR3D
static EGMesh*_railTies = nil;
static EGMesh*_railGravel = nil;
static EGMesh*_rails = nil;
static EGMesh*_railTurnTies = nil;
static EGMesh*_railTurnGravel = nil;
static EGMesh*_railsTurn = nil;
static EGMesh *_switchStraight = nil;
static EGMesh *_switchTurn = nil;
static EGMesh *_light = nil;
static EGMesh *_city = nil;
static EGMesh *_engineFloor = nil;
static EGMesh *_engineBlack = nil;
static EGMesh *_engine = nil;
static EGMesh *_carBlack = nil;
static EGMesh *_car = nil;


static ODType* _TR3D_type;

+ (id)r3D {
    return [[TR3D alloc] init];
}

- (id)init {
    self = [super init];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _TR3D_type = [ODType typeWithCls:[TR3D class]];
    _railTies = egJasModel(RailTies);
    _railGravel = egJasModel(RailGravel);
    _rails = egJasModel(Rails);
    _railTurnTies = egJasModel(RailTurnTies);
    _railTurnGravel = egJasModel(RailTurnGravel);
    _railsTurn = egJasModel(RailsTurn);
    _switchStraight = egJasModel(SwitchStraight);
    _switchTurn = egJasModel(SwitchTurn);
    _light = egJasModel(Light);
    _city = egJasModel(City);
    _engineFloor = egJasModel(EngineFloor);
    _engineBlack = egJasModel(EngineBlack);
    _engine = egJasModel(Engine);
    _carBlack = egJasModel(CarBlack);
    _car = egJasModel(Car);
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

+ (EGMesh *)light {
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

+ (EGMesh *)engineFloor {
    return _engineFloor;
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


