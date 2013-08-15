#import "objd.h"
#import "EGTypes.h"
@class EGLine;
@class EGSlopeLine;
@class EGVerticalLine;
@protocol EGFigure;
@class EGLineSegment;
@class EGPolygon;
@class EGThickLineSegment;
#import "CNTreeMap.h"
@class CNTreeSet;
@protocol CNIterator;
@protocol CNBuilder;
@protocol CNTraversable;
@protocol CNIterable;
@class CNPair;
@class CNPairIterator;
#import "CNSet.h"

@class EGBentleyOttmann;
@class EGIntersection;
@class EGBentleyOttmannEvent;
@class EGBentleyOttmannPointEvent;
@class EGBentleyOttmannIntersectionEvent;
@class EGBentleyOttmannEventQueue;
@class EGPointClass;
@class EGSweepLine;

@interface EGBentleyOttmann : NSObject
+ (id)bentleyOttmann;
- (id)init;
+ (NSSet*)intersectionsForSegments:(NSArray*)segments;
@end


@interface EGIntersection : NSObject
@property (nonatomic, readonly) CNPair* items;
@property (nonatomic, readonly) EGPoint point;

+ (id)intersectionWithItems:(CNPair*)items point:(EGPoint)point;
- (id)initWithItems:(CNPair*)items point:(EGPoint)point;
@end


@interface EGBentleyOttmannEvent : NSObject
+ (id)bentleyOttmannEvent;
- (id)init;
- (EGPoint)point;
- (BOOL)isIntersection;
- (BOOL)isStart;
- (BOOL)isEnd;
@end


@interface EGBentleyOttmannPointEvent : EGBentleyOttmannEvent
@property (nonatomic, readonly) BOOL isStart;
@property (nonatomic, readonly) id data;
@property (nonatomic, readonly) EGLineSegment* segment;
@property (nonatomic, readonly) EGPoint point;

+ (id)bentleyOttmannPointEventWithIsStart:(BOOL)isStart data:(id)data segment:(EGLineSegment*)segment point:(EGPoint)point;
- (id)initWithIsStart:(BOOL)isStart data:(id)data segment:(EGLineSegment*)segment point:(EGPoint)point;
- (double)yForX:(double)x;
- (double)slope;
- (BOOL)isVertical;
- (BOOL)isEnd;
@end


@interface EGBentleyOttmannIntersectionEvent : EGBentleyOttmannEvent
@property (nonatomic, readonly) EGPoint point;

+ (id)bentleyOttmannIntersectionEventWithPoint:(EGPoint)point;
- (id)initWithPoint:(EGPoint)point;
- (BOOL)isIntersection;
@end


@interface EGBentleyOttmannEventQueue : NSObject
@property (nonatomic, readonly) CNTreeMap* events;

+ (id)bentleyOttmannEventQueue;
- (id)init;
- (BOOL)isEmpty;
+ (EGBentleyOttmannEventQueue*)newWithSegments:(NSArray*)segments sweepLine:(EGSweepLine*)sweepLine;
- (void)offerPoint:(EGPoint)point event:(EGBentleyOttmannEvent*)event;
- (NSArray*)poll;
@end


@interface EGPointClass : NSObject
@property (nonatomic, readonly) EGPoint point;

+ (id)pointClassWithPoint:(EGPoint)point;
- (id)initWithPoint:(EGPoint)point;
@end


@interface EGSweepLine : NSObject
@property (nonatomic, retain) CNTreeSet* events;
@property (nonatomic, readonly) NSMutableDictionary* intersections;
@property (nonatomic, retain) EGBentleyOttmannEventQueue* queue;

+ (id)sweepLine;
- (id)init;
- (void)handleEvents:(NSArray*)events;
@end


