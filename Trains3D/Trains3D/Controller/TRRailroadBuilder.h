#import "objd.h"
#import "EGScene.h"
#import "GEVec.h"
@class TRRail;
@class TRLevel;
@class TRRailroad;
@class TRRailConnector;
@class EGMapSso;
@class TRRailroadState;
@class TRRailroadConnectorContent;
@class TRForest;
@class TRRailForm;
@class TRScore;
@class TRRailroadBuilderProcessor;

@class TRRailBuilding;
@class TRRailroadBuilder;
@class TRRailBuildingType;

@interface TRRailBuilding : NSObject
@property (nonatomic, readonly) TRRailBuildingType* tp;
@property (nonatomic, readonly) TRRail* rail;
@property (nonatomic) CGFloat progress;

+ (instancetype)railBuildingWithTp:(TRRailBuildingType*)tp rail:(TRRail*)rail;
- (instancetype)initWithTp:(TRRailBuildingType*)tp rail:(TRRail*)rail;
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

+ (instancetype)railroadBuilderWithLevel:(TRLevel*)level;
- (instancetype)initWithLevel:(TRLevel*)level;
- (ODClassType*)type;
- (id)notFixedRailBuilding;
- (BOOL)isLocked;
- (id<CNSeq>)buildingRails;
- (id)railForUndo;
- (BOOL)isDestruction;
- (BOOL)isConstruction;
- (BOOL)tryBuildRail:(TRRail*)rail;
- (BOOL)checkCityTile:(GEVec2i)tile connector:(TRRailConnector*)connector;
- (void)clear;
- (void)fix;
- (BOOL)canAddRail:(TRRail*)rail;
- (void)updateWithDelta:(CGFloat)delta;
- (void)undo;
- (BOOL)buildMode;
- (void)setBuildMode:(BOOL)buildMode;
- (BOOL)clearMode;
- (void)setClearMode:(BOOL)clearMode;
- (void)beganLocation:(GEVec2)location;
- (void)changedLocation:(GEVec2)location;
- (void)ended;
+ (CNNotificationHandle*)changedNotification;
+ (CNNotificationHandle*)buildModeNotification;
+ (CNNotificationHandle*)clearModeNotification;
+ (CNNotificationHandle*)refuseBuildNotification;
+ (ODClassType*)type;
@end


