#import "objd.h"
@class EGCollisionWorld;
@class TRTrain;
@class TRCar;
@class EGCollision2;
@class EGCollisionBody;
@class TRCarPosition;
@class TRRailPoint;

@class TRCollisionWorld;
@class TRCollision;

@interface TRCollisionWorld : NSObject
+ (id)collisionWorld;
- (id)init;
- (ODClassType*)type;
- (void)addTrain:(TRTrain*)train;
- (void)removeTrain:(TRTrain*)train;
- (id<CNSeq>)detect;
+ (ODClassType*)type;
@end


@interface TRCollision : NSObject
@property (nonatomic, readonly) CNPair* cars;
@property (nonatomic, readonly) TRRailPoint* railPoint;

+ (id)collisionWithCars:(CNPair*)cars railPoint:(TRRailPoint*)railPoint;
- (id)initWithCars:(CNPair*)cars railPoint:(TRRailPoint*)railPoint;
- (ODClassType*)type;
+ (ODClassType*)type;
@end


