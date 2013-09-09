#import "objd.h"
#import "EGVec.h"
@class EGLineSegment;
@class EGLine;
@class EGSlopeLine;

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
- (ODClassType*)type;
+ (id<CNSet>)intersectionsForSegments:(id<CNSeq>)segments;
+ (ODClassType*)type;
@end


@interface EGIntersection : NSObject
@property (nonatomic, readonly) CNPair* items;
@property (nonatomic, readonly) EGVec2 point;

+ (id)intersectionWithItems:(CNPair*)items point:(EGVec2)point;
- (id)initWithItems:(CNPair*)items point:(EGVec2)point;
- (ODClassType*)type;
+ (ODClassType*)type;
@end


@interface EGBentleyOttmannEvent : NSObject
+ (id)bentleyOttmannEvent;
- (id)init;
- (ODClassType*)type;
- (EGVec2)point;
- (BOOL)isIntersection;
- (BOOL)isStart;
- (BOOL)isEnd;
+ (ODClassType*)type;
@end


@interface EGBentleyOttmannPointEvent : EGBentleyOttmannEvent
@property (nonatomic, readonly) BOOL isStart;
@property (nonatomic, readonly) id data;
@property (nonatomic, readonly) EGLineSegment* segment;
@property (nonatomic, readonly) EGVec2 point;

+ (id)bentleyOttmannPointEventWithIsStart:(BOOL)isStart data:(id)data segment:(EGLineSegment*)segment point:(EGVec2)point;
- (id)initWithIsStart:(BOOL)isStart data:(id)data segment:(EGLineSegment*)segment point:(EGVec2)point;
- (ODClassType*)type;
- (CGFloat)yForX:(CGFloat)x;
- (CGFloat)slope;
- (BOOL)isVertical;
- (BOOL)isEnd;
+ (ODClassType*)type;
@end


@interface EGBentleyOttmannIntersectionEvent : EGBentleyOttmannEvent
@property (nonatomic, readonly) EGVec2 point;

+ (id)bentleyOttmannIntersectionEventWithPoint:(EGVec2)point;
- (id)initWithPoint:(EGVec2)point;
- (ODClassType*)type;
- (BOOL)isIntersection;
+ (ODClassType*)type;
@end


@interface EGBentleyOttmannEventQueue : NSObject
@property (nonatomic, readonly) CNMutableTreeMap* events;

+ (id)bentleyOttmannEventQueue;
- (id)init;
- (ODClassType*)type;
- (BOOL)isEmpty;
+ (EGBentleyOttmannEventQueue*)newWithSegments:(id<CNSeq>)segments sweepLine:(EGSweepLine*)sweepLine;
- (void)offerPoint:(EGVec2)point event:(EGBentleyOttmannEvent*)event;
- (id<CNSeq>)poll;
+ (ODClassType*)type;
@end


@interface EGPointClass : NSObject
@property (nonatomic, readonly) EGVec2 point;

+ (id)pointClassWithPoint:(EGVec2)point;
- (id)initWithPoint:(EGVec2)point;
- (ODClassType*)type;
+ (ODClassType*)type;
@end


@interface EGSweepLine : NSObject
@property (nonatomic, retain) CNMutableTreeSet* events;
@property (nonatomic, readonly) NSMutableDictionary* intersections;
@property (nonatomic, retain) EGBentleyOttmannEventQueue* queue;

+ (id)sweepLine;
- (id)init;
- (ODClassType*)type;
- (void)handleEvents:(id<CNSeq>)events;
+ (ODClassType*)type;
@end


