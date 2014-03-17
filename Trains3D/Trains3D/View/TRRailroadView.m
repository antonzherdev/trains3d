#import "TRRailroadView.h"

#import "TRLevel.h"
#import "TRRailroad.h"
#import "EGPlatformPlat.h"
#import "EGPlatform.h"
#import "EGMultisamplingSurface.h"
#import "TRGameDirector.h"
#import "TRRailroadBuilder.h"
#import "EGCameraIso.h"
#import "EGContext.h"
#import "EGShadow.h"
#import "EGMapIsoView.h"
#import "GL.h"
#import "EGVertexArray.h"
#import "EGMaterial.h"
#import "EGDirector.h"
#import "EGTexture.h"
#import "TRModels.h"
#import "GEMat4.h"
#import "EGMatrixModel.h"
#import "ATReact.h"
#import "EGSprite.h"
#import "EGSchedule.h"
@implementation TRRailroadView
static ODClassType* _TRRailroadView_type;
@synthesize level = _level;
@synthesize railroad = _railroad;
@synthesize shadowVao = _shadowVao;
@synthesize _changed = __changed;

+ (instancetype)railroadViewWithLevel:(TRLevel*)level {
    return [[TRRailroadView alloc] initWithLevel:level];
}

- (instancetype)initWithLevel:(TRLevel*)level {
    self = [super init];
    __weak TRRailroadView* _weakSelf = self;
    if(self) {
        _level = level;
        _railroad = _level.railroad;
        _switchView = [TRSwitchView switchView];
        _lightView = [TRLightView lightViewWithRailroad:_level.railroad];
        _damageView = [TRDamageView damageViewWithRailroad:_level.railroad];
        _iOS6 = [egPlatform() isIOSLessVersion:@"7"];
        _railroadSurface = [EGViewportSurface toTextureDepth:YES multisampling:[TRGameDirector.instance railroadAA]];
        _undoView = [TRUndoView undoViewWithBuilder:_level.builder];
        _obs1 = [TRRailroad.changedNotification observeBy:^void(TRRailroad* _0, id _1) {
            TRRailroadView* _self = _weakSelf;
            _self->__changed = YES;
        }];
        _obs2 = [TRRailroadBuilder.changedNotification observeBy:^void(TRRailroadBuilder* _0, id _1) {
            TRRailroadView* _self = _weakSelf;
            _self->__changed = YES;
        }];
        _obs3 = [EGCameraIsoMove.cameraChangedNotification observeBy:^void(EGCameraIsoMove* _0, id _1) {
            TRRailroadView* _self = _weakSelf;
            _self->__changed = YES;
        }];
        __changed = YES;
        [self _init];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [TRRailroadView class]) _TRRailroadView_type = [ODClassType classTypeWithCls:[TRRailroadView class]];
}

- (void)_init {
    EGGlobal.context.considerShadows = NO;
    _backgroundView = [TRBackgroundView backgroundViewWithLevel:_level];
    _railView = [TRRailView railViewWithRailroad:_railroad];
    EGShadowDrawParam* shadowParam = [EGShadowDrawParam shadowDrawParamWithPercents:(@[@0.3]) viewportSurface:[CNOption applyValue:_railroadSurface]];
    _shadowVao = ((egPlatform().shadows) ? [CNOption applyValue:[_backgroundView.mapView.plane vaoShaderSystem:EGShadowDrawShaderSystem.instance material:shadowParam shadow:NO]] : [CNOption none]);
    EGGlobal.context.considerShadows = YES;
}

- (void)drawBackgroundRrState:(TRRailroadState*)rrState {
    egPushGroupMarker(@"Railroad background");
    if([EGGlobal.context.renderTarget isShadow]) {
        [_lightView drawShadowRrState:rrState];
    } else {
        if(egPlatform().shadows) [EGGlobal.context.depthTest disabledF:^void() {
            [EGGlobal.context.cullFace disabledF:^void() {
                [((EGVertexArray*)([_shadowVao get])) draw];
            }];
        }];
        else [_railroadSurface draw];
        [_lightView drawBodiesRrState:rrState];
    }
    egPopGroupMarker();
}

- (void)drawLightGlowsRrState:(TRRailroadState*)rrState {
    [EGBlendFunction.standard applyDraw:^void() {
        [_damageView drawRrState:rrState];
        [_lightView drawGlows];
    }];
}

- (void)drawForegroundRrState:(TRRailroadState*)rrState {
    egPushGroupMarker(@"Railroad foreground");
    [EGBlendFunction.standard applyDraw:^void() {
        [EGGlobal.context.cullFace disabledF:^void() {
            [[rrState switches] forEach:^void(TRSwitchState* _) {
                [_switchView drawTheSwitch:_];
            }];
            [_undoView draw];
            [_damageView drawForeground];
        }];
    }];
    egPopGroupMarker();
}

- (void)prepare {
    [_railroadSurface maybeForce:__changed draw:^void() {
        [EGGlobal.context clearColorColor:GEVec4Make(0.0, 0.0, 0.0, 0.0)];
        glClear(GL_COLOR_BUFFER_BIT + GL_DEPTH_BUFFER_BIT);
        EGGlobal.context.considerShadows = NO;
        [self drawSurface];
        EGGlobal.context.considerShadows = YES;
        __changed = NO;
        if(_iOS6) glFinish();
    }];
}

- (void)drawSurface {
    [[[_level.builder state] joinAnother:[_level.railroad state]] waitAndOnSuccessAwait:1.0 f:^void(CNTuple* t) {
        TRRailroadBuilderState* builderState = ((CNTuple*)(t)).a;
        TRRailroadState* rrState = ((CNTuple*)(t)).b;
        [_backgroundView draw];
        id building = [builderState.notFixedRailBuilding mapF:^TRRail*(TRRailBuilding* _) {
            return ((TRRailBuilding*)(_)).rail;
        }];
        BOOL builderIsLocked = builderState.isLocked;
        [[rrState rails] forEach:^void(TRRail* rail) {
            if(builderIsLocked || !([building containsItem:rail])) [_railView drawRail:rail];
        }];
        if(!(builderIsLocked)) [builderState.notFixedRailBuilding forEach:^void(TRRailBuilding* nf) {
            if([((TRRailBuilding*)(nf)) isConstruction]) [_railView drawRailBuilding:nf];
            else [_railView drawRail:((TRRailBuilding*)(nf)).rail count:2];
        }];
        [builderState.buildingRails forEach:^void(TRRailBuilding* _) {
            [_railView drawRailBuilding:_];
        }];
    }];
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


@implementation TRRailView
static ODClassType* _TRRailView_type;
@synthesize railroad = _railroad;
@synthesize railMaterial = _railMaterial;
@synthesize gravel = _gravel;
@synthesize railModel = _railModel;
@synthesize railTurnModel = _railTurnModel;

+ (instancetype)railViewWithRailroad:(TRRailroad*)railroad {
    return [[TRRailView alloc] initWithRailroad:railroad];
}

- (instancetype)initWithRailroad:(TRRailroad*)railroad {
    self = [super init];
    if(self) {
        _railroad = railroad;
        _railMaterial = [EGStandardMaterial standardMaterialWithDiffuse:[EGColorSource applyColor:GEVec4Make(0.5, 0.5, 0.6, 1.0)] specularColor:GEVec4Make(0.5, 0.5, 0.5, 1.0) specularSize:0.3 normalMap:[CNOption none]];
        _gravel = [EGGlobal compressedTextureForFile:@"Gravel"];
        _railModel = [EGMeshModel applyMeshes:(@[tuple(TRModels.railGravel, [EGMaterial applyTexture:_gravel]), tuple(TRModels.railTies, ([EGMaterial applyColor:GEVec4Make(0.55, 0.45, 0.25, 1.0)])), tuple(TRModels.rails, _railMaterial)])];
        _railTurnModel = [EGMeshModel applyMeshes:(@[tuple(TRModels.railTurnGravel, [EGMaterial applyTexture:_gravel]), tuple(TRModels.railTurnTies, ([EGMaterial applyColor:GEVec4Make(0.55, 0.45, 0.25, 1.0)])), tuple(TRModels.railsTurn, _railMaterial)])];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [TRRailView class]) _TRRailView_type = [ODClassType classTypeWithCls:[TRRailView class]];
}

- (void)drawRailBuilding:(TRRailBuilding*)railBuilding {
    float p = (([railBuilding isConstruction]) ? railBuilding.progress : ((float)(1.0 - railBuilding.progress)));
    [self drawRail:railBuilding.rail count:((p < 0.5) ? 1 : 2)];
}

- (void)drawRail:(TRRail*)rail {
    [self drawRail:rail count:3];
}

- (void)drawRail:(TRRail*)rail count:(unsigned int)count {
    [EGGlobal.matrix applyModify:^void(EGMMatrixModel* _) {
        [[_ modifyW:^GEMat4*(GEMat4* w) {
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
                    [[EGGlobal.matrix value] modifyW:^GEMat4*(GEMat4* w) {
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


@implementation TRUndoView
static ODClassType* _TRUndoView_type;
@synthesize builder = _builder;

+ (instancetype)undoViewWithBuilder:(TRRailroadBuilder*)builder {
    return [[TRUndoView alloc] initWithBuilder:builder];
}

- (instancetype)initWithBuilder:(TRRailroadBuilder*)builder {
    self = [super init];
    if(self) {
        _builder = builder;
        _empty = YES;
        _buttonPos = [ATVar var];
        _button = [EGSprite applyMaterial:[ATReact applyValue:[[[EGGlobal scaledTextureForName:@"Pause" format:EGTextureFormat.RGBA4] regionX:32.0 y:32.0 width:32.0 height:32.0] colorSource]] position:_buttonPos];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [TRUndoView class]) _TRUndoView_type = [ODClassType classTypeWithCls:[TRUndoView class]];
}

- (void)draw {
    [[_builder state] waitAndOnSuccessAwait:1.0 f:^void(TRRailroadBuilderState* s) {
        id rail = [((TRRailroadBuilderState*)(s)) railForUndo];
        if([rail isEmpty] || ((TRRailroadBuilderState*)(s)).isBuilding) {
            _empty = YES;
        } else {
            _empty = NO;
            [EGGlobal.context.depthTest disabledF:^void() {
                [_buttonPos setValue:wrap(GEVec3, (geVec3ApplyVec2Z(geVec2ApplyVec2i(((TRRail*)([rail get])).tile), 0.0)))];
                [_button draw];
            }];
        }
    }];
}

- (EGRecognizers*)recognizers {
    return [EGRecognizers applyRecognizer:[EGRecognizer applyTp:[EGTap apply] on:^BOOL(id<EGEvent> event) {
        if(_empty) return NO;
        GEVec2 p = [event locationInViewport];
        if([_button containsViewportVec2:p]) {
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


@implementation TRSwitchView
static ODClassType* _TRSwitchView_type;
@synthesize material = _material;
@synthesize switchStraightModel = _switchStraightModel;
@synthesize switchTurnModel = _switchTurnModel;

+ (instancetype)switchView {
    return [[TRSwitchView alloc] init];
}

- (instancetype)init {
    self = [super init];
    if(self) {
        _material = [EGColorSource applyTexture:[EGGlobal compressedTextureForFile:@"Switches" filter:EGTextureFilter.mipmapNearest]];
        _switchStraightModel = [EGMeshModel applyMeshes:(@[tuple(TRModels.switchStraight, _material)])];
        _switchTurnModel = [EGMeshModel applyMeshes:(@[tuple(TRModels.switchTurn, _material)])];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [TRSwitchView class]) _TRSwitchView_type = [ODClassType classTypeWithCls:[TRSwitchView class]];
}

- (void)drawTheSwitch:(TRSwitchState*)theSwitch {
    TRRailConnector* connector = [theSwitch connector];
    TRRail* rail = [theSwitch activeRail];
    TRRailForm* form = rail.form;
    __block BOOL ref = NO;
    [EGGlobal.matrix applyModify:^void(EGMMatrixModel* _) {
        [[_ modifyW:^GEMat4*(GEMat4* w) {
            return [w translateX:((float)([theSwitch tile].x)) y:((float)([theSwitch tile].y)) z:0.03];
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
        if(form.start.x + form.end.x == 0) [_switchStraightModel draw];
        else [_switchTurnModel draw];
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


@implementation TRLightView
static ODClassType* _TRLightView_type;
@synthesize railroad = _railroad;
@synthesize _matrixChanged = __matrixChanged;
@synthesize _bodyChanged = __bodyChanged;
@synthesize _matrixShadowChanged = __matrixShadowChanged;
@synthesize _lightGlowChanged = __lightGlowChanged;

+ (instancetype)lightViewWithRailroad:(TRRailroad*)railroad {
    return [[TRLightView alloc] initWithRailroad:railroad];
}

- (instancetype)initWithRailroad:(TRRailroad*)railroad {
    self = [super init];
    __weak TRLightView* _weakSelf = self;
    if(self) {
        _railroad = railroad;
        __matrixChanged = YES;
        __bodyChanged = YES;
        __matrixShadowChanged = YES;
        __lightGlowChanged = YES;
        _obs1 = [TRRailroad.changedNotification observeSender:_railroad by:^void(id _) {
            TRLightView* _self = _weakSelf;
            _self->__matrixChanged = YES;
            _self->__bodyChanged = YES;
            _self->__matrixShadowChanged = YES;
            _self->__lightGlowChanged = YES;
        }];
        _obs2 = [TRRailroad.lightTurnNotification observeSender:_railroad by:^void(TRRailLightState* _) {
            TRLightView* _self = _weakSelf;
            _self->__lightGlowChanged = YES;
            _self->__bodyChanged = YES;
            _self->__matrixChanged = YES;
        }];
        _obs3 = [EGCameraIsoMove.cameraChangedNotification observeBy:^void(EGCameraIsoMove* _, id __) {
            TRLightView* _self = _weakSelf;
            _self->__matrixChanged = YES;
            _self->__bodyChanged = YES;
            _self->__matrixShadowChanged = YES;
            _self->__lightGlowChanged = YES;
        }];
        __matrixArr = (@[]);
        _bodies = [EGMeshUnite applyMeshModel:TRModels.light createVao:^EGVertexArray*(EGMesh* _) {
            return [_ vaoMaterial:[EGColorSource applyTexture:[EGGlobal compressedTextureForFile:@"Light" filter:EGTextureFilter.linear]] shadow:NO];
        }];
        _shadows = [EGMeshUnite applyMeshModel:TRModels.light createVao:^EGVertexArray*(EGMesh* _) {
            return [_ vaoShadow];
        }];
        _glows = [EGMeshUnite meshUniteWithVertexSample:TRModels.lightGreenGlow indexSample:TRModels.lightGlowIndex createVao:^EGVertexArray*(EGMesh* _) {
            return [_ vaoMaterial:[EGColorSource applyTexture:[EGGlobal compressedTextureForFile:((egPlatform().isPhone) ? @"LightGlowPhone" : @"LightGlow") filter:EGTextureFilter.mipmapNearest]] shadow:NO];
        }];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [TRLightView class]) _TRLightView_type = [ODClassType classTypeWithCls:[TRLightView class]];
}

- (CNChain*)calculateMatrixArrRrState:(TRRailroadState*)rrState {
    return [[[rrState lights] chain] map:^CNTuple*(TRRailLightState* light) {
        return tuple([[[[EGGlobal.matrix value] copy] modifyW:^GEMat4*(GEMat4* w) {
            return [w translateX:((float)([((TRRailLightState*)(light)) tile].x)) y:((float)([((TRRailLightState*)(light)) tile].y)) z:0.0];
        }] modifyM:^GEMat4*(GEMat4* m) {
            return [[m rotateAngle:((float)(90 + [((TRRailLightState*)(light)) connector].angle)) x:0.0 y:1.0 z:0.0] translateVec3:[((TRRailLightState*)(light)) shift]];
        }], light);
    }];
}

- (void)drawBodiesRrState:(TRRailroadState*)rrState {
    if(__matrixChanged) {
        __matrixArr = [[self calculateMatrixArrRrState:rrState] toArray];
        __matrixChanged = NO;
    }
    if(__bodyChanged) {
        [_bodies writeCount:((unsigned int)([__matrixArr count])) f:^void(EGMeshWriter* writer) {
            [__matrixArr forEach:^void(CNTuple* p) {
                BOOL g = ((TRRailLightState*)(((CNTuple*)(p)).b)).isGreen;
                [writer writeMap:^EGMeshData(EGMeshData _) {
                    return egMeshDataMulMat4((((g) ? _ : egMeshDataUvAddVec2(_, (GEVec2Make(0.5, 0.0))))), [((EGMatrixModel*)(((CNTuple*)(p)).a)) mwcp]);
                }];
            }];
        }];
        __bodyChanged = NO;
    }
    [_bodies draw];
}

- (void)drawShadowRrState:(TRRailroadState*)rrState {
    if(__matrixShadowChanged) {
        [_shadows writeMat4Array:[[[self calculateMatrixArrRrState:rrState] map:^GEMat4*(CNTuple* _) {
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
                    [writer writeVertex:((((TRRailLightState*)(((CNTuple*)(p)).b)).isGreen) ? TRModels.lightGreenGlow : TRModels.lightRedGlow) mat4:[((EGMatrixModel*)(((CNTuple*)(p)).a)) mwcp]];
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


@implementation TRDamageView
static ODClassType* _TRDamageView_type;
@synthesize railroad = _railroad;
@synthesize model = _model;
@synthesize sporadicAnimations = _sporadicAnimations;
@synthesize spObs = _spObs;

+ (instancetype)damageViewWithRailroad:(TRRailroad*)railroad {
    return [[TRDamageView alloc] initWithRailroad:railroad];
}

- (instancetype)initWithRailroad:(TRRailroad*)railroad {
    self = [super init];
    __weak TRDamageView* _weakSelf = self;
    if(self) {
        _railroad = railroad;
        _model = [EGMeshModel applyMeshes:(@[tuple(TRModels.damage, ([EGColorSource applyColor:GEVec4Make(1.0, 0.0, 0.0, 0.3)]))])];
        _sporadicAnimations = [EGMutableCounterArray mutableCounterArray];
        _spObs = [TRLevel.sporadicDamageNotification observeBy:^void(TRLevel* level, id point) {
            TRDamageView* _self = _weakSelf;
            [_self->_sporadicAnimations appendCounter:[EGLengthCounter lengthCounterWithLength:3.0] data:point];
        }];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [TRDamageView class]) _TRDamageView_type = [ODClassType classTypeWithCls:[TRDamageView class]];
}

- (void)drawPoint:(TRRailPoint)point {
    [EGGlobal.matrix applyModify:^void(EGMMatrixModel* _) {
        [[_ modifyW:^GEMat4*(GEMat4* w) {
            return [w translateX:point.point.x y:point.point.y z:0.0];
        }] modifyM:^GEMat4*(GEMat4* m) {
            return [m rotateAngle:[self angleForPoint:point] x:0.0 y:1.0 z:0.0];
        }];
    } f:^void() {
        [_model draw];
    }];
}

- (void)drawRrState:(TRRailroadState*)rrState {
    [rrState.damages.points forEach:^void(id _) {
        [self drawPoint:uwrap(TRRailPoint, _)];
    }];
}

- (void)drawForeground {
    [EGGlobal.context.depthTest disabledF:^void() {
        [_sporadicAnimations forEach:^void(EGCounterData* counter) {
            [EGD2D drawCircleBackColor:GEVec4Make(1.0, 0.0, 0.0, 0.5) strokeColor:GEVec4Make(1.0, 0.0, 0.0, 0.5) at:geVec3ApplyVec2Z((uwrap(TRRailPoint, counter.data).point), 0.0) radius:((float)(0.5 * (1.0 - unumf([[counter time] value])))) relative:GEVec2Make(0.0, 0.0)];
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


@implementation TRBackgroundView
static ODClassType* _TRBackgroundView_type;
@synthesize level = _level;
@synthesize mapView = _mapView;

+ (instancetype)backgroundViewWithLevel:(TRLevel*)level {
    return [[TRBackgroundView alloc] initWithLevel:level];
}

- (instancetype)initWithLevel:(TRLevel*)level {
    self = [super init];
    if(self) {
        _level = level;
        _mapView = [EGMapSsoView mapSsoViewWithMap:_level.map material:[EGColorSource applyTexture:[EGGlobal compressedTextureForFile:_level.rules.theme.background filter:EGTextureFilter.nearest]]];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [TRBackgroundView class]) _TRBackgroundView_type = [ODClassType classTypeWithCls:[TRBackgroundView class]];
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


