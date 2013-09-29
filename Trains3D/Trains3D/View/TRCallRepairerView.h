#import "objd.h"
#import "GEVec.h"
#import "EGMaterial.h"
#import "EGMapIso.h"
#import "EGFont.h"
@class TRLevel;
@class EGGlobal;
@class TRRailroad;
@class TRCity;
@class TRCityColor;
@class EGBillboard;
@class TRStr;
@protocol TRStrings;

@class TRCallRepairerView;

@interface TRCallRepairerView : NSObject
@property (nonatomic, readonly) TRLevel* level;

+ (id)callRepairerViewWithLevel:(TRLevel*)level;
- (id)initWithLevel:(TRLevel*)level;
- (ODClassType*)type;
- (void)draw;
- (void)drawButtonForCity:(TRCity*)city;
+ (ODClassType*)type;
@end


