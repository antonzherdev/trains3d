#import "objd.h"
#import "ATTypedActor.h"
#import "TSTestCase.h"
@class ATFuture;
@class ATTypedActorFuture;
@class ATActors;
@class ATTry;

@class ATTestedActor;
@class ATActorTest;

@interface ATTestedActor : NSObject<ATTypedActor>
@property (nonatomic, readonly) id<CNSeq> items;

+ (id)testedActor;
- (id)init;
- (ODClassType*)type;
- (void)addNumber:(NSInteger)number;
- (ATFuture*)getItems;
+ (ODClassType*)type;
@end


@interface ATActorTest : TSTestCase
+ (id)actorTest;
- (id)init;
- (ODClassType*)type;
- (void)testTypedActor;
+ (ODClassType*)type;
@end


