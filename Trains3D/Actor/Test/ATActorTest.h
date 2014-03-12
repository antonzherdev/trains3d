#import "objd.h"
#import "ATActor.h"
#import "TSTestCase.h"

@class ATTestedActor;
@class ATActorTest;

@interface ATTestedActor : ATActor {
@private
    id<CNImSeq> _items;
}
@property (nonatomic) id<CNImSeq> items;

+ (instancetype)testedActor;
- (instancetype)init;
- (ODClassType*)type;
- (CNFuture*)addNumber:(NSString*)number;
- (CNFuture*)getItems;
- (CNFuture*)getItemsF;
- (CNFuture*)lockFuture:(CNFuture*)future;
+ (ODClassType*)type;
@end


@interface ATActorTest : TSTestCase
+ (instancetype)actorTest;
- (instancetype)init;
- (ODClassType*)type;
- (void)testTypedActor;
- (void)testTypedActor2;
- (void)testLock;
+ (ODClassType*)type;
@end


