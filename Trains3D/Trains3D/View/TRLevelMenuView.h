#import "objd.h"
#import "EGScene.h"
#import "EGInput.h"
#import "GEVec.h"
#import "EGFont.h"
@class TRLevel;
@class EGTexture;
@class EGTextureFormat;
@class EGGlobal;
@class EGSprite;
@class EGPlatform;
@class EGColorSource;
@class ATReact;
@class EGContext;
@class ATVar;
@class TRRailroadBuilder;
@class TRRailroadBuilderMode;
@class TRGameDirector;
@class TRStr;
@class TRStrings;
@class TRScore;
@class EGCounter;
@class EGFinisher;
@class EGProgress;
@class EGCamera2D;
@class EGBlendFunction;
@class EGD2D;
@class EGEnablingState;
@class TRNotifications;
@class EGDirector;
@class EGEnvironment;

@class TRLevelMenuView;

@interface TRLevelMenuView : NSObject<EGLayerView, EGInputProcessor> {
@private
    TRLevel* _level;
    NSString* _name;
    EGTexture* _t;
    EGSprite* _pauseSprite;
    EGSprite* _slowSprite;
    EGSprite* __hammerSprite;
    EGSprite* __clearSprite;
    id _shadow;
    EGText* _slowMotionCountText;
    EGText* _scoreText;
    ATVar* _currentNotificationText;
    EGText* _notificationText;
    id _levelText;
    GEVec4(^_notificationProgress)(float);
    ATReact* __camera;
    EGCounter* _notificationAnimation;
    EGFinisher* _levelAnimation;
}
@property (nonatomic, readonly) TRLevel* level;
@property (nonatomic, readonly) NSString* name;
@property (nonatomic) id levelText;

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


