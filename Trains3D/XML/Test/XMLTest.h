#import "objd.h"
#import "TSTestCase.h"
@class XML;
@class XMLElement;

@class XMLTest;

@interface XMLTest : TSTestCase
+ (instancetype)test;
- (instancetype)init;
- (CNClassType*)type;
- (void)testChild;
- (void)testAttributes;
- (NSString*)description;
+ (CNClassType*)type;
@end


