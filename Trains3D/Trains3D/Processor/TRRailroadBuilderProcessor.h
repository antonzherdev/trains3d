#import "objd.h"
#import "EGInput.h"
@class TRRailroadBuilder;
@class TRRailroadBuilderMode;
@class ATVar;
@class EGDirector;
@class ATReact;

@class TRRailroadBuilderProcessor;

@interface TRRailroadBuilderProcessor : NSObject<EGInputProcessor> {
@protected
    TRRailroadBuilder* _builder;
}
@property (nonatomic, readonly) TRRailroadBuilder* builder;

+ (instancetype)railroadBuilderProcessorWithBuilder:(TRRailroadBuilder*)builder;
- (instancetype)initWithBuilder:(TRRailroadBuilder*)builder;
- (ODClassType*)type;
- (EGRecognizers*)recognizers;
+ (ODClassType*)type;
@end


