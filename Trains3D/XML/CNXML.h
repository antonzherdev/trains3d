#import "objdcore.h"
#import "TBXML.h"

@class CNClassType;
@protocol CNIterable;

@class CNXML;
@class CNXMLElement;
@class CNXMLAttribute;
@class TBXML;

@interface CNXML : NSObject
- (CNClassType*)type;
+ (CNXMLElement*)fileName:(NSString*)name;
+ (CNXMLElement*)strData:(NSString*)data;
+ (CNClassType*)type;
@end


@interface CNXMLElement : NSObject
@property(nonatomic) TBXMLElement *element;

- (CNClassType*)type;

- (id)initWithXML:(TBXML *)tbxml element:(TBXMLElement *)element;

- (NSString*)name;
- (NSString*)text;
- (id)parent;
- (id<CNIterable>)children;
- (id)firstChild;
- (id)previousSibling;
- (id)nextSibling;
- (id)childWithName:(NSString*)name;
- (id)nextSiblingWithName:(NSString*)name;

- (id)firstAttribute;
- (id<CNIterable>)attributes;
- (id)applyName:(NSString*)name;

+ (CNClassType*)type;

+ (CNXMLElement *)elementWithXML:(TBXML *)xml element:(TBXMLElement *)element;
@end


@interface CNXMLAttribute : NSObject
@property(nonatomic) TBXMLAttribute *attribute;

- (id)initWithXML:(TBXML *)xml attribute:(TBXMLAttribute *)attribute;

+ (id)attributeWithXML:(TBXML *)xml attribute:(TBXMLAttribute *)attribute;

- (CNClassType*)type;
- (NSString*)name;
- (NSString*)value;
- (id)next;
+ (CNClassType*)type;
@end


