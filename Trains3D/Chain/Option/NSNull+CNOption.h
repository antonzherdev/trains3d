#import <Foundation/Foundation.h>
#import "cnTypes.h"

@interface NSNull (CNOption)
- (void)forEach:(cnP)f;
- (id)getOrElse:(cnF0)f;
- (id)getOrValue:(id)value;
- (BOOL) isEmpty;
- (BOOL) isDefined;
- (id) map:(cnF)f;
@end