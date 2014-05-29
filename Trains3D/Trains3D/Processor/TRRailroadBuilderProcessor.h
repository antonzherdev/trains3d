#import "objd.h"
#import "EGInput.h"
#import "TRRailroadBuilder.h"
@class CNVar;

@class TRRailroadBuilderProcessor;

@interface TRRailroadBuilderProcessor : EGInputProcessor_impl {
@protected
    TRRailroadBuilder* _builder;
}
@property (nonatomic, readonly) TRRailroadBuilder* builder;

+ (instancetype)railroadBuilderProcessorWithBuilder:(TRRailroadBuilder*)builder;
- (instancetype)initWithBuilder:(TRRailroadBuilder*)builder;
- (CNClassType*)type;
- (EGRecognizers*)recognizers;
- (NSString*)description;
+ (CNClassType*)type;
@end


