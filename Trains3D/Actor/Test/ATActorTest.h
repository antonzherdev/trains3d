#import "objd.h"
#import "ATTypedActor.h"
#import "TSTestCase.h"

@class ATTestedActor;
@class ATActorTest;

@interface ATTestedActor : ATTypedActor
@property (nonatomic) id<CNSeq> items;

+ (instancetype)testedActor;
- (instancetype)init;
- (ODClassType*)type;
- (CNFuture*)addNumber:(NSString*)number;
- (CNFuture*)getItems;
- (CNFuture*)getItemsF;
+ (ODClassType*)type;
@end


@interface ATActorTest : TSTestCase
+ (instancetype)actorTest;
- (instancetype)init;
- (ODClassType*)type;
- (void)testTypedActor;
- (void)testTypedActor2;
+ (ODClassType*)type;
@end


