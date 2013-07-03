#import "objd.h"
#import "EGMap.h"
#import "EGTypes.h"

@interface TRRail : NSObject
@property (nonatomic, readonly) EGMapPoint tile;
@property (nonatomic, readonly) CGPoint start;
@property (nonatomic, readonly) CGPoint end;

+ (id)railWithTile:(EGMapPoint)tile start:(CGPoint)start end:(CGPoint)end;
- (id)initWithTile:(EGMapPoint)tile start:(CGPoint)start end:(CGPoint)end;
@end


@interface TRRailroad : NSObject
@property (nonatomic, readonly) EGMapSize mapSize;
@property (nonatomic, readonly) NSArray* rails;

+ (id)railroadWithMapSize:(EGMapSize)mapSize;
- (id)initWithMapSize:(EGMapSize)mapSize;
- (BOOL)canAddRail:(TRRail*)rail;
- (BOOL)tryAddRail:(TRRail*)rail;
@end


