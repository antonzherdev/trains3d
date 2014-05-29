#import "objd.h"
@class GEMat4;

@class EGMatrixStack;
@class EGMatrixModel;
@class EGImMatrixModel;
@class EGMMatrixModel;

@interface EGMatrixStack : NSObject {
@protected
    CNImList* _stack;
    EGMMatrixModel* __value;
}
+ (instancetype)matrixStack;
- (instancetype)init;
- (CNClassType*)type;
- (EGMMatrixModel*)value;
- (void)setValue:(EGMatrixModel*)value;
- (void)clear;
- (void)push;
- (void)pop;
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
- (NSString*)description;
+ (CNClassType*)type;
@end


@interface EGMatrixModel : NSObject
+ (instancetype)matrixModel;
- (instancetype)init;
- (CNClassType*)type;
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
- (NSString*)description;
+ (EGMatrixModel*)identity;
+ (CNClassType*)type;
@end


@interface EGImMatrixModel : EGMatrixModel {
@protected
    GEMat4* _m;
    GEMat4* _w;
    GEMat4* _c;
    GEMat4* _p;
}
@property (nonatomic, readonly) GEMat4* m;
@property (nonatomic, readonly) GEMat4* w;
@property (nonatomic, readonly) GEMat4* c;
@property (nonatomic, readonly) GEMat4* p;

+ (instancetype)imMatrixModelWithM:(GEMat4*)m w:(GEMat4*)w c:(GEMat4*)c p:(GEMat4*)p;
- (instancetype)initWithM:(GEMat4*)m w:(GEMat4*)w c:(GEMat4*)c p:(GEMat4*)p;
- (CNClassType*)type;
- (EGMMatrixModel*)mutable;
- (GEMat4*)mw;
- (GEMat4*)mwc;
- (GEMat4*)mwcp;
- (GEMat4*)cp;
- (GEMat4*)wcp;
- (GEMat4*)wc;
- (NSString*)description;
+ (CNClassType*)type;
@end


@interface EGMMatrixModel : EGMatrixModel {
@protected
    GEMat4* __m;
    GEMat4* __w;
    GEMat4* __c;
    GEMat4* __p;
    GEMat4* __mw;
    GEMat4* __mwc;
    GEMat4* __mwcp;
}
@property (nonatomic, retain) GEMat4* _m;
@property (nonatomic, retain) GEMat4* _w;
@property (nonatomic, retain) GEMat4* _c;
@property (nonatomic, retain) GEMat4* _p;

+ (instancetype)matrixModel;
- (instancetype)init;
- (CNClassType*)type;
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
- (NSString*)description;
+ (CNClassType*)type;
@end


