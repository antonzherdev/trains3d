#import "objd.h"
#import "PGInput.h"
#import "TRRailroadBuilder.h"
@class CNVar;

@class TRRailroadBuilderProcessor;

@interface TRRailroadBuilderProcessor : PGInputProcessor_impl {
@public
    TRRailroadBuilder* _builder;
}
@property (nonatomic, readonly) TRRailroadBuilder* builder;

+ (instancetype)railroadBuilderProcessorWithBuilder:(TRRailroadBuilder*)builder;
- (instancetype)initWithBuilder:(TRRailroadBuilder*)builder;
- (CNClassType*)type;
- (PGRecognizers*)recognizers;
- (NSString*)description;
+ (CNClassType*)type;
@end


