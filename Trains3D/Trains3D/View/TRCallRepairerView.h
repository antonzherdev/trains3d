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
@class EGContext;
@class EGBlendFunction;
@class EGEnablingState;
@class TRCity;
@class TRCityColor;
@class EGColorSource;
@class EGBillboard;
@class EGDirector;

@class TRCallRepairerView;

@interface TRCallRepairerView : NSObject<EGInputProcessor, EGTapProcessor>
@property (nonatomic, readonly) TRLevel* level;

+ (id)callRepairerViewWithLevel:(TRLevel*)level;
- (id)initWithLevel:(TRLevel*)level;
- (ODClassType*)type;
- (void)reshapeWithViewport:(GERect)viewport;
- (void)draw;
- (void)drawButtonForCity:(TRCity*)city;
- (BOOL)processEvent:(EGEvent*)event;
- (BOOL)tapEvent:(EGEvent*)event;
+ (ODClassType*)type;
@end


