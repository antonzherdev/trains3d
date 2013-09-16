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
+ (id)bentleyOttmann;
- (id)init;
- (ODClassType*)type;
+ (id<CNSet>)intersectionsForSegments:(id<CNSeq>)segments;
+ (ODType*)type;
@end


@interface GEIntersection : NSObject
@property (nonatomic, readonly) CNPair* items;
@property (nonatomic, readonly) GEVec2 point;

+ (id)intersectionWithItems:(CNPair*)items point:(GEVec2)point;
- (id)initWithItems:(CNPair*)items point:(GEVec2)point;
- (ODClassType*)type;
+ (ODType*)type;
@end


@interface GEBentleyOttmannEvent : NSObject
+ (id)bentleyOttmannEvent;
- (id)init;
- (ODClassType*)type;
- (GEVec2)point;
- (BOOL)isIntersection;
- (BOOL)isStart;
- (BOOL)isEnd;
+ (ODType*)type;
@end


@interface GEBentleyOttmannPointEvent : GEBentleyOttmannEvent
@property (nonatomic, readonly) BOOL isStart;
@property (nonatomic, readonly) id data;
@property (nonatomic, readonly) GELineSegment* segment;
@property (nonatomic, readonly) GEVec2 point;

+ (id)bentleyOttmannPointEventWithIsStart:(BOOL)isStart data:(id)data segment:(GELineSegment*)segment point:(GEVec2)point;
- (id)initWithIsStart:(BOOL)isStart data:(id)data segment:(GELineSegment*)segment point:(GEVec2)point;
- (ODClassType*)type;
- (CGFloat)yForX:(CGFloat)x;
- (CGFloat)slope;
- (BOOL)isVertical;
- (BOOL)isEnd;
+ (ODType*)type;
@end


@interface GEBentleyOttmannIntersectionEvent : GEBentleyOttmannEvent
@property (nonatomic, readonly) GEVec2 point;

+ (id)bentleyOttmannIntersectionEventWithPoint:(GEVec2)point;
- (id)initWithPoint:(GEVec2)point;
- (ODClassType*)type;
- (BOOL)isIntersection;
+ (ODType*)type;
@end


@interface GEBentleyOttmannEventQueue : NSObject
@property (nonatomic, readonly) CNMutableTreeMap* events;

+ (id)bentleyOttmannEventQueue;
- (id)init;
- (ODClassType*)type;
- (BOOL)isEmpty;
+ (GEBentleyOttmannEventQueue*)newWithSegments:(id<CNSeq>)segments sweepLine:(GESweepLine*)sweepLine;
- (void)offerPoint:(GEVec2)point event:(GEBentleyOttmannEvent*)event;
- (id<CNSeq>)poll;
+ (ODType*)type;
@end


@interface GEPointClass : NSObject
@property (nonatomic, readonly) GEVec2 point;

+ (id)pointClassWithPoint:(GEVec2)point;
- (id)initWithPoint:(GEVec2)point;
- (ODClassType*)type;
+ (ODType*)type;
@end


@interface GESweepLine : NSObject
@property (nonatomic, retain) CNMutableTreeSet* events;
@property (nonatomic, readonly) NSMutableDictionary* intersections;
@property (nonatomic, retain) GEBentleyOttmannEventQueue* queue;

+ (id)sweepLine;
- (id)init;
- (ODClassType*)type;
- (void)handleEvents:(id<CNSeq>)events;
+ (ODType*)type;
@end


