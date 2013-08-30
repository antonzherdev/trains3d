#import "TRRailroadView.h"
#import "TR3DRailTurn.h"
#import "TR3DSwitch.h"

#import "EGMesh.h"
#import "EG.h"
#import "EGTexture.h"
#import "EGMaterial.h"
#import "EGContext.h"
#import "TRRailroad.h"
#import "TRRailPoint.h"
#import "TR3D.h"
@implementation TRRailroadView{
    TRRailView* _railView;
    TRSwitchView* _switchView;
    TRLightView* _lightView;
    TRDamageView* _damageView;
}
static ODType* _TRRailroadView_type;

+ (id)railroadView {
    return [[TRRailroadView alloc] init];
}

- (id)init {
    self = [super init];
    if(self) {
        _railView = [TRRailView railView];
        _switchView = [TRSwitchView switchView];
        _lightView = [TRLightView lightView];
        _damageView = [TRDamageView damageView];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _TRRailroadView_type = [ODType typeWithCls:[TRRailroadView class]];
}

- (void)drawRailroad:(TRRailroad*)railroad {
    [[railroad rails] forEach:^void(TRRail* _) {
        [_railView drawRail:_];
    }];
    [[railroad switches] forEach:^void(TRSwitch* _) {
        [_switchView drawTheSwitch:_];
    }];
    [[railroad lights] forEach:^void(TRLight* _) {
        [_lightView drawLight:_];
    }];
    [[railroad.builder rail] forEach:^void(TRRail* _) {
        [_railView drawRail:_];
    }];
    [[railroad damagesPoints] forEach:^void(TRRailPoint* _) {
        [_damageView drawPoint:_];
    }];
}

- (ODType*)type {
    return _TRRailroadView_type;
}

+ (ODType*)type {
    return _TRRailroadView_type;
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


@implementation TRRailView{
    EGMeshModel* _railModel;
}
static ODType* _TRRailView_type;
@synthesize railModel = _railModel;

+ (id)railView {
    return [[TRRailView alloc] init];
}

- (id)init {
    self = [super init];
    if(self) _railModel = [EGMeshModel meshModelWithMeshes:(@[tuple(TR3D.railGravel, ((EGMaterial2*)([EGMaterial2 applyTexture:[EG textureForFile:@"Gravel.png"]]))), tuple(TR3D.railTies, ((EGMaterial2*)([EGMaterial2 applyColor:EGColorMake(0.55, 0.45, 0.25, 1.0)]))), tuple(TR3D.rails, [EGStandardMaterial standardMaterialWithDiffuse:[EGColorSource applyColor:EGColorMake(0.45, 0.47, 0.55, 1.0)] specular:EGColorMake(0.5, 0.5, 0.5, 1.0)])])];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _TRRailView_type = [ODType typeWithCls:[TRRailView class]];
}

- (void)drawRail:(TRRail*)rail {
    EGMutableMatrix* m = [EG worldMatrix];
    [m push];
    [m translateX:((CGFloat)(rail.tile.x)) y:((CGFloat)(rail.tile.y)) z:0.001];
    if(rail.form == TRRailForm.bottomTop || rail.form == TRRailForm.leftRight) {
        if(rail.form == TRRailForm.leftRight) [m rotateAngle:90.0 x:0.0 y:0.0 z:1.0];
        [_railModel draw];
    } else {
        if(rail.form == TRRailForm.topRight) {
            [m rotateAngle:270.0 x:0.0 y:0.0 z:1.0];
        } else {
            if(rail.form == TRRailForm.bottomRight) {
                [m rotateAngle:180.0 x:0.0 y:0.0 z:1.0];
            } else {
                if(rail.form == TRRailForm.leftBottom) [m rotateAngle:90.0 x:0.0 y:0.0 z:1.0];
            }
        }
        [m rotateAngle:90.0 x:1.0 y:0.0 z:0.0];
        egColor3(0.5, 0.5, 0.5);
        [EGMaterial.stone set];
        [[EG textureForFile:@"Gravel.png"] draw:^void() {
            egDrawJasModel(RailTurnGravel);
        }];
        [EGMaterial.wood set];
        egDrawJasModel(RailTurnTies);
        [EGMaterial.steel set];
        egDrawJasModel(RailsTurn);
    }
    [m pop];
}

- (ODType*)type {
    return _TRRailView_type;
}

+ (ODType*)type {
    return _TRRailView_type;
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


@implementation TRSwitchView
static ODType* _TRSwitchView_type;

+ (id)switchView {
    return [[TRSwitchView alloc] init];
}

- (id)init {
    self = [super init];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _TRSwitchView_type = [ODType typeWithCls:[TRSwitchView class]];
}

- (void)drawTheSwitch:(TRSwitch*)theSwitch {
    TRRailConnector* connector = theSwitch.connector;
    glPushMatrix();
    egTranslate(((CGFloat)(theSwitch.tile.x)), ((CGFloat)(theSwitch.tile.y)), 0.03);
    egRotate(((CGFloat)(connector.angle)), 0.0, 0.0, 1.0);
    TRRail* rail = [theSwitch activeRail];
    TRRailForm* form = rail.form;
    [EGMaterial.emerald set];
    egTranslate(-0.5, 0.0, 0.0);
    if(form.start.x + form.end.x == 0) {
        egRotate(90.0, 1.0, 0.0, 0.0);
        egDrawJasModel(SwitchStraight);
    } else {
        TRRailConnector* otherConnector = ((form.start == connector) ? form.end : form.start);
        NSInteger x = connector.x;
        NSInteger y = connector.y;
        NSInteger ox = otherConnector.x;
        NSInteger oy = otherConnector.y;
        if((x == -1 && oy == -1) || (y == 1 && ox == -1) || (y == -1 && ox == 1) || (x == 1 && oy == 1)) egScale(1.0, -1.0, 1.0);
        egRotate(90.0, 1.0, 0.0, 0.0);
        egDrawJasModel(SwitchTurn);
    }
    glPopMatrix();
}

- (ODType*)type {
    return _TRSwitchView_type;
}

+ (ODType*)type {
    return _TRSwitchView_type;
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


@implementation TRLightView
static ODType* _TRLightView_type;

+ (id)lightView {
    return [[TRLightView alloc] init];
}

- (id)init {
    self = [super init];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _TRLightView_type = [ODType typeWithCls:[TRLightView class]];
}

- (void)drawLight:(TRLight*)light {
    glPushMatrix();
    egTranslate(((CGFloat)(light.tile.x)), ((CGFloat)(light.tile.y)), 0.0);
    egRotate(((CGFloat)(light.connector.angle)), 0.0, 0.0, 1.0);
    egTranslate(-0.45, 0.2, 0.0);
    if(light.isGreen) [EGMaterial.emerald set];
    else [EGMaterial.ruby set];
    glutSolidCube(0.1);
    glPopMatrix();
}

- (ODType*)type {
    return _TRLightView_type;
}

+ (ODType*)type {
    return _TRLightView_type;
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


@implementation TRDamageView
static ODType* _TRDamageView_type;

+ (id)damageView {
    return [[TRDamageView alloc] init];
}

- (id)init {
    self = [super init];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _TRDamageView_type = [ODType typeWithCls:[TRDamageView class]];
}

- (void)drawPoint:(TRRailPoint*)point {
    glPushMatrix();
    egTranslate(point.point.x, point.point.y, 0.01);
    egColor4(1.0, 0.0, 0.0, 0.5);
    egNormal3(0.0, 0.0, 1.0);
    egRect(-0.1, -0.1, 0.1, 0.1);
    glPopMatrix();
}

- (ODType*)type {
    return _TRDamageView_type;
}

+ (ODType*)type {
    return _TRDamageView_type;
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


