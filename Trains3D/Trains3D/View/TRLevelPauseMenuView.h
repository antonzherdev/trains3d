#import "objd.h"
#import "EGScene.h"
#import "EGInput.h"
#import "GEVec.h"
#import "EGFont.h"
@class TRLevel;
@class EGCamera2D;
@class TRLevelResult;
@class EGDirector;
@class EGBlendFunction;
@class EGGlobal;
@class EGContext;
@class EGColorSource;
@class EGD2D;
@class EGEnablingState;
@class EGEnvironment;
@class EGSprite;
@class EGButton;
@class TRStr;
@protocol TRStrings;
@class TRGameDirector;
@class TRLevelMenuView;
@class TRHelp;

@class TRLevelPauseMenuView;
@class TRMenuView;
@class TRPauseMenuView;
@class TRWinMenu;
@class TRLooseMenu;
@class TRHelpView;
@protocol TRPauseView;

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
- (void)updateWithDelta:(CGFloat)delta;
- (BOOL)isActive;
- (BOOL)isProcessorActive;
- (BOOL)processEvent:(EGEvent*)event;
+ (ODClassType*)type;
@end


@protocol TRPauseView<EGTapProcessor>
- (void)reshapeWithViewport:(GERect)viewport;
- (void)draw;
@end


@interface TRMenuView : NSObject
+ (id)menuView;
- (id)init;
- (ODClassType*)type;
- (EGFont*)font;
- (EGButton*)buttonText:(NSString*)text onClick:(void(^)())onClick;
- (void(^)(GERect))drawLine;
- (id<CNSeq>)buttons;
- (BOOL)tapEvent:(EGEvent*)event;
- (void)draw;
- (CGFloat)headerHeight;
- (void)reshapeWithViewport:(GERect)viewport;
- (void)reshape;
- (void)drawHeaderRect:(GERect)rect;
+ (ODClassType*)type;
@end


@interface TRPauseMenuView : TRMenuView<TRPauseView>
@property (nonatomic, readonly) TRLevel* level;
@property (nonatomic, readonly) id<CNSeq> buttons;

+ (id)pauseMenuViewWithLevel:(TRLevel*)level;
- (id)initWithLevel:(TRLevel*)level;
- (ODClassType*)type;
+ (ODClassType*)type;
@end


@interface TRWinMenu : TRMenuView<TRPauseView>
@property (nonatomic, readonly) TRLevel* level;
@property (nonatomic, readonly) id<CNSeq> buttons;
@property (nonatomic, retain) EGFont* headerFont;

+ (id)winMenuWithLevel:(TRLevel*)level;
- (id)initWithLevel:(TRLevel*)level;
- (ODClassType*)type;
- (CGFloat)headerHeight;
- (void)drawHeaderRect:(GERect)rect;
- (void)reshape;
+ (ODClassType*)type;
@end


@interface TRLooseMenu : TRMenuView<TRPauseView>
@property (nonatomic, readonly) TRLevel* level;
@property (nonatomic, readonly) id<CNSeq> buttons;
@property (nonatomic, retain) EGFont* headerFont;
@property (nonatomic, retain) EGFont* detailsFont;

+ (id)looseMenuWithLevel:(TRLevel*)level;
- (id)initWithLevel:(TRLevel*)level;
- (ODClassType*)type;
- (CGFloat)headerHeight;
- (void)drawHeaderRect:(GERect)rect;
- (void)reshape;
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


