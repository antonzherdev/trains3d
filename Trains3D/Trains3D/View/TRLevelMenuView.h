#import "objd.h"
#import "EGScene.h"
#import "EGInput.h"
#import "GEVec.h"
#import "EGFont.h"
@class TRLevel;
@class EGGlobal;
@class EGContext;
@class EGCamera2D;
@class EGSprite;
@class EGProgress;
@class EGCounter;
@class EGBlendFunction;
@class TRScore;
@class EGTextureRegion;
@class EGColorSource;
@class EGEnablingState;
@class TRNotifications;
@class EGDirector;
@class EGEnvironment;

@class TRLevelMenuView;
@class TRLevelMenuViewRes;

@interface TRLevelMenuView : NSObject<EGLayerView, EGInputProcessor, EGTapProcessor>
@property (nonatomic, readonly) TRLevel* level;
@property (nonatomic, readonly) NSString* name;
@property (nonatomic, readonly) CNCache* cameraCache;
@property (nonatomic, readonly) EGSprite* pauseSprite;
@property (nonatomic, readonly) GEVec4(^notificationProgress)(float);
@property (nonatomic, readonly) GERect pauseReg;

+ (id)levelMenuViewWithLevel:(TRLevel*)level;
- (id)initWithLevel:(TRLevel*)level;
- (ODClassType*)type;
- (id<EGCamera>)cameraWithViewport:(GERect)viewport;
- (void)draw;
- (NSString*)formatScore:(NSInteger)score;
- (void)updateWithDelta:(CGFloat)delta;
- (BOOL)processEvent:(EGEvent*)event;
- (BOOL)tapEvent:(EGEvent*)event;
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


