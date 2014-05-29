#import "CNXMLTest.h"

#import "CNXML.h"
@implementation CNXMLTest
static CNClassType* _CNXMLTest_type;

+ (instancetype)test {
    return [[CNXMLTest alloc] init];
}

- (instancetype)init {
    self = [super init];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [CNXMLTest class]) _CNXMLTest_type = [CNClassType classTypeWithCls:[CNXMLTest class]];
}

- (void)testChild {
    CNXMLElement* root = [CNXML strData:@"<root><c1/><c2></c2></root>"];
    assertEquals(@"root", [root name]);
    assertEquals(@2, numi(((NSInteger)([[root children] count]))));
    assertEquals([root childWithName:@"c1"], [root firstChild]);
}

- (void)testAttributes {
    CNXMLElement* root = [CNXML strData:@"<root a1=\"v1\" a2=\"v2\"></root>"];
    assertEquals(@2, numi(((NSInteger)([[root attributes] count]))));
    assertEquals(@"v1", ((NSString*)(nonnil([root applyName:@"a1"]))));
    assertEquals(@"v2", ((NSString*)(nonnil([root applyName:@"a2"]))));
}

- (CNClassType*)type {
    return [CNXMLTest type];
}

+ (CNClassType*)type {
    return _CNXMLTest_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendString:@">"];
    return description;
}

@end


