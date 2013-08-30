#import "TRRailroadView.h"

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
    EGMeshModel* _railTurnModel;
}
static ODType* _TRRailView_type;
@synthesize railModel = _railModel;
@synthesize railTurnModel = _railTurnModel;

+ (id)railView {
    return [[TRRailView alloc] init];
}

- (id)init {
    self = [super init];
    if(self) {
        _railModel = [EGMeshModel meshModelWithMeshes:(@[tuple(TR3D.railGravel, ((EGMaterial2*)([EGMaterial2 applyTexture:[EG textureForFile:@"Gravel.png"]]))), tuple(TR3D.railTies, ((EGMaterial2*)([EGMaterial2 applyColor:EGColorMake(0.55, 0.45, 0.25, 1.0)]))), tuple(TR3D.rails, [EGStandardMaterial standardMaterialWithDiffuse:[EGColorSource applyColor:EGColorMake(0.45, 0.47, 0.55, 1.0)] specularColor:EGColorMake(0.5, 0.5, 0.5, 1.0) specularSize:1.0])])];
        _railTurnModel = [EGMeshModel meshModelWithMeshes:(@[tuple(TR3D.railTurnGravel, ((EGMaterial2*)([EGMaterial2 applyTexture:[EG textureForFile:@"Gravel.png"]]))), tuple(TR3D.railTurnTies, ((EGMaterial2*)([EGMaterial2 applyColor:EGColorMake(0.55, 0.45, 0.25, 1.0)]))), tuple(TR3D.railsTurn, [EGStandardMaterial standardMaterialWithDiffuse:[EGColorSource applyColor:EGColorMake(0.45, 0.47, 0.55, 1.0)] specularColor:EGColorMake(0.5, 0.5, 0.5, 1.0) specularSize:1.0])])];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _TRRailView_type = [ODType typeWithCls:[TRRailView class]];
}

- (void)drawRail:(TRRail*)rail {
    [EG keepMWF:^void() {
        [[EG worldMatrix] translateX:((CGFloat)(rail.tile.x)) y:((CGFloat)(rail.tile.y)) z:0.001];
        if(rail.form == TRRailForm.bottomTop || rail.form == TRRailForm.leftRight) {
            if(rail.form == TRRailForm.leftRight) [[EG modelMatrix] rotateAngle:90.0 x:0.0 y:1.0 z:0.0];
            [_railModel draw];
        } else {
            if(rail.form == TRRailForm.topRight) {
                [[EG modelMatrix] rotateAngle:270.0 x:0.0 y:1.0 z:0.0];
            } else {
                if(rail.form == TRRailForm.bottomRight) {
                    [[EG modelMatrix] rotateAngle:180.0 x:0.0 y:1.0 z:0.0];
                } else {
                    if(rail.form == TRRailForm.leftBottom) [[EG modelMatrix] rotateAngle:90.0 x:0.0 y:1.0 z:0.0];
                }
            }
            [_railTurnModel draw];
        }
    }];
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


@implementation TRSwitchView{
    EGStandardMaterial* _material;
    EGMeshModel* _switchStraightModel;
    EGMeshModel* _switchTurnModel;
}
static ODType* _TRSwitchView_type;
@synthesize material = _material;
@synthesize switchStraightModel = _switchStraightModel;
@synthesize switchTurnModel = _switchTurnModel;

+ (id)switchView {
    return [[TRSwitchView alloc] init];
}

- (id)init {
    self = [super init];
    if(self) {
        _material = [EGStandardMaterial standardMaterialWithDiffuse:[EGColorSource applyColor:EGColorMake(0.07568, 0.61424, 0.07568, 1.0)] specularColor:EGColorMake(0.633, 0.727811, 0.633, 1.0) specularSize:1.0];
        _switchStraightModel = [EGMeshModel meshModelWithMeshes:(@[tuple(TR3D.switchStraight, _material)])];
        _switchTurnModel = [EGMeshModel meshModelWithMeshes:(@[tuple(TR3D.switchTurn, _material)])];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _TRSwitchView_type = [ODType typeWithCls:[TRSwitchView class]];
}

- (void)drawTheSwitch:(TRSwitch*)theSwitch {
    [EG keepMWF:^void() {
        TRRailConnector* connector = theSwitch.connector;
        [[EG worldMatrix] translateX:((CGFloat)(theSwitch.tile.x)) y:((CGFloat)(theSwitch.tile.y)) z:0.03];
        [[EG modelMatrix] rotateAngle:((CGFloat)(connector.angle)) x:0.0 y:1.0 z:0.0];
        TRRail* rail = [theSwitch activeRail];
        TRRailForm* form = rail.form;
        [EGMaterial.emerald set];
        [[EG modelMatrix] translateX:-0.5 y:0.0 z:0.0];
        if(form.start.x + form.end.x == 0) {
            [_switchStraightModel draw];
        } else {
            TRRailConnector* otherConnector = ((form.start == connector) ? form.end : form.start);
            NSInteger x = connector.x;
            NSInteger y = connector.y;
            NSInteger ox = otherConnector.x;
            NSInteger oy = otherConnector.y;
            if((x == -1 && oy == -1) || (y == 1 && ox == -1) || (y == -1 && ox == 1) || (x == 1 && oy == 1)) [[EG modelMatrix] scaleX:1.0 y:1.0 z:-1.0];
            [_switchTurnModel draw];
        }
    }];
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


@implementation TRLightView{
    EGStandardMaterial* _greenMaterial;
    EGStandardMaterial* _redMaterial;
}
static ODType* _TRLightView_type;
@synthesize greenMaterial = _greenMaterial;
@synthesize redMaterial = _redMaterial;

+ (id)lightView {
    return [[TRLightView alloc] init];
}

- (id)init {
    self = [super init];
    if(self) {
        _greenMaterial = [EGStandardMaterial standardMaterialWithDiffuse:[EGColorSource applyColor:EGColorMake(0.07568, 0.61424, 0.07568, 1.0)] specularColor:EGColorMake(0.633, 0.727811, 0.633, 1.0) specularSize:1.0];
        _redMaterial = [EGStandardMaterial standardMaterialWithDiffuse:[EGColorSource applyColor:EGColorMake(0.61424, 0.04136, 0.04136, 1.0)] specularColor:EGColorMake(0.727811, 0.626959, 0.626959, 1.0) specularSize:1.0];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _TRLightView_type = [ODType typeWithCls:[TRLightView class]];
}

- (void)drawLight:(TRLight*)light {
    [EG keepMWF:^void() {
        [[EG worldMatrix] translateX:((CGFloat)(light.tile.x)) y:((CGFloat)(light.tile.y)) z:0.0];
        [[EG modelMatrix] rotateAngle:((CGFloat)(light.connector.angle)) x:0.0 y:1.0 z:0.0];
        [[EG modelMatrix] translateX:-0.45 y:0.0 z:-0.2];
        [TR3D.light drawWithMaterial:((light.isGreen) ? _greenMaterial : _redMaterial)];
    }];
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


@implementation TRDamageView{
    EGMeshModel* _model;
}
static ODType* _TRDamageView_type;
@synthesize model = _model;

+ (id)damageView {
    return [[TRDamageView alloc] init];
}

- (id)init {
    self = [super init];
    if(self) _model = [EGMeshModel meshModelWithMeshes:(@[tuple(TR3D.damage, ((EGMaterial2*)([EGMaterial2 applyColor:EGColorMake(1.0, 0.0, 0.0, 1.0)])))])];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _TRDamageView_type = [ODType typeWithCls:[TRDamageView class]];
}

- (void)drawPoint:(TRRailPoint*)point {
    [[EG worldMatrix] keepF:^void() {
        [[EG worldMatrix] translateX:point.point.x y:point.point.y z:0.0];
        [_model draw];
    }];
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


