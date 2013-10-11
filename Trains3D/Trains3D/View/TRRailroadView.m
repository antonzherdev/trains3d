#import "TRRailroadView.h"

#import "TRRailroad.h"
#import "EGMultisamplingSurface.h"
#import "EGContext.h"
#import "GL.h"
#import "EGMaterial.h"
#import "EGMesh.h"
#import "TRModels.h"
#import "GEMat4.h"
#import "TRRailPoint.h"
#import "EGTexture.h"
#import "EGMapIso.h"
#import "EGMapIsoView.h"
#import "EGShadow.h"
#import "EGPlatform.h"
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
        _switchView = [TRSwitchView switchView];
        _lightView = [TRLightView lightView];
        _damageView = [TRDamageView damageView];
        _railroadSurface = [EGViewportSurface viewportSurfaceWithDepth:YES multisampling:YES];
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
    EGGlobal.context.considerShadows = NO;
    _backgroundView = [TRBackgroundView backgroundViewWithMap:_railroad.map];
    _railView = [TRRailView railView];
    EGGlobal.context.considerShadows = YES;
}

- (void)drawBackground {
    [_railroadSurface maybeForce:_changed draw:^void() {
        glClearColor(0.0, 0.0, 0.0, 0.0);
        glClear(GL_COLOR_BUFFER_BIT + GL_DEPTH_BUFFER_BIT);
        EGGlobal.context.considerShadows = NO;
        [_backgroundView draw];
        [[_railroad rails] forEach:^void(TRRail* _) {
            [_railView drawRail:_];
        }];
        EGGlobal.context.considerShadows = YES;
        _changed = NO;
    }];
    [_railroadSurface draw];
    [_backgroundView drawShadow];
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
    [_lightView drawLights:[_railroad lights]];
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
        _railModel = [EGMeshModel applyMeshes:(@[tuple(TRModels.railGravel, ((EGMaterial*)([EGMaterial applyTexture:[EGGlobal textureForFile:@"Gravel.png"]]))), tuple(TRModels.railTies, ((EGMaterial*)([EGMaterial applyColor:GEVec4Make(0.55, 0.45, 0.25, 1.0)]))), tuple(TRModels.rails, _railMaterial)])];
        _railTurnModel = [EGMeshModel applyMeshes:(@[tuple(TRModels.railTurnGravel, ((EGMaterial*)([EGMaterial applyTexture:[EGGlobal textureForFile:@"Gravel.png"]]))), tuple(TRModels.railTurnTies, ((EGMaterial*)([EGMaterial applyColor:GEVec4Make(0.55, 0.45, 0.25, 1.0)]))), tuple(TRModels.railsTurn, _railMaterial)])];
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
        _switchStraightModel = [EGMeshModel applyMeshes:(@[tuple(TRModels.switchStraight, _material)])];
        _switchTurnModel = [EGMeshModel applyMeshes:(@[tuple(TRModels.switchTurn, _material)])];
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
    EGTexture* _texture;
    EGVertexArray* _redBodyVao;
    EGVertexArray* _greenBodyVao;
    EGVertexArray* _greenGlowVao;
    EGVertexArray* _redGlowVao;
}
static ODClassType* _TRLightView_type;
@synthesize texture = _texture;
@synthesize redBodyVao = _redBodyVao;
@synthesize greenBodyVao = _greenBodyVao;
@synthesize greenGlowVao = _greenGlowVao;
@synthesize redGlowVao = _redGlowVao;

+ (id)lightView {
    return [[TRLightView alloc] init];
}

- (id)init {
    self = [super init];
    if(self) {
        _texture = [EGGlobal textureForFile:@"Light.png" magFilter:GL_LINEAR minFilter:GL_LINEAR_MIPMAP_LINEAR];
        _redBodyVao = [TRModels.light vaoMaterial:[EGStandardMaterial applyTexture:[EGTextureRegion textureRegionWithTexture:_texture rect:geRectApplyXYWidthHeight(0.5, 0.0, 1.0, 1.0)]] shadow:NO];
        _greenBodyVao = [TRModels.light vaoMaterial:[EGStandardMaterial applyTexture:_texture] shadow:NO];
        _greenGlowVao = [TRModels.lightGreenGlow vaoMaterial:[EGStandardMaterial applyDiffuse:[EGColorSource applyColor:GEVec4Make(0.0, 1.0, 0.0, 0.8) texture:[EGGlobal textureForFile:@"LightGlow.png"]]] shadow:NO];
        _redGlowVao = [TRModels.lightRedGlow vaoMaterial:[EGStandardMaterial applyDiffuse:[EGColorSource applyColor:GEVec4Make(1.0, 0.0, 0.0, 0.8) texture:[EGGlobal textureForFile:@"LightGlow.png"]]] shadow:NO];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _TRLightView_type = [ODClassType classTypeWithCls:[TRLightView class]];
}

- (void)drawLights:(id<CNSeq>)lights {
    if([lights isEmpty]) return ;
    [EGGlobal.matrix push];
    id<CNSeq> arr = [[[lights chain] map:^CNTuple*(TRRailLight* light) {
        return tuple([[EGGlobal.matrix.value modifyW:^GEMat4*(GEMat4* w) {
            return [w translateX:((float)(light.tile.x)) y:((float)(light.tile.y)) z:0.0];
        }] modifyM:^GEMat4*(GEMat4* m) {
            return [[m rotateAngle:((float)(90 + light.connector.angle)) x:0.0 y:1.0 z:0.0] translateX:0.2 y:0.0 z:-0.45];
        }], numb(light.isGreen));
    }] toArray];
    BOOL shadow = [EGGlobal.context.renderTarget isKindOfClass:[EGShadowRenderTarget class]];
    [arr forEach:^void(CNTuple* p) {
        EGGlobal.matrix.value = ((EGMatrixModel*)(p.a));
        [((unumb(p.b)) ? _greenBodyVao : _redBodyVao) draw];
    }];
    if(!(shadow)) [EGGlobal.context.cullFace disabledF:^void() {
        [EGBlendFunction.standard applyDraw:^void() {
            [arr forEach:^void(CNTuple* p) {
                EGGlobal.matrix.value = ((EGMatrixModel*)(p.a));
                if(unumb(p.b)) [_greenGlowVao draw];
                else [_redGlowVao draw];
            }];
        }];
    }];
    [EGGlobal.matrix pop];
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
    if(self) _model = [EGMeshModel applyMeshes:(@[tuple(TRModels.damage, ((EGMaterial*)([EGMaterial applyColor:GEVec4Make(1.0, 0.0, 0.0, 1.0)])))])];
    
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
    EGShadowDrawParam* _shadowParam;
    EGVertexArray* _shadowVao;
}
static ODClassType* _TRBackgroundView_type;
@synthesize map = _map;
@synthesize mapView = _mapView;
@synthesize shadowParam = _shadowParam;
@synthesize shadowVao = _shadowVao;

+ (id)backgroundViewWithMap:(EGMapSso*)map {
    return [[TRBackgroundView alloc] initWithMap:map];
}

- (id)initWithMap:(EGMapSso*)map {
    self = [super init];
    if(self) {
        _map = map;
        _mapView = [EGMapSsoView mapSsoViewWithMap:_map material:[EGStandardMaterial applyTexture:[EGGlobal textureForFile:@"Grass.png"]]];
        _shadowParam = [EGShadowDrawParam shadowDrawParamWithPercents:(@[@0.3])];
        _shadowVao = [_mapView.plane vaoShader:[EGShadowDrawShaderSystem.instance shaderForParam:_shadowParam]];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _TRBackgroundView_type = [ODClassType classTypeWithCls:[TRBackgroundView class]];
}

- (void)draw {
    [_mapView draw];
}

- (void)drawShadow {
    if(egPlatform().shadows) [EGBlendFunction.standard applyDraw:^void() {
        [EGGlobal.context.cullFace disabledF:^void() {
            [EGGlobal.context.depthTest disabledF:^void() {
                [_shadowVao drawParam:_shadowParam];
            }];
        }];
    }];
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


