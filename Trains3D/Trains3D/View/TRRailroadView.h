#import "objd.h"
#import "EGInput.h"
#import "GEVec.h"
#import "EGMapIso.h"
#import "EGFont.h"
#import "EGMesh.h"
@class TRRailroad;
@class EGViewportSurface;
@class TRRailroadBuilder;
@class EGGlobal;
@class EGContext;
@class EGShadowDrawParam;
@class EGPlatform;
@class EGMapSsoView;
@class EGShadowDrawShaderSystem;
@class EGRenderTarget;
@class EGEnablingState;
@class EGBlendFunction;
@class EGDirector;
@class EGStandardMaterial;
@class EGColorSource;
@class EGTexture;
@class TRModels;
@class EGMaterial;
@class TRRailBuilding;
@class TRRail;
@class GEMat4;
@class EGMatrixModel;
@class TRRailForm;
@class TRRailConnector;
@class EGMatrixStack;
@class EGBillboard;
@class TRStr;
@protocol TRStrings;
@class TRSwitch;
@class EGTextureRegion;
@class EGMutableVertexBuffer;
@class EGVBO;
@class EGMutableIndexBuffer;
@class EGIBO;
@class TRRailLight;
@class TRRailPoint;

@class TRRailroadView;
@class TRRailView;
@class TRUndoView;
@class TRSwitchView;
@class TRLightView;
@class TRMeshWriter;
@class TRDamageView;
@class TRBackgroundView;

@interface TRRailroadView : NSObject<EGInputProcessor>
@property (nonatomic, readonly) TRRailroad* railroad;
@property (nonatomic, readonly) id shadowVao;
@property (nonatomic) BOOL _changed;

+ (id)railroadViewWithRailroad:(TRRailroad*)railroad;
- (id)initWithRailroad:(TRRailroad*)railroad;
- (ODClassType*)type;
- (void)_init;
- (void)drawBackground;
- (void)drawForeground;
- (void)prepare;
- (void)reshape;
- (BOOL)processEvent:(EGEvent*)event;
+ (ODClassType*)type;
@end


@interface TRRailView : NSObject
@property (nonatomic, readonly) TRRailroad* railroad;
@property (nonatomic, readonly) EGStandardMaterial* railMaterial;
@property (nonatomic, readonly) EGTexture* gravel;
@property (nonatomic, readonly) EGMeshModel* railModel;
@property (nonatomic, readonly) EGMeshModel* railTurnModel;

+ (id)railViewWithRailroad:(TRRailroad*)railroad;
- (id)initWithRailroad:(TRRailroad*)railroad;
- (ODClassType*)type;
- (void)drawRailBuilding:(TRRailBuilding*)railBuilding;
- (void)drawRail:(TRRail*)rail;
+ (ODClassType*)type;
@end


@interface TRUndoView : NSObject<EGInputProcessor, EGTapProcessor>
@property (nonatomic, readonly) TRRailroadBuilder* builder;

+ (id)undoViewWithBuilder:(TRRailroadBuilder*)builder;
- (id)initWithBuilder:(TRRailroadBuilder*)builder;
- (ODClassType*)type;
- (void)reshape;
- (void)draw;
- (BOOL)processEvent:(EGEvent*)event;
- (BOOL)tapEvent:(EGEvent*)event;
+ (ODClassType*)type;
@end


@interface TRSwitchView : NSObject
@property (nonatomic, readonly) EGColorSource* material;
@property (nonatomic, readonly) EGMeshModel* switchStraightModel;
@property (nonatomic, readonly) EGMeshModel* switchTurnModel;

+ (id)switchView;
- (id)init;
- (ODClassType*)type;
- (void)drawTheSwitch:(TRSwitch*)theSwitch;
+ (ODClassType*)type;
@end


@interface TRLightView : NSObject
@property (nonatomic, readonly) TRRailroad* railroad;
@property (nonatomic, readonly) EGTexture* texture;
@property (nonatomic, readonly) EGVertexArray* redBodyVao;
@property (nonatomic, readonly) EGVertexArray* greenBodyVao;
@property (nonatomic, readonly) EGVertexArray* shadowBodyVao;
@property (nonatomic) BOOL _changed;

+ (id)lightViewWithRailroad:(TRRailroad*)railroad;
- (id)initWithRailroad:(TRRailroad*)railroad;
- (ODClassType*)type;
- (void)_init;
- (void)drawBodies;
- (void)drawShadow;
- (void)drawGlows;
+ (ODClassType*)type;
@end


@interface TRMeshWriter : NSObject
@property (nonatomic, readonly) EGMutableVertexBuffer* vbo;
@property (nonatomic, readonly) EGMutableIndexBuffer* ibo;
@property (nonatomic, readonly) unsigned int count;
@property (nonatomic, readonly) CNPArray* vertexSample;
@property (nonatomic, readonly) CNPArray* indexSample;

+ (id)meshWriterWithVbo:(EGMutableVertexBuffer*)vbo ibo:(EGMutableIndexBuffer*)ibo count:(unsigned int)count vertexSample:(CNPArray*)vertexSample indexSample:(CNPArray*)indexSample;
- (id)initWithVbo:(EGMutableVertexBuffer*)vbo ibo:(EGMutableIndexBuffer*)ibo count:(unsigned int)count vertexSample:(CNPArray*)vertexSample indexSample:(CNPArray*)indexSample;
- (ODClassType*)type;
- (void)writeMat4:(GEMat4*)mat4;
- (void)writeVertex:(CNPArray*)vertex mat4:(GEMat4*)mat4;
- (void)writeVertex:(CNPArray*)vertex index:(CNPArray*)index mat4:(GEMat4*)mat4;
- (void)flush;
- (void)dealloc;
+ (ODClassType*)type;
@end


@interface TRDamageView : NSObject
@property (nonatomic, readonly) EGMeshModel* model;

+ (id)damageView;
- (id)init;
- (ODClassType*)type;
- (void)drawPoint:(TRRailPoint*)point;
+ (ODClassType*)type;
@end


@interface TRBackgroundView : NSObject
@property (nonatomic, readonly) EGMapSso* map;
@property (nonatomic, readonly) EGMapSsoView* mapView;

+ (id)backgroundViewWithMap:(EGMapSso*)map;
- (id)initWithMap:(EGMapSso*)map;
- (ODClassType*)type;
- (void)draw;
+ (ODClassType*)type;
@end


