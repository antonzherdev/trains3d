#import "objd.h"
#import "EGInput.h"
#import "GELine.h"
#import "GEVec.h"
@class TRRailroadBuilder;
@class TRRailForm;
@class TRRail;
@class TRRailConnector;
@class EGDirector;

@class TRRailroadBuilderProcessor;

@interface TRRailroadBuilderProcessor : NSObject<EGInputProcessor>
@property (nonatomic, readonly) TRRailroadBuilder* builder;

+ (id)railroadBuilderProcessorWithBuilder:(TRRailroadBuilder*)builder;
- (id)initWithBuilder:(TRRailroadBuilder*)builder;
- (ODClassType*)type;
- (EGRecognizers*)recognizers;
+ (ODClassType*)type;
@end


