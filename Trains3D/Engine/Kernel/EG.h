#import "objd.h"
@class EGDirector;
@class EGFileTexture;
@class EGEnvironment;
@class GEMatrix;

@class EG;
@class EGContext;
@class EGMatrixStack;
@class EGMatrixModel;

@interface EG : NSObject
+ (id)g;
- (id)init;
- (ODClassType*)type;
+ (EGDirector*)director;
+ (EGFileTexture*)textureForFile:(NSString*)file;
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
@property (nonatomic, readonly) GEMatrix* m;
@property (nonatomic, readonly) GEMatrix* w;
@property (nonatomic, readonly) GEMatrix* c;
@property (nonatomic, readonly) GEMatrix* p;
@property (nonatomic, readonly) CNLazy* _mw;
@property (nonatomic, readonly) CNLazy* _mwc;
@property (nonatomic, readonly) CNLazy* _mwcp;
@property (nonatomic, readonly) CNLazy* _cp;
@property (nonatomic, readonly) CNLazy* _wcp;
@property (nonatomic, readonly) CNLazy* _wc;

+ (id)matrixModelWithM:(GEMatrix*)m w:(GEMatrix*)w c:(GEMatrix*)c p:(GEMatrix*)p _mw:(CNLazy*)_mw _mwc:(CNLazy*)_mwc _mwcp:(CNLazy*)_mwcp _cp:(CNLazy*)_cp _wcp:(CNLazy*)_wcp _wc:(CNLazy*)_wc;
- (id)initWithM:(GEMatrix*)m w:(GEMatrix*)w c:(GEMatrix*)c p:(GEMatrix*)p _mw:(CNLazy*)_mw _mwc:(CNLazy*)_mwc _mwcp:(CNLazy*)_mwcp _cp:(CNLazy*)_cp _wcp:(CNLazy*)_wcp _wc:(CNLazy*)_wc;
- (ODClassType*)type;
+ (EGMatrixModel*)applyM:(GEMatrix*)m w:(GEMatrix*)w c:(GEMatrix*)c p:(GEMatrix*)p;
- (GEMatrix*)mw;
- (GEMatrix*)mwc;
- (GEMatrix*)mwcp;
- (GEMatrix*)cp;
- (GEMatrix*)wcp;
- (GEMatrix*)wc;
- (EGMatrixModel*)modifyM:(GEMatrix*(^)(GEMatrix*))m;
- (EGMatrixModel*)modifyW:(GEMatrix*(^)(GEMatrix*))w;
- (EGMatrixModel*)modifyC:(GEMatrix*(^)(GEMatrix*))c;
- (EGMatrixModel*)modifyP:(GEMatrix*(^)(GEMatrix*))p;
+ (EGMatrixModel*)identity;
+ (ODClassType*)type;
@end


