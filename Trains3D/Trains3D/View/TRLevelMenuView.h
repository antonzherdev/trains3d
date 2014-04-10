#import "objd.h"
#import "EGScene.h"
#import "EGInput.h"
#import "GEVec.h"
#import "EGFont.h"
@class TRLevel;
@class EGTexture;
@class EGTextureFormat;
@class EGGlobal;
@class EGCounter;
@class EGProgress;
@class EGSprite;
@class EGPlatform;
@class EGColorSource;
@class ATReact;
@class EGContext;
@class TRHistory;
@class EGText;
@class TRGameDirector;
@class ATSlot;
@class TRRailroadBuilder;
@class TRRailroadBuilderMode;
@class ATVal;
@class EGTextShadow;
@class TRStr;
@class TRStrings;
@class TRScore;
@class ATVar;
@class EGCamera2D;
@class EGEnablingState;
@class EGBlendFunction;
@class EGD2D;
@class TRNotifications;
@class EGDirector;
@class EGEnvironment;

@class TRLevelMenuView;

@interface TRLevelMenuView : NSObject<EGLayerView, EGInputProcessor> {
@private
    TRLevel* _level;
    NSString* _name;
    EGTexture* _t;
    EGCounter* _notificationAnimation;
    EGCounter* _levelAnimation;
    GEVec4(^_notificationProgress)(float);
    EGSprite* _pauseSprite;
    EGSprite* _rewindSprite;
    EGText* _rewindCountText;
    EGSprite* _slowSprite;
    EGText* _slowMotionCountText;
    EGSprite* __hammerSprite;
    EGSprite* __clearSprite;
    EGTextShadow* _shadow;
    EGText* _scoreText;
    ATVar* _currentNotificationText;
    EGText* _notificationText;
    EGText* _levelText;
    ATReact* __camera;
}
@property (nonatomic, readonly) TRLevel* level;
@property (nonatomic, readonly) NSString* name;
@property (nonatomic) EGText* levelText;

+ (instancetype)levelMenuViewWithLevel:(TRLevel*)level;
- (instancetype)initWithLevel:(TRLevel*)level;
- (ODClassType*)type;
- (id<EGCamera>)camera;
- (void)draw;
- (NSString*)formatScore:(NSInteger)score;
- (void)updateWithDelta:(CGFloat)delta;
- (EGRecognizers*)recognizers;
+ (ODClassType*)type;
@end


