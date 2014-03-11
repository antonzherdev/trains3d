#import "objd.h"
#import "ATTypedActor.h"
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

@class TRRailBuilding;
@class TRRailroadBuilderState;
@class TRRailroadBuilder;
@class TRRailBuildingType;
@class TRRailroadBuilderMode;

@interface TRRailBuilding : NSObject
@property (nonatomic, readonly) TRRailBuildingType* tp;
@property (nonatomic, readonly) TRRail* rail;
@property (nonatomic, readonly) float progress;

+ (instancetype)railBuildingWithTp:(TRRailBuildingType*)tp rail:(TRRail*)rail progress:(float)progress;
- (instancetype)initWithTp:(TRRailBuildingType*)tp rail:(TRRail*)rail progress:(float)progress;
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


@interface TRRailroadBuilderMode : ODEnum
+ (TRRailroadBuilderMode*)simple;
+ (TRRailroadBuilderMode*)build;
+ (TRRailroadBuilderMode*)clear;
+ (NSArray*)values;
@end


@interface TRRailroadBuilderState : NSObject
@property (nonatomic, readonly) id notFixedRailBuilding;
@property (nonatomic, readonly) BOOL isLocked;
@property (nonatomic, readonly) CNImList* buildingRails;
@property (nonatomic, readonly) BOOL isBuilding;

+ (instancetype)railroadBuilderStateWithNotFixedRailBuilding:(id)notFixedRailBuilding isLocked:(BOOL)isLocked buildingRails:(CNImList*)buildingRails isBuilding:(BOOL)isBuilding;
- (instancetype)initWithNotFixedRailBuilding:(id)notFixedRailBuilding isLocked:(BOOL)isLocked buildingRails:(CNImList*)buildingRails isBuilding:(BOOL)isBuilding;
- (ODClassType*)type;
- (BOOL)isDestruction;
- (BOOL)isConstruction;
- (TRRailroadBuilderState*)lock;
- (id)railForUndo;
- (TRRailroadBuilderState*)setIsBuilding:(BOOL)isBuilding;
+ (ODClassType*)type;
@end


@interface TRRailroadBuilder : ATTypedActor
@property (nonatomic, readonly, weak) TRLevel* level;
@property (nonatomic) id _startedPoint;
@property (nonatomic, readonly, weak) TRRailroad* _railroad;
@property (nonatomic, retain) TRRailroadBuilderState* _state;
@property (nonatomic, retain) TRRailroadBuilderMode* _mode;
@property (nonatomic) BOOL _firstTry;
@property (nonatomic) id _fixedStart;

+ (instancetype)railroadBuilderWithLevel:(TRLevel*)level;
- (instancetype)initWithLevel:(TRLevel*)level;
- (ODClassType*)type;
- (CNFuture*)state;
- (BOOL)isLocked;
- (CNFuture*)updateWithDelta:(CGFloat)delta;
- (CNFuture*)undo;
- (CNFuture*)mode;
- (CNFuture*)modeBuildFlip;
- (CNFuture*)modeClearFlip;
- (CNFuture*)setMode:(TRRailroadBuilderMode*)mode;
- (CNFuture*)beganLocation:(GEVec2)location;
- (CNFuture*)changedLocation:(GEVec2)location;
- (CNFuture*)ended;
+ (CNNotificationHandle*)changedNotification;
+ (CNNotificationHandle*)modeNotification;
+ (CNNotificationHandle*)refuseBuildNotification;
+ (ODClassType*)type;
@end


