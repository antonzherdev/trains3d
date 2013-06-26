#import <Foundation/Foundation.h>
#import "TRCity.h"
#import "EGMap.h"

@interface TRLevel : NSObject
@property (nonatomic, readonly) EGMapSize mapSize;
@property (nonatomic, readonly) NSArray* cities;

+ (id)levelWithMapSize:(EGMapSize)mapSize;
- (id)initWithMapSize:(EGMapSize)mapSize;
@end


