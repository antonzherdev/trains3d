#import "objd.h"
#import "PGScene.h"
#import "PGInput.h"
#import "PGTexture.h"
#import "PGVec.h"
#import "PGFont.h"
#import "TRRailroadBuilder.h"
@class TRLevel;
@class PGGlobal;
@class PGCounter;
@class PGProgress;
@class PGSprite;
@class PGPlatform;
@class PGColorSource;
@class CNReact;
@class PGContext;
@class TRHistory;
@class PGText;
@class TRGameDirector;
@class CNSlot;
@class CNVar;
@class CNVal;
@class PGTextShadow;
@class TRStr;
@class TRStrings;
@class TRScore;
@class PGCamera2D;
@class PGEnablingState;
@class PGBlendFunction;
@class PGD2D;
@class TRNotifications;
@class PGDirector;

@class TRLevelMenuView;

@interface TRLevelMenuView : PGLayerView_impl<PGInputProcessor> {
@public
    TRLevel* _level;
    NSString* _name;
    PGTexture* _t;
    PGCounter* _notificationAnimation;
    PGCounter* _levelAnimation;
    PGVec4(^_notificationProgress)(float);
    PGSprite* _pauseSprite;
    PGSprite* _rewindSprite;
    PGText* _rewindCountText;
    PGSprite* _slowSprite;
    PGText* _slowMotionCountText;
    PGSprite* __hammerSprite;
    PGSprite* __clearSprite;
    PGTextShadow* _shadow;
    PGText* _scoreText;
    CNVal* _notificationFont;
    PGText* _remainingTrainsText;
    NSInteger _remainingTrainsDeltaX;
    NSInteger _remainingTrainsDeltaY;
    PGSprite* _remainingTrainsSprite;
    CNVar* _currentNotificationText;
    PGText* _notificationText;
    PGText* _levelText;
    CNReact* __camera;
}
@property (nonatomic, readonly) TRLevel* level;
@property (nonatomic, readonly) NSString* name;
@property (nonatomic) PGText* levelText;

+ (instancetype)levelMenuViewWithLevel:(TRLevel*)level;
- (instancetype)initWithLevel:(TRLevel*)level;
- (CNClassType*)type;
- (id<PGCamera>)camera;
- (void)draw;
- (NSString*)formatScore:(NSInteger)score;
- (void)updateWithDelta:(CGFloat)delta;
- (PGRecognizers*)recognizers;
- (NSString*)description;
+ (CNClassType*)type;
@end


