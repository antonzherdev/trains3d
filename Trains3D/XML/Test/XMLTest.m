#import "XMLTest.h"

#import "XML.h"
@implementation XMLTest
static CNClassType* _XMLTest_type;

+ (instancetype)test {
    return [[XMLTest alloc] init];
}

- (instancetype)init {
    self = [super init];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [XMLTest class]) _XMLTest_type = [CNClassType classTypeWithCls:[XMLTest class]];
}

- (void)testChild {
    XMLElement* root = [XML strData:@"<root><c1/><c2></c2></root>"];
    assertEquals(@"root", [root name]);
    assertEquals(@2, numi(((NSInteger)([[root children] count]))));
    assertEquals([root childWithName:@"c1"], [root firstChild]);
}

- (void)testAttributes {
    XMLElement* root = [XML strData:@"<root a1=\"v1\" a2=\"v2\"></root>"];
    assertEquals(@2, numi(((NSInteger)([[root attributes] count]))));
    assertEquals(@"v1", ((NSString*)(nonnil([root applyName:@"a1"]))));
    assertEquals(@"v2", ((NSString*)(nonnil([root applyName:@"a2"]))));
}

- (NSString*)description {
    return @"XMLTest";
}

- (CNClassType*)type {
    return [XMLTest type];
}

+ (CNClassType*)type {
    return _XMLTest_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

