#import "objd.h"
#import "EGScene.h"
#import "GEVec.h"
#import "EGFont.h"
@class TRLevel;
@class EGCamera2D;
@class EGProgress;
@class EGCounter;
@class EGGlobal;
@class EGContext;
@class TRScore;
@class EGSchedule;
@class EGColorSource;
@class EGSprite;
@class TRRailroad;
@class TRNotifications;
@class EGEnvironment;
@class EGTexture;
@class EGFileTexture;

@class TRLevelMenuView;
@class TRLevelMenuViewRes1x;
@class TRLevelMenuViewRes2x;
@protocol TRLevelMenuViewRes;

@interface TRLevelMenuView : NSObject<EGLayerView>
@property (nonatomic, readonly) TRLevel* level;
@property (nonatomic, readonly) id<EGCamera> camera;
@property (nonatomic, readonly) GEVec4(^notificationProgress)(float);

+ (id)levelMenuViewWithLevel:(TRLevel*)level;
- (id)initWithLevel:(TRLevel*)level;
- (ODClassType*)type;
- (TRLevelMenuViewRes1x*)res1x;
- (TRLevelMenuViewRes2x*)res2x;
- (id<TRLevelMenuViewRes>)res;
- (EGFont*)font;
- (void)drawView;
- (void)updateWithDelta:(CGFloat)delta;
+ (ODClassType*)type;
@end


@protocol TRLevelMenuViewRes<NSObject>
- (EGFont*)font;
- (EGTexture*)pause;
- (GERect)pauseUV;
@end


@interface TRLevelMenuViewRes1x : NSObject<TRLevelMenuViewRes>
@property (nonatomic, readonly) EGFont* font;
@property (nonatomic, readonly) EGFileTexture* pause;

+ (id)levelMenuViewRes1x;
- (id)init;
- (ODClassType*)type;
- (GERect)pauseUV;
+ (ODClassType*)type;
@end


@interface TRLevelMenuViewRes2x : NSObject<TRLevelMenuViewRes>
@property (nonatomic, readonly) EGFont* font;
@property (nonatomic, readonly) EGFileTexture* pause;

+ (id)levelMenuViewRes2x;
- (id)init;
- (ODClassType*)type;
- (GERect)pauseUV;
+ (ODClassType*)type;
@end


