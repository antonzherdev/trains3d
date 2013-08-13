#import "objd.h"
#import "EGTypes.h"

@class EGLine;
@class EGSlopeLine;
@class EGVerticalLine;
@class EGLineSegment;
@class EGPolygon;
@class EGThickLineSegment;

@interface EGLine : NSObject
+ (id)line;
- (id)init;
+ (EGLine*)newWithSlope:(double)slope point:(EGPoint)point;
+ (EGLine*)newWithP1:(EGPoint)p1 p2:(EGPoint)p2;
+ (double)calculateSlopeWithP1:(EGPoint)p1 p2:(EGPoint)p2;
+ (double)calculateConstantWithSlope:(double)slope point:(EGPoint)point;
- (BOOL)containsPoint:(EGPoint)point;
- (BOOL)isVertical;
- (BOOL)isHorizontal;
- (id)intersectionWithLine:(EGLine*)line;
- (double)xIntersectionWithLine:(EGLine*)line;
- (BOOL)isRightPoint:(EGPoint)point;
- (double)slope;
- (id)moveWithDistance:(double)distance;
- (double)angle;
- (double)degreeAngle;
- (EGLine*)perpendicularWithPoint:(EGPoint)point;
@end


@interface EGSlopeLine : EGLine
@property (nonatomic, readonly) double slope;
@property (nonatomic, readonly) double constant;

+ (id)slopeLineWithSlope:(double)slope constant:(double)constant;
- (id)initWithSlope:(double)slope constant:(double)constant;
- (BOOL)containsPoint:(EGPoint)point;
- (BOOL)isVertical;
- (BOOL)isHorizontal;
- (double)xIntersectionWithLine:(EGLine*)line;
- (double)yForX:(double)x;
- (id)intersectionWithLine:(EGLine*)line;
- (BOOL)isRightPoint:(EGPoint)point;
- (id)moveWithDistance:(double)distance;
- (double)angle;
- (EGLine*)perpendicularWithPoint:(EGPoint)point;
@end


@interface EGVerticalLine : EGLine
@property (nonatomic, readonly) double x;

+ (id)verticalLineWithX:(double)x;
- (id)initWithX:(double)x;
- (BOOL)containsPoint:(EGPoint)point;
- (BOOL)isVertical;
- (BOOL)isHorizontal;
- (double)xIntersectionWithLine:(EGLine*)line;
- (id)intersectionWithLine:(EGLine*)line;
- (BOOL)isRightPoint:(EGPoint)point;
- (double)slope;
- (id)moveWithDistance:(double)distance;
- (double)angle;
- (EGLine*)perpendicularWithPoint:(EGPoint)point;
@end


@protocol EGFigure<NSObject>
- (EGRect)boxingRect;
- (NSArray*)segments;
@end


@interface EGLineSegment : NSObject<EGFigure>
@property (nonatomic, readonly) EGPoint p1;
@property (nonatomic, readonly) EGPoint p2;
@property (nonatomic, readonly) EGRect boundingRect;

+ (id)lineSegmentWithP1:(EGPoint)p1 p2:(EGPoint)p2;
- (id)initWithP1:(EGPoint)p1 p2:(EGPoint)p2;
+ (EGLineSegment*)newWithP1:(EGPoint)p1 p2:(EGPoint)p2;
+ (EGLineSegment*)newWithX1:(double)x1 y1:(double)y1 x2:(double)x2 y2:(double)y2;
- (EGLine*)line;
- (BOOL)containsPoint:(EGPoint)point;
- (BOOL)containsInBoundingRectPoint:(EGPoint)point;
- (id)intersectionWithSegment:(EGLineSegment*)segment;
- (BOOL)endingsContainPoint:(EGPoint)point;
- (NSArray*)segments;
- (EGLineSegment*)moveWithPoint:(EGPoint)point;
- (EGLineSegment*)moveWithX:(double)x y:(double)y;
@end


@interface EGPolygon : NSObject<EGFigure>
@property (nonatomic, readonly) NSArray* points;
@property (nonatomic, readonly) NSArray* segments;

+ (id)polygonWithPoints:(NSArray*)points;
- (id)initWithPoints:(NSArray*)points;
- (EGRect)boxingRect;
@end


@interface EGThickLineSegment : NSObject<EGFigure>
@property (nonatomic, readonly) EGLineSegment* segment;
@property (nonatomic, readonly) double thickness;

+ (id)thickLineSegmentWithSegment:(EGLineSegment*)segment thickness:(double)thickness;
- (id)initWithSegment:(EGLineSegment*)segment thickness:(double)thickness;
- (EGRect)boxingRect;
- (NSArray*)segments;
@end


