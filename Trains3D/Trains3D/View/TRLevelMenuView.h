#import "objd.h"
#import "EGScene.h"
#import "EGInput.h"
#import "GEVec.h"
#import "EGFont.h"
@class TRLevel;
@class EGSprite;
@class EGProgress;
@class EGCounter;
@class EGFinisher;
@class EGGlobal;
@class EGContext;
@class EGCamera2D;
@class EGTextureRegion;
@class EGColorSource;
@class EGBlendFunction;
@class EGD2D;
@class TRScore;
@class TRStr;
@protocol TRStrings;
@class EGEnablingState;
@class TRNotifications;
@class EGDirector;
@class EGEnvironment;

@class TRLevelMenuView;

@interface TRLevelMenuView : NSObject<EGLayerView, EGInputProcessor, EGTapProcessor>
@property (nonatomic, readonly) TRLevel* level;
@property (nonatomic, readonly) NSString* name;
@property (nonatomic, readonly) EGSprite* pauseSprite;
@property (nonatomic, readonly) GEVec4(^notificationProgress)(float);
@property (nonatomic, readonly) GERect pauseReg;
@property (nonatomic) id<EGCamera> camera;
@property (nonatomic) id levelText;

+ (id)levelMenuViewWithLevel:(TRLevel*)level;
- (id)initWithLevel:(TRLevel*)level;
- (ODClassType*)type;
- (void)reshapeWithViewport:(GERect)viewport;
- (void)draw;
- (NSString*)formatScore:(NSInteger)score;
- (void)updateWithDelta:(CGFloat)delta;
- (BOOL)processEvent:(EGEvent*)event;
- (BOOL)tapEvent:(EGEvent*)event;
+ (GEVec4)backgroundColor;
+ (ODClassType*)type;
@end


