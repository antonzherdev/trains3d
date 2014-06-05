#import "objd.h"
#import "TRLevelPauseMenuView.h"
#import "PGVec.h"
#import "PGFont.h"
@class PGText;
@class TRStr;
@class TRStrings;
@class TRGameDirector;
@class PGPlatform;
@class CNReact;
@class PGColorSource;
@class PGGlobal;

@class TRRateMenu;

@interface TRRateMenu : TRMenuView {
@public
    PGText* _headerText;
}
+ (instancetype)rateMenu;
- (instancetype)init;
- (CNClassType*)type;
- (NSArray*)buttons;
- (CGFloat)headerHeight;
- (NSInteger)columnWidth;
- (NSInteger)buttonHeight;
- (CNReact*)headerMaterial;
- (void)_init;
- (void)drawHeader;
- (NSString*)description;
+ (CNClassType*)type;
@end


