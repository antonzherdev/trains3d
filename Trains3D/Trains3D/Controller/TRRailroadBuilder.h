#import "objd.h"
#import "ATActor.h"
#import "GEVec.h"
@class TRRail;
@class TRLevel;
@class TRRailroad;
@class ATVar;
@class ATObserver;
@class TRRailroadState;
@class TRRailConnector;
@class EGMapSso;
@class TRRailroadConnectorContent;
@class TRForest;
@class TRRailForm;
@class TRScore;
@class ATReact;

@class TRRailBuilding;
@class TRRailroadBuilderState;
@class TRRailroadBuilder;
@class TRRailBuildingType;
@class TRRailroadBuilderMode;

@interface TRRailBuilding : NSObject {
@private
    TRRailBuildingType* _tp;
    TRRail* _rail;
    float _progress;
}
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


@interface TRRailroadBuilderState : NSObject {
@private
    id _notFixedRailBuilding;
    BOOL _isLocked;
    CNImList* _buildingRails;
    BOOL _isBuilding;
}
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


@interface TRRailroadBuilder : ATActor {
@private
    __weak TRLevel* _level;
    id __startedPoint;
    __weak TRRailroad* __railroad;
    TRRailroadBuilderState* __state;
    ATVar* __mode;
    ATObserver* _modeObs;
    BOOL __firstTry;
    id __fixedStart;
}
@property (nonatomic, readonly, weak) TRLevel* level;
@property (nonatomic) id _startedPoint;
@property (nonatomic, readonly, weak) TRRailroad* _railroad;
@property (nonatomic, retain) TRRailroadBuilderState* _state;
@property (nonatomic) BOOL _firstTry;
@property (nonatomic) id _fixedStart;

+ (instancetype)railroadBuilderWithLevel:(TRLevel*)level;
- (instancetype)initWithLevel:(TRLevel*)level;
- (ODClassType*)type;
- (CNFuture*)state;
- (CNFuture*)updateWithDelta:(CGFloat)delta;
- (CNFuture*)undo;
- (ATReact*)mode;
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


