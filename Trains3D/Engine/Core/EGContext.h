#import "objd.h"
#import "GEVec.h"
@class EGDirector;
@class EGFileTexture;
@class EGFont;
@class GEMat4;

@class EGGlobal;
@class EGContext;
@class EGEnvironment;
@class EGLight;
@class EGDirectLight;
@class EGMatrixStack;
@class EGMatrixModel;

@interface EGGlobal : NSObject
- (ODClassType*)type;
+ (EGDirector*)director;
+ (EGFileTexture*)textureForFile:(NSString*)file;
+ (EGFont*)fontWithName:(NSString*)name size:(NSUInteger)size;
+ (EGContext*)context;
+ (EGMatrixStack*)matrix;
+ (ODClassType*)type;
@end


@interface EGContext : NSObject
@property (nonatomic, retain) EGDirector* director;
@property (nonatomic, retain) EGEnvironment* environment;
@property (nonatomic, readonly) EGMatrixStack* matrixStack;

+ (id)context;
- (id)init;
- (ODClassType*)type;
- (EGFileTexture*)textureForFile:(NSString*)file;
- (EGFont*)fontWithName:(NSString*)name size:(NSUInteger)size;
- (GERecti)viewport;
- (void)setViewport:(GERecti)viewport;
+ (ODClassType*)type;
@end


@interface EGEnvironment : NSObject
@property (nonatomic, readonly) GEVec4 ambientColor;
@property (nonatomic, readonly) id<CNSeq> lights;

+ (id)environmentWithAmbientColor:(GEVec4)ambientColor lights:(id<CNSeq>)lights;
- (id)initWithAmbientColor:(GEVec4)ambientColor lights:(id<CNSeq>)lights;
- (ODClassType*)type;
+ (EGEnvironment*)applyLights:(id<CNSeq>)lights;
+ (EGEnvironment*)applyLight:(EGLight*)light;
+ (EGEnvironment*)aDefault;
+ (ODClassType*)type;
@end


@interface EGLight : NSObject
@property (nonatomic, readonly) GEVec4 color;

+ (id)lightWithColor:(GEVec4)color;
- (id)initWithColor:(GEVec4)color;
- (ODClassType*)type;
+ (ODClassType*)type;
@end


@interface EGDirectLight : EGLight
@property (nonatomic, readonly) GEVec3 direction;

+ (id)directLightWithColor:(GEVec4)color direction:(GEVec3)direction;
- (id)initWithColor:(GEVec4)color direction:(GEVec3)direction;
- (ODClassType*)type;
+ (ODClassType*)type;
@end


@interface EGMatrixStack : NSObject
@property (nonatomic, retain) EGMatrixModel* value;

+ (id)matrixStack;
- (id)init;
- (ODClassType*)type;
- (void)clear;
- (void)push;
- (void)pop;
- (void)applyModify:(EGMatrixModel*(^)(EGMatrixModel*))modify f:(void(^)())f;
+ (ODClassType*)type;
@end


@interface EGMatrixModel : NSObject
@property (nonatomic, readonly) GEMat4* m;
@property (nonatomic, readonly) GEMat4* w;
@property (nonatomic, readonly) GEMat4* c;
@property (nonatomic, readonly) GEMat4* p;
@property (nonatomic, readonly) CNLazy* _mw;
@property (nonatomic, readonly) CNLazy* _mwc;
@property (nonatomic, readonly) CNLazy* _mwcp;
@property (nonatomic, readonly) CNLazy* _cp;
@property (nonatomic, readonly) CNLazy* _wcp;
@property (nonatomic, readonly) CNLazy* _wc;

+ (id)matrixModelWithM:(GEMat4*)m w:(GEMat4*)w c:(GEMat4*)c p:(GEMat4*)p _mw:(CNLazy*)_mw _mwc:(CNLazy*)_mwc _mwcp:(CNLazy*)_mwcp _cp:(CNLazy*)_cp _wcp:(CNLazy*)_wcp _wc:(CNLazy*)_wc;
- (id)initWithM:(GEMat4*)m w:(GEMat4*)w c:(GEMat4*)c p:(GEMat4*)p _mw:(CNLazy*)_mw _mwc:(CNLazy*)_mwc _mwcp:(CNLazy*)_mwcp _cp:(CNLazy*)_cp _wcp:(CNLazy*)_wcp _wc:(CNLazy*)_wc;
- (ODClassType*)type;
+ (EGMatrixModel*)applyM:(GEMat4*)m w:(GEMat4*)w c:(GEMat4*)c p:(GEMat4*)p;
- (GEMat4*)mw;
- (GEMat4*)mwc;
- (GEMat4*)mwcp;
- (GEMat4*)cp;
- (GEMat4*)wcp;
- (GEMat4*)wc;
- (EGMatrixModel*)modifyM:(GEMat4*(^)(GEMat4*))m;
- (EGMatrixModel*)modifyW:(GEMat4*(^)(GEMat4*))w;
- (EGMatrixModel*)modifyC:(GEMat4*(^)(GEMat4*))c;
- (EGMatrixModel*)modifyP:(GEMat4*(^)(GEMat4*))p;
+ (EGMatrixModel*)identity;
+ (ODClassType*)type;
@end


