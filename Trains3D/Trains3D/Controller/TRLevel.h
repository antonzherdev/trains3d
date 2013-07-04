#import "objd.h"
#import "EGTypes.h"
#import "EGMapIso.h"
#import "TRCity.h"
#import "TRTypes.h"
#import "TRRailroad.h"

@class TRLevel;

@interface TRLevel : NSObject
@property (nonatomic, readonly) EGMapSize mapSize;
@property (nonatomic, readonly) NSArray* cities;
@property (nonatomic, readonly) TRRailroad* railroad;

+ (id)levelWithMapSize:(EGMapSize)mapSize;
- (id)initWithMapSize:(EGMapSize)mapSize;
- (void)createNewCity;
@end


