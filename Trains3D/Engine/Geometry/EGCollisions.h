#import "objd.h"
#import "EGTypes.h"
@protocol EGFigure;
@class EGBentleyOttmann;
@class EGIntersection;

@class EGCollisions;
@class EGCollision;

@interface EGCollisions : NSObject
+ (id)collisions;
- (id)init;
- (ODClassType*)type;
+ (id<CNSet>)collisionsForFigures:(id<CNSeq>)figures;
+ (ODClassType*)type;
@end


@interface EGCollision : NSObject
@property (nonatomic, readonly) CNPair* items;
@property (nonatomic, readonly) id<CNSet> points;

+ (id)collisionWithItems:(CNPair*)items points:(id<CNSet>)points;
- (id)initWithItems:(CNPair*)items points:(id<CNSet>)points;
- (ODClassType*)type;
+ (ODClassType*)type;
@end


