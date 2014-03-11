#import "objd.h"
#import "EGScene.h"
#import "EGInput.h"
#import "GEVec.h"
#import "EGFont.h"
@class TRLevel;
@class EGSprite;
@class EGProgress;
@class TRScore;
@class TRRailroadBuilder;
@class TRRailroadBuilderMode;
@class EGColorSource;
@class EGPlatform;
@class EGCounter;
@class EGFinisher;
@class EGGlobal;
@class EGContext;
@class EGCamera2D;
@class TRStr;
@class TRStrings;
@class EGTextureFormat;
@class EGTexture;
@class EGBlendFunction;
@class EGD2D;
@class TRGameDirector;
@class EGEnablingState;
@class TRNotifications;
@class EGDirector;
@class EGEnvironment;

@class TRLevelMenuView;

@interface TRLevelMenuView : NSObject<EGLayerView, EGInputProcessor>
@property (nonatomic, readonly) TRLevel* level;
@property (nonatomic, readonly) NSString* name;
@property (nonatomic, retain) EGSprite* _hammerSprite;
@property (nonatomic, retain) EGSprite* _clearSprite;
@property (nonatomic, readonly) GEVec4(^notificationProgress)(float);
@property (nonatomic) id<EGCamera> camera;
@property (nonatomic, readonly) EGText* scoreText;
@property (nonatomic) id levelText;

+ (instancetype)levelMenuViewWithLevel:(TRLevel*)level;
- (instancetype)initWithLevel:(TRLevel*)level;
- (ODClassType*)type;
- (void)_init;
- (void)reshapeWithViewport:(GERect)viewport;
- (GEVec4)color;
- (void)draw;
- (NSString*)formatScore:(NSInteger)score;
- (void)updateWithDelta:(CGFloat)delta;
- (EGRecognizers*)recognizers;
+ (ODClassType*)type;
@end


