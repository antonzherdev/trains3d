#import <Foundation/Foundation.h>
#import "cnTypes.h"

@interface NSNull (CNOption)
- (void) foreach:(cnP)f;
- (id) or:(cnF0)f;
- (id) orValue:(id)value;
- (BOOL) isEmpty;
- (BOOL) isDefined;
- (id) map:(cnF)f;
@end