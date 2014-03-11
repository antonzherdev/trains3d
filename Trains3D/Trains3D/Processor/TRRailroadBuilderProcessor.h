#import "objd.h"
#import "EGInput.h"
#import "GEVec.h"
@class TRRailroadBuilder;
@class TRRail;
@class TRRailForm;
@class TRRailConnector;
@class TRRailroad;
@class TRRailroadState;
@class TRRailroadConnectorContent;
@class EGDirector;

@class TRRailroadBuilderProcessor;

@interface TRRailroadBuilderProcessor : NSObject<EGInputProcessor>
@property (nonatomic, readonly) TRRailroadBuilder* builder;

+ (instancetype)railroadBuilderProcessorWithBuilder:(TRRailroadBuilder*)builder;
- (instancetype)initWithBuilder:(TRRailroadBuilder*)builder;
- (ODClassType*)type;
- (EGRecognizers*)recognizers;
+ (CNNotificationHandle*)refuseBuildNotification;
+ (ODClassType*)type;
@end


