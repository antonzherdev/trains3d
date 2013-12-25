#import "TRRailroadView.h"

#import "TRLevel.h"
#import "TRRailroad.h"
#import "EGMultisamplingSurface.h"
#import "EGCameraIso.h"
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
#import "TRStrings.h"
#import "EGBillboard.h"
#import "EGSchedule.h"
#import "EGSprite.h"
@implementation TRRailroadView{
    TRLevel* _level;
    TRRailroad* _railroad;
    TRRailView* _railView;
    TRSwitchView* _switchView;
    TRLightView* _lightView;
    TRDamageView* _damageView;
    EGViewportSurface* _railroadSurface;
    TRBackgroundView* _backgroundView;
    TRUndoView* _undoView;
    id _shadowVao;
    CNNotificationObserver* _obs1;
    CNNotificationObserver* _obs2;
    CNNotificationObserver* _obs3;
    BOOL __changed;
}
static ODClassType* _TRRailroadView_type;
@synthesize level = _level;
@synthesize railroad = _railroad;
@synthesize shadowVao = _shadowVao;
@synthesize _changed = __changed;

+ (id)railroadViewWithLevel:(TRLevel*)level {
    return [[TRRailroadView alloc] initWithLevel:level];
}

- (id)initWithLevel:(TRLevel*)level {
    self = [super init];
    __weak TRRailroadView* _weakSelf = self;
    if(self) {
        _level = level;
        _railroad = _level.railroad;
        _switchView = [TRSwitchView switchView];
        _lightView = [TRLightView lightViewWithRailroad:_level.railroad];
        _damageView = [TRDamageView damageViewWithRailroad:_level.railroad];
        _railroadSurface = [EGViewportSurface viewportSurfaceWithDepth:YES multisampling:YES];
        _undoView = [TRUndoView undoViewWithBuilder:_level.railroad.builder];
        _obs1 = [TRRailroad.changedNotification observeBy:^void(id _) {
            _weakSelf._changed = YES;
        }];
        _obs2 = [TRRailroadBuilder.changedNotification observeBy:^void(id _) {
            _weakSelf._changed = YES;
        }];
        _obs3 = [EGCameraIsoMove.cameraChangedNotification observeBy:^void(EGCameraIsoMove* _) {
            _weakSelf._changed = YES;
        }];
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
    EGGlobal.context.considerShadows = NO;
    _backgroundView = [TRBackgroundView backgroundViewWithLevel:_level];
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

- (void)drawLightGlows {
    [EGBlendFunction.standard applyDraw:^void() {
        [_damageView draw];
        [_lightView drawGlows];
    }];
}

- (void)drawForeground {
    egPushGroupMarker(@"Railroad foreground");
    [EGBlendFunction.standard applyDraw:^void() {
        [_undoView draw];
        [_damageView drawForeground];
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

- (EGRecognizers*)recognizers {
    return [_undoView recognizers];
}

- (void)updateWithDelta:(CGFloat)delta {
    [_damageView updateWithDelta:delta];
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
    return [self.level isEqual:o.level];
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.level hash];
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"level=%@", self.level];
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
    EGText* _text;
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
        _text = [EGText applyFont:nil text:[TRStr.Loc undo] position:GEVec3Make(0.0, 0.0, 0.0) alignment:egTextAlignmentApplyXY(0.0, 0.0) color:GEVec4Make(0.1, 0.1, 0.1, 1.0)];
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
    GEVec2 buttonSize = geVec4Xy([[EGGlobal.matrix p] divBySelfVec4:geVec4ApplyVec2ZW(geVec2DivVec2(geVec2ApplyF(64 * EGGlobal.context.scale), geVec2ApplyVec2i([EGGlobal.context viewport].size)), 0.0, 0.0)]);
    _button.material = [EGColorSource applyTexture:[[EGGlobal scaledTextureForName:@"Pause" format:@"png" magFilter:GL_NEAREST minFilter:GL_NEAREST] regionX:0.5 y:0.5 width:0.5 height:0.5]];
    _button.rect = GERectMake(geVec2DivI(geVec2Negate(buttonSize), 2), buttonSize);
}

- (void)draw {
    id rail = [_builder railForUndo];
    if([rail isEmpty] || _builder.building) {
        _empty = YES;
    } else {
        _empty = NO;
        [EGGlobal.context.depthTest disabledF:^void() {
            _button.position = geVec3ApplyVec2Z(geVec2ApplyVec2i(((TRRail*)([rail get])).tile), 0.0);
            [_button draw];
            [_text setPosition:_button.position];
            [_text draw];
        }];
    }
}

- (EGRecognizers*)recognizers {
    return [EGRecognizers applyRecognizer:[EGRecognizer applyTp:[EGTap apply] on:^BOOL(id<EGEvent> event) {
        if(_empty) return NO;
        GEVec2 p = [event locationInViewport];
        if([_button containsVec2:p]) {
            [_builder undo];
            return YES;
        } else {
            return NO;
        }
    }]];
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
    BOOL __matrixChanged;
    BOOL __bodyChanged;
    BOOL __matrixShadowChanged;
    BOOL __lightGlowChanged;
    CNNotificationObserver* _obs1;
    CNNotificationObserver* _obs2;
    CNNotificationObserver* _obs3;
    id<CNSeq> __matrixArr;
    EGMeshUnite* _bodies;
    EGMeshUnite* _shadows;
    EGMeshUnite* _glows;
}
static ODClassType* _TRLightView_type;
@synthesize railroad = _railroad;
@synthesize _matrixChanged = __matrixChanged;
@synthesize _bodyChanged = __bodyChanged;
@synthesize _matrixShadowChanged = __matrixShadowChanged;
@synthesize _lightGlowChanged = __lightGlowChanged;

+ (id)lightViewWithRailroad:(TRRailroad*)railroad {
    return [[TRLightView alloc] initWithRailroad:railroad];
}

- (id)initWithRailroad:(TRRailroad*)railroad {
    self = [super init];
    __weak TRLightView* _weakSelf = self;
    if(self) {
        _railroad = railroad;
        __matrixChanged = YES;
        __bodyChanged = YES;
        __matrixShadowChanged = YES;
        __lightGlowChanged = YES;
        _obs1 = [TRRailroad.changedNotification observeBy:^void(id _) {
            _weakSelf._matrixChanged = YES;
            _weakSelf._bodyChanged = YES;
            _weakSelf._matrixShadowChanged = YES;
            _weakSelf._lightGlowChanged = YES;
        }];
        _obs2 = [TRRailLight.turnNotification observeBy:^void(TRRailLight* _) {
            _weakSelf._lightGlowChanged = YES;
            _weakSelf._bodyChanged = YES;
        }];
        _obs3 = [EGCameraIsoMove.cameraChangedNotification observeBy:^void(EGCameraIsoMove* _) {
            _weakSelf._matrixChanged = YES;
            _weakSelf._bodyChanged = YES;
            _weakSelf._matrixShadowChanged = YES;
            _weakSelf._lightGlowChanged = YES;
        }];
        __matrixArr = (@[]);
        _bodies = [EGMeshUnite applyMeshModel:TRModels.light createVao:^EGVertexArray*(EGMesh* _) {
            return [_ vaoMaterial:[EGColorSource applyTexture:[EGGlobal textureForFile:@"Light.png" magFilter:GL_LINEAR minFilter:GL_LINEAR_MIPMAP_NEAREST]] shadow:NO];
        }];
        _shadows = [EGMeshUnite applyMeshModel:TRModels.light createVao:^EGVertexArray*(EGMesh* _) {
            return [_ vaoShadow];
        }];
        _glows = [EGMeshUnite meshUniteWithVertexSample:TRModels.lightGreenGlow indexSample:TRModels.lightGlowIndex createVao:^EGVertexArray*(EGMesh* _) {
            return [_ vaoMaterial:[EGColorSource applyTexture:[EGGlobal textureForFile:((egInterfaceIdiom().isPhone) ? @"LightGlowPhone.png" : @"LightGlow.png")]] shadow:NO];
        }];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _TRLightView_type = [ODClassType classTypeWithCls:[TRLightView class]];
}

- (CNChain*)calculateMatrixArr {
    return [[[_railroad lights] chain] map:^CNTuple*(TRRailLight* light) {
        return tuple([[EGGlobal.matrix.value modifyW:^GEMat4*(GEMat4* w) {
            return [w translateX:((float)(((TRRailLight*)(light)).tile.x)) y:((float)(((TRRailLight*)(light)).tile.y)) z:0.0];
        }] modifyM:^GEMat4*(GEMat4* m) {
            return [[m rotateAngle:((float)(90 + ((TRRailLight*)(light)).connector.angle)) x:0.0 y:1.0 z:0.0] translateVec3:[((TRRailLight*)(light)) shift]];
        }], light);
    }];
}

- (void)drawBodies {
    if(__matrixChanged) {
        __matrixArr = [[self calculateMatrixArr] toArray];
        __matrixChanged = NO;
    }
    if(__bodyChanged) {
        [_bodies writeCount:((unsigned int)([__matrixArr count])) f:^void(EGMeshWriter* writer) {
            [__matrixArr forEach:^void(CNTuple* p) {
                BOOL g = ((TRRailLight*)(((CNTuple*)(p)).b)).isGreen;
                [writer writeMap:^EGMeshData(EGMeshData _) {
                    return egMeshDataMulMat4(((g) ? _ : egMeshDataUvAddVec2(_, GEVec2Make(0.5, 0.0))), [((EGMatrixModel*)(((CNTuple*)(p)).a)) mwcp]);
                }];
            }];
        }];
        __bodyChanged = NO;
    }
    [_bodies draw];
}

- (void)drawShadow {
    if(__matrixShadowChanged) {
        [_shadows writeMat4Array:[[[self calculateMatrixArr] map:^GEMat4*(CNTuple* _) {
            return [((EGMatrixModel*)(((CNTuple*)(_)).a)) mwcp];
        }] toArray]];
        __matrixShadowChanged = NO;
    }
    [_shadows draw];
}

- (void)drawGlows {
    if(!([__matrixArr isEmpty]) && !([EGGlobal.context.renderTarget isKindOfClass:[EGShadowRenderTarget class]])) {
        if(__lightGlowChanged) {
            [_glows writeCount:((unsigned int)([__matrixArr count])) f:^void(EGMeshWriter* writer) {
                [__matrixArr forEach:^void(CNTuple* p) {
                    [writer writeVertex:((((TRRailLight*)(((CNTuple*)(p)).b)).isGreen) ? TRModels.lightGreenGlow : TRModels.lightRedGlow) mat4:[((EGMatrixModel*)(((CNTuple*)(p)).a)) mwcp]];
                }];
            }];
            __lightGlowChanged = NO;
        }
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


@implementation TRDamageView{
    TRRailroad* _railroad;
    EGMeshModel* _model;
    EGMutableCounterArray* _sporadicAnimations;
    CNNotificationObserver* _spObs;
}
static ODClassType* _TRDamageView_type;
@synthesize railroad = _railroad;
@synthesize model = _model;
@synthesize sporadicAnimations = _sporadicAnimations;
@synthesize spObs = _spObs;

+ (id)damageViewWithRailroad:(TRRailroad*)railroad {
    return [[TRDamageView alloc] initWithRailroad:railroad];
}

- (id)initWithRailroad:(TRRailroad*)railroad {
    self = [super init];
    __weak TRDamageView* _weakSelf = self;
    if(self) {
        _railroad = railroad;
        _model = [EGMeshModel applyMeshes:(@[tuple(TRModels.damage, [EGColorSource applyColor:GEVec4Make(1.0, 0.0, 0.0, 0.3)])])];
        _sporadicAnimations = [EGMutableCounterArray mutableCounterArray];
        _spObs = [TRLevel.sporadicDamageNotification observeBy:^void(CNTuple* p) {
            [_weakSelf.sporadicAnimations appendCounter:[EGLengthCounter lengthCounterWithLength:2.0] data:((CNTuple*)(p)).b];
        }];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _TRDamageView_type = [ODClassType classTypeWithCls:[TRDamageView class]];
}

- (void)drawPoint:(TRRailPoint)point {
    [EGGlobal.matrix applyModify:^EGMatrixModel*(EGMatrixModel* _) {
        return [[_ modifyW:^GEMat4*(GEMat4* w) {
            return [w translateX:point.point.x y:point.point.y z:0.0];
        }] modifyM:^GEMat4*(GEMat4* m) {
            return [m rotateAngle:[self angleForPoint:point] x:0.0 y:1.0 z:0.0];
        }];
    } f:^void() {
        [_model draw];
    }];
}

- (void)draw {
    [[_railroad damagesPoints] forEach:^void(id _) {
        [self drawPoint:uwrap(TRRailPoint, _)];
    }];
}

- (void)drawForeground {
    [EGGlobal.context.depthTest disabledF:^void() {
        [_sporadicAnimations forEach:^void(EGCounterData* counter) {
            [EGD2D drawCircleBackColor:GEVec4Make(1.0, 0.0, 0.0, 0.5) strokeColor:GEVec4Make(1.0, 0.0, 0.0, 0.5) at:geVec3ApplyVec2Z(uwrap(TRRailPoint, counter.data).point, 0.0) radius:((float)(0.1 * [counter invTime])) relative:GEVec2Make(0.0, 0.0)];
        }];
    }];
}

- (float)angleForPoint:(TRRailPoint)point {
    TRRailPoint p = trRailPointStraight(point);
    TRRailPoint a = trRailPointAddX(p, -0.1);
    TRRailPoint b = trRailPointAddX(p, 0.1);
    GELine2 line = geLine2ApplyP0P1(a.point, b.point);
    float angle = geLine2DegreeAngle(line);
    return angle + 90;
}

- (void)updateWithDelta:(CGFloat)delta {
    [_sporadicAnimations updateWithDelta:delta];
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
    TRDamageView* o = ((TRDamageView*)(other));
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


@implementation TRBackgroundView{
    TRLevel* _level;
    EGMapSsoView* _mapView;
}
static ODClassType* _TRBackgroundView_type;
@synthesize level = _level;
@synthesize mapView = _mapView;

+ (id)backgroundViewWithLevel:(TRLevel*)level {
    return [[TRBackgroundView alloc] initWithLevel:level];
}

- (id)initWithLevel:(TRLevel*)level {
    self = [super init];
    if(self) {
        _level = level;
        _mapView = [EGMapSsoView mapSsoViewWithMap:_level.map material:[EGColorSource applyTexture:[EGGlobal textureForFile:_level.rules.theme.background magFilter:GL_NEAREST minFilter:GL_NEAREST]]];
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
    return [self.level isEqual:o.level];
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.level hash];
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"level=%@", self.level];
    [description appendString:@">"];
    return description;
}

@end


