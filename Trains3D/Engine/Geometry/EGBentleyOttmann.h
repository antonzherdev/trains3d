#import "objd.h"
#import "EGTypes.h"
@class EGLine;
@class EGSlopeLine;
@class EGVerticalLine;
@protocol EGFigure;
@class EGLineSegment;
@class EGThickLineSegment;
#import "CNTreeMap.h"
@class CNTreeSet;
@protocol CNIterator;
@protocol CNTraversable;
@protocol CNIterable;
@protocol CNSet;

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
@property (nonatomic, readonly) EGPoint point;
@property (nonatomic, readonly) NSSet* data;

+ (id)intersectionWithPoint:(EGPoint)point data:(NSSet*)data;
- (id)initWithPoint:(EGPoint)point data:(NSSet*)data;
@end


@interface EGBentleyOttmannEvent : NSObject
+ (id)bentleyOttmannEvent;
- (id)init;
- (EGPoint)point;
- (BOOL)isIntersection;
- (BOOL)isStart;
- (BOOL)isEnd;
- (double)yForX:(double)x;
- (double)slope;
@end


@interface EGBentleyOttmannPointEvent : EGBentleyOttmannEvent
@property (nonatomic, readonly) BOOL isStart;
@property (nonatomic, readonly) id data;
@property (nonatomic, readonly) EGLineSegment* segment;
@property (nonatomic, readonly) EGPoint point;

+ (id)bentleyOttmannPointEventWithIsStart:(BOOL)isStart data:(id)data segment:(EGLineSegment*)segment point:(EGPoint)point;
- (id)initWithIsStart:(BOOL)isStart data:(id)data segment:(EGLineSegment*)segment point:(EGPoint)point;
- (BOOL)isIntersection;
- (double)yForX:(double)x;
- (double)slope;
@end


@interface EGBentleyOttmannIntersectionEvent : EGBentleyOttmannEvent
@property (nonatomic, readonly) EGPoint point;

+ (id)bentleyOttmannIntersectionEventWithPoint:(EGPoint)point;
- (id)initWithPoint:(EGPoint)point;
- (BOOL)isIntersection;
- (BOOL)isStart;
- (double)yForX:(double)x;
- (double)slope;
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


