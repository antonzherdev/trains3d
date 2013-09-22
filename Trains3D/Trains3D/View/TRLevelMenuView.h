#import "objd.h"
#import "EGScene.h"
#import "GEVec.h"
#import "EGFont.h"
@class TRLevel;
@class EGCamera2D;
@class EGGlobal;
@class TRScore;
@class EGSchedule;
@class TRRailroad;
@class EGEnvironment;

@class TRLevelMenuView;

@interface TRLevelMenuView : NSObject<EGLayerView>
@property (nonatomic, readonly) TRLevel* level;
@property (nonatomic, readonly) id<EGCamera> camera;
@property (nonatomic, readonly) EGFont* font;

+ (id)levelMenuViewWithLevel:(TRLevel*)level;
- (id)initWithLevel:(TRLevel*)level;
- (ODClassType*)type;
- (void)drawView;
+ (ODClassType*)type;
@end


