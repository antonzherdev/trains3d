#import "objd.h"
#import "ATTypedActor.h"
#import "TSTestCase.h"

@class ATTestedActor;
@class ATActorTest;

@interface ATTestedActor : ATTypedActor
@property (nonatomic, readonly) id<CNSeq> items;

+ (instancetype)testedActor;
- (instancetype)init;
- (ODClassType*)type;
- (void)addNumber:(NSInteger)number;
- (CNFuture*)getItems;
- (CNFuture*)getItemsF;
+ (ODClassType*)type;
@end


@interface ATActorTest : TSTestCase
+ (instancetype)actorTest;
- (instancetype)init;
- (ODClassType*)type;
- (void)testTypedActor;
+ (ODClassType*)type;
@end


