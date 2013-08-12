#import "objd.h"
#import "EGTypes.h"
@class EGLine;
@class EGSlopeLine;
@class EGVerticalLine;
@class EGLineSegment;
#import "CNTreeMap.h"
@class CNTreeSet;

@class EGBentleyOttmann;
@class EGBentleyOttmannEventQueue;
@class EGBentleyOttmannEventStart;
@class EGBentleyOttmannEventEnd;
@class EGBentleyOttmannIntersection;
@class EGSweepLine;

@interface EGBentleyOttmann : NSObject
+ (id)bentleyOttmann;
- (id)init;
+ (NSArray*)intersectionsSegments:(NSArray*)segments;
@end


@protocol EGBentleyOttmannEvent<NSObject>
- (EGPoint)point;
- (id)data;
- (EGLineSegment*)segment;
@end


@interface EGBentleyOttmannEventQueue : NSObject
@property (nonatomic, readonly) CNTreeMap* events;

+ (id)bentleyOttmannEventQueue;
- (id)init;
- (BOOL)isEmpty;
+ (EGBentleyOttmannEventQueue*)newWithSegments:(NSArray*)segments sweepLine:(EGSweepLine*)sweepLine;
- (void)offerPoint:(EGPoint)point event:(id<EGBentleyOttmannEvent>)event;
- (NSArray*)poll;
@end


@interface EGBentleyOttmannEventStart : NSObject<EGBentleyOttmannEvent>
@property (nonatomic, readonly) id data;
@property (nonatomic, readonly) EGLineSegment* segment;
@property (nonatomic, readonly) EGPoint point;

+ (id)bentleyOttmannEventStartWithData:(id)data segment:(EGLineSegment*)segment point:(EGPoint)point;
- (id)initWithData:(id)data segment:(EGLineSegment*)segment point:(EGPoint)point;
@end


@interface EGBentleyOttmannEventEnd : NSObject<EGBentleyOttmannEvent>
@property (nonatomic, readonly) id data;
@property (nonatomic, readonly) EGLineSegment* segment;
@property (nonatomic, readonly) EGPoint point;

+ (id)bentleyOttmannEventEndWithData:(id)data segment:(EGLineSegment*)segment point:(EGPoint)point;
- (id)initWithData:(id)data segment:(EGLineSegment*)segment point:(EGPoint)point;
@end


@interface EGBentleyOttmannIntersection : NSObject<EGBentleyOttmannEvent>
@property (nonatomic, readonly) id data1;
@property (nonatomic, readonly) id data2;
@property (nonatomic, readonly) EGPoint point;

+ (id)bentleyOttmannIntersectionWithData1:(id)data1 data2:(id)data2 point:(EGPoint)point;
- (id)initWithData1:(id)data1 data2:(id)data2 point:(EGPoint)point;
@end


@interface EGSweepLine : NSObject
@property (nonatomic, readonly) NSMutableDictionary* intersections;
@property (nonatomic, retain) EGLine* sweepLine;
@property (nonatomic, retain) EGBentleyOttmannEventQueue* queue;

+ (id)sweepLine;
- (id)init;
- (void)handleEvents:(NSArray*)events;
@end


