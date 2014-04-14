#import "objd.h"
#import "GEVec.h"
#import "EGFont.h"
@class EGSprite;
@class EGText;
@class ATSignal;
@protocol EGEvent;
@class ATReact;

@class EGButton;

@interface EGButton : NSObject {
@protected
    EGSprite* _sprite;
    EGText* _text;
}
@property (nonatomic, readonly) EGSprite* sprite;
@property (nonatomic, readonly) EGText* text;

+ (instancetype)buttonWithSprite:(EGSprite*)sprite text:(EGText*)text;
- (instancetype)initWithSprite:(EGSprite*)sprite text:(EGText*)text;
- (ODClassType*)type;
- (ATSignal*)tap;
- (void)draw;
- (BOOL)tapEvent:(id<EGEvent>)event;
+ (EGButton*)applyVisible:(ATReact*)visible font:(ATReact*)font text:(ATReact*)text textColor:(ATReact*)textColor backgroundMaterial:(ATReact*)backgroundMaterial position:(ATReact*)position rect:(ATReact*)rect;
+ (EGButton*)applyFont:(ATReact*)font text:(ATReact*)text textColor:(ATReact*)textColor backgroundMaterial:(ATReact*)backgroundMaterial position:(ATReact*)position rect:(ATReact*)rect;
+ (ODClassType*)type;
@end


