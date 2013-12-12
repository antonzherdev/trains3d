#import "objd.h"
#import "EGInput.h"
#import "GEVec.h"
@class TRRailroadBuilder;
@class TRRail;
@class TRRailForm;
@class TRRailConnector;
@class EGDirector;

@class TRRailroadBuilderProcessor;

@interface TRRailroadBuilderProcessor : NSObject<EGInputProcessor>
@property (nonatomic, readonly) TRRailroadBuilder* builder;

+ (id)railroadBuilderProcessorWithBuilder:(TRRailroadBuilder*)builder;
- (id)initWithBuilder:(TRRailroadBuilder*)builder;
- (ODClassType*)type;
- (EGRecognizers*)recognizers;
+ (CNNotificationHandle*)refuseBuildNotification;
+ (ODClassType*)type;
@end


