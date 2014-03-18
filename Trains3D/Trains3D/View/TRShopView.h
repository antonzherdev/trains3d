#import "objd.h"
#import "GEVec.h"
#import "EGFont.h"
#import "TRLevelPauseMenuView.h"
@protocol EGEvent;
@class ATVar;
@class ATReact;
@class EGTexture;
@class EGTextureFormat;
@class EGGlobal;
@class TRGameDirector;
@class EGColorSource;
@class EGD2D;
@class EGInAppProduct;
@class EGContext;

@class TRShopButton;
@class TRSlowMotionShopMenu;

@interface TRShopButton : NSObject {
@private
    void(^_onDraw)(GERect);
    void(^_onClick)();
    GERect _rect;
}
@property (nonatomic, readonly) void(^onDraw)(GERect);
@property (nonatomic, readonly) void(^onClick)();
@property (nonatomic) GERect rect;

+ (instancetype)shopButtonWithOnDraw:(void(^)(GERect))onDraw onClick:(void(^)())onClick;
- (instancetype)initWithOnDraw:(void(^)(GERect))onDraw onClick:(void(^)())onClick;
- (ODClassType*)type;
+ (TRShopButton*)applyRect:(GERect)rect onDraw:(void(^)(GERect))onDraw onClick:(void(^)())onClick;
- (BOOL)tapEvent:(id<EGEvent>)event;
- (void)draw;
+ (void(^)(GERect))drawTextFont:(EGFont*)font color:(GEVec4)color text:(NSString*)text;
+ (ODClassType*)type;
@end


@interface TRSlowMotionShopMenu : TRPauseView {
@private
    CNLazy* __lazy_shop;
    EGFont* _shareFont;
    GEVec2 _buttonSize;
    id<CNImSeq> _curButtons;
}
@property (nonatomic, readonly) EGFont* shareFont;

+ (instancetype)slowMotionShopMenu;
- (instancetype)init;
- (ODClassType*)type;
- (EGTexture*)shop;
- (void)drawBuyButtonCount:(NSUInteger)count price:(NSString*)price rect:(GERect)rect;
- (void)drawShareButtonColor:(GEVec3)color texture:(EGTexture*)texture name:(NSString*)name count:(NSUInteger)count rect:(GERect)rect;
- (void)drawButtonBackgroundColor:(GEVec3)color rect:(GERect)rect;
- (void)drawSnailColor:(GEVec3)color count:(NSUInteger)count rect:(GERect)rect;
- (void)drawCloseButtonRect:(GERect)rect;
- (void)draw;
- (BOOL)tapEvent:(id<EGEvent>)event;
+ (ODClassType*)type;
@end


