#import "objdcore.h"
#import "ODObject.h"
#import "TBXML.h"

@class ODClassType;
@protocol CNIterable;

@class CNXML;
@class CNXMLElement;
@class CNXMLAttribute;
@class TBXML;

@interface CNXML : NSObject
- (ODClassType*)type;
+ (CNXMLElement*)fileName:(NSString*)name;
+ (CNXMLElement*)strData:(NSString*)data;
+ (ODClassType*)type;
@end


@interface CNXMLElement : NSObject
@property(nonatomic) TBXMLElement *element;

- (ODClassType*)type;

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

+ (ODClassType*)type;

+ (CNXMLElement *)elementWithXML:(TBXML *)xml element:(TBXMLElement *)element;
@end


@interface CNXMLAttribute : NSObject
@property(nonatomic) TBXMLAttribute *attribute;

- (id)initWithXML:(TBXML *)xml attribute:(TBXMLAttribute *)attribute;

+ (id)attributeWithXML:(TBXML *)xml attribute:(TBXMLAttribute *)attribute;

- (ODClassType*)type;
- (NSString*)name;
- (NSString*)value;
- (id)next;
+ (ODClassType*)type;
@end


