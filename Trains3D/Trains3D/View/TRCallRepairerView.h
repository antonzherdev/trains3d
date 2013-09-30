#import "objd.h"
#import "GEVec.h"
#import "EGMaterial.h"
#import "EGMapIso.h"
#import "EGFont.h"
@class TRLevel;
@class EGGlobal;
@class TRStr;
@protocol TRStrings;
@class EGMatrixStack;
@class GEMat4;
@class TRRailroad;
@class TRCity;
@class TRCityColor;
@class EGBillboard;

@class TRCallRepairerView;

@interface TRCallRepairerView : NSObject
@property (nonatomic, readonly) TRLevel* level;
@property (nonatomic, readonly) EGFont* font;

+ (id)callRepairerViewWithLevel:(TRLevel*)level;
- (id)initWithLevel:(TRLevel*)level;
- (ODClassType*)type;
- (void)draw;
- (void)drawButtonForCity:(TRCity*)city;
+ (ODClassType*)type;
@end


