#import "objd.h"
@class CNPair;
@class CNPairIterator;
@protocol CNSet;
@protocol CNMutableSet;
@class CNHashSetBuilder;
@class NSSet;
@class NSMutableSet;
@class EGLine;
@class EGSlopeLine;
@class EGVerticalLine;
@protocol EGFigure;
@class EGLineSegment;
@class EGPolygon;
@class EGThickLineSegment;
@class EGBentleyOttmann;
@class EGIntersection;
@class EGBentleyOttmannEvent;
@class EGBentleyOttmannPointEvent;
@class EGBentleyOttmannIntersectionEvent;
@class EGBentleyOttmannEventQueue;
@class EGPointClass;
@class EGSweepLine;
#import "EGVec.h"

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


