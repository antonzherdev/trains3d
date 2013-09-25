#import "objd.h"
#import "EGScene.h"
#import "EGInput.h"
#import "GEVec.h"
#import "EGMaterial.h"
@class TRLevel;
@class EGCamera2D;
@class EGSprite;
@class EGGlobal;
@class EGDirector;
@class EGContext;
@class EGEnvironment;

@class TRLevelPauseMenuView;

@interface TRLevelPauseMenuView : NSObject<EGLayerView, EGInputProcessor, EGMouseProcessor>
@property (nonatomic, readonly) TRLevel* level;
@property (nonatomic, readonly) EGSprite* menuBackSprite;

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


