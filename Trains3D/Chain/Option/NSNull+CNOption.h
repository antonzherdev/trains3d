#import <Foundation/Foundation.h>
#import "CNTypes.h"

@interface NSNull (CNOption)
- (void)forEach:(cnP)f;
- (id)getOrElse:(cnF0)f;
- (id)getOr:(id)value;
- (BOOL) isEmpty;
- (BOOL) isDefined;
- (id) map:(cnF)f;
- (id) filter:(cnPredicate)f;
- (id) flatMap:(cnF)f;
- (id) get;
- (id)asKindOfClass:(Class)pClass;
@end