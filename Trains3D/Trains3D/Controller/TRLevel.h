#import "objd.h"
#import "EGTypes.h"
#import "EGMapIso.h"
#import "TRCity.h"
#import "TRTypes.h"
#import "TRRailroad.h"

@class TRLevel;

@interface TRLevel : NSObject
@property (nonatomic, readonly) EGISize mapSize;
@property (nonatomic, readonly) NSArray* cities;
@property (nonatomic, readonly) TRRailroad* railroad;

+ (id)levelWithMapSize:(EGISize)mapSize;
- (id)initWithMapSize:(EGISize)mapSize;
- (void)createNewCity;
@end


