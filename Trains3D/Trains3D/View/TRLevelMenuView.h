#import "objd.h"
#import "EGTypes.h"
#import "GEVec.h"
@class TRLevel;
@class EGCamera2D;
@class TRScore;
@class EGSchedule;
@class TRRailroad;

@class TRLevelMenuView;

@interface TRLevelMenuView : NSObject<EGView>
@property (nonatomic, readonly) TRLevel* level;
@property (nonatomic, readonly) id<EGCamera> camera;

+ (id)levelMenuViewWithLevel:(TRLevel*)level;
- (id)initWithLevel:(TRLevel*)level;
- (ODClassType*)type;
- (void)drawView;
+ (ODType*)type;
@end


