#import "objd.h"
#import "PGVec.h"
#import "PGFont.h"
#import "TRLevelPauseMenuView.h"
#import "PGTexture.h"
@protocol PGEvent;
@class CNVar;
@class CNReact;
@class PGText;
@class PGGlobal;
@class TRGameDirector;
@class PGColorSource;
@class PGD2D;
@class PGInAppProduct;
@class CNChain;
@class PGContext;

@class TRShopButton;
@class TRShopMenu;

@interface TRShopButton : NSObject {
@public
    void(^_onDraw)(PGRect);
    void(^_onClick)();
    PGRect _rect;
}
@property (nonatomic, readonly) void(^onDraw)(PGRect);
@property (nonatomic, readonly) void(^onClick)();
@property (nonatomic) PGRect rect;

+ (instancetype)shopButtonWithOnDraw:(void(^)(PGRect))onDraw onClick:(void(^)())onClick;
- (instancetype)initWithOnDraw:(void(^)(PGRect))onDraw onClick:(void(^)())onClick;
- (CNClassType*)type;
+ (TRShopButton*)applyRect:(PGRect)rect onDraw:(void(^)(PGRect))onDraw onClick:(void(^)())onClick;
- (BOOL)tapEvent:(id<PGEvent>)event;
- (void)draw;
+ (void(^)(PGRect))drawTextFont:(PGFont*)font color:(PGVec4)color text:(NSString*)text;
- (NSString*)description;
+ (CNClassType*)type;
@end


@interface TRShopMenu : TRPauseView {
@public
    CNLazy* __lazy_shop;
    PGFont* _shareFont;
    PGVec2 _buttonSize;
    NSArray* _curButtons;
}
@property (nonatomic, readonly) PGFont* shareFont;

+ (instancetype)shopMenu;
- (instancetype)init;
- (CNClassType*)type;
- (PGTexture*)shop;
- (void)drawBuyButtonCount:(NSUInteger)count price:(NSString*)price rect:(PGRect)rect;
- (void)drawShareButtonColor:(PGVec3)color texture:(PGTexture*)texture name:(NSString*)name count:(NSUInteger)count rect:(PGRect)rect;
- (void)drawButtonBackgroundColor:(PGVec3)color rect:(PGRect)rect;
- (void)drawSnailColor:(PGVec3)color count:(NSUInteger)count rect:(PGRect)rect;
- (void)drawCloseButtonRect:(PGRect)rect;
- (void)draw;
- (BOOL)tapEvent:(id<PGEvent>)event;
- (NSString*)description;
+ (CNClassType*)type;
@end


