#import "TRLightView.h"

#import "CNReact.h"
#import "PGContext.h"
#import "TRLevelView.h"
#import "PGCameraIso.h"
#import "TRModels.h"
#import "PGMaterial.h"
#import "PGPlatformPlat.h"
#import "PGPlatform.h"
#import "CNChain.h"
#import "TRRailroad.h"
#import "PGMatrixModel.h"
#import "PGMat4.h"
#import "GL.h"
@implementation TRLightView
static CNClassType* _TRLightView_type;

+ (instancetype)lightViewWithLevelView:(TRLevelView*)levelView railroad:(TRRailroad*)railroad {
    return [[TRLightView alloc] initWithLevelView:levelView railroad:railroad];
}

- (instancetype)initWithLevelView:(TRLevelView*)levelView railroad:(TRRailroad*)railroad {
    self = [super init];
    if(self) {
        __matrixChanged = [CNReactFlag reactFlagWithInitial:YES reacts:(@[((id<CNObservable>)([PGGlobal context]->_viewSize)), ((id<CNObservable>)([levelView cameraMove]->_changed))])];
        __matrixShadowChanged = [CNReactFlag reactFlagWithInitial:YES reacts:(@[((id<CNObservable>)([PGGlobal context]->_viewSize)), ((id<CNObservable>)([levelView cameraMove]->_changed))])];
        __lightGlowChanged = [CNReactFlag apply];
        __lastId = 0;
        __lastShadowId = 0;
        __matrixArr = ((NSArray*)((@[])));
        _bodies = [PGMeshUnite applyMeshModel:[TRModels light] createVao:^PGVertexArray*(PGMesh* _) {
            return [_ vaoMaterial:[PGColorSource applyTexture:[PGGlobal compressedTextureForFile:@"Light" filter:PGTextureFilter_linear]] shadow:NO];
        }];
        _shadows = [PGMeshUnite applyMeshModel:[TRModels light] createVao:^PGVertexArray*(PGMesh* _) {
            return [_ vaoShadow];
        }];
        _glows = [PGMeshUnite meshUniteWithVertexSample:[TRModels lightGreenGlow] indexSample:[TRModels lightGlowIndex] createVao:^PGVertexArray*(PGMesh* _) {
            return [_ vaoMaterial:[PGColorSource applyTexture:[PGGlobal compressedTextureForFile:((egPlatform()->_isPhone) ? @"LightGlowPhone" : @"LightGlow") filter:PGTextureFilter_mipmapNearest]] shadow:NO];
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
        return tuple([[[[[PGGlobal matrix] value] copy] modifyW:^PGMat4*(PGMat4* w) {
            return [w translateX:((float)([((TRRailLightState*)(light)) tile].x)) y:((float)([((TRRailLightState*)(light)) tile].y)) z:0.0];
        }] modifyM:^PGMat4*(PGMat4* m) {
            return [[m rotateAngle:((float)(90 + [TRRailConnector value:[((TRRailLightState*)(light)) connector]].angle)) x:0.0 y:1.0 z:0.0] translateVec3:[((TRRailLightState*)(light)) shift]];
        }], light);
    }];
}

- (void)drawBodiesRrState:(TRRailroadState*)rrState {
    if(unumb([__matrixChanged value]) || __lastId != rrState->_id) {
        __matrixArr = [[self calculateMatrixArrRrState:rrState] toArray];
        [_bodies writeCount:((unsigned int)([__matrixArr count])) f:^void(PGMeshWriter* writer) {
            for(CNTuple* p in __matrixArr) {
                BOOL g = ((TRRailLightState*)(((CNTuple*)(p))->_b))->_isGreen;
                [writer writeMap:^PGMeshData(PGMeshData _) {
                    return pgMeshDataMulMat4((((g) ? _ : pgMeshDataUvAddVec2(_, (PGVec2Make(0.5, 0.0))))), [((PGMatrixModel*)(((CNTuple*)(p))->_a)) mwcp]);
                }];
            }
        }];
        [__lightGlowChanged set];
        __lastId = rrState->_id;
        [__matrixChanged clear];
    }
    [_bodies draw];
}

- (void)drawShadowRrState:(TRRailroadState*)rrState {
    if(unumb([__matrixShadowChanged value]) || __lastShadowId != rrState->_id) {
        [_shadows writeMat4Array:[[[self calculateMatrixArrRrState:rrState] mapF:^PGMat4*(CNTuple* _) {
            return [((PGMatrixModel*)(((CNTuple*)(_))->_a)) mwcp];
        }] toArray]];
        [__matrixShadowChanged clear];
        __lastShadowId = rrState->_id;
    }
    [_shadows draw];
}

- (void)drawGlows {
    if(!([__matrixArr isEmpty]) && !([[PGGlobal context]->_renderTarget isKindOfClass:[PGShadowRenderTarget class]])) {
        [__lightGlowChanged processF:^void() {
            [_glows writeCount:((unsigned int)([__matrixArr count])) f:^void(PGMeshWriter* writer) {
                for(CNTuple* p in __matrixArr) {
                    [writer writeVertex:((((TRRailLightState*)(((CNTuple*)(p))->_b))->_isGreen) ? [TRModels lightGreenGlow] : [TRModels lightRedGlow]) mat4:[((PGMatrixModel*)(((CNTuple*)(p))->_a)) mwcp]];
                }
            }];
        }];
        {
            PGCullFace* __tmp__il__0t_1self = [PGGlobal context]->_cullFace;
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

