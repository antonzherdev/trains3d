#import "objd.h"
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
#import "EGTypes.h"
@class CNPair;
@class CNPairIterator;
#import "CNSet.h"

@class EGCollisions;
@class EGCollision;

@interface EGCollisions : NSObject
+ (id)collisions;
- (id)init;
+ (id<CNSet>)collisionsForFigures:(id<CNList>)figures;
@end


@interface EGCollision : NSObject
@property (nonatomic, readonly) CNPair* items;
@property (nonatomic, readonly) id<CNSet> points;

+ (id)collisionWithItems:(CNPair*)items points:(id<CNSet>)points;
- (id)initWithItems:(CNPair*)items points:(id<CNSet>)points;
@end


