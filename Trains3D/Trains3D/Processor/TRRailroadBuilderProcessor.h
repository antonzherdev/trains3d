#import "objd.h"
#import "EGInput.h"
@class TRRailroadBuilder;
@class EGDirector;
@class ATReact;

@class TRRailroadBuilderProcessor;

@interface TRRailroadBuilderProcessor : NSObject<EGInputProcessor> {
@private
    TRRailroadBuilder* _builder;
}
@property (nonatomic, readonly) TRRailroadBuilder* builder;

+ (instancetype)railroadBuilderProcessorWithBuilder:(TRRailroadBuilder*)builder;
- (instancetype)initWithBuilder:(TRRailroadBuilder*)builder;
- (ODClassType*)type;
- (EGRecognizers*)recognizers;
+ (ODClassType*)type;
@end


