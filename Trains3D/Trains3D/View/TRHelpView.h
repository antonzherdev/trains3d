#import "objd.h"
#import "TRLevelPauseMenuView.h"
#import "GEVec.h"
#import "EGFont.h"
@class TRLevel;
@class EGText;
@class EGPlatform;
@class EGGlobal;
@class ATReact;
@class TRHelp;
@class ATVar;
@class EGContext;
@class TRStr;
@class TRStrings;
@class EGSprite;
@class EGColorSource;
@class EGDirector;
@protocol EGEvent;

@class TRHelpView;

@interface TRHelpView : TRPauseView {
@private
    TRLevel* _level;
    NSInteger _delta;
    EGText* _helpText;
    EGText* _tapText;
    EGSprite* _helpBackSprite;
    BOOL __allowClose;
}
@property (nonatomic, readonly) TRLevel* level;
@property (nonatomic) BOOL _allowClose;

+ (instancetype)helpViewWithLevel:(TRLevel*)level;
- (instancetype)initWithLevel:(TRLevel*)level;
- (ODClassType*)type;
- (void)draw;
- (BOOL)tapEvent:(id<EGEvent>)event;
+ (ODClassType*)type;
@end


