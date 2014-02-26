#import "objd.h"
#import "TRRailPoint.h"
#import "ATTypedActor.h"
#import "EGScene.h"
#import "GEVec.h"
@class TRObstacle;
@class TRObstacleType;
@class TRLevel;
@class EGMapSso;
@class TRRailroad;
@class TRCityColor;
@class TRCar;
@class TRCarPosition;
@class TRSwitch;
@class TRRail;
@class TRCity;
@class EGRigidBody;
@class TRSmoke;
@class TRCarType;

@class TRTrainActor;
@class TRTrain;
@class TRTrainGenerator;
@class TRTrainSoundData;
@class TRTrainType;

@interface TRTrainType : ODEnum
@property (nonatomic, readonly) BOOL(^obstacleProcessor)(TRLevel*, TRTrain*, TRObstacle*);

+ (TRTrainType*)simple;
+ (TRTrainType*)crazy;
+ (TRTrainType*)fast;
+ (TRTrainType*)repairer;
+ (NSArray*)values;
@end


@interface TRTrainActor : ATTypedActor<EGUpdatable>
@property (nonatomic, readonly) TRTrain* _train;

+ (instancetype)trainActorWith_train:(TRTrain*)_train;
- (instancetype)initWith_train:(TRTrain*)_train;
- (ODClassType*)type;
- (TRTrainType*)trainType;
- (TRCityColor*)color;
- (NSUInteger)speed;
- (NSUInteger)carsCount;
- (CGFloat)time;
- (id<CNSeq>)collisionBodies;
- (id<CNSeq>)kinematicBodies;
- (CNFuture*)dynamicBodies;
- (void)updateWithDelta:(CGFloat)delta;
- (void)setHead:(TRRailPoint)head;
- (CNFuture*)lockedTiles;
- (CNFuture*)isLockedASwitch:(TRSwitch*)aSwitch;
- (CNFuture*)isLockedRail:(TRRail*)rail;
- (void)startFromCity:(TRCity*)city;
- (void)die;
- (CNFuture*)isDying;
- (CNFuture*)carPositions;
- (CNFuture*)carDynamicMatrix;
- (CNFuture*)writeCollisionMatrix;
- (CNFuture*)writeKinematicMatrix;
- (CNFuture*)smokeDataCreator:(id(^)(TRSmoke*))creator;
+ (ODClassType*)type;
@end


@interface TRTrain : NSObject<EGUpdatable>
@property (nonatomic, readonly, weak) TRLevel* level;
@property (nonatomic, readonly) TRTrainType* trainType;
@property (nonatomic, readonly) TRCityColor* color;
@property (nonatomic, readonly) id<CNSeq>(^__cars)(TRTrain*);
@property (nonatomic, readonly) NSUInteger speed;
@property (nonatomic) id viewData;
@property (nonatomic, readonly) TRTrainSoundData* soundData;
@property (nonatomic, readonly) id<CNSeq> cars;
@property (nonatomic, readonly) TRSmoke* smoke;
@property (nonatomic, readonly) CGFloat speedFloat;
@property (nonatomic) BOOL isDying;

+ (instancetype)trainWithLevel:(TRLevel*)level trainType:(TRTrainType*)trainType color:(TRCityColor*)color __cars:(id<CNSeq>(^)(TRTrain*))__cars speed:(NSUInteger)speed;
- (instancetype)initWithLevel:(TRLevel*)level trainType:(TRTrainType*)trainType color:(TRCityColor*)color __cars:(id<CNSeq>(^)(TRTrain*))__cars speed:(NSUInteger)speed;
- (ODClassType*)type;
- (BOOL)isBack;
- (void)startFromCity:(TRCity*)city;
- (NSString*)description;
- (TRRailPoint)head;
- (void)setHead:(TRRailPoint)head;
- (CGFloat)time;
- (void)updateWithDelta:(CGFloat)delta;
- (BOOL)isLockedTheSwitch:(TRSwitch*)theSwitch;
- (BOOL)isLockedRail:(TRRail*)rail;
+ (CNNotificationHandle*)chooNotification;
+ (ODClassType*)type;
@end


@interface TRTrainGenerator : NSObject
@property (nonatomic, readonly) TRTrainType* trainType;
@property (nonatomic, readonly) id<CNSeq> carsCount;
@property (nonatomic, readonly) id<CNSeq> speed;
@property (nonatomic, readonly) id<CNSeq> carTypes;

+ (instancetype)trainGeneratorWithTrainType:(TRTrainType*)trainType carsCount:(id<CNSeq>)carsCount speed:(id<CNSeq>)speed carTypes:(id<CNSeq>)carTypes;
- (instancetype)initWithTrainType:(TRTrainType*)trainType carsCount:(id<CNSeq>)carsCount speed:(id<CNSeq>)speed carTypes:(id<CNSeq>)carTypes;
- (ODClassType*)type;
- (id<CNSeq>)generateCarsForTrain:(TRTrain*)train;
- (NSUInteger)generateSpeed;
+ (ODClassType*)type;
@end


@interface TRTrainSoundData : NSObject
@property (nonatomic) NSInteger chooCounter;
@property (nonatomic) CGFloat toNextChoo;
@property (nonatomic) GEVec2i lastTile;
@property (nonatomic) CGFloat lastX;

+ (instancetype)trainSoundData;
- (instancetype)init;
- (ODClassType*)type;
- (void)nextChoo;
- (void)nextHead:(TRRailPoint)head;
+ (ODClassType*)type;
@end


