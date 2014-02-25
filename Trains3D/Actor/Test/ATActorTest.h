#import "objd.h"
#import "TSTestCase.h"
@class ATActors;

@class ATTestedActor;
@class ATActorTest;

@interface ATTestedActor : NSObject
@property (nonatomic, readonly) id<CNSeq> items;

+ (id)testedActor;
- (id)init;
- (ODClassType*)type;
- (void)addNumber:(NSInteger)number;
- (id<CNSeq>)getItems;
+ (ODClassType*)type;
@end


@interface ATActorTest : TSTestCase
+ (id)actorTest;
- (id)init;
- (ODClassType*)type;
- (void)testTypedActor;
+ (ODClassType*)type;
@end


