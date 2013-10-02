#import "TRRailroadView.h"

#import "TRRailroad.h"
#import "EGSurface.h"
#import "GL.h"
#import "TRModels.h"
#import "EGContext.h"
#import "GEMat4.h"
#import "TRRailPoint.h"
#import "EGMapIso.h"
@implementation TRRailroadView{
    TRRailroad* _railroad;
    TRRailView* _railView;
    TRSwitchView* _switchView;
    TRLightView* _lightView;
    TRDamageView* _damageView;
    EGViewportSurface* _railroadSurface;
    TRBackgroundView* _backgroundView;
    BOOL _changed;
}
static ODClassType* _TRRailroadView_type;
@synthesize railroad = _railroad;

+ (id)railroadViewWithRailroad:(TRRailroad*)railroad {
    return [[TRRailroadView alloc] initWithRailroad:railroad];
}

- (id)initWithRailroad:(TRRailroad*)railroad {
    self = [super init];
    if(self) {
        _railroad = railroad;
        _railView = [TRRailView railView];
        _switchView = [TRSwitchView switchView];
        _lightView = [TRLightView lightView];
        _damageView = [TRDamageView damageView];
        _railroadSurface = [EGViewportSurface viewportSurfaceWithDepth:YES multisampling:YES];
        _backgroundView = [TRBackgroundView backgroundViewWithMap:_railroad.map];
        _changed = YES;
        [self _init];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _TRRailroadView_type = [ODClassType classTypeWithCls:[TRRailroadView class]];
}

- (void)_init {
    [_railroad addChangeListener:^void() {
        _changed = YES;
    }];
}

- (void)drawBackground {
    glClear(GL_COLOR_BUFFER_BIT + GL_DEPTH_BUFFER_BIT);
    [_backgroundView draw];
    [[_railroad rails] forEach:^void(TRRail* _) {
        [_railView drawRail:_];
    }];
    [[_railroad switches] forEach:^void(TRSwitch* _) {
        [_switchView drawTheSwitch:_];
    }];
    [[_railroad.builder rail] forEach:^void(TRRail* _) {
        [_railView drawRail:_];
    }];
    [[_railroad damagesPoints] forEach:^void(TRRailPoint* _) {
        [_damageView drawPoint:_];
    }];
}

- (void)drawForeground {
    [[_railroad lights] forEach:^void(TRRailLight* _) {
        [_lightView drawLight:_];
    }];
}

- (ODClassType*)type {
    return [TRRailroadView type];
}

+ (ODClassType*)type {
    return _TRRailroadView_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    TRRailroadView* o = ((TRRailroadView*)(other));
    return [self.railroad isEqual:o.railroad];
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.railroad hash];
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"railroad=%@", self.railroad];
    [description appendString:@">"];
    return description;
}

@end


@implementation TRRailView{
    EGStandardMaterial* _railMaterial;
    EGMeshModel* _railModel;
    EGMeshModel* _railTurnModel;
}
static ODClassType* _TRRailView_type;
@synthesize railMaterial = _railMaterial;
@synthesize railModel = _railModel;
@synthesize railTurnModel = _railTurnModel;

+ (id)railView {
    return [[TRRailView alloc] init];
}

- (id)init {
    self = [super init];
    if(self) {
        _railMaterial = [EGStandardMaterial standardMaterialWithDiffuse:[EGColorSource applyColor:GEVec4Make(0.5, 0.5, 0.6, 1.0)] specularColor:GEVec4Make(0.5, 0.5, 0.5, 1.0) specularSize:0.3];
        _railModel = [EGMeshModel meshModelWithMeshes:(@[tuple(TRModels.railGravel, ((EGMaterial*)([EGMaterial applyTexture:[EGGlobal textureForFile:@"Gravel.png"]]))), tuple(TRModels.railTies, ((EGMaterial*)([EGMaterial applyColor:GEVec4Make(0.55, 0.45, 0.25, 1.0)]))), tuple(TRModels.rails, _railMaterial)])];
        _railTurnModel = [EGMeshModel meshModelWithMeshes:(@[tuple(TRModels.railTurnGravel, ((EGMaterial*)([EGMaterial applyTexture:[EGGlobal textureForFile:@"Gravel.png"]]))), tuple(TRModels.railTurnTies, ((EGMaterial*)([EGMaterial applyColor:GEVec4Make(0.55, 0.45, 0.25, 1.0)]))), tuple(TRModels.railsTurn, _railMaterial)])];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _TRRailView_type = [ODClassType classTypeWithCls:[TRRailView class]];
}

- (void)drawRail:(TRRail*)rail {
    [EGGlobal.matrix applyModify:^EGMatrixModel*(EGMatrixModel* _) {
        return [[_ modifyW:^GEMat4*(GEMat4* w) {
            return [w translateX:((float)(rail.tile.x)) y:((float)(rail.tile.y)) z:0.001];
        }] modifyM:^GEMat4*(GEMat4* m) {
            if(rail.form == TRRailForm.bottomTop || rail.form == TRRailForm.leftRight) {
                if(rail.form == TRRailForm.leftRight) return [m rotateAngle:90.0 x:0.0 y:1.0 z:0.0];
                else return m;
            } else {
                if(rail.form == TRRailForm.topRight) {
                    return [m rotateAngle:270.0 x:0.0 y:1.0 z:0.0];
                } else {
                    if(rail.form == TRRailForm.bottomRight) {
                        return [m rotateAngle:180.0 x:0.0 y:1.0 z:0.0];
                    } else {
                        if(rail.form == TRRailForm.leftBottom) return [m rotateAngle:90.0 x:0.0 y:1.0 z:0.0];
                        else return m;
                    }
                }
            }
        }];
    } f:^void() {
        if(rail.form == TRRailForm.bottomTop || rail.form == TRRailForm.leftRight) [_railModel draw];
        else [_railTurnModel draw];
    }];
}

- (ODClassType*)type {
    return [TRRailView type];
}

+ (ODClassType*)type {
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
static ODClassType* _TRSwitchView_type;
@synthesize material = _material;
@synthesize switchStraightModel = _switchStraightModel;
@synthesize switchTurnModel = _switchTurnModel;

+ (id)switchView {
    return [[TRSwitchView alloc] init];
}

- (id)init {
    self = [super init];
    if(self) {
        _material = [EGStandardMaterial standardMaterialWithDiffuse:[EGColorSource applyColor:GEVec4Make(0.2, 0.5, 0.15, 1.0)] specularColor:GEVec4Make(0.5, 1.0, 0.5, 1.0) specularSize:1.0];
        _switchStraightModel = [EGMeshModel meshModelWithMeshes:(@[tuple(TRModels.switchStraight, _material)])];
        _switchTurnModel = [EGMeshModel meshModelWithMeshes:(@[tuple(TRModels.switchTurn, _material)])];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _TRSwitchView_type = [ODClassType classTypeWithCls:[TRSwitchView class]];
}

- (void)drawTheSwitch:(TRSwitch*)theSwitch {
    TRRailConnector* connector = theSwitch.connector;
    TRRail* rail = [theSwitch activeRail];
    TRRailForm* form = rail.form;
    __block BOOL ref = NO;
    [EGGlobal.matrix applyModify:^EGMatrixModel*(EGMatrixModel* _) {
        return [[_ modifyW:^GEMat4*(GEMat4* w) {
            return [w translateX:((float)(theSwitch.tile.x)) y:((float)(theSwitch.tile.y)) z:0.03];
        }] modifyM:^GEMat4*(GEMat4* m) {
            GEMat4* m2 = [[m rotateAngle:((float)(connector.angle)) x:0.0 y:1.0 z:0.0] translateX:-0.5 y:0.0 z:0.0];
            if(form.start.x + form.end.x != 0) {
                TRRailConnector* otherConnector = ((form.start == connector) ? form.end : form.start);
                NSInteger x = connector.x;
                NSInteger y = connector.y;
                NSInteger ox = otherConnector.x;
                NSInteger oy = otherConnector.y;
                if((x == -1 && oy == -1) || (y == 1 && ox == -1) || (y == -1 && ox == 1) || (x == 1 && oy == 1)) {
                    ref = YES;
                    return [m2 scaleX:1.0 y:1.0 z:-1.0];
                } else {
                    return m2;
                }
            } else {
                return m2;
            }
        }];
    } f:^void() {
        GEMat4* m = [EGGlobal.matrix.value wc];
        if(ref) glCullFace(GL_BACK);
        if(form.start.x + form.end.x == 0) [_switchStraightModel draw];
        else [_switchTurnModel draw];
        if(ref) glCullFace(GL_FRONT);
    }];
}

- (ODClassType*)type {
    return [TRSwitchView type];
}

+ (ODClassType*)type {
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
    EGStandardMaterial* _inactiveMaterial;
    EGStandardMaterial* _bodyMaterial;
    EGColorSource* _greenGlowMaterial;
    EGColorSource* _redGlowMaterial;
}
static ODClassType* _TRLightView_type;
@synthesize greenMaterial = _greenMaterial;
@synthesize redMaterial = _redMaterial;
@synthesize inactiveMaterial = _inactiveMaterial;
@synthesize bodyMaterial = _bodyMaterial;
@synthesize greenGlowMaterial = _greenGlowMaterial;
@synthesize redGlowMaterial = _redGlowMaterial;

+ (id)lightView {
    return [[TRLightView alloc] init];
}

- (id)init {
    self = [super init];
    if(self) {
        _greenMaterial = [EGStandardMaterial standardMaterialWithDiffuse:[EGColorSource applyColor:GEVec4Make(0.07568, 0.61424, 0.07568, 1.0)] specularColor:GEVec4Make(0.633, 0.727811, 0.633, 1.0) specularSize:1.0];
        _redMaterial = [EGStandardMaterial standardMaterialWithDiffuse:[EGColorSource applyColor:GEVec4Make(0.61424, 0.04136, 0.04136, 1.0)] specularColor:GEVec4Make(0.727811, 0.626959, 0.626959, 1.0) specularSize:1.0];
        _inactiveMaterial = [EGStandardMaterial standardMaterialWithDiffuse:[EGColorSource applyColor:GEVec4Make(0.3, 0.3, 0.3, 1.0)] specularColor:GEVec4Make(1.0, 1.0, 1.0, 1.0) specularSize:1.0];
        _bodyMaterial = [EGStandardMaterial standardMaterialWithDiffuse:[EGColorSource applyColor:GEVec4Make(0.1, 0.1, 0.1, 1.0)] specularColor:GEVec4Make(0.1, 0.1, 0.1, 1.0) specularSize:1.0];
        _greenGlowMaterial = [EGColorSource applyColor:GEVec4Make(0.0, 1.0, 0.0, 0.8) texture:[EGGlobal textureForFile:@"LightGlow.png"]];
        _redGlowMaterial = [EGColorSource applyColor:GEVec4Make(1.0, 0.0, 0.0, 0.8) texture:[EGGlobal textureForFile:@"LightGlow.png"]];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _TRLightView_type = [ODClassType classTypeWithCls:[TRLightView class]];
}

- (void)drawLight:(TRRailLight*)light {
    [EGGlobal.matrix applyModify:^EGMatrixModel*(EGMatrixModel* _) {
        return [[_ modifyW:^GEMat4*(GEMat4* w) {
            return [w translateX:((float)(light.tile.x)) y:((float)(light.tile.y)) z:0.0];
        }] modifyM:^GEMat4*(GEMat4* m) {
            return [[m rotateAngle:((float)(90 + light.connector.angle)) x:0.0 y:1.0 z:0.0] translateX:0.2 y:0.0 z:-0.45];
        }];
    } f:^void() {
        [_bodyMaterial drawMesh:TRModels.light];
        if(!(EGGlobal.context.isShadowsDrawing)) if(light.isGreen) {
            [_greenMaterial drawMesh:TRModels.lightGreen];
            [_inactiveMaterial drawMesh:TRModels.lightRed];
            glDisable(GL_CULL_FACE);
            egBlendFunctionApplyDraw(egBlendFunctionStandard(), ^void() {
                [_greenGlowMaterial drawMesh:TRModels.lightGreenGlow];
            });
            glEnable(GL_CULL_FACE);
        } else {
            [_inactiveMaterial drawMesh:TRModels.lightGreen];
            [_redMaterial drawMesh:TRModels.lightRed];
            glDisable(GL_CULL_FACE);
            egBlendFunctionApplyDraw(egBlendFunctionStandard(), ^void() {
                [_redGlowMaterial drawMesh:TRModels.lightRedGlow];
            });
            glEnable(GL_CULL_FACE);
        }
    }];
}

- (ODClassType*)type {
    return [TRLightView type];
}

+ (ODClassType*)type {
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
static ODClassType* _TRDamageView_type;
@synthesize model = _model;

+ (id)damageView {
    return [[TRDamageView alloc] init];
}

- (id)init {
    self = [super init];
    if(self) _model = [EGMeshModel meshModelWithMeshes:(@[tuple(TRModels.damage, ((EGMaterial*)([EGMaterial applyColor:GEVec4Make(1.0, 0.0, 0.0, 1.0)])))])];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _TRDamageView_type = [ODClassType classTypeWithCls:[TRDamageView class]];
}

- (void)drawPoint:(TRRailPoint*)point {
    [EGGlobal.matrix applyModify:^EGMatrixModel*(EGMatrixModel* _) {
        return [_ modifyW:^GEMat4*(GEMat4* w) {
            return [w translateX:point.point.x y:point.point.y z:0.0];
        }];
    } f:^void() {
        [_model draw];
    }];
}

- (ODClassType*)type {
    return [TRDamageView type];
}

+ (ODClassType*)type {
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


@implementation TRBackgroundView{
    EGMapSso* _map;
    EGMapSsoView* _mapView;
    EGMaterial* _material;
}
static ODClassType* _TRBackgroundView_type;
@synthesize map = _map;
@synthesize mapView = _mapView;
@synthesize material = _material;

+ (id)backgroundViewWithMap:(EGMapSso*)map {
    return [[TRBackgroundView alloc] initWithMap:map];
}

- (id)initWithMap:(EGMapSso*)map {
    self = [super init];
    if(self) {
        _map = map;
        _mapView = [EGMapSsoView mapSsoViewWithMap:_map];
        _material = [EGStandardMaterial applyTexture:[EGGlobal textureForFile:@"Grass.png"]];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _TRBackgroundView_type = [ODClassType classTypeWithCls:[TRBackgroundView class]];
}

- (void)draw {
    [_mapView drawPlaneWithMaterial:_material];
}

- (ODClassType*)type {
    return [TRBackgroundView type];
}

+ (ODClassType*)type {
    return _TRBackgroundView_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    TRBackgroundView* o = ((TRBackgroundView*)(other));
    return [self.map isEqual:o.map];
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.map hash];
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"map=%@", self.map];
    [description appendString:@">"];
    return description;
}

@end


