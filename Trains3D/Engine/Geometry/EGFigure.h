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
+ (EGLine*)newWithSlope:(CGFloat)slope point:(EGPoint)point;
+ (EGLine*)newWithP1:(EGPoint)p1 p2:(EGPoint)p2;
+ (CGFloat)calculateSlopeWithP1:(EGPoint)p1 p2:(EGPoint)p2;
+ (CGFloat)calculateConstantWithSlope:(CGFloat)slope point:(EGPoint)point;
- (BOOL)containsPoint:(EGPoint)point;
- (BOOL)isVertical;
- (BOOL)isHorizontal;
- (id)intersectionWithLine:(EGLine*)line;
- (CGFloat)xIntersectionWithLine:(EGLine*)line;
- (BOOL)isRightPoint:(EGPoint)point;
- (CGFloat)slope;
- (id)moveWithDistance:(CGFloat)distance;
- (CGFloat)angle;
- (CGFloat)degreeAngle;
- (EGLine*)perpendicularWithPoint:(EGPoint)point;
- (ODType*)type;
+ (ODType*)type;
@end


@interface EGSlopeLine : EGLine
@property (nonatomic, readonly) CGFloat slope;
@property (nonatomic, readonly) CGFloat constant;

+ (id)slopeLineWithSlope:(CGFloat)slope constant:(CGFloat)constant;
- (id)initWithSlope:(CGFloat)slope constant:(CGFloat)constant;
- (BOOL)containsPoint:(EGPoint)point;
- (BOOL)isVertical;
- (BOOL)isHorizontal;
- (CGFloat)xIntersectionWithLine:(EGLine*)line;
- (CGFloat)yForX:(CGFloat)x;
- (id)intersectionWithLine:(EGLine*)line;
- (BOOL)isRightPoint:(EGPoint)point;
- (id)moveWithDistance:(CGFloat)distance;
- (CGFloat)angle;
- (EGLine*)perpendicularWithPoint:(EGPoint)point;
- (ODType*)type;
+ (ODType*)type;
@end


@interface EGVerticalLine : EGLine
@property (nonatomic, readonly) CGFloat x;

+ (id)verticalLineWithX:(CGFloat)x;
- (id)initWithX:(CGFloat)x;
- (BOOL)containsPoint:(EGPoint)point;
- (BOOL)isVertical;
- (BOOL)isHorizontal;
- (CGFloat)xIntersectionWithLine:(EGLine*)line;
- (id)intersectionWithLine:(EGLine*)line;
- (BOOL)isRightPoint:(EGPoint)point;
- (CGFloat)slope;
- (id)moveWithDistance:(CGFloat)distance;
- (CGFloat)angle;
- (EGLine*)perpendicularWithPoint:(EGPoint)point;
- (ODType*)type;
+ (ODType*)type;
@end


@protocol EGFigure<NSObject>
- (EGRect)boundingRect;
- (id<CNSeq>)segments;
- (ODType*)type;
@end


@interface EGLineSegment : NSObject<EGFigure>
@property (nonatomic, readonly) EGPoint p1;
@property (nonatomic, readonly) EGPoint p2;
@property (nonatomic, readonly) EGRect boundingRect;

+ (id)lineSegmentWithP1:(EGPoint)p1 p2:(EGPoint)p2;
- (id)initWithP1:(EGPoint)p1 p2:(EGPoint)p2;
+ (EGLineSegment*)newWithP1:(EGPoint)p1 p2:(EGPoint)p2;
+ (EGLineSegment*)newWithX1:(CGFloat)x1 y1:(CGFloat)y1 x2:(CGFloat)x2 y2:(CGFloat)y2;
- (BOOL)isVertical;
- (BOOL)isHorizontal;
- (EGLine*)line;
- (BOOL)containsPoint:(EGPoint)point;
- (BOOL)containsInBoundingRectPoint:(EGPoint)point;
- (id)intersectionWithSegment:(EGLineSegment*)segment;
- (BOOL)endingsContainPoint:(EGPoint)point;
- (id<CNSeq>)segments;
- (EGLineSegment*)moveWithPoint:(EGPoint)point;
- (EGLineSegment*)moveWithX:(CGFloat)x y:(CGFloat)y;
- (ODType*)type;
+ (ODType*)type;
@end


@interface EGPolygon : NSObject<EGFigure>
@property (nonatomic, readonly) id<CNSeq> points;
@property (nonatomic, readonly) id<CNSeq> segments;

+ (id)polygonWithPoints:(id<CNSeq>)points;
- (id)initWithPoints:(id<CNSeq>)points;
- (EGRect)boundingRect;
- (ODType*)type;
+ (ODType*)type;
@end


@interface EGThickLineSegment : NSObject<EGFigure>
@property (nonatomic, readonly) EGLineSegment* segment;
@property (nonatomic, readonly) CGFloat thickness;
@property (nonatomic, readonly) CGFloat thickness_2;

+ (id)thickLineSegmentWithSegment:(EGLineSegment*)segment thickness:(CGFloat)thickness;
- (id)initWithSegment:(EGLineSegment*)segment thickness:(CGFloat)thickness;
- (EGRect)boundingRect;
- (id<CNSeq>)segments;
- (ODType*)type;
+ (ODType*)type;
@end


