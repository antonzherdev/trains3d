#import "objd.h"
#import "EGScene.h"
#import "EGInput.h"
#import "EGTexture.h"
#import "GEVec.h"
#import "EGFont.h"
#import "TRRailroadBuilder.h"
@class TRLevel;
@class EGGlobal;
@class EGCounter;
@class EGProgress;
@class EGSprite;
@class EGPlatform;
@class EGColorSource;
@class CNReact;
@class EGContext;
@class TRHistory;
@class EGText;
@class TRGameDirector;
@class CNSlot;
@class CNVar;
@class CNVal;
@class EGTextShadow;
@class TRStr;
@class TRStrings;
@class TRScore;
@class EGCamera2D;
@class EGEnablingState;
@class EGBlendFunction;
@class EGD2D;
@class TRNotifications;
@class EGDirector;

@class TRLevelMenuView;

@interface TRLevelMenuView : EGLayerView_impl<EGInputProcessor> {
@protected
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
    CNVar* _currentNotificationText;
    EGText* _notificationText;
    EGText* _levelText;
    CNReact* __camera;
}
@property (nonatomic, readonly) TRLevel* level;
@property (nonatomic, readonly) NSString* name;
@property (nonatomic) EGText* levelText;

+ (instancetype)levelMenuViewWithLevel:(TRLevel*)level;
- (instancetype)initWithLevel:(TRLevel*)level;
- (CNClassType*)type;
- (id<EGCamera>)camera;
- (void)draw;
- (NSString*)formatScore:(NSInteger)score;
- (void)updateWithDelta:(CGFloat)delta;
- (EGRecognizers*)recognizers;
- (NSString*)description;
+ (CNClassType*)type;
@end


