#import "objd.h"
#import "EGScene.h"
#import "GEVec.h"
@class TRRail;
@class TRLevel;
@class TRRailroad;
@class TRRailConnector;
@class EGMapSso;
@class TRRailroadConnectorContent;
@class TRForest;
@class TRRailForm;
@class TRScore;

@class TRRailBuilding;
@class TRRailroadBuilder;
@class TRRailBuildingType;

@interface TRRailBuilding : NSObject
@property (nonatomic, readonly) TRRailBuildingType* tp;
@property (nonatomic, readonly) TRRail* rail;
@property (nonatomic) CGFloat progress;

+ (id)railBuildingWithTp:(TRRailBuildingType*)tp rail:(TRRail*)rail;
- (id)initWithTp:(TRRailBuildingType*)tp rail:(TRRail*)rail;
- (ODClassType*)type;
- (BOOL)isDestruction;
- (BOOL)isConstruction;
+ (ODClassType*)type;
@end


@interface TRRailBuildingType : ODEnum
+ (TRRailBuildingType*)construction;
+ (TRRailBuildingType*)destruction;
+ (NSArray*)values;
@end


@interface TRRailroadBuilder : NSObject<EGUpdatable>
@property (nonatomic, readonly, weak) TRLevel* level;
@property (nonatomic, readonly, weak) TRRailroad* railroad;
@property (nonatomic) BOOL building;

+ (id)railroadBuilderWithLevel:(TRLevel*)level;
- (id)initWithLevel:(TRLevel*)level;
- (ODClassType*)type;
- (id)notFixedRailBuilding;
- (BOOL)isLocked;
- (id<CNSeq>)buildingRails;
- (id)railForUndo;
- (BOOL)isDestruction;
- (BOOL)isConstruction;
- (BOOL)tryBuildRail:(TRRail*)rail canRemove:(BOOL)canRemove;
- (BOOL)checkCityTile:(GEVec2i)tile connector:(TRRailConnector*)connector;
- (void)clear;
- (void)fix;
- (BOOL)canAddRail:(TRRail*)rail;
- (void)updateWithDelta:(CGFloat)delta;
- (void)undo;
- (BOOL)buildMode;
- (void)setBuildMode:(BOOL)buildMode;
+ (CNNotificationHandle*)changedNotification;
+ (CNNotificationHandle*)buildModeNotification;
+ (ODClassType*)type;
@end


