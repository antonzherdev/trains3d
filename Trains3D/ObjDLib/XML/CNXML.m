#import "objd.h"
#import "CNXML.h"

#import "ODType.h"
#import "CNCollection.h"
#import "TBXML.h"

@implementation CNXML
static ODClassType* _CNXML_type;

+ (void)initialize {
    [super initialize];
    _CNXML_type = [ODClassType classTypeWithCls:[CNXML class]];
}

+ (CNXMLElement*)fileName:(NSString*)name {
    NSError *error;
    TBXML *xml = [TBXML newTBXMLWithXMLFile:name error:&error];
    if(error) @throw error;
    return [CNXMLElement elementWithXML:xml element:xml.rootXMLElement];
}

+ (CNXMLElement*)strData:(NSString*)data {
    NSError *error;
    TBXML *xml = [TBXML newTBXMLWithXMLString:data error:&error];
    if(error) @throw error;
    return [CNXMLElement elementWithXML:xml element:xml.rootXMLElement];
}

- (ODClassType*)type {
    return [CNXML type];
}

+ (ODClassType*)type {
    return _CNXML_type;
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


@interface CNXMLElementIterator : NSObject<CNIterator> {
    TBXML *_xml;
    TBXMLElement *_element;
}
- (id)initWithXml:(TBXML *)xml element:(TBXMLElement *)element;

+ (id)iteratorWithXml:(TBXML *)xml element:(TBXMLElement *)element;

@end

@implementation CNXMLElementIterator
- (id)initWithXml:(TBXML *)xml element:(TBXMLElement *)element {
    self = [super init];
    if (self) {
        _xml = xml;
        _element = element;
    }

    return self;
}

+ (id)iteratorWithXml:(TBXML *)xml element:(TBXMLElement *)element {
    return [[self alloc] initWithXml:xml element:element];
}


- (BOOL)hasNext {
    return _element != nil;
}

- (id)next {
    TBXMLElement *r = _element;
    _element = _element->nextSibling;
    return [CNXMLElement elementWithXML:_xml element:r];
}
@end

@interface CNXMLAttributeIterator : NSObject<CNIterator> {
    TBXML *_xml;
    TBXMLAttribute *_attribute;
}
- (id)initWithXml:(TBXML *)xml attribute:(TBXMLAttribute *)attribute;

+ (id)iteratorWithXml:(TBXML *)xml attribute:(TBXMLAttribute *)attribute;
@end

@implementation CNXMLAttributeIterator
- (id)initWithXml:(TBXML *)xml attribute:(TBXMLAttribute *)attribute {
    self = [super init];
    if (self) {
        _xml = xml;
        _attribute = attribute;
    }

    return self;
}

+ (id)iteratorWithXml:(TBXML *)xml attribute:(TBXMLAttribute *)attribute {
    return [[self alloc] initWithXml:xml attribute:attribute];
}


- (BOOL)hasNext {
    return _attribute != nil;
}

- (id)next {
    TBXMLAttribute *r = _attribute;
    _attribute = _attribute->next;
    return [CNXMLAttribute attributeWithXML:_xml attribute:r];
}
@end


@implementation CNXMLElement {
    TBXML *_xml;
    TBXMLElement *_element;
}
static ODClassType* _CNXMLElement_type;
@synthesize element = _element;

+ (CNXMLElement *)elementWithXML:(TBXML *)xml element:(TBXMLElement *)element {
    return [[CNXMLElement alloc] initWithXML : xml element:element];
}

- (id)initWithXML:(TBXML *)xml element:(TBXMLElement *)element {
    self = [super init];
    if(self) {
        _xml = xml;
        _element = element;
    }
    return self;
}

+ (id)element {
    return [[CNXMLElement alloc] init];
}

- (id)init {
    self = [super init];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _CNXMLElement_type = [ODClassType classTypeWithCls:[CNXMLElement class]];
}

- (NSString*)name {
    return [TBXML elementName:_element];
}

- (NSString*)text {
    return [TBXML textForElement:_element];
}

- (id)parent {
   if(_element->parentElement) return [CNOption someValue:[CNXMLElement elementWithXML:_xml element:_element->parentElement]];
   else return [CNOption none];
}

- (id<CNIterable>)children {
    if(!_element->firstChild) return [CNOption none];
    return [CNIterableF iterableFWithIteratorF:^id <CNIterator> {
        return [CNXMLElementIterator iteratorWithXml:_xml element:_element->firstChild];
    }];
}

- (id)firstChild {
    if(_element->firstChild) return [CNOption someValue:[CNXMLElement elementWithXML:_xml element:_element->firstChild]];
    else return [CNOption none];
}


- (id)previousSibling {
    if(_element->previousSibling) return [CNOption someValue:[CNXMLElement elementWithXML:_xml element:_element->previousSibling]];
    else return [CNOption none];
}

- (id)nextSibling {
    if(_element->nextSibling) return [CNOption someValue:[CNXMLElement elementWithXML:_xml element:_element->nextSibling]];
    else return [CNOption none];
}

- (id)childWithName:(NSString*)name {
    TBXMLElement *e = [TBXML childElementNamed:name parentElement:_element];
    if(e)return [CNOption someValue:[CNXMLElement elementWithXML:_xml element:e]];
    else return [CNOption none];
}

- (id)nextSiblingWithName:(NSString*)name {
    TBXMLElement *e = [TBXML nextSiblingNamed:name searchFromElement:_element];
    if(e) return [CNOption someValue:[CNXMLElement elementWithXML:_xml element:e]];
    else return [CNOption none];
}

- (id)firstAttribute {
    if(_element->firstAttribute) return [CNOption someValue:[CNXMLAttribute attributeWithXML:_xml attribute:_element->firstAttribute]];
    else return [CNOption none];
}

- (id<CNIterable>)attributes {
    if(!_element->firstAttribute) return [CNOption none];
    return [CNIterableF iterableFWithIteratorF:^id <CNIterator> {
        return [CNXMLAttributeIterator iteratorWithXml:_xml attribute:_element->firstAttribute];
    }];
}

- (id)applyName:(NSString*)name {
    return [CNOption applyValue:[TBXML valueOfAttributeNamed:name forElement:_element]];
}

- (ODClassType*)type {
    return [CNXMLElement type];
}

+ (ODClassType*)type {
    return _CNXMLElement_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    return ((CNXMLElement *)other).element == _element;
}

- (NSUInteger)hash {
    return [[self name] hash];
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendString:[self name]];
    [description appendString:@">"];
    return description;
}
@end


@implementation CNXMLAttribute {
    TBXML *_xml;
    TBXMLAttribute *_attribute;
}
static ODClassType* _CNXMLAttribute_type;
@synthesize attribute = _attribute;

- (id)initWithXML:(TBXML *)xml attribute:(TBXMLAttribute *)attribute {
    self = [super init];
    if (self) {
        _xml = xml;
        _attribute = attribute;
    }

    return self;
}

+ (id)attributeWithXML:(TBXML *)xml attribute:(TBXMLAttribute *)attribute {
    return [[self alloc] initWithXML:xml attribute:attribute];
}

+ (void)initialize {
    [super initialize];
    _CNXMLAttribute_type = [ODClassType classTypeWithCls:[CNXMLAttribute class]];
}

- (NSString*)name {
    return [TBXML attributeName:_attribute];
}

- (NSString*)value {
    return [TBXML attributeValue:_attribute];
}

- (id)next {
    if(_attribute->next) return [CNOption someValue:[CNXMLAttribute attributeWithXML:_xml attribute:_attribute->next]];
    else return [CNOption none];
}


- (ODClassType*)type {
    return [CNXMLAttribute type];
}

+ (ODClassType*)type {
    return _CNXMLAttribute_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    return ((CNXMLAttribute *)other).attribute == _attribute;
}

- (NSUInteger)hash {
    return [[self name] hash];
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendString:[self name]];
    [description appendString:@">"];
    return description;
}

@end

