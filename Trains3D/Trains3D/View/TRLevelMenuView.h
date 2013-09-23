#import "objd.h"
#import "EGScene.h"
#import "GEVec.h"
#import "EGFont.h"
@class TRLevel;
@class EGCamera2D;
@class EGGlobal;
@class EGProgress;
@class EGCounter;
@class TRScore;
@class EGSchedule;
@class TRRailroad;
@class TRNotifications;
@class EGEnvironment;

@class TRLevelMenuView;

@interface TRLevelMenuView : NSObject<EGLayerView>
@property (nonatomic, readonly) TRLevel* level;
@property (nonatomic, readonly) id<EGCamera> camera;
@property (nonatomic, readonly) EGFont* font;
@property (nonatomic, readonly) GEVec4(^notificationProgress)(float);

+ (id)levelMenuViewWithLevel:(TRLevel*)level;
- (id)initWithLevel:(TRLevel*)level;
- (ODClassType*)type;
- (void)drawView;
- (void)updateWithDelta:(CGFloat)delta;
+ (ODClassType*)type;
@end


