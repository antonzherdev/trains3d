#import "objd.h"
#import "EGScene.h"
#import "EGInput.h"
#import "GEVec.h"
#import "EGFont.h"
@class TRLevel;
@class EGSprite;
@class EGColorSource;
@class EGLine2d;
@class EGCamera2D;
@class EGGlobal;
@class EGContext;
@class EGDirector;
@class EGBlendFunction;
@class EGD2D;
@class EGEnablingState;
@class TRStr;
@protocol TRStrings;
@class TRHelp;
@class TRSceneFactory;
@class EGEnvironment;

@class TRLevelPauseMenuView;

@interface TRLevelPauseMenuView : NSObject<EGLayerView, EGInputProcessor, EGTapProcessor>
@property (nonatomic, readonly) TRLevel* level;
@property (nonatomic, readonly) NSString* name;
@property (nonatomic) id<EGCamera> camera;

+ (id)levelPauseMenuViewWithLevel:(TRLevel*)level;
- (id)initWithLevel:(TRLevel*)level;
- (ODClassType*)type;
- (void)reshapeWithViewport:(GERect)viewport;
- (void)draw;
- (void)drawMenu;
- (void)drawHelp;
- (BOOL)isProcessorActive;
- (BOOL)processEvent:(EGEvent*)event;
- (BOOL)tapEvent:(EGEvent*)event;
+ (ODClassType*)type;
@end


