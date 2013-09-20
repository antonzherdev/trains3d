#import "objd.h"
#import "CNXMLTest.h"

#import "CNXML.h"
#import "CNCollection.h"
#import "ODType.h"
@implementation CNXMLTest
static ODClassType* _CNXMLTest_type;

+ (id)test {
    return [[CNXMLTest alloc] init];
}

- (id)init {
    self = [super init];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _CNXMLTest_type = [ODClassType classTypeWithCls:[CNXMLTest class]];
}

- (void)testChild {
    CNXMLElement* root = [CNXML strData:@"<root><c1/><c2></c2></root>"];
    [self assertEqualsA:@"root" b:[root name]];
    [self assertEqualsA:@2 b:numi(((NSInteger)([[root children] count])))];
    [self assertEqualsA:[root childWithName:@"c1"] b:[root firstChild]];
}

- (void)testAttributes {
    CNXMLElement* root = [CNXML strData:@"<root a1=\"v1\" a2=\"v2\"></root>"];
    [self assertEqualsA:@2 b:numi(((NSInteger)([[root attributes] count])))];
    [self assertEqualsA:@"v1" b:[root valueOfAttributeWithName:@"a1"]];
    [self assertEqualsA:@"v2" b:[root valueOfAttributeWithName:@"a2"]];
}

- (ODClassType*)type {
    return [CNXMLTest type];
}

+ (ODClassType*)type {
    return _CNXMLTest_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    return YES;
}

- (NSUInteger)hash {
    return 0;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendString:@">"];
    return description;
}

@end


