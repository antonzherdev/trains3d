#import "TRRailroadView.h"

#import "TRRailroad.h"
#import "EGMultisamplingSurface.h"
#import "EGContext.h"
#import "EGShadow.h"
#import "GL.h"
#import "EGPlatform.h"
#import "EGMapIsoView.h"
#import "EGMaterial.h"
#import "EGDirector.h"
#import "EGTexture.h"
#import "TRModels.h"
#import "GEMat4.h"
#import "TRRailPoint.h"
#import "EGBillboard.h"
#import "TRStrings.h"
#import "EGVertex.h"
#import "EGIndex.h"
@implementation TRRailroadView{
    TRRailroad* _railroad;
    TRRailView* _railView;
    TRSwitchView* _switchView;
    TRLightView* _lightView;
    TRDamageView* _damageView;
    EGViewportSurface* _railroadSurface;
    TRBackgroundView* _backgroundView;
    TRUndoView* _undoView;
    id _shadowVao;
    BOOL __changed;
}
static ODClassType* _TRRailroadView_type;
@synthesize railroad = _railroad;
@synthesize shadowVao = _shadowVao;
@synthesize _changed = __changed;

+ (id)railroadViewWithRailroad:(TRRailroad*)railroad {
    return [[TRRailroadView alloc] initWithRailroad:railroad];
}

- (id)initWithRailroad:(TRRailroad*)railroad {
    self = [super init];
    if(self) {
        _railroad = railroad;
        _switchView = [TRSwitchView switchView];
        _lightView = [TRLightView lightViewWithRailroad:_railroad];
        _damageView = [TRDamageView damageView];
        _railroadSurface = [EGViewportSurface viewportSurfaceWithDepth:YES multisampling:YES];
        _undoView = [TRUndoView undoViewWithBuilder:_railroad.builder];
        __changed = YES;
        [self _init];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _TRRailroadView_type = [ODClassType classTypeWithCls:[TRRailroadView class]];
}

- (void)_init {
    __weak TRRailroadView* weakSelf = self;
    [TRRailroad.changedNotification observeBy:^void(id _) {
        weakSelf._changed = YES;
    }];
    [TRRailroadBuilder.changedNotification observeBy:^void(id _) {
        weakSelf._changed = YES;
    }];
    EGGlobal.context.considerShadows = NO;
    _backgroundView = [TRBackgroundView backgroundViewWithMap:_railroad.map];
    _railView = [TRRailView railViewWithRailroad:_railroad];
    EGShadowDrawParam* shadowParam = [EGShadowDrawParam shadowDrawParamWithPercents:(@[@0.3]) viewportSurface:[CNOption applyValue:_railroadSurface]];
    _shadowVao = ((egPlatform().shadows) ? [CNOption applyValue:[_backgroundView.mapView.plane vaoShaderSystem:EGShadowDrawShaderSystem.instance material:shadowParam shadow:NO]] : [CNOption none]);
    EGGlobal.context.considerShadows = YES;
}

- (void)drawBackground {
    egPushGroupMarker(@"Railroad background");
    if([EGGlobal.context.renderTarget isShadow]) {
        [_lightView drawShadow];
    } else {
        if(egPlatform().shadows) [EGGlobal.context.cullFace disabledF:^void() {
            [EGGlobal.context.depthTest disabledF:^void() {
                [((EGVertexArray*)([_shadowVao get])) draw];
            }];
        }];
        else [_railroadSurface draw];
        [[_railroad switches] forEach:^void(TRSwitch* _) {
            [_switchView drawTheSwitch:_];
        }];
        [_lightView drawBodies];
    }
    egPopGroupMarker();
}

- (void)drawForeground {
    egPushGroupMarker(@"Railroad foreground");
    [EGBlendFunction.standard applyDraw:^void() {
        [_undoView draw];
        [_lightView drawGlows];
        [[_railroad damagesPoints] forEach:^void(TRRailPoint* _) {
            [_damageView drawPoint:_];
        }];
    }];
    egPopGroupMarker();
}

- (void)prepare {
    [_railroadSurface maybeForce:__changed draw:^void() {
        [EGGlobal.context clearColorColor:GEVec4Make(0.0, 0.0, 0.0, 0.0)];
        glClear(GL_COLOR_BUFFER_BIT + GL_DEPTH_BUFFER_BIT);
        EGGlobal.context.considerShadows = NO;
        [_backgroundView draw];
        [[_railroad rails] forEach:^void(TRRail* _) {
            [_railView drawRail:_];
        }];
        [[_railroad.builder rail] forEach:^void(TRRail* _) {
            [_railView drawRail:_];
        }];
        [[_railroad.builder buildingRails] forEach:^void(TRRailBuilding* _) {
            [_railView drawRailBuilding:_];
        }];
        EGGlobal.context.considerShadows = YES;
        __changed = NO;
    }];
}

- (void)reshape {
    [_undoView reshape];
}

- (BOOL)processEvent:(EGEvent*)event {
    return [_undoView processEvent:event];
}

- (BOOL)isProcessorActive {
    return !([[EGDirector current] isPaused]);
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
    TRRailroad* _railroad;
    EGStandardMaterial* _railMaterial;
    EGTexture* _gravel;
    EGMeshModel* _railModel;
    EGMeshModel* _railTurnModel;
}
static ODClassType* _TRRailView_type;
@synthesize railroad = _railroad;
@synthesize railMaterial = _railMaterial;
@synthesize gravel = _gravel;
@synthesize railModel = _railModel;
@synthesize railTurnModel = _railTurnModel;

+ (id)railViewWithRailroad:(TRRailroad*)railroad {
    return [[TRRailView alloc] initWithRailroad:railroad];
}

- (id)initWithRailroad:(TRRailroad*)railroad {
    self = [super init];
    if(self) {
        _railroad = railroad;
        _railMaterial = [EGStandardMaterial standardMaterialWithDiffuse:[EGColorSource applyColor:GEVec4Make(0.5, 0.5, 0.6, 1.0)] specularColor:GEVec4Make(0.5, 0.5, 0.5, 1.0) specularSize:0.3];
        _gravel = [EGGlobal textureForFile:@"Gravel.png" magFilter:GL_LINEAR minFilter:GL_LINEAR_MIPMAP_LINEAR];
        _railModel = [EGMeshModel applyMeshes:(@[tuple(TRModels.railGravel, [EGMaterial applyTexture:_gravel]), tuple(TRModels.railTies, [EGMaterial applyColor:GEVec4Make(0.55, 0.45, 0.25, 1.0)]), tuple(TRModels.rails, _railMaterial)])];
        _railTurnModel = [EGMeshModel applyMeshes:(@[tuple(TRModels.railTurnGravel, [EGMaterial applyTexture:_gravel]), tuple(TRModels.railTurnTies, [EGMaterial applyColor:GEVec4Make(0.55, 0.45, 0.25, 1.0)]), tuple(TRModels.railsTurn, _railMaterial)])];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _TRRailView_type = [ODClassType classTypeWithCls:[TRRailView class]];
}

- (void)drawRailBuilding:(TRRailBuilding*)railBuilding {
    CGFloat p = railBuilding.progress;
    [self drawRail:railBuilding.rail count:((p < 0.5) ? 1 : 2)];
}

- (void)drawRail:(TRRail*)rail {
    [self drawRail:rail count:3];
}

- (void)drawRail:(TRRail*)rail count:(unsigned int)count {
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
        if(rail.form == TRRailForm.bottomTop || rail.form == TRRailForm.leftRight) {
            [_railModel drawOnly:count];
            GEVec2i t = rail.tile;
            if([_railroad.map isPartialTile:t]) {
                if([_railroad.map cutStateForTile:t].y != 0) {
                    GEVec2i dt = geVec2iSubVec2i([((rail.form == TRRailForm.leftRight) ? rail.form.start : rail.form.end) nextTile:t], t);
                    EGGlobal.matrix.value = [EGGlobal.matrix.value modifyW:^GEMat4*(GEMat4* w) {
                        return [w translateX:((float)(dt.x)) y:((float)(dt.y)) z:0.001];
                    }];
                    [_railModel drawOnly:count];
                }
            }
        } else {
            [_railTurnModel drawOnly:count];
        }
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
    TRRailView* o = ((TRRailView*)(other));
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


@implementation TRUndoView{
    TRRailroadBuilder* _builder;
    EGFont* _font;
    BOOL _empty;
    EGBillboard* _button;
}
static ODClassType* _TRUndoView_type;
@synthesize builder = _builder;

+ (id)undoViewWithBuilder:(TRRailroadBuilder*)builder {
    return [[TRUndoView alloc] initWithBuilder:builder];
}

- (id)initWithBuilder:(TRRailroadBuilder*)builder {
    self = [super init];
    if(self) {
        _builder = builder;
        _empty = YES;
        _button = [EGBillboard applyMaterial:[EGColorSource applyColor:GEVec4Make(0.85, 0.9, 0.75, 0.8)]];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _TRUndoView_type = [ODClassType classTypeWithCls:[TRUndoView class]];
}

- (void)reshape {
    _font = [EGGlobal fontWithName:@"lucida_grande" size:18];
    GEVec2 textSize = [_font measurePText:[TRStr.Loc undo]];
    GEVec2 buttonSize = geVec4Xy([[EGGlobal.matrix p] divBySelfVec4:geVec4ApplyVec2ZW(geVec2MulF(textSize, 1.5), 0.0, 0.0)]);
    _button.rect = GERectMake(geVec2DivI(geVec2Negate(buttonSize), 2), buttonSize);
}

- (void)draw {
    id rail = [_builder railForUndo];
    if([rail isEmpty]) {
        _empty = YES;
    } else {
        _empty = NO;
        [EGGlobal.context.depthTest disabledF:^void() {
            _button.position = geVec3ApplyVec2Z(geVec2ApplyVec2i(((TRRail*)([rail get])).tile), 0.0);
            [_button draw];
            [_font drawText:[TRStr.Loc undo] color:GEVec4Make(0.1, 0.1, 0.1, 1.0) at:_button.position alignment:egTextAlignmentApplyXY(0.0, 0.0)];
        }];
    }
}

- (BOOL)processEvent:(EGEvent*)event {
    return !(_empty) && [event tapProcessor:self];
}

- (BOOL)tapEvent:(EGEvent*)event {
    GEVec2 p = [event locationInViewport];
    if([_button containsVec2:p]) {
        [_builder undo];
        return YES;
    } else {
        return NO;
    }
}

- (BOOL)isProcessorActive {
    return !([[EGDirector current] isPaused]);
}

- (ODClassType*)type {
    return [TRUndoView type];
}

+ (ODClassType*)type {
    return _TRUndoView_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    TRUndoView* o = ((TRUndoView*)(other));
    return [self.builder isEqual:o.builder];
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.builder hash];
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"builder=%@", self.builder];
    [description appendString:@">"];
    return description;
}

@end


@implementation TRSwitchView{
    EGColorSource* _material;
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
        _material = [EGColorSource applyTexture:[EGGlobal textureForFile:@"Switches.png" magFilter:GL_LINEAR minFilter:GL_LINEAR_MIPMAP_NEAREST]];
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
        [EGBlendFunction.standard applyDraw:^void() {
            [EGGlobal.context.cullFace disabledF:^void() {
                if(form.start.x + form.end.x == 0) [_switchStraightModel draw];
                else [_switchTurnModel draw];
            }];
        }];
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
    TRRailroad* _railroad;
    EGTexture* _texture;
    EGVertexArray* _redBodyVao;
    EGVertexArray* _greenBodyVao;
    EGVertexArray* _shadowBodyVao;
    BOOL __matrixChanged;
    BOOL __matrixShadowChanged;
    id<CNSeq> __matrixArr;
    id<CNSeq> __matrixArrShadow;
    TRMeshUnite* _glows;
}
static ODClassType* _TRLightView_type;
@synthesize railroad = _railroad;
@synthesize texture = _texture;
@synthesize redBodyVao = _redBodyVao;
@synthesize greenBodyVao = _greenBodyVao;
@synthesize shadowBodyVao = _shadowBodyVao;
@synthesize _matrixChanged = __matrixChanged;
@synthesize _matrixShadowChanged = __matrixShadowChanged;

+ (id)lightViewWithRailroad:(TRRailroad*)railroad {
    return [[TRLightView alloc] initWithRailroad:railroad];
}

- (id)initWithRailroad:(TRRailroad*)railroad {
    self = [super init];
    if(self) {
        _railroad = railroad;
        _texture = [EGGlobal textureForFile:@"Light.png" magFilter:GL_LINEAR minFilter:GL_LINEAR_MIPMAP_NEAREST];
        _redBodyVao = [TRModels.light vaoMaterial:[EGColorSource applyTexture:[EGTextureRegion textureRegionWithTexture:_texture uv:geRectApplyXYWidthHeight(0.5, 0.0, 1.0, 1.0)]] shadow:NO];
        _greenBodyVao = [TRModels.light vaoMaterial:[EGColorSource applyTexture:_texture] shadow:NO];
        _shadowBodyVao = [TRModels.light vaoShadow];
        __matrixChanged = YES;
        __matrixShadowChanged = YES;
        __matrixArr = (@[]);
        __matrixArrShadow = (@[]);
        _glows = [TRMeshUnite meshUniteWithVertexSample:TRModels.lightGreenGlow indexSample:TRModels.lightIndex createVao:^EGVertexArray*(EGMesh* _) {
            return [_ vaoMaterial:[EGColorSource applyTexture:[EGGlobal textureForFile:@"LightGlow.png"]] shadow:NO];
        }];
        [self _init];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _TRLightView_type = [ODClassType classTypeWithCls:[TRLightView class]];
}

- (void)_init {
    __weak TRLightView* weakSelf = self;
    [TRRailroad.changedNotification observeBy:^void(id _) {
        weakSelf._matrixChanged = YES;
        weakSelf._matrixShadowChanged = YES;
    }];
}

- (id<CNSeq>)calculateMatrixArr {
    return [[[[_railroad lights] chain] map:^CNTuple*(TRRailLight* light) {
        return tuple([[EGGlobal.matrix.value modifyW:^GEMat4*(GEMat4* w) {
            return [w translateX:((float)(((TRRailLight*)(light)).tile.x)) y:((float)(((TRRailLight*)(light)).tile.y)) z:0.0];
        }] modifyM:^GEMat4*(GEMat4* m) {
            return [[m rotateAngle:((float)(90 + ((TRRailLight*)(light)).connector.angle)) x:0.0 y:1.0 z:0.0] translateX:0.2 y:0.0 z:-0.45];
        }], light);
    }] toArray];
}

- (void)drawBodies {
    if(__matrixChanged) {
        __matrixArr = [self calculateMatrixArr];
        __matrixChanged = NO;
    }
    [EGGlobal.matrix push];
    [__matrixArr forEach:^void(CNTuple* p) {
        EGGlobal.matrix.value = ((CNTuple*)(p)).a;
        [((((TRRailLight*)(((CNTuple*)(p)).b)).isGreen) ? _greenBodyVao : _redBodyVao) draw];
    }];
    [EGGlobal.matrix pop];
}

- (void)drawShadow {
    if(__matrixShadowChanged) {
        __matrixArrShadow = [self calculateMatrixArr];
        __matrixShadowChanged = NO;
    }
    [EGGlobal.matrix push];
    [__matrixArrShadow forEach:^void(CNTuple* p) {
        EGGlobal.matrix.value = ((CNTuple*)(p)).a;
        [_shadowBodyVao draw];
    }];
    [EGGlobal.matrix pop];
}

- (void)drawGlows {
    if(!([__matrixArr isEmpty]) && !([EGGlobal.context.renderTarget isKindOfClass:[EGShadowRenderTarget class]])) {
        [_glows writeCount:((unsigned int)([__matrixArr count])) f:^void(TRMeshWriter* writer) {
            [__matrixArr forEach:^void(CNTuple* p) {
                [writer writeVertex:((((TRRailLight*)(((CNTuple*)(p)).b)).isGreen) ? TRModels.lightGreenGlow : TRModels.lightRedGlow) mat4:[((EGMatrixModel*)(((CNTuple*)(p)).a)) mwcp]];
            }];
        }];
        [EGGlobal.context.cullFace disabledF:^void() {
            [_glows draw];
        }];
    }
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
    TRLightView* o = ((TRLightView*)(other));
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


@implementation TRMeshUnite{
    CNPArray* _vertexSample;
    CNPArray* _indexSample;
    EGVertexArray*(^_createVao)(EGMesh*);
    EGMutableVertexBuffer* _vbo;
    EGMutableIndexBuffer* _ibo;
    EGMesh* _mesh;
    EGVertexArray* _vao;
}
static ODClassType* _TRMeshUnite_type;
@synthesize vertexSample = _vertexSample;
@synthesize indexSample = _indexSample;
@synthesize createVao = _createVao;
@synthesize mesh = _mesh;
@synthesize vao = _vao;

+ (id)meshUniteWithVertexSample:(CNPArray*)vertexSample indexSample:(CNPArray*)indexSample createVao:(EGVertexArray*(^)(EGMesh*))createVao {
    return [[TRMeshUnite alloc] initWithVertexSample:vertexSample indexSample:indexSample createVao:createVao];
}

- (id)initWithVertexSample:(CNPArray*)vertexSample indexSample:(CNPArray*)indexSample createVao:(EGVertexArray*(^)(EGMesh*))createVao {
    self = [super init];
    if(self) {
        _vertexSample = vertexSample;
        _indexSample = indexSample;
        _createVao = createVao;
        _vbo = [EGVBO mutMesh];
        _ibo = [EGIBO mut];
        _mesh = [EGMesh meshWithVertex:_vbo index:_ibo];
        _vao = _createVao(_mesh);
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _TRMeshUnite_type = [ODClassType classTypeWithCls:[TRMeshUnite class]];
}

- (void)writeCount:(unsigned int)count f:(void(^)(TRMeshWriter*))f {
    TRMeshWriter* w = [self writerCount:count];
    f(w);
    [w flush];
}

- (TRMeshWriter*)writerCount:(unsigned int)count {
    return [TRMeshWriter meshWriterWithVbo:_vbo ibo:_ibo count:count vertexSample:_vertexSample indexSample:_indexSample];
}

- (void)draw {
    [EGGlobal.matrix identityF:^void() {
        [_vao draw];
    }];
}

- (ODClassType*)type {
    return [TRMeshUnite type];
}

+ (ODClassType*)type {
    return _TRMeshUnite_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    TRMeshUnite* o = ((TRMeshUnite*)(other));
    return [self.vertexSample isEqual:o.vertexSample] && [self.indexSample isEqual:o.indexSample] && [self.createVao isEqual:o.createVao];
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.vertexSample hash];
    hash = hash * 31 + [self.indexSample hash];
    hash = hash * 31 + [self.createVao hash];
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"vertexSample=%@", self.vertexSample];
    [description appendFormat:@", indexSample=%@", self.indexSample];
    [description appendString:@">"];
    return description;
}

@end


@implementation TRMeshWriter{
    EGMutableVertexBuffer* _vbo;
    EGMutableIndexBuffer* _ibo;
    unsigned int _count;
    CNPArray* _vertexSample;
    CNPArray* _indexSample;
    CNVoidRefArray _vertex;
    CNVoidRefArray _index;
    CNVoidRefArray __vp;
    CNVoidRefArray __ip;
    unsigned int __indexShift;
}
static ODClassType* _TRMeshWriter_type;
@synthesize vbo = _vbo;
@synthesize ibo = _ibo;
@synthesize count = _count;
@synthesize vertexSample = _vertexSample;
@synthesize indexSample = _indexSample;

+ (id)meshWriterWithVbo:(EGMutableVertexBuffer*)vbo ibo:(EGMutableIndexBuffer*)ibo count:(unsigned int)count vertexSample:(CNPArray*)vertexSample indexSample:(CNPArray*)indexSample {
    return [[TRMeshWriter alloc] initWithVbo:vbo ibo:ibo count:count vertexSample:vertexSample indexSample:indexSample];
}

- (id)initWithVbo:(EGMutableVertexBuffer*)vbo ibo:(EGMutableIndexBuffer*)ibo count:(unsigned int)count vertexSample:(CNPArray*)vertexSample indexSample:(CNPArray*)indexSample {
    self = [super init];
    if(self) {
        _vbo = vbo;
        _ibo = ibo;
        _count = count;
        _vertexSample = vertexSample;
        _indexSample = indexSample;
        _vertex = cnVoidRefArrayApplyTpCount(egMeshDataType(), _vertexSample.count * _count);
        _index = cnVoidRefArrayApplyTpCount(oduInt4Type(), _indexSample.count * _count);
        __vp = _vertex;
        __ip = _index;
        __indexShift = 0;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _TRMeshWriter_type = [ODClassType classTypeWithCls:[TRMeshWriter class]];
}

- (void)writeMat4:(GEMat4*)mat4 {
    [self writeVertex:_vertexSample index:_indexSample mat4:mat4];
}

- (void)writeVertex:(CNPArray*)vertex mat4:(GEMat4*)mat4 {
    [self writeVertex:vertex index:_indexSample mat4:mat4];
}

- (void)writeVertex:(CNPArray*)vertex index:(CNPArray*)index mat4:(GEMat4*)mat4 {
    [vertex forRefEach:^void(VoidRef r) {
        __vp = cnVoidRefArrayWriteTpItem(__vp, EGMeshData, egMeshDataMulMat4(*(((EGMeshData*)(r))), mat4));
    }];
    [index forRefEach:^void(VoidRef r) {
        __ip = cnVoidRefArrayWriteUInt4(__ip, *(((unsigned int*)(r))) + __indexShift);
    }];
    __indexShift += ((unsigned int)(vertex.count));
}

- (void)flush {
    [_vbo setArray:_vertex];
    [_ibo setArray:_index];
}

- (void)dealloc {
    cnVoidRefArrayFree(_vertex);
    cnVoidRefArrayFree(_index);
}

- (ODClassType*)type {
    return [TRMeshWriter type];
}

+ (ODClassType*)type {
    return _TRMeshWriter_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    TRMeshWriter* o = ((TRMeshWriter*)(other));
    return [self.vbo isEqual:o.vbo] && [self.ibo isEqual:o.ibo] && self.count == o.count && [self.vertexSample isEqual:o.vertexSample] && [self.indexSample isEqual:o.indexSample];
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.vbo hash];
    hash = hash * 31 + [self.ibo hash];
    hash = hash * 31 + self.count;
    hash = hash * 31 + [self.vertexSample hash];
    hash = hash * 31 + [self.indexSample hash];
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"vbo=%@", self.vbo];
    [description appendFormat:@", ibo=%@", self.ibo];
    [description appendFormat:@", count=%u", self.count];
    [description appendFormat:@", vertexSample=%@", self.vertexSample];
    [description appendFormat:@", indexSample=%@", self.indexSample];
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
    if(self) _model = [EGMeshModel applyMeshes:(@[tuple(TRModels.damage, [EGColorSource applyColor:GEVec4Make(1.0, 0.0, 0.0, 0.6)])])];
    
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
}
static ODClassType* _TRBackgroundView_type;
@synthesize map = _map;
@synthesize mapView = _mapView;

+ (id)backgroundViewWithMap:(EGMapSso*)map {
    return [[TRBackgroundView alloc] initWithMap:map];
}

- (id)initWithMap:(EGMapSso*)map {
    self = [super init];
    if(self) {
        _map = map;
        _mapView = [EGMapSsoView mapSsoViewWithMap:_map material:[EGColorSource applyTexture:[EGGlobal textureForFile:@"Grass.png" magFilter:GL_NEAREST minFilter:GL_NEAREST]]];
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


