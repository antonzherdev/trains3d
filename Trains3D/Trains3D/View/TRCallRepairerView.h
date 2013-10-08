#import "objd.h"
#import "EGInput.h"
#import "GEVec.h"
#import "EGMapIso.h"
#import "EGFont.h"
@class TRLevel;
@class EGGlobal;
@class TRStr;
@protocol TRStrings;
@class EGMatrixStack;
@class GEMat4;
@class TRRailroad;
@class EGBlendFunction;
@class TRCity;
@class EGContext;
@class TRCityColor;
@class EGColorSource;
@class EGBillboard;
@class EGDirector;

@class TRCallRepairerView;

@interface TRCallRepairerView : NSObject<EGInputProcessor, EGMouseProcessor>
@property (nonatomic, readonly) TRLevel* level;
@property (nonatomic, readonly) EGFont* font;

+ (id)callRepairerViewWithLevel:(TRLevel*)level;
- (id)initWithLevel:(TRLevel*)level;
- (ODClassType*)type;
- (void)draw;
- (void)drawButtonForCity:(TRCity*)city;
- (BOOL)processEvent:(EGEvent*)event;
- (BOOL)mouseDownEvent:(EGEvent*)event;
+ (ODClassType*)type;
@end


