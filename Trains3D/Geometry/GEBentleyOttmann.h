#import "objd.h"
#import "GEVec.h"
@class CNChain;
@class GELineSegment;
@class GELine;
@class GESlopeLine;

@class GEBentleyOttmann;
@class GEIntersection;
@class GEBentleyOttmannEvent;
@class GEBentleyOttmannPointEvent;
@class GEBentleyOttmannIntersectionEvent;
@class GEBentleyOttmannEventQueue;
@class GESweepLine;

@interface GEBentleyOttmann : NSObject
+ (instancetype)bentleyOttmann;
- (instancetype)init;
- (CNClassType*)type;
+ (id<CNSet>)intersectionsForSegments:(NSArray*)segments;
- (NSString*)description;
+ (CNClassType*)type;
@end


@interface GEIntersection : NSObject {
@protected
    CNPair* _items;
    GEVec2 _point;
}
@property (nonatomic, readonly) CNPair* items;
@property (nonatomic, readonly) GEVec2 point;

+ (instancetype)intersectionWithItems:(CNPair*)items point:(GEVec2)point;
- (instancetype)initWithItems:(CNPair*)items point:(GEVec2)point;
- (CNClassType*)type;
- (NSString*)description;
- (BOOL)isEqual:(id)to;
- (NSUInteger)hash;
+ (CNClassType*)type;
@end


@interface GEBentleyOttmannEvent : NSObject
+ (instancetype)bentleyOttmannEvent;
- (instancetype)init;
- (CNClassType*)type;
- (GEVec2)point;
- (BOOL)isIntersection;
- (BOOL)isStart;
- (BOOL)isEnd;
- (NSString*)description;
+ (CNClassType*)type;
@end


@interface GEBentleyOttmannPointEvent : GEBentleyOttmannEvent {
@protected
    BOOL _isStart;
    id _data;
    GELineSegment* _segment;
    GEVec2 _point;
}
@property (nonatomic, readonly) BOOL isStart;
@property (nonatomic, readonly) id data;
@property (nonatomic, readonly) GELineSegment* segment;
@property (nonatomic, readonly) GEVec2 point;

+ (instancetype)bentleyOttmannPointEventWithIsStart:(BOOL)isStart data:(id)data segment:(GELineSegment*)segment point:(GEVec2)point;
- (instancetype)initWithIsStart:(BOOL)isStart data:(id)data segment:(GELineSegment*)segment point:(GEVec2)point;
- (CNClassType*)type;
- (CGFloat)yForX:(CGFloat)x;
- (CGFloat)slope;
- (BOOL)isVertical;
- (BOOL)isEnd;
- (NSString*)description;
+ (CNClassType*)type;
@end


@interface GEBentleyOttmannIntersectionEvent : GEBentleyOttmannEvent {
@protected
    GEVec2 _point;
}
@property (nonatomic, readonly) GEVec2 point;

+ (instancetype)bentleyOttmannIntersectionEventWithPoint:(GEVec2)point;
- (instancetype)initWithPoint:(GEVec2)point;
- (CNClassType*)type;
- (BOOL)isIntersection;
- (NSString*)description;
+ (CNClassType*)type;
@end


@interface GEBentleyOttmannEventQueue : NSObject {
@protected
    CNMTreeMap* _events;
}
@property (nonatomic, readonly) CNMTreeMap* events;

+ (instancetype)bentleyOttmannEventQueue;
- (instancetype)init;
- (CNClassType*)type;
- (BOOL)isEmpty;
+ (GEBentleyOttmannEventQueue*)newWithSegments:(NSArray*)segments sweepLine:(GESweepLine*)sweepLine;
- (void)offerPoint:(GEVec2)point event:(GEBentleyOttmannEvent*)event;
- (id<CNSeq>)poll;
- (NSString*)description;
+ (CNClassType*)type;
@end


@interface GESweepLine : NSObject {
@protected
    CNMTreeSet* _events;
    CNMHashMap* _intersections;
    GEVec2 _currentEventPoint;
    GEBentleyOttmannEventQueue* _queue;
}
@property (nonatomic, retain) CNMTreeSet* events;
@property (nonatomic, readonly) CNMHashMap* intersections;
@property (nonatomic) GEBentleyOttmannEventQueue* queue;

+ (instancetype)sweepLine;
- (instancetype)init;
- (CNClassType*)type;
- (void)handleEvents:(id<CNSeq>)events;
- (NSString*)description;
+ (CNClassType*)type;
@end


