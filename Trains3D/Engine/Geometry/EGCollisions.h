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
@protocol CNSet;
@class NSSetBuilder;
@class NSSet;
@class NSMutableSet;

@class EGCollisions;
@class EGCollision;

@interface EGCollisions : NSObject
+ (id)collisions;
- (id)init;
+ (NSSet*)collisionsForFigures:(NSArray*)figures;
@end


@interface EGCollision : NSObject
@property (nonatomic, readonly) CNPair* items;
@property (nonatomic, readonly) NSSet* points;

+ (id)collisionWithItems:(CNPair*)items points:(NSSet*)points;
- (id)initWithItems:(CNPair*)items points:(NSSet*)points;
@end


