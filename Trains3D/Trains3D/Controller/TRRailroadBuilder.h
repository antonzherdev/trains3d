#import "objd.h"
#import "CNActor.h"
#import "GEVec.h"
#import "TRRailPoint.h"
@class TRRail;
@class TRLevel;
@class TRRailroad;
@class CNSignal;
@class CNVar;
@class EGPlatform;
@class CNFuture;
@class TRRailroadState;
@class EGMapSso;
@class TRRailroadConnectorContent;
@class TRForest;
@class CNChain;
@class TRScore;
@class CNSortBuilder;

@class TRRailBuilding;
@class TRRailroadBuilderState;
@class TRRailroadBuilder;
@class TRRailBuildingType;
@class TRRailroadBuilderMode;

typedef enum TRRailBuildingTypeR {
    TRRailBuildingType_Nil = 0,
    TRRailBuildingType_construction = 1,
    TRRailBuildingType_destruction = 2
} TRRailBuildingTypeR;
@interface TRRailBuildingType : CNEnum
+ (NSArray*)values;
+ (TRRailBuildingType*)value:(TRRailBuildingTypeR)r;
@end


typedef enum TRRailroadBuilderModeR {
    TRRailroadBuilderMode_Nil = 0,
    TRRailroadBuilderMode_simple = 1,
    TRRailroadBuilderMode_build = 2,
    TRRailroadBuilderMode_clear = 3
} TRRailroadBuilderModeR;
@interface TRRailroadBuilderMode : CNEnum
+ (NSArray*)values;
+ (TRRailroadBuilderMode*)value:(TRRailroadBuilderModeR)r;
@end


@interface TRRailBuilding : NSObject {
@protected
    TRRailBuildingTypeR _tp;
    TRRail* _rail;
    float _progress;
}
@property (nonatomic, readonly) TRRailBuildingTypeR tp;
@property (nonatomic, readonly) TRRail* rail;
@property (nonatomic, readonly) float progress;

+ (instancetype)railBuildingWithTp:(TRRailBuildingTypeR)tp rail:(TRRail*)rail progress:(float)progress;
- (instancetype)initWithTp:(TRRailBuildingTypeR)tp rail:(TRRail*)rail progress:(float)progress;
- (CNClassType*)type;
- (BOOL)isDestruction;
- (BOOL)isConstruction;
- (NSString*)description;
- (BOOL)isEqual:(id)to;
- (NSUInteger)hash;
+ (CNClassType*)type;
@end


@interface TRRailroadBuilderState : NSObject {
@protected
    TRRailBuilding* _notFixedRailBuilding;
    CNImList* _buildingRails;
    BOOL _isBuilding;
}
@property (nonatomic, readonly) TRRailBuilding* notFixedRailBuilding;
@property (nonatomic, readonly) CNImList* buildingRails;
@property (nonatomic, readonly) BOOL isBuilding;

+ (instancetype)railroadBuilderStateWithNotFixedRailBuilding:(TRRailBuilding*)notFixedRailBuilding buildingRails:(CNImList*)buildingRails isBuilding:(BOOL)isBuilding;
- (instancetype)initWithNotFixedRailBuilding:(TRRailBuilding*)notFixedRailBuilding buildingRails:(CNImList*)buildingRails isBuilding:(BOOL)isBuilding;
- (CNClassType*)type;
- (BOOL)isDestruction;
- (BOOL)isConstruction;
- (TRRailroadBuilderState*)lock;
- (TRRail*)railForUndo;
- (TRRailroadBuilderState*)setIsBuilding:(BOOL)isBuilding;
- (NSString*)description;
- (BOOL)isEqual:(id)to;
- (NSUInteger)hash;
+ (CNClassType*)type;
@end


@interface TRRailroadBuilder : CNActor {
@protected
    __weak TRLevel* _level;
    id __startedPoint;
    __weak TRRailroad* __railroad;
    TRRailroadBuilderState* __state;
    CNSignal* _changed;
    CNVar* _mode;
    CNSignal* _buildingWasRefused;
    BOOL __firstTry;
    CNTuple* __fixedStart;
    CGFloat _limitedLen;
}
@property (nonatomic, readonly, weak) TRLevel* level;
@property (nonatomic) id _startedPoint;
@property (nonatomic, readonly, weak) TRRailroad* _railroad;
@property (nonatomic, retain) TRRailroadBuilderState* _state;
@property (nonatomic, readonly) CNSignal* changed;
@property (nonatomic, readonly) CNVar* mode;
@property (nonatomic, readonly) CNSignal* buildingWasRefused;
@property (nonatomic) BOOL _firstTry;
@property (nonatomic) CNTuple* _fixedStart;

+ (instancetype)railroadBuilderWithLevel:(TRLevel*)level;
- (instancetype)initWithLevel:(TRLevel*)level;
- (CNClassType*)type;
- (CNFuture*)state;
- (CNFuture*)restoreState:(TRRailroadBuilderState*)state;
- (CNFuture*)updateWithDelta:(CGFloat)delta;
- (CNFuture*)undo;
- (CNFuture*)modeBuildFlip;
- (CNFuture*)modeClearFlip;
- (CNFuture*)eBeganLocation:(GEVec2)location;
- (CNFuture*)eChangedLocation:(GEVec2)location;
- (CNFuture*)eEnded;
- (CNFuture*)eTapLocation:(GEVec2)location;
- (NSString*)description;
+ (CNClassType*)type;
@end


