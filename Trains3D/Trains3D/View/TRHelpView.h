#import "objd.h"
#import "TRLevelPauseMenuView.h"
#import "PGVec.h"
#import "PGFont.h"
@class TRLevel;
@class PGText;
@class PGPlatform;
@class PGGlobal;
@class CNReact;
@class TRHelp;
@class CNVar;
@class PGContext;
@class TRStr;
@class TRStrings;
@class PGSprite;
@class PGColorSource;
@class PGDirector;
@protocol PGEvent;

@class TRHelpView;

@interface TRHelpView : TRPauseView {
@public
    TRLevel* _level;
    NSInteger _delta;
    PGText* _helpText;
    PGText* _tapText;
    PGSprite* _helpBackSprite;
    BOOL __allowClose;
}
@property (nonatomic, readonly) TRLevel* level;
@property (nonatomic) BOOL _allowClose;

+ (instancetype)helpViewWithLevel:(TRLevel*)level;
- (instancetype)initWithLevel:(TRLevel*)level;
- (CNClassType*)type;
- (void)draw;
- (BOOL)tapEvent:(id<PGEvent>)event;
- (NSString*)description;
+ (CNClassType*)type;
@end


