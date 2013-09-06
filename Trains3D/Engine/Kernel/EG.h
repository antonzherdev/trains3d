#import "objd.h"
@class CNLazy;
@class EGDirector;
@class EGTexture;
@class EGFileTexture;
@class EGMatrix;
#import "EGVec.h"
#import "EGGL.h"
#import "EGTypes.h"

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
@property (nonatomic, readonly) EGMatrix* m;
@property (nonatomic, readonly) EGMatrix* w;
@property (nonatomic, readonly) EGMatrix* c;
@property (nonatomic, readonly) EGMatrix* p;
@property (nonatomic, readonly) CNLazy* _mw;
@property (nonatomic, readonly) CNLazy* _mwc;
@property (nonatomic, readonly) CNLazy* _mwcp;
@property (nonatomic, readonly) CNLazy* _cp;
@property (nonatomic, readonly) CNLazy* _wcp;
@property (nonatomic, readonly) CNLazy* _wc;

+ (id)matrixModelWithM:(EGMatrix*)m w:(EGMatrix*)w c:(EGMatrix*)c p:(EGMatrix*)p _mw:(CNLazy*)_mw _mwc:(CNLazy*)_mwc _mwcp:(CNLazy*)_mwcp _cp:(CNLazy*)_cp _wcp:(CNLazy*)_wcp _wc:(CNLazy*)_wc;
- (id)initWithM:(EGMatrix*)m w:(EGMatrix*)w c:(EGMatrix*)c p:(EGMatrix*)p _mw:(CNLazy*)_mw _mwc:(CNLazy*)_mwc _mwcp:(CNLazy*)_mwcp _cp:(CNLazy*)_cp _wcp:(CNLazy*)_wcp _wc:(CNLazy*)_wc;
- (ODClassType*)type;
+ (EGMatrixModel*)applyM:(EGMatrix*)m w:(EGMatrix*)w c:(EGMatrix*)c p:(EGMatrix*)p;
- (EGMatrix*)mw;
- (EGMatrix*)mwc;
- (EGMatrix*)mwcp;
- (EGMatrix*)cp;
- (EGMatrix*)wcp;
- (EGMatrix*)wc;
- (EGMatrixModel*)modifyM:(EGMatrix*(^)(EGMatrix*))m;
- (EGMatrixModel*)modifyW:(EGMatrix*(^)(EGMatrix*))w;
- (EGMatrixModel*)modifyC:(EGMatrix*(^)(EGMatrix*))c;
- (EGMatrixModel*)modifyP:(EGMatrix*(^)(EGMatrix*))p;
+ (EGMatrixModel*)identity;
+ (ODClassType*)type;
@end


