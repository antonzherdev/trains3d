#import "objd.h"
#import "EGMap.h"
#import "TRCity.h"
#import "TRTypes.h"

@interface TRLevel : NSObject
@property (nonatomic, readonly) EGMapSize mapSize;
@property (nonatomic, readonly) NSArray* cities;

+ (id)levelWithMapSize:(EGMapSize)mapSize;
- (id)initWithMapSize:(EGMapSize)mapSize;
- (void)addNextCity;
@end


