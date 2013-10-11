#import "objd.h"
#import "EGScene.h"
#import "EGInput.h"
#import "GEVec.h"
#import "EGFont.h"
@class TRLevel;
@class EGProgress;
@class EGCounter;
@class EGGlobal;
@class EGContext;
@class EGBlendFunction;
@class TRScore;
@class EGSprite;
@class EGEnablingState;
@class TRNotifications;
@class EGDirector;
@class EGEnvironment;
@class EGCamera2D;
@class EGColorSource;

@class TRLevelMenuView;
@class TRLevelMenuViewRes;
@class TRLevelMenuViewRes1x;
@class TRLevelMenuViewRes2x;

@interface TRLevelMenuView : NSObject<EGLayerView, EGInputProcessor, EGMouseProcessor>
@property (nonatomic, readonly) TRLevel* level;
@property (nonatomic, readonly) GEVec4(^notificationProgress)(float);

+ (id)levelMenuViewWithLevel:(TRLevel*)level;
- (id)initWithLevel:(TRLevel*)level;
- (ODClassType*)type;
- (TRLevelMenuViewRes1x*)res1x;
- (TRLevelMenuViewRes2x*)res2x;
- (id<EGCamera>)cameraWithViewport:(GERect)viewport;
- (TRLevelMenuViewRes*)res;
- (TRLevelMenuViewRes*)resHeight:(float)height;
- (EGFont*)font;
- (void)draw;
- (NSString*)formatScore:(NSInteger)score;
- (void)updateWithDelta:(CGFloat)delta;
- (BOOL)processEvent:(EGEvent*)event;
- (BOOL)mouseUpEvent:(EGEvent*)event;
+ (ODClassType*)type;
@end


@interface TRLevelMenuViewRes : NSObject
@property (nonatomic, readonly) CNCache* cameraCache;

+ (id)levelMenuViewRes;
- (id)init;
- (ODClassType*)type;
- (EGFont*)font;
- (EGFont*)notificationFont;
- (EGSprite*)pauseSprite;
- (float)pixelsInPoint;
- (id<EGCamera>)cameraWithViewport:(GERect)viewport;
+ (ODClassType*)type;
@end


@interface TRLevelMenuViewRes1x : TRLevelMenuViewRes
@property (nonatomic, readonly) EGFont* font;
@property (nonatomic, readonly) EGFont* notificationFont;
@property (nonatomic, readonly) float pixelsInPoint;
@property (nonatomic, readonly) EGSprite* pauseSprite;

+ (id)levelMenuViewRes1x;
- (id)init;
- (ODClassType*)type;
+ (ODClassType*)type;
@end


@interface TRLevelMenuViewRes2x : TRLevelMenuViewRes
@property (nonatomic, readonly) EGFont* font;
@property (nonatomic, readonly) EGFont* notificationFont;
@property (nonatomic, readonly) float pixelsInPoint;
@property (nonatomic, readonly) EGSprite* pauseSprite;

+ (id)levelMenuViewRes2x;
- (id)init;
- (ODClassType*)type;
+ (ODClassType*)type;
@end


