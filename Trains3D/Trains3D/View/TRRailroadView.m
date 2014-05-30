#import "TRRailroadView.h"

#import "TRLevelView.h"
#import "TRRailroad.h"
#import "EGPlatformPlat.h"
#import "EGPlatform.h"
#import "EGMultisamplingSurface.h"
#import "TRGameDirector.h"
#import "EGVertexArray.h"
#import "CNReact.h"
#import "TRRailroadBuilder.h"
#import "EGCameraIso.h"
#import "EGContext.h"
#import "EGShadow.h"
#import "EGMapIsoView.h"
#import "GL.h"
#import "EGMaterial.h"
#import "CNFuture.h"
#import "TRModels.h"
#import "EGMatrixModel.h"
#import "GEMat4.h"
#import "EGSprite.h"
#import "CNChain.h"
#import "EGSchedule.h"
#import "CNObserver.h"
#import "EGD2D.h"
@implementation TRRailroadView
static CNClassType* _TRRailroadView_type;
@synthesize levelView = _levelView;
@synthesize level = _level;
@synthesize railroad = _railroad;
@synthesize shadowVao = _shadowVao;

+ (instancetype)railroadViewWithLevelView:(TRLevelView*)levelView level:(TRLevel*)level {
    return [[TRRailroadView alloc] initWithLevelView:levelView level:level];
}

- (instancetype)initWithLevelView:(TRLevelView*)levelView level:(TRLevel*)level {
    self = [super init];
    if(self) {
        _levelView = levelView;
        _level = level;
        _railroad = level.railroad;
        _switchView = [TRSwitchView switchView];
        _lightView = [TRLightView lightViewWithLevelView:levelView railroad:level.railroad];
        _damageView = [TRDamageView damageViewWithRailroad:level.railroad];
        _iOS6 = [egPlatform().os isIOSLessVersion:@"7"];
        _railroadSurface = [EGViewportSurface toTextureDepth:YES multisampling:[TRGameDirector.instance railroadAA]];
        _undoView = [TRUndoView undoViewWithBuilder:level.builder];
        __changed = [CNReactFlag reactFlagWithInitial:YES reacts:(@[((CNSignal*)(level.railroad.railWasBuilt)), ((CNSignal*)(level.railroad.railWasRemoved)), ((CNSignal*)(level.builder.changed)), ((CNSignal*)([levelView cameraMove].changed)), ((CNSignal*)(level.railroad.stateWasRestored))])];
        if([self class] == [TRRailroadView class]) [self _init];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [TRRailroadView class]) _TRRailroadView_type = [CNClassType classTypeWithCls:[TRRailroadView class]];
}

- (void)_init {
    EGGlobal.context.considerShadows = NO;
    _backgroundView = [TRBackgroundView backgroundViewWithLevel:_level];
    _railView = [TRRailView railViewWithRailroad:_railroad];
    EGShadowDrawParam* shadowParam = [EGShadowDrawParam shadowDrawParamWithPercents:(@[@0.3]) viewportSurface:_railroadSurface];
    _shadowVao = ((egPlatform().shadows) ? [_backgroundView.mapView.plane vaoShaderSystem:EGShadowDrawShaderSystem.instance material:shadowParam shadow:NO] : nil);
    EGGlobal.context.considerShadows = YES;
}

- (void)drawBackgroundRrState:(TRRailroadState*)rrState {
    egPushGroupMarker(@"Railroad background");
    if([EGGlobal.context.renderTarget isShadow]) {
        [_lightView drawShadowRrState:rrState];
    } else {
        if(egPlatform().shadows) {
            EGCullFace* __tmp__il__1f_0t_0self = EGGlobal.context.cullFace;
            {
                unsigned int __il__1f_0t_0oldValue = [__tmp__il__1f_0t_0self disable];
                {
                    EGEnablingState* __tmp__il__1f_0t_0rp0self = EGGlobal.context.depthTest;
                    {
                        BOOL __il__1f_0t_0rp0changed = [__tmp__il__1f_0t_0rp0self disable];
                        [((EGVertexArray*)(_shadowVao)) draw];
                        if(__il__1f_0t_0rp0changed) [__tmp__il__1f_0t_0rp0self enable];
                    }
                }
                if(__il__1f_0t_0oldValue != GL_NONE) [__tmp__il__1f_0t_0self setValue:__il__1f_0t_0oldValue];
            }
        } else {
            EGEnablingState* __tmp__il__1f_0f_0self = EGGlobal.context.depthTest;
            {
                BOOL __il__1f_0f_0changed = [__tmp__il__1f_0f_0self disable];
                [_railroadSurface draw];
                if(__il__1f_0f_0changed) [__tmp__il__1f_0f_0self enable];
            }
        }
        [_lightView drawBodiesRrState:rrState];
    }
    egPopGroupMarker();
}

- (void)drawLightGlowsRrState:(TRRailroadState*)rrState {
    EGEnablingState* __il__0__tmp__il__0self = EGGlobal.context.blend;
    {
        BOOL __il__0__il__0changed = [__il__0__tmp__il__0self enable];
        {
            [EGGlobal.context setBlendFunction:EGBlendFunction.standard];
            {
                [_damageView drawRrState:rrState];
                [_lightView drawGlows];
            }
        }
        if(__il__0__il__0changed) [__il__0__tmp__il__0self disable];
    }
}

- (void)drawSwitchesRrState:(TRRailroadState*)rrState {
    egPushGroupMarker(@"Switches");
    EGEnablingState* __il__1__tmp__il__0self = EGGlobal.context.blend;
    {
        BOOL __il__1__il__0changed = [__il__1__tmp__il__0self enable];
        {
            [EGGlobal.context setBlendFunction:EGBlendFunction.standard];
            {
                EGCullFace* __tmp__il__1rp0self = EGGlobal.context.cullFace;
                {
                    unsigned int __il__1rp0oldValue = [__tmp__il__1rp0self disable];
                    for(TRSwitchState* _ in [rrState switches]) {
                        [_switchView drawTheSwitch:_];
                    }
                    if(__il__1rp0oldValue != GL_NONE) [__tmp__il__1rp0self setValue:__il__1rp0oldValue];
                }
            }
        }
        if(__il__1__il__0changed) [__il__1__tmp__il__0self disable];
    }
    egPopGroupMarker();
}

- (void)drawForegroundRrState:(TRRailroadState*)rrState {
    egPushGroupMarker(@"Railroad foreground");
    EGEnablingState* __il__1__tmp__il__0self = EGGlobal.context.blend;
    {
        BOOL __il__1__il__0changed = [__il__1__tmp__il__0self enable];
        {
            [EGGlobal.context setBlendFunction:EGBlendFunction.standard];
            {
                EGCullFace* __tmp__il__1rp0self = EGGlobal.context.cullFace;
                {
                    unsigned int __il__1rp0oldValue = [__tmp__il__1rp0self disable];
                    {
                        for(TRSwitchState* _ in [rrState switches]) {
                            [_switchView drawTheSwitch:_];
                        }
                        {
                            EGEnablingState* __tmp__il__1rp0rp0_1self = EGGlobal.context.depthTest;
                            {
                                BOOL __il__1rp0rp0_1changed = [__tmp__il__1rp0rp0_1self disable];
                                {
                                    [_undoView draw];
                                    [_damageView drawForeground];
                                }
                                if(__il__1rp0rp0_1changed) [__tmp__il__1rp0rp0_1self enable];
                            }
                        }
                    }
                    if(__il__1rp0oldValue != GL_NONE) [__tmp__il__1rp0self setValue:__il__1rp0oldValue];
                }
            }
        }
        if(__il__1__il__0changed) [__il__1__tmp__il__0self disable];
    }
    egPopGroupMarker();
}

- (void)prepare {
    if(unumb([__changed value]) || [_railroadSurface needRedraw]) {
        [_railroadSurface bind];
        {
            [__changed clear];
            [EGGlobal.context clearColorColor:GEVec4Make(0.0, 0.0, 0.0, 0.0)];
            glClear(GL_COLOR_BUFFER_BIT + GL_DEPTH_BUFFER_BIT);
            EGGlobal.context.considerShadows = NO;
            [self drawSurface];
            EGGlobal.context.considerShadows = YES;
            if(_iOS6) glFinish();
        }
        [_railroadSurface unbind];
    }
}

- (void)drawSurface {
    CNTry* __il__0__tr = [[[_level.builder state] joinAnother:[_level.railroad state]] waitResultPeriod:1.0];
    if(__il__0__tr != nil) {
        if([((CNTry*)(__il__0__tr)) isSuccess]) {
            CNTuple* t = [((CNTry*)(__il__0__tr)) get];
            {
                TRRailroadBuilderState* builderState = ((CNTuple*)(t)).a;
                TRRailroadState* rrState = ((CNTuple*)(t)).b;
                [_backgroundView draw];
                TRRail* building = ((TRRailBuilding*)(builderState.notFixedRailBuilding)).rail;
                for(TRRail* rail in [rrState rails]) {
                    if(building == nil || !([building isEqual:rail])) [_railView drawRail:rail];
                }
                {
                    TRRailBuilding* nf = builderState.notFixedRailBuilding;
                    if(nf != nil) {
                        if([((TRRailBuilding*)(nf)) isConstruction]) [_railView drawRailBuilding:nf];
                        else [_railView drawRail:((TRRailBuilding*)(nf)).rail count:2];
                    }
                }
                {
                    id<CNIterator> __il__0r_6i = [builderState.buildingRails iterator];
                    while([__il__0r_6i hasNext]) {
                        TRRailBuilding* _ = [__il__0r_6i next];
                        [_railView drawRailBuilding:_];
                    }
                }
            }
        }
    }
}

- (EGRecognizers*)recognizers {
    return [_undoView recognizers];
}

- (void)updateWithDelta:(CGFloat)delta {
    [_damageView updateWithDelta:delta];
}

- (NSString*)description {
    return [NSString stringWithFormat:@"RailroadView(%@, %@)", _levelView, _level];
}

- (CNClassType*)type {
    return [TRRailroadView type];
}

+ (CNClassType*)type {
    return _TRRailroadView_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation TRRailView
static CNClassType* _TRRailView_type;
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
        _railMaterial = [EGStandardMaterial standardMaterialWithDiffuse:[EGColorSource applyColor:GEVec4Make(0.5, 0.5, 0.6, 1.0)] specularColor:GEVec4Make(0.5, 0.5, 0.5, 1.0) specularSize:0.3 normalMap:nil];
        _gravel = [EGGlobal compressedTextureForFile:@"Gravel"];
        _railModel = [EGMeshModel applyMeshes:(@[((CNTuple*)(tuple(TRModels.railGravel, [_gravel colorSource]))), ((CNTuple*)(tuple(TRModels.railTies, ([EGColorSource applyColor:GEVec4Make(0.55, 0.45, 0.25, 1.0)])))), ((CNTuple*)(tuple(TRModels.rails, _railMaterial)))])];
        _railTurnModel = [EGMeshModel applyMeshes:(@[((CNTuple*)(tuple(TRModels.railTurnGravel, [_gravel colorSource]))), ((CNTuple*)(tuple(TRModels.railTurnTies, ([EGColorSource applyColor:GEVec4Make(0.55, 0.45, 0.25, 1.0)])))), ((CNTuple*)(tuple(TRModels.railsTurn, _railMaterial)))])];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [TRRailView class]) _TRRailView_type = [CNClassType classTypeWithCls:[TRRailView class]];
}

- (void)drawRailBuilding:(TRRailBuilding*)railBuilding {
    float p = (([railBuilding isConstruction]) ? railBuilding.progress : ((float)(1.0 - railBuilding.progress)));
    [self drawRail:railBuilding.rail count:((p < 0.5) ? 1 : 2)];
}

- (void)drawRail:(TRRail*)rail {
    [self drawRail:rail count:3];
}

- (void)drawRail:(TRRail*)rail count:(unsigned int)count {
    EGMatrixStack* __tmp__il__0self = EGGlobal.matrix;
    {
        [__tmp__il__0self push];
        {
            EGMMatrixModel* _ = [__tmp__il__0self value];
            [[_ modifyW:^GEMat4*(GEMat4* w) {
                return [w translateX:((float)(rail.tile.x)) y:((float)(rail.tile.y)) z:0.001];
            }] modifyM:^GEMat4*(GEMat4* m) {
                if(rail.form == TRRailForm_bottomTop || rail.form == TRRailForm_leftRight) {
                    if(rail.form == TRRailForm_leftRight) return [m rotateAngle:90.0 x:0.0 y:1.0 z:0.0];
                    else return m;
                } else {
                    if(rail.form == TRRailForm_topRight) {
                        return [m rotateAngle:270.0 x:0.0 y:1.0 z:0.0];
                    } else {
                        if(rail.form == TRRailForm_bottomRight) {
                            return [m rotateAngle:180.0 x:0.0 y:1.0 z:0.0];
                        } else {
                            if(rail.form == TRRailForm_leftBottom) return [m rotateAngle:90.0 x:0.0 y:1.0 z:0.0];
                            else return m;
                        }
                    }
                }
            }];
        }
        if(rail.form == TRRailForm_bottomTop || rail.form == TRRailForm_leftRight) {
            [_railModel drawOnly:count];
            GEVec2i t = rail.tile;
            if([_railroad.map isPartialTile:t]) {
                if([_railroad.map cutStateForTile:t].y != 0) {
                    GEVec2i dt = geVec2iSubVec2i([TRRailConnector_Values[((rail.form == TRRailForm_leftRight) ? TRRailForm_Values[rail.form].start : TRRailForm_Values[rail.form].end)] nextTile:t], t);
                    [[EGGlobal.matrix value] modifyW:^GEMat4*(GEMat4* w) {
                        return [w translateX:((float)(dt.x)) y:((float)(dt.y)) z:0.001];
                    }];
                    [_railModel drawOnly:count];
                }
            }
        } else {
            [_railTurnModel drawOnly:count];
        }
        [__tmp__il__0self pop];
    }
}

- (NSString*)description {
    return [NSString stringWithFormat:@"RailView(%@)", _railroad];
}

- (CNClassType*)type {
    return [TRRailView type];
}

+ (CNClassType*)type {
    return _TRRailView_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation TRUndoView
static CNClassType* _TRUndoView_type;
@synthesize builder = _builder;

+ (instancetype)undoViewWithBuilder:(TRRailroadBuilder*)builder {
    return [[TRUndoView alloc] initWithBuilder:builder];
}

- (instancetype)initWithBuilder:(TRRailroadBuilder*)builder {
    self = [super init];
    if(self) {
        _builder = builder;
        _empty = YES;
        _buttonPos = [CNVar applyInitial:wrap(GEVec3, (GEVec3Make(0.0, 0.0, 0.0)))];
        _button = [EGSprite applyMaterial:[CNReact applyValue:[[[EGGlobal scaledTextureForName:@"Pause" format:EGTextureFormat_RGBA4] regionX:32.0 y:32.0 width:32.0 height:32.0] colorSource]] position:_buttonPos];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [TRUndoView class]) _TRUndoView_type = [CNClassType classTypeWithCls:[TRUndoView class]];
}

- (void)draw {
    CNTry* __il__0__tr = [[_builder state] waitResultPeriod:1.0];
    if(__il__0__tr != nil) {
        if([((CNTry*)(__il__0__tr)) isSuccess]) {
            TRRailroadBuilderState* s = [((CNTry*)(__il__0__tr)) get];
            {
                TRRail* rail = [((TRRailroadBuilderState*)(s)) railForUndo];
                if(rail == nil || ((TRRailroadBuilderState*)(s)).isBuilding) {
                    _empty = YES;
                } else {
                    _empty = NO;
                    {
                        EGEnablingState* __tmp__il__0r_1f_1self = EGGlobal.context.depthTest;
                        {
                            BOOL __il__0r_1f_1changed = [__tmp__il__0r_1f_1self disable];
                            {
                                [_buttonPos setValue:wrap(GEVec3, (geVec3ApplyVec2iZ(((TRRail*)(nonnil(rail))).tile, 0.0)))];
                                [_button draw];
                            }
                            if(__il__0r_1f_1changed) [__tmp__il__0r_1f_1self enable];
                        }
                    }
                }
            }
        }
    }
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

- (NSString*)description {
    return [NSString stringWithFormat:@"UndoView(%@)", _builder];
}

- (CNClassType*)type {
    return [TRUndoView type];
}

+ (CNClassType*)type {
    return _TRUndoView_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation TRSwitchView
static CNClassType* _TRSwitchView_type;
@synthesize material = _material;
@synthesize switchStraightModel = _switchStraightModel;
@synthesize switchTurnModel = _switchTurnModel;

+ (instancetype)switchView {
    return [[TRSwitchView alloc] init];
}

- (instancetype)init {
    self = [super init];
    if(self) {
        _material = [EGColorSource applyTexture:[EGGlobal compressedTextureForFile:@"Switches" filter:EGTextureFilter_mipmapNearest]];
        _switchStraightModel = [EGMeshModel applyMeshes:(@[tuple(TRModels.switchStraight, _material)])];
        _switchTurnModel = [EGMeshModel applyMeshes:(@[tuple(TRModels.switchTurn, _material)])];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [TRSwitchView class]) _TRSwitchView_type = [CNClassType classTypeWithCls:[TRSwitchView class]];
}

- (void)drawTheSwitch:(TRSwitchState*)theSwitch {
    TRRailConnectorR connector = [theSwitch connector];
    TRRail* rail = [theSwitch activeRail];
    TRRailFormR form = rail.form;
    __block BOOL ref = NO;
    {
        EGMatrixStack* __tmp__il__4self = EGGlobal.matrix;
        {
            [__tmp__il__4self push];
            {
                EGMMatrixModel* _ = [__tmp__il__4self value];
                [[_ modifyW:^GEMat4*(GEMat4* w) {
                    return [w translateX:((float)([theSwitch tile].x)) y:((float)([theSwitch tile].y)) z:0.03];
                }] modifyM:^GEMat4*(GEMat4* m) {
                    GEMat4* m2 = [[m rotateAngle:((float)(TRRailConnector_Values[connector].angle)) x:0.0 y:1.0 z:0.0] translateX:-0.5 y:0.0 z:0.0];
                    if(TRRailConnector_Values[TRRailForm_Values[form].start].x + TRRailConnector_Values[TRRailForm_Values[form].end].x != 0) {
                        TRRailConnectorR otherConnector = ((TRRailForm_Values[form].start == connector) ? TRRailForm_Values[form].end : TRRailForm_Values[form].start);
                        NSInteger x = TRRailConnector_Values[connector].x;
                        NSInteger y = TRRailConnector_Values[connector].y;
                        NSInteger ox = TRRailConnector_Values[otherConnector].x;
                        NSInteger oy = TRRailConnector_Values[otherConnector].y;
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
            }
            if(TRRailConnector_Values[TRRailForm_Values[form].start].x + TRRailConnector_Values[TRRailForm_Values[form].end].x == 0) [_switchStraightModel draw];
            else [_switchTurnModel draw];
            [__tmp__il__4self pop];
        }
    }
}

- (NSString*)description {
    return @"SwitchView";
}

- (CNClassType*)type {
    return [TRSwitchView type];
}

+ (CNClassType*)type {
    return _TRSwitchView_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation TRLightView
static CNClassType* _TRLightView_type;

+ (instancetype)lightViewWithLevelView:(TRLevelView*)levelView railroad:(TRRailroad*)railroad {
    return [[TRLightView alloc] initWithLevelView:levelView railroad:railroad];
}

- (instancetype)initWithLevelView:(TRLevelView*)levelView railroad:(TRRailroad*)railroad {
    self = [super init];
    if(self) {
        __matrixChanged = [CNReactFlag reactFlagWithInitial:YES reacts:(@[((id<CNObservable>)(EGGlobal.context.viewSize)), ((id<CNObservable>)([levelView cameraMove].changed))])];
        __matrixShadowChanged = [CNReactFlag reactFlagWithInitial:YES reacts:(@[((id<CNObservable>)(EGGlobal.context.viewSize)), ((id<CNObservable>)([levelView cameraMove].changed))])];
        __lightGlowChanged = [CNReactFlag apply];
        __lastId = 0;
        __lastShadowId = 0;
        __matrixArr = ((NSArray*)((@[])));
        _bodies = [EGMeshUnite applyMeshModel:TRModels.light createVao:^EGVertexArray*(EGMesh* _) {
            return [_ vaoMaterial:[EGColorSource applyTexture:[EGGlobal compressedTextureForFile:@"Light" filter:EGTextureFilter_linear]] shadow:NO];
        }];
        _shadows = [EGMeshUnite applyMeshModel:TRModels.light createVao:^EGVertexArray*(EGMesh* _) {
            return [_ vaoShadow];
        }];
        _glows = [EGMeshUnite meshUniteWithVertexSample:TRModels.lightGreenGlow indexSample:TRModels.lightGlowIndex createVao:^EGVertexArray*(EGMesh* _) {
            return [_ vaoMaterial:[EGColorSource applyTexture:[EGGlobal compressedTextureForFile:((egPlatform().isPhone) ? @"LightGlowPhone" : @"LightGlow") filter:EGTextureFilter_mipmapNearest]] shadow:NO];
        }];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [TRLightView class]) _TRLightView_type = [CNClassType classTypeWithCls:[TRLightView class]];
}

- (CNChain*)calculateMatrixArrRrState:(TRRailroadState*)rrState {
    return [[[rrState lights] chain] mapF:^CNTuple*(TRRailLightState* light) {
        return tuple([[[[EGGlobal.matrix value] copy] modifyW:^GEMat4*(GEMat4* w) {
            return [w translateX:((float)([((TRRailLightState*)(light)) tile].x)) y:((float)([((TRRailLightState*)(light)) tile].y)) z:0.0];
        }] modifyM:^GEMat4*(GEMat4* m) {
            return [[m rotateAngle:((float)(90 + TRRailConnector_Values[[((TRRailLightState*)(light)) connector]].angle)) x:0.0 y:1.0 z:0.0] translateVec3:[((TRRailLightState*)(light)) shift]];
        }], light);
    }];
}

- (void)drawBodiesRrState:(TRRailroadState*)rrState {
    if(unumb([__matrixChanged value]) || __lastId != rrState.id) {
        __matrixArr = [[self calculateMatrixArrRrState:rrState] toArray];
        [_bodies writeCount:((unsigned int)([__matrixArr count])) f:^void(EGMeshWriter* writer) {
            for(CNTuple* p in __matrixArr) {
                BOOL g = ((TRRailLightState*)(((CNTuple*)(p)).b)).isGreen;
                [writer writeMap:^EGMeshData(EGMeshData _) {
                    return egMeshDataMulMat4((((g) ? _ : egMeshDataUvAddVec2(_, (GEVec2Make(0.5, 0.0))))), [((EGMatrixModel*)(((CNTuple*)(p)).a)) mwcp]);
                }];
            }
        }];
        [__lightGlowChanged set];
        __lastId = rrState.id;
        [__matrixChanged clear];
    }
    [_bodies draw];
}

- (void)drawShadowRrState:(TRRailroadState*)rrState {
    if(unumb([__matrixShadowChanged value]) || __lastShadowId != rrState.id) {
        [_shadows writeMat4Array:[[[self calculateMatrixArrRrState:rrState] mapF:^GEMat4*(CNTuple* _) {
            return [((EGMatrixModel*)(((CNTuple*)(_)).a)) mwcp];
        }] toArray]];
        [__matrixShadowChanged clear];
        __lastShadowId = rrState.id;
    }
    [_shadows draw];
}

- (void)drawGlows {
    if(!([__matrixArr isEmpty]) && !([EGGlobal.context.renderTarget isKindOfClass:[EGShadowRenderTarget class]])) {
        [__lightGlowChanged processF:^void() {
            [_glows writeCount:((unsigned int)([__matrixArr count])) f:^void(EGMeshWriter* writer) {
                for(CNTuple* p in __matrixArr) {
                    [writer writeVertex:((((TRRailLightState*)(((CNTuple*)(p)).b)).isGreen) ? TRModels.lightGreenGlow : TRModels.lightRedGlow) mat4:[((EGMatrixModel*)(((CNTuple*)(p)).a)) mwcp]];
                }
            }];
        }];
        {
            EGCullFace* __tmp__il__0t_1self = EGGlobal.context.cullFace;
            {
                unsigned int __il__0t_1oldValue = [__tmp__il__0t_1self disable];
                [_glows draw];
                if(__il__0t_1oldValue != GL_NONE) [__tmp__il__0t_1self setValue:__il__0t_1oldValue];
            }
        }
    }
}

- (NSString*)description {
    return @"LightView";
}

- (CNClassType*)type {
    return [TRLightView type];
}

+ (CNClassType*)type {
    return _TRLightView_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation TRDamageView
static CNClassType* _TRDamageView_type;
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
        _spObs = [TRLevel.sporadicDamaged observeF:^void(id point) {
            TRDamageView* _self = _weakSelf;
            if(_self != nil) [_self->_sporadicAnimations appendCounter:[EGLengthCounter lengthCounterWithLength:3.0] data:point];
        }];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [TRDamageView class]) _TRDamageView_type = [CNClassType classTypeWithCls:[TRDamageView class]];
}

- (void)drawPoint:(TRRailPoint)point {
    EGMatrixStack* __tmp__il__0self = EGGlobal.matrix;
    {
        [__tmp__il__0self push];
        {
            EGMMatrixModel* _ = [__tmp__il__0self value];
            [[_ modifyW:^GEMat4*(GEMat4* w) {
                return [w translateX:point.point.x y:point.point.y z:0.0];
            }] modifyM:^GEMat4*(GEMat4* m) {
                return [m rotateAngle:[self angleForPoint:point] x:0.0 y:1.0 z:0.0];
            }];
        }
        [_model draw];
        [__tmp__il__0self pop];
    }
}

- (void)drawRrState:(TRRailroadState*)rrState {
    for(id _ in rrState.damages.points) {
        [self drawPoint:uwrap(TRRailPoint, _)];
    }
}

- (void)drawForeground {
    EGEnablingState* __tmp__il__0self = EGGlobal.context.depthTest;
    {
        BOOL __il__0changed = [__tmp__il__0self disable];
        [_sporadicAnimations forEach:^void(EGCounterData* counter) {
            [EGD2D drawCircleBackColor:GEVec4Make(1.0, 0.0, 0.0, 0.5) strokeColor:GEVec4Make(1.0, 0.0, 0.0, 0.5) at:geVec3ApplyVec2Z((uwrap(TRRailPoint, counter.data).point), 0.0) radius:((float)(0.5 * (1.0 - unumf([[counter time] value])))) relative:GEVec2Make(0.0, 0.0)];
        }];
        if(__il__0changed) [__tmp__il__0self enable];
    }
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

- (NSString*)description {
    return [NSString stringWithFormat:@"DamageView(%@)", _railroad];
}

- (CNClassType*)type {
    return [TRDamageView type];
}

+ (CNClassType*)type {
    return _TRDamageView_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation TRBackgroundView
static CNClassType* _TRBackgroundView_type;
@synthesize mapView = _mapView;

+ (instancetype)backgroundViewWithLevel:(TRLevel*)level {
    return [[TRBackgroundView alloc] initWithLevel:level];
}

- (instancetype)initWithLevel:(TRLevel*)level {
    self = [super init];
    if(self) _mapView = [EGMapSsoView mapSsoViewWithMap:level.map material:[EGColorSource applyTexture:[EGGlobal compressedTextureForFile:TRLevelTheme_Values[level.rules.theme].background filter:EGTextureFilter_nearest]]];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [TRBackgroundView class]) _TRBackgroundView_type = [CNClassType classTypeWithCls:[TRBackgroundView class]];
}

- (void)draw {
    EGEnablingState* __tmp__il__0self = EGGlobal.context.depthTest;
    {
        BOOL __il__0changed = [__tmp__il__0self disable];
        [_mapView draw];
        if(__il__0changed) [__tmp__il__0self enable];
    }
}

- (NSString*)description {
    return @"BackgroundView";
}

- (CNClassType*)type {
    return [TRBackgroundView type];
}

+ (CNClassType*)type {
    return _TRBackgroundView_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

