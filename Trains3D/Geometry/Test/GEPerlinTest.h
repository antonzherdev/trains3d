#import "objd.h"
#import "TSTestCase.h"
@class GEPerlin1;
@class CNChain;

@class GEPerlinTest;

@interface GEPerlinTest : TSTestCase
+ (instancetype)perlinTest;
- (instancetype)init;
- (CNClassType*)type;
- (void)testMain;
- (NSString*)description;
+ (CNClassType*)type;
@end


