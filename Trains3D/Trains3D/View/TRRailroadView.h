#import "objd.h"
#import "TR3DRail.h"
#import "TR3DRailTurn.h"
@class TRRail;
@class TRRailroad;
@class TRRailroadBuilder;
#import "TRRailPoint.h"

@class TRRailroadView;
@class TRRailView;

@interface TRRailroadView : NSObject
+ (id)railroadView;
- (id)init;
- (void)drawRailroad:(TRRailroad*)railroad;
@end


@interface TRRailView : NSObject
+ (id)railView;
- (id)init;
- (void)drawRail:(TRRail*)rail;
@end


