#import "TRRailroadView.h"

#import "TRLevelView.h"
#import "TRRailroad.h"
#import "TRLightView.h"
#import "PGPlatformPlat.h"
#import "PGPlatform.h"
#import "PGMultisamplingSurface.h"
#import "TRGameDirector.h"
#import "PGVertexArray.h"
#import "CNReact.h"
#import "TRRailroadBuilder.h"
#import "PGCameraIso.h"
#import "PGContext.h"
#import "PGShadow.h"
#import "PGMapIsoView.h"
#import "PGMesh.h"
#import "GL.h"
#import "PGMaterial.h"
#import "CNFuture.h"
#import "TRModels.h"
#import "PGMatrixModel.h"
#import "PGMat4.h"
#import "PGSprite.h"
#import "PGSchedule.h"
#import "CNObserver.h"
#import "PGD2D.h"
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
        _railroad = level->_railroad;
        _switchView = [TRSwitchView switchView];
        _lightView = [TRLightView lightViewWithLevelView:levelView railroad:level->_railroad];
        _damageView = [TRDamageView damageViewWithRailroad:level->_railroad];
        _iOS6 = [egPlatform()->_os isIOSLessVersion:@"7"];
        _railroadSurface = [PGViewportSurface toTextureDepth:YES multisampling:[[TRGameDirector instance] railroadAA]];
        _undoView = [TRUndoView undoViewWithBuilder:level->_builder];
        __changed = [CNReactFlag reactFlagWithInitial:YES reacts:(@[((CNSignal*)(level->_railroad->_railWasBuilt)), ((CNSignal*)(level->_railroad->_railWasRemoved)), ((CNSignal*)(level->_builder->_changed)), ((CNSignal*)([levelView cameraMove]->_changed)), ((CNSignal*)(level->_railroad->_stateWasRestored))])];
        if([self class] == [TRRailroadView class]) [self _init];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [TRRailroadView class]) _TRRailroadView_type = [CNClassType classTypeWithCls:[TRRailroadView class]];
}

- (void)_init {
    [PGGlobal context]->_considerShadows = NO;
    _backgroundView = [TRBackgroundView backgroundViewWithLevel:_level];
    _railView = [TRRailView railViewWithRailroad:_railroad];
    PGShadowDrawParam* shadowParam = [PGShadowDrawParam shadowDrawParamWithPercents:(@[@0.3]) viewportSurface:_railroadSurface];
    _shadowVao = ((egPlatform()->_shadows) ? [_backgroundView->_mapView->_plane vaoShaderSystem:[PGShadowDrawShaderSystem instance] material:shadowParam shadow:NO] : nil);
    [PGGlobal context]->_considerShadows = YES;
}

- (void)drawBackgroundRrState:(TRRailroadState*)rrState {
    egPushGroupMarker(@"Railroad background");
    if([[PGGlobal context]->_renderTarget isShadow]) {
        [_lightView drawShadowRrState:rrState];
    } else {
        if(egPlatform()->_shadows) {
            PGCullFace* __tmp__il__1f_0t_0self = [PGGlobal context]->_cullFace;
            {
                unsigned int __il__1f_0t_0oldValue = [__tmp__il__1f_0t_0self disable];
                {
                    PGEnablingState* __tmp__il__1f_0t_0rp0self = [PGGlobal context]->_depthTest;
                    {
                        BOOL __il__1f_0t_0rp0changed = [__tmp__il__1f_0t_0rp0self disable];
                        [((PGVertexArray*)(_shadowVao)) draw];
                        if(__il__1f_0t_0rp0changed) [__tmp__il__1f_0t_0rp0self enable];
                    }
                }
                if(__il__1f_0t_0oldValue != GL_NONE) [__tmp__il__1f_0t_0self setValue:__il__1f_0t_0oldValue];
            }
        } else {
            PGEnablingState* __tmp__il__1f_0f_0self = [PGGlobal context]->_depthTest;
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
    PGEnablingState* __il__0__tmp__il__0self = [PGGlobal context]->_blend;
    {
        BOOL __il__0__il__0changed = [__il__0__tmp__il__0self enable];
        {
            [[PGGlobal context] setBlendFunction:[PGBlendFunction standard]];
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
    PGEnablingState* __il__1__tmp__il__0self = [PGGlobal context]->_blend;
    {
        BOOL __il__1__il__0changed = [__il__1__tmp__il__0self enable];
        {
            [[PGGlobal context] setBlendFunction:[PGBlendFunction standard]];
            {
                PGCullFace* __tmp__il__1rp0self = [PGGlobal context]->_cullFace;
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
    PGEnablingState* __il__1__tmp__il__0self = [PGGlobal context]->_blend;
    {
        BOOL __il__1__il__0changed = [__il__1__tmp__il__0self enable];
        {
            [[PGGlobal context] setBlendFunction:[PGBlendFunction standard]];
            {
                PGCullFace* __tmp__il__1rp0self = [PGGlobal context]->_cullFace;
                {
                    unsigned int __il__1rp0oldValue = [__tmp__il__1rp0self disable];
                    {
                        for(TRSwitchState* _ in [rrState switches]) {
                            [_switchView drawTheSwitch:_];
                        }
                        {
                            PGEnablingState* __tmp__il__1rp0rp0_1self = [PGGlobal context]->_depthTest;
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
            [[PGGlobal context] clearColorColor:PGVec4Make(0.0, 0.0, 0.0, 0.0)];
            glClear(GL_COLOR_BUFFER_BIT + GL_DEPTH_BUFFER_BIT);
            [PGGlobal context]->_considerShadows = NO;
            [self drawSurface];
            [PGGlobal context]->_considerShadows = YES;
            if(_iOS6) glFinish();
        }
        [_railroadSurface unbind];
    }
}

- (void)drawSurface {
    CNTry* __il__0__tr = [[[_level->_builder state] joinAnother:[_level->_railroad state]] waitResultPeriod:1.0];
    if(__il__0__tr != nil) {
        if([((CNTry*)(__il__0__tr)) isSuccess]) {
            CNTuple* t = [((CNTry*)(__il__0__tr)) get];
            {
                TRRailroadBuilderState* builderState = ((CNTuple*)(t))->_a;
                TRRailroadState* rrState = ((CNTuple*)(t))->_b;
                [_backgroundView draw];
                TRRail* building = ((TRRailBuilding*)(builderState->_notFixedRailBuilding)).rail;
                for(TRRail* rail in [rrState rails]) {
                    if(building == nil || !([building isEqual:rail])) [_railView drawRail:rail];
                }
                {
                    TRRailBuilding* nf = builderState->_notFixedRailBuilding;
                    if(nf != nil) {
                        if([((TRRailBuilding*)(nf)) isConstruction]) [_railView drawRailBuilding:nf];
                        else [_railView drawRail:((TRRailBuilding*)(nf))->_rail count:2];
                    }
                }
                {
                    id<CNIterator> __il__0r_6i = [builderState->_buildingRails iterator];
                    while([__il__0r_6i hasNext]) {
                        TRRailBuilding* _ = [__il__0r_6i next];
                        [_railView drawRailBuilding:_];
                    }
                }
            }
        }
    }
}

- (PGRecognizers*)recognizers {
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
        _railMaterial = [PGStandardMaterial standardMaterialWithDiffuse:[PGColorSource applyColor:PGVec4Make(0.5, 0.5, 0.6, 1.0)] specularColor:PGVec4Make(0.5, 0.5, 0.5, 1.0) specularSize:0.3 normalMap:nil];
        _gravel = [PGGlobal compressedTextureForFile:@"Gravel"];
        _railModel = [PGMeshModel applyMeshes:(@[((CNTuple*)(tuple([TRModels railGravel], [_gravel colorSource]))), ((CNTuple*)(tuple([TRModels railTies], ([PGColorSource applyColor:PGVec4Make(0.55, 0.45, 0.25, 1.0)])))), ((CNTuple*)(tuple([TRModels rails], _railMaterial)))])];
        _railTurnModel = [PGMeshModel applyMeshes:(@[((CNTuple*)(tuple([TRModels railTurnGravel], [_gravel colorSource]))), ((CNTuple*)(tuple([TRModels railTurnTies], ([PGColorSource applyColor:PGVec4Make(0.55, 0.45, 0.25, 1.0)])))), ((CNTuple*)(tuple([TRModels railsTurn], _railMaterial)))])];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [TRRailView class]) _TRRailView_type = [CNClassType classTypeWithCls:[TRRailView class]];
}

- (void)drawRailBuilding:(TRRailBuilding*)railBuilding {
    float p = (([railBuilding isConstruction]) ? railBuilding->_progress : ((float)(1.0 - railBuilding->_progress)));
    [self drawRail:railBuilding->_rail count:((p < 0.5) ? 1 : 2)];
}

- (void)drawRail:(TRRail*)rail {
    [self drawRail:rail count:3];
}

- (void)drawRail:(TRRail*)rail count:(unsigned int)count {
    PGMatrixStack* __tmp__il__0self = [PGGlobal matrix];
    {
        [__tmp__il__0self push];
        {
            PGMMatrixModel* _ = [__tmp__il__0self value];
            [[_ modifyW:^PGMat4*(PGMat4* w) {
                return [w translateX:((float)(rail->_tile.x)) y:((float)(rail->_tile.y)) z:0.001];
            }] modifyM:^PGMat4*(PGMat4* m) {
                if(rail->_form == TRRailForm_bottomTop || rail->_form == TRRailForm_leftRight) {
                    if(rail->_form == TRRailForm_leftRight) return [m rotateAngle:90.0 x:0.0 y:1.0 z:0.0];
                    else return m;
                } else {
                    if(rail->_form == TRRailForm_topRight) {
                        return [m rotateAngle:270.0 x:0.0 y:1.0 z:0.0];
                    } else {
                        if(rail->_form == TRRailForm_bottomRight) {
                            return [m rotateAngle:180.0 x:0.0 y:1.0 z:0.0];
                        } else {
                            if(rail->_form == TRRailForm_leftBottom) return [m rotateAngle:90.0 x:0.0 y:1.0 z:0.0];
                            else return m;
                        }
                    }
                }
            }];
        }
        if(rail->_form == TRRailForm_bottomTop || rail->_form == TRRailForm_leftRight) {
            [_railModel drawOnly:count];
            PGVec2i t = rail->_tile;
            if([_railroad->_map isPartialTile:t]) {
                if([_railroad->_map cutStateForTile:t].y != 0) {
                    PGVec2i dt = pgVec2iSubVec2i([[TRRailConnector value:((rail->_form == TRRailForm_leftRight) ? [TRRailForm value:rail->_form].start : [TRRailForm value:rail->_form].end)] nextTile:t], t);
                    [[[PGGlobal matrix] value] modifyW:^PGMat4*(PGMat4* w) {
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
        _buttonPos = [CNVar applyInitial:wrap(PGVec3, (PGVec3Make(0.0, 0.0, 0.0)))];
        _button = [PGSprite applyMaterial:[CNReact applyValue:[[[PGGlobal scaledTextureForName:@"Pause" format:PGTextureFormat_RGBA4] regionX:32.0 y:32.0 width:32.0 height:32.0] colorSource]] position:_buttonPos];
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
                if(rail == nil || ((TRRailroadBuilderState*)(s))->_isBuilding) {
                    _empty = YES;
                } else {
                    _empty = NO;
                    {
                        PGEnablingState* __tmp__il__0r_1f_1self = [PGGlobal context]->_depthTest;
                        {
                            BOOL __il__0r_1f_1changed = [__tmp__il__0r_1f_1self disable];
                            {
                                [_buttonPos setValue:wrap(PGVec3, (pgVec3ApplyVec2iZ(((TRRail*)(nonnil(rail)))->_tile, 0.0)))];
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

- (PGRecognizers*)recognizers {
    return [PGRecognizers applyRecognizer:[PGRecognizer applyTp:[PGTap apply] on:^BOOL(id<PGEvent> event) {
        if(_empty) return NO;
        PGVec2 p = [event locationInViewport];
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
        _material = [PGColorSource applyTexture:[PGGlobal compressedTextureForFile:@"Switches" filter:PGTextureFilter_mipmapNearest]];
        _switchStraightModel = [PGMeshModel applyMeshes:(@[tuple([TRModels switchStraight], _material)])];
        _switchTurnModel = [PGMeshModel applyMeshes:(@[tuple([TRModels switchTurn], _material)])];
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
    TRRailFormR form = rail->_form;
    __block BOOL ref = NO;
    {
        PGMatrixStack* __tmp__il__4self = [PGGlobal matrix];
        {
            [__tmp__il__4self push];
            {
                PGMMatrixModel* _ = [__tmp__il__4self value];
                [[_ modifyW:^PGMat4*(PGMat4* w) {
                    return [w translateX:((float)([theSwitch tile].x)) y:((float)([theSwitch tile].y)) z:0.03];
                }] modifyM:^PGMat4*(PGMat4* m) {
                    PGMat4* m2 = [[m rotateAngle:((float)([TRRailConnector value:connector].angle)) x:0.0 y:1.0 z:0.0] translateX:-0.5 y:0.0 z:0.0];
                    if([TRRailConnector value:[TRRailForm value:form].start].x + [TRRailConnector value:[TRRailForm value:form].end].x != 0) {
                        TRRailConnectorR otherConnector = (([TRRailForm value:form].start == connector) ? [TRRailForm value:form].end : [TRRailForm value:form].start);
                        NSInteger x = [TRRailConnector value:connector].x;
                        NSInteger y = [TRRailConnector value:connector].y;
                        NSInteger ox = [TRRailConnector value:otherConnector].x;
                        NSInteger oy = [TRRailConnector value:otherConnector].y;
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
            if([TRRailConnector value:[TRRailForm value:form].start].x + [TRRailConnector value:[TRRailForm value:form].end].x == 0) [_switchStraightModel draw];
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
        _model = [PGMeshModel applyMeshes:(@[tuple([TRModels damage], ([PGColorSource applyColor:PGVec4Make(1.0, 0.0, 0.0, 0.3)]))])];
        _sporadicAnimations = [PGMutableCounterArray mutableCounterArray];
        _spObs = [[TRLevel sporadicDamaged] observeF:^void(id point) {
            TRDamageView* _self = _weakSelf;
            if(_self != nil) [_self->_sporadicAnimations appendCounter:[PGLengthCounter lengthCounterWithLength:3.0] data:point];
        }];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [TRDamageView class]) _TRDamageView_type = [CNClassType classTypeWithCls:[TRDamageView class]];
}

- (void)drawPoint:(TRRailPoint)point {
    PGMatrixStack* __tmp__il__0self = [PGGlobal matrix];
    {
        [__tmp__il__0self push];
        {
            PGMMatrixModel* _ = [__tmp__il__0self value];
            [[_ modifyW:^PGMat4*(PGMat4* w) {
                return [w translateX:point.point.x y:point.point.y z:0.0];
            }] modifyM:^PGMat4*(PGMat4* m) {
                return [m rotateAngle:[self angleForPoint:point] x:0.0 y:1.0 z:0.0];
            }];
        }
        [_model draw];
        [__tmp__il__0self pop];
    }
}

- (void)drawRrState:(TRRailroadState*)rrState {
    for(id _ in rrState->_damages->_points) {
        [self drawPoint:uwrap(TRRailPoint, _)];
    }
}

- (void)drawForeground {
    PGEnablingState* __tmp__il__0self = [PGGlobal context]->_depthTest;
    {
        BOOL __il__0changed = [__tmp__il__0self disable];
        [_sporadicAnimations forEach:^void(PGCounterData* counter) {
            [PGD2D drawCircleBackColor:PGVec4Make(1.0, 0.0, 0.0, 0.5) strokeColor:PGVec4Make(1.0, 0.0, 0.0, 0.5) at:pgVec3ApplyVec2Z((uwrap(TRRailPoint, counter->_data).point), 0.0) radius:((float)(0.5 * (1.0 - unumf([[counter time] value])))) relative:PGVec2Make(0.0, 0.0)];
        }];
        if(__il__0changed) [__tmp__il__0self enable];
    }
}

- (float)angleForPoint:(TRRailPoint)point {
    TRRailPoint p = trRailPointStraight(point);
    TRRailPoint a = trRailPointAddX(p, -0.1);
    TRRailPoint b = trRailPointAddX(p, 0.1);
    PGLine2 line = pgLine2ApplyP0P1(a.point, b.point);
    float angle = pgLine2DegreeAngle(line);
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
    if(self) _mapView = [PGMapSsoView mapSsoViewWithMap:level->_map material:[PGColorSource applyTexture:[PGGlobal compressedTextureForFile:[TRLevelTheme value:level->_rules->_theme].background filter:PGTextureFilter_nearest]]];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [TRBackgroundView class]) _TRBackgroundView_type = [CNClassType classTypeWithCls:[TRBackgroundView class]];
}

- (void)draw {
    PGEnablingState* __tmp__il__0self = [PGGlobal context]->_depthTest;
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

