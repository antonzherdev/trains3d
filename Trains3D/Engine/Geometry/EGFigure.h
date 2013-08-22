#import "objd.h"
#import "EGTypes.h"

@class EGLine;
@class EGSlopeLine;
@class EGVerticalLine;
@class EGLineSegment;
@class EGPolygon;
@class EGThickLineSegment;
@protocol EGFigure;

@interface EGLine : NSObject
+ (id)line;
- (id)init;
+ (EGLine*)newWithSlope:(float)slope point:(EGPoint)point;
+ (EGLine*)newWithP1:(EGPoint)p1 p2:(EGPoint)p2;
+ (float)calculateSlopeWithP1:(EGPoint)p1 p2:(EGPoint)p2;
+ (float)calculateConstantWithSlope:(float)slope point:(EGPoint)point;
- (BOOL)containsPoint:(EGPoint)point;
- (BOOL)isVertical;
- (BOOL)isHorizontal;
- (id)intersectionWithLine:(EGLine*)line;
- (float)xIntersectionWithLine:(EGLine*)line;
- (BOOL)isRightPoint:(EGPoint)point;
- (float)slope;
- (id)moveWithDistance:(float)distance;
- (float)angle;
- (float)degreeAngle;
- (EGLine*)perpendicularWithPoint:(EGPoint)point;
@end


@interface EGSlopeLine : EGLine
@property (nonatomic, readonly) float slope;
@property (nonatomic, readonly) float constant;

+ (id)slopeLineWithSlope:(float)slope constant:(float)constant;
- (id)initWithSlope:(float)slope constant:(float)constant;
- (BOOL)containsPoint:(EGPoint)point;
- (BOOL)isVertical;
- (BOOL)isHorizontal;
- (float)xIntersectionWithLine:(EGLine*)line;
- (float)yForX:(float)x;
- (id)intersectionWithLine:(EGLine*)line;
- (BOOL)isRightPoint:(EGPoint)point;
- (id)moveWithDistance:(float)distance;
- (float)angle;
- (EGLine*)perpendicularWithPoint:(EGPoint)point;
@end


@interface EGVerticalLine : EGLine
@property (nonatomic, readonly) float x;

+ (id)verticalLineWithX:(float)x;
- (id)initWithX:(float)x;
- (BOOL)containsPoint:(EGPoint)point;
- (BOOL)isVertical;
- (BOOL)isHorizontal;
- (float)xIntersectionWithLine:(EGLine*)line;
- (id)intersectionWithLine:(EGLine*)line;
- (BOOL)isRightPoint:(EGPoint)point;
- (float)slope;
- (id)moveWithDistance:(float)distance;
- (float)angle;
- (EGLine*)perpendicularWithPoint:(EGPoint)point;
@end


@protocol EGFigure<NSObject>
- (EGRect)boundingRect;
- (id<CNList>)segments;
@end


@interface EGLineSegment : NSObject<EGFigure>
@property (nonatomic, readonly) EGPoint p1;
@property (nonatomic, readonly) EGPoint p2;
@property (nonatomic, readonly) EGRect boundingRect;

+ (id)lineSegmentWithP1:(EGPoint)p1 p2:(EGPoint)p2;
- (id)initWithP1:(EGPoint)p1 p2:(EGPoint)p2;
+ (EGLineSegment*)newWithP1:(EGPoint)p1 p2:(EGPoint)p2;
+ (EGLineSegment*)newWithX1:(float)x1 y1:(float)y1 x2:(float)x2 y2:(float)y2;
- (BOOL)isVertical;
- (BOOL)isHorizontal;
- (EGLine*)line;
- (BOOL)containsPoint:(EGPoint)point;
- (BOOL)containsInBoundingRectPoint:(EGPoint)point;
- (id)intersectionWithSegment:(EGLineSegment*)segment;
- (BOOL)endingsContainPoint:(EGPoint)point;
- (id<CNList>)segments;
- (EGLineSegment*)moveWithPoint:(EGPoint)point;
- (EGLineSegment*)moveWithX:(float)x y:(float)y;
@end


@interface EGPolygon : NSObject<EGFigure>
@property (nonatomic, readonly) id<CNList> points;
@property (nonatomic, readonly) id<CNList> segments;

+ (id)polygonWithPoints:(id<CNList>)points;
- (id)initWithPoints:(id<CNList>)points;
- (EGRect)boundingRect;
@end


@interface EGThickLineSegment : NSObject<EGFigure>
@property (nonatomic, readonly) EGLineSegment* segment;
@property (nonatomic, readonly) float thickness;
@property (nonatomic, readonly) float thickness_2;

+ (id)thickLineSegmentWithSegment:(EGLineSegment*)segment thickness:(float)thickness;
- (id)initWithSegment:(EGLineSegment*)segment thickness:(float)thickness;
- (EGRect)boundingRect;
- (id<CNList>)segments;
@end


