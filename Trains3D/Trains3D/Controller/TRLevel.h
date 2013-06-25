#import <Foundation/Foundation.h>
#import "TRCity.h"

@interface TRLevel : NSObject
@property (nonatomic, readonly) NSArray* cities;

+ (id)level;
- (id)init;
@end


