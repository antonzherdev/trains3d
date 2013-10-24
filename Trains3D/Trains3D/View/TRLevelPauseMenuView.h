#import "objd.h"
#import "EGScene.h"
#import "EGInput.h"
#import "GEVec.h"
#import "EGFont.h"
@class TRLevel;
@class EGCamera2D;
@class EGGlobal;
@class EGDirector;
@class EGBlendFunction;
@class EGContext;
@class EGColorSource;
@class EGD2D;
@class EGEnablingState;
@class EGEnvironment;
@class EGButton;
@class EGSprite;
@class TRStr;
@protocol TRStrings;
@class TRSceneFactory;
@class TRLevelMenuView;
@class TRHelp;

@class TRLevelPauseMenuView;
@class TRPauseMenuView;
@class TRHelpView;
@protocol TRPauseView;
@protocol TRMenuView;

@interface TRLevelPauseMenuView : NSObject<EGLayerView, EGInputProcessor>
@property (nonatomic, readonly) TRLevel* level;
@property (nonatomic, readonly) NSString* name;
@property (nonatomic) id<EGCamera> camera;

+ (id)levelPauseMenuViewWithLevel:(TRLevel*)level;
- (id)initWithLevel:(TRLevel*)level;
- (ODClassType*)type;
- (void)reshapeWithViewport:(GERect)viewport;
- (id<TRPauseView>)view;
- (void)draw;
- (BOOL)isProcessorActive;
- (BOOL)processEvent:(EGEvent*)event;
+ (ODClassType*)type;
@end


@protocol TRPauseView<EGTapProcessor>
- (void)reshapeWithViewport:(GERect)viewport;
- (void)draw;
@end


@protocol TRMenuView<NSObject>
- (EGButton*)buttonText:(NSString*)text onClick:(void(^)())onClick;
- (void(^)(GERect))drawLine;
- (id<CNSeq>)buttons;
- (BOOL)tapEvent:(EGEvent*)event;
- (void)draw;
- (EGSprite*)menuBackSprite;
- (void)reshapeWithViewport:(GERect)viewport;
@end


@interface TRPauseMenuView : NSObject<TRPauseView, TRMenuView>
@property (nonatomic, readonly) TRLevel* level;
@property (nonatomic, readonly) EGSprite* menuBackSprite;
@property (nonatomic, readonly) id<CNSeq> buttons;

+ (id)pauseMenuViewWithLevel:(TRLevel*)level;
- (id)initWithLevel:(TRLevel*)level;
- (ODClassType*)type;
+ (ODClassType*)type;
@end


@interface TRHelpView : NSObject<TRPauseView>
@property (nonatomic, readonly) TRLevel* level;

+ (id)helpViewWithLevel:(TRLevel*)level;
- (id)initWithLevel:(TRLevel*)level;
- (ODClassType*)type;
- (void)reshapeWithViewport:(GERect)viewport;
- (void)draw;
- (BOOL)tapEvent:(EGEvent*)event;
+ (ODClassType*)type;
@end


