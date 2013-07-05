#import "objd.h"
#import "EGMap.h"
#import "EGTypes.h"

@class TRRail;
@class TRRailroad;
@class TRRailroadBuilder;

@interface TRRail : NSObject
@property (nonatomic, readonly) EGIPoint tile;
@property (nonatomic, readonly) EGIPoint start;
@property (nonatomic, readonly) EGIPoint end;

+ (id)railWithTile:(EGIPoint)tile start:(EGIPoint)start end:(EGIPoint)end;
- (id)initWithTile:(EGIPoint)tile start:(EGIPoint)start end:(EGIPoint)end;
@end


@interface TRRailroad : NSObject
@property (nonatomic, readonly) EGISize mapSize;
@property (nonatomic, readonly) NSArray* rails;
@property (nonatomic, readonly) TRRailroadBuilder* builder;

+ (id)railroadWithMapSize:(EGISize)mapSize;
- (id)initWithMapSize:(EGISize)mapSize;
- (BOOL)canAddRail:(TRRail*)rail;
- (BOOL)tryAddRail:(TRRail*)rail;
@end


@interface TRRailroadBuilder : NSObject
@property (nonatomic, readonly, weak) TRRailroad* railroad;
@property (nonatomic, readonly) TRRail* rail;

+ (id)railroadBuilderWithRailroad:(TRRailroad*)railroad;
- (id)initWithRailroad:(TRRailroad*)railroad;
- (BOOL)tryBuildRail:(TRRail*)rail;
- (void)clear;
- (void)fix;
@end


