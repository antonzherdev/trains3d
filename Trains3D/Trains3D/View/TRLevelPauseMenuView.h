#import "objd.h"
#import "EGScene.h"
#import "EGInput.h"
#import "GEVec.h"
#import "EGFont.h"
@class TRLevel;
@class EGCamera2D;
@class EGSprite;
@class EGColorSource;
@class EGLine2d;
@class EGGlobal;
@class EGDirector;
@class EGBlendFunction;
@class EGContext;
@class EGD2D;
@class TRStr;
@protocol TRStrings;
@class EGEnablingState;
@class TRSceneFactory;
@class EGEnvironment;

@class TRLevelPauseMenuView;

@interface TRLevelPauseMenuView : NSObject<EGLayerView, EGInputProcessor, EGMouseProcessor>
@property (nonatomic, readonly) TRLevel* level;
@property (nonatomic, readonly) NSInteger width;
@property (nonatomic, readonly) EGSprite* menuBackSprite;
@property (nonatomic, readonly) EGLine2d* resumeLine;
@property (nonatomic, readonly) EGLine2d* restartLine;
@property (nonatomic, readonly) EGLine2d* mainMenuLine;
@property (nonatomic, readonly) EGFont* font;

+ (id)levelPauseMenuViewWithLevel:(TRLevel*)level;
- (id)initWithLevel:(TRLevel*)level;
- (ODClassType*)type;
- (id<EGCamera>)cameraWithViewport:(GERect)viewport;
- (void)draw;
- (BOOL)isProcessorActive;
- (BOOL)processEvent:(EGEvent*)event;
- (BOOL)mouseUpEvent:(EGEvent*)event;
+ (ODClassType*)type;
@end


