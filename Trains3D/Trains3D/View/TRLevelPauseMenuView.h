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

@interface TRLevelPauseMenuView : NSObject<EGLayerView, EGInputProcessor, EGTapProcessor>
@property (nonatomic, readonly) TRLevel* level;
@property (nonatomic, readonly) NSString* name;

+ (id)levelPauseMenuViewWithLevel:(TRLevel*)level;
- (id)initWithLevel:(TRLevel*)level;
- (ODClassType*)type;
- (id<EGCamera>)cameraWithViewport:(GERect)viewport;
- (void)draw;
- (BOOL)isProcessorActive;
- (BOOL)processEvent:(EGEvent*)event;
- (BOOL)tapEvent:(EGEvent*)event;
+ (ODClassType*)type;
@end


