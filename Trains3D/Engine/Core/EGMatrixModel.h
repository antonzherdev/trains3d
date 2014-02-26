#import "objd.h"
@class GEMat4;

@class EGMatrixStack;
@class EGMatrixModel;
@class EGImMatrixModel;
@class EGMMatrixModel;

@interface EGMatrixStack : NSObject
+ (instancetype)matrixStack;
- (instancetype)init;
- (ODClassType*)type;
- (EGMMatrixModel*)value;
- (void)setValue:(EGMatrixModel*)value;
- (void)clear;
- (void)push;
- (void)pop;
- (void)applyModify:(void(^)(EGMMatrixModel*))modify f:(void(^)())f;
- (void)identityF:(void(^)())f;
- (GEMat4*)m;
- (GEMat4*)w;
- (GEMat4*)c;
- (GEMat4*)p;
- (GEMat4*)mw;
- (GEMat4*)mwc;
- (GEMat4*)mwcp;
- (GEMat4*)wc;
- (GEMat4*)wcp;
- (GEMat4*)cp;
+ (ODClassType*)type;
@end


@interface EGMatrixModel : NSObject
+ (instancetype)matrixModel;
- (instancetype)init;
- (ODClassType*)type;
- (GEMat4*)m;
- (GEMat4*)w;
- (GEMat4*)c;
- (GEMat4*)p;
- (GEMat4*)mw;
- (GEMat4*)mwc;
- (GEMat4*)mwcp;
- (GEMat4*)cp;
- (GEMat4*)wcp;
- (GEMat4*)wc;
- (EGMMatrixModel*)mutable;
+ (EGMatrixModel*)identity;
+ (ODClassType*)type;
@end


@interface EGImMatrixModel : EGMatrixModel
@property (nonatomic, readonly) GEMat4* m;
@property (nonatomic, readonly) GEMat4* w;
@property (nonatomic, readonly) GEMat4* c;
@property (nonatomic, readonly) GEMat4* p;

+ (instancetype)imMatrixModelWithM:(GEMat4*)m w:(GEMat4*)w c:(GEMat4*)c p:(GEMat4*)p;
- (instancetype)initWithM:(GEMat4*)m w:(GEMat4*)w c:(GEMat4*)c p:(GEMat4*)p;
- (ODClassType*)type;
- (EGMMatrixModel*)mutable;
- (GEMat4*)mw;
- (GEMat4*)mwc;
- (GEMat4*)mwcp;
- (GEMat4*)cp;
- (GEMat4*)wcp;
- (GEMat4*)wc;
+ (ODClassType*)type;
@end


@interface EGMMatrixModel : EGMatrixModel
@property (nonatomic, retain) GEMat4* _m;
@property (nonatomic, retain) GEMat4* _w;
@property (nonatomic, retain) GEMat4* _c;
@property (nonatomic, retain) GEMat4* _p;

+ (instancetype)matrixModel;
- (instancetype)init;
- (ODClassType*)type;
- (GEMat4*)m;
- (GEMat4*)w;
- (GEMat4*)c;
- (GEMat4*)p;
- (GEMat4*)mw;
- (GEMat4*)mwc;
- (GEMat4*)mwcp;
- (GEMat4*)cp;
- (GEMat4*)wcp;
- (GEMat4*)wc;
- (EGMMatrixModel*)copy;
+ (EGMMatrixModel*)applyMatrixModel:(EGMatrixModel*)matrixModel;
+ (EGMMatrixModel*)applyImMatrixModel:(EGImMatrixModel*)imMatrixModel;
+ (EGMMatrixModel*)applyM:(GEMat4*)m w:(GEMat4*)w c:(GEMat4*)c p:(GEMat4*)p;
- (EGMMatrixModel*)mutable;
- (EGImMatrixModel*)immutable;
- (EGMMatrixModel*)modifyM:(GEMat4*(^)(GEMat4*))m;
- (EGMMatrixModel*)modifyW:(GEMat4*(^)(GEMat4*))w;
- (EGMMatrixModel*)modifyC:(GEMat4*(^)(GEMat4*))c;
- (EGMMatrixModel*)modifyP:(GEMat4*(^)(GEMat4*))p;
- (void)clear;
- (void)setMatrixModel:(EGMatrixModel*)matrixModel;
+ (ODClassType*)type;
@end


