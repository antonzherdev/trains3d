#import <Foundation/Foundation.h>
#import "cnTypes.h"


@interface CNGroupByLink : NSObject <CNChainLink>
- (id)initWithBy:(cnF)by fold:(cnF2)fold withStart:(cnF0)start factor:(double)factor mutableMode:(BOOL)mutableMode mapAfter:(cnF)mapAfter;

+ (id)linkWithBy:(cnF)by fold:(cnF2)fold withStart:(cnF0)start factor:(double)factor mutableMode:(BOOL)mutableMode mapAfter:(cnF)mapAfter;
@end