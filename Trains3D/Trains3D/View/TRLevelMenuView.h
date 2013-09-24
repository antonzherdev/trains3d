#import "objd.h"
#import "EGScene.h"
#import "GEVec.h"
#import "EGFont.h"
@class TRLevel;
@class EGProgress;
@class EGCounter;
@class EGGlobal;
@class EGContext;
@class TRScore;
@class EGSchedule;
@class EGSprite;
@class TRRailroad;
@class TRNotifications;
@class EGEnvironment;
@class EGCamera2D;
@class EGColorSource;

@class TRLevelMenuView;
@class TRLevelMenuViewRes;
@class TRLevelMenuViewRes1x;
@class TRLevelMenuViewRes2x;

@interface TRLevelMenuView : NSObject<EGLayerView>
@property (nonatomic, readonly) TRLevel* level;
@property (nonatomic, readonly) GEVec4(^notificationProgress)(float);

+ (id)levelMenuViewWithLevel:(TRLevel*)level;
- (id)initWithLevel:(TRLevel*)level;
- (ODClassType*)type;
- (TRLevelMenuViewRes1x*)res1x;
- (TRLevelMenuViewRes2x*)res2x;
- (id<EGCamera>)cameraWithViewport:(GERect)viewport;
- (TRLevelMenuViewRes*)res;
- (EGFont*)font;
- (void)draw;
- (void)updateWithDelta:(CGFloat)delta;
+ (ODClassType*)type;
@end


@interface TRLevelMenuViewRes : NSObject
+ (id)levelMenuViewRes;
- (id)init;
- (ODClassType*)type;
- (EGFont*)font;
- (EGSprite*)pauseSprite;
- (float)pixelsInPoint;
- (id<EGCamera>)cameraWithViewport:(GERect)viewport;
+ (ODClassType*)type;
@end


@interface TRLevelMenuViewRes1x : TRLevelMenuViewRes
@property (nonatomic, readonly) EGFont* font;
@property (nonatomic, readonly) float pixelsInPoint;
@property (nonatomic, readonly) EGSprite* pauseSprite;

+ (id)levelMenuViewRes1x;
- (id)init;
- (ODClassType*)type;
+ (ODClassType*)type;
@end


@interface TRLevelMenuViewRes2x : TRLevelMenuViewRes
@property (nonatomic, readonly) EGFont* font;
@property (nonatomic, readonly) float pixelsInPoint;
@property (nonatomic, readonly) EGSprite* pauseSprite;

+ (id)levelMenuViewRes2x;
- (id)init;
- (ODClassType*)type;
+ (ODClassType*)type;
@end


