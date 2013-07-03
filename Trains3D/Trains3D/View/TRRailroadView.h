#import "objd.h"
#import "EGGL.h"
#import "TRRailroad.h"

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


