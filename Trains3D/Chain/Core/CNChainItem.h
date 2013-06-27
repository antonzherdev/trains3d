#import <Foundation/Foundation.h>
#import "cnTypes.h"


@interface CNChainItem : NSObject
@property(nonatomic, retain) CNChainItem* next;

- (id)initWithLink:(id <CNChainLink>)link;

+ (id)itemWithLink:(id <CNChainLink>)link;

- (CNYield *)buildYield:(CNYield *)next;
@end