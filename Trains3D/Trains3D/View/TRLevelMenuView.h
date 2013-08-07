#import "objd.h"
#import "EGTypes.h"
@class EGCamera2D;
@class TRLevelRules;
@class TRLevel;

@class TRLevelMenuView;

@interface TRLevelMenuView : NSObject<EGView>
@property (nonatomic, readonly) TRLevel* level;
@property (nonatomic, readonly) id<EGCamera> camera;

+ (id)levelMenuViewWithLevel:(TRLevel*)level;
- (id)initWithLevel:(TRLevel*)level;
- (void)drawView;
@end


