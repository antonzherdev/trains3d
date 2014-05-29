#import "objd.h"
#import "TRLevelPauseMenuView.h"
#import "GEVec.h"
#import "EGFont.h"
@class TRLevel;
@class EGText;
@class EGPlatform;
@class EGGlobal;
@class CNReact;
@class TRHelp;
@class CNVar;
@class EGContext;
@class TRStr;
@class TRStrings;
@class EGSprite;
@class EGColorSource;
@class EGDirector;
@protocol EGEvent;

@class TRHelpView;

@interface TRHelpView : TRPauseView {
@protected
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
- (CNClassType*)type;
- (void)draw;
- (BOOL)tapEvent:(id<EGEvent>)event;
- (NSString*)description;
+ (CNClassType*)type;
@end


