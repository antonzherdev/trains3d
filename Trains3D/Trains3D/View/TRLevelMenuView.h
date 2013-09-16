#import "objd.h"
#import "EGScene.h"
#import "GEVec.h"
@class TRLevel;
@protocol EGCamera;
@class EGCamera2D;
@class TRScore;
@class EGSchedule;
@class TRRailroad;

@class TRLevelMenuView;

@interface TRLevelMenuView : NSObject<EGLayerView>
@property (nonatomic, readonly) TRLevel* level;
@property (nonatomic, readonly) id<EGCamera> camera;

+ (id)levelMenuViewWithLevel:(TRLevel*)level;
- (id)initWithLevel:(TRLevel*)level;
- (ODClassType*)type;
- (void)drawView;
+ (ODType*)type;
@end


