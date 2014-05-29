#import "objd.h"
#import "GEVec.h"
#import "EGFont.h"
@class EGSprite;
@class EGText;
@class CNSignal;
@protocol EGEvent;
@class CNReact;

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
- (CNClassType*)type;
- (CNSignal*)tap;
- (void)draw;
- (BOOL)tapEvent:(id<EGEvent>)event;
+ (EGButton*)applyVisible:(CNReact*)visible font:(CNReact*)font text:(CNReact*)text textColor:(CNReact*)textColor backgroundMaterial:(CNReact*)backgroundMaterial position:(CNReact*)position rect:(CNReact*)rect;
+ (EGButton*)applyFont:(CNReact*)font text:(CNReact*)text textColor:(CNReact*)textColor backgroundMaterial:(CNReact*)backgroundMaterial position:(CNReact*)position rect:(CNReact*)rect;
- (NSString*)description;
+ (CNClassType*)type;
@end


