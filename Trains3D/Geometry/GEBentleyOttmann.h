#import "objd.h"
#import "GEVec.h"
@class GELineSegment;
@class GELine;
@class GESlopeLine;

@class GEBentleyOttmann;
@class GEIntersection;
@class GEBentleyOttmannEvent;
@class GEBentleyOttmannPointEvent;
@class GEBentleyOttmannIntersectionEvent;
@class GEBentleyOttmannEventQueue;
@class GEPointClass;
@class GESweepLine;

@interface GEBentleyOttmann : NSObject
+ (instancetype)bentleyOttmann;
- (instancetype)init;
- (ODClassType*)type;
+ (id<CNSet>)intersectionsForSegments:(id<CNImSeq>)segments;
+ (ODClassType*)type;
@end


@interface GEIntersection : NSObject
@property (nonatomic, readonly) CNPair* items;
@property (nonatomic, readonly) GEVec2 point;

+ (instancetype)intersectionWithItems:(CNPair*)items point:(GEVec2)point;
- (instancetype)initWithItems:(CNPair*)items point:(GEVec2)point;
- (ODClassType*)type;
+ (ODClassType*)type;
@end


@interface GEBentleyOttmannEvent : NSObject
+ (instancetype)bentleyOttmannEvent;
- (instancetype)init;
- (ODClassType*)type;
- (GEVec2)point;
- (BOOL)isIntersection;
- (BOOL)isStart;
- (BOOL)isEnd;
+ (ODClassType*)type;
@end


@interface GEBentleyOttmannPointEvent : GEBentleyOttmannEvent
@property (nonatomic, readonly) BOOL isStart;
@property (nonatomic, readonly) id data;
@property (nonatomic, readonly) GELineSegment* segment;
@property (nonatomic, readonly) GEVec2 point;

+ (instancetype)bentleyOttmannPointEventWithIsStart:(BOOL)isStart data:(id)data segment:(GELineSegment*)segment point:(GEVec2)point;
- (instancetype)initWithIsStart:(BOOL)isStart data:(id)data segment:(GELineSegment*)segment point:(GEVec2)point;
- (ODClassType*)type;
- (CGFloat)yForX:(CGFloat)x;
- (CGFloat)slope;
- (BOOL)isVertical;
- (BOOL)isEnd;
+ (ODClassType*)type;
@end


@interface GEBentleyOttmannIntersectionEvent : GEBentleyOttmannEvent
@property (nonatomic, readonly) GEVec2 point;

+ (instancetype)bentleyOttmannIntersectionEventWithPoint:(GEVec2)point;
- (instancetype)initWithPoint:(GEVec2)point;
- (ODClassType*)type;
- (BOOL)isIntersection;
+ (ODClassType*)type;
@end


@interface GEBentleyOttmannEventQueue : NSObject
@property (nonatomic, readonly) CNMTreeMap* events;

+ (instancetype)bentleyOttmannEventQueue;
- (instancetype)init;
- (ODClassType*)type;
- (BOOL)isEmpty;
+ (GEBentleyOttmannEventQueue*)newWithSegments:(id<CNImSeq>)segments sweepLine:(GESweepLine*)sweepLine;
- (void)offerPoint:(GEVec2)point event:(GEBentleyOttmannEvent*)event;
- (id<CNSeq>)poll;
+ (ODClassType*)type;
@end


@interface GEPointClass : NSObject
@property (nonatomic, readonly) GEVec2 point;

+ (instancetype)pointClassWithPoint:(GEVec2)point;
- (instancetype)initWithPoint:(GEVec2)point;
- (ODClassType*)type;
+ (ODClassType*)type;
@end


@interface GESweepLine : NSObject
@property (nonatomic, retain) CNMTreeSet* events;
@property (nonatomic, readonly) NSMutableDictionary* intersections;
@property (nonatomic, retain) GEBentleyOttmannEventQueue* queue;

+ (instancetype)sweepLine;
- (instancetype)init;
- (ODClassType*)type;
- (void)handleEvents:(id<CNSeq>)events;
+ (ODClassType*)type;
@end


