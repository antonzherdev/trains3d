#import "objd.h"
#import "EGVec.h"
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
- (ODClassType*)type;
+ (EGLine*)applySlope:(CGFloat)slope point:(EGVec2)point;
+ (EGLine*)applyP0:(EGVec2)p0 p1:(EGVec2)p1;
+ (CGFloat)calculateSlopeWithP0:(EGVec2)p0 p1:(EGVec2)p1;
+ (CGFloat)calculateConstantWithSlope:(CGFloat)slope point:(EGVec2)point;
- (BOOL)containsPoint:(EGVec2)point;
- (BOOL)isVertical;
- (BOOL)isHorizontal;
- (id)intersectionWithLine:(EGLine*)line;
- (CGFloat)xIntersectionWithLine:(EGLine*)line;
- (BOOL)isRightPoint:(EGVec2)point;
- (CGFloat)slope;
- (id)moveWithDistance:(CGFloat)distance;
- (CGFloat)angle;
- (CGFloat)degreeAngle;
- (EGLine*)perpendicularWithPoint:(EGVec2)point;
+ (ODClassType*)type;
@end


@interface EGSlopeLine : EGLine
@property (nonatomic, readonly) CGFloat slope;
@property (nonatomic, readonly) CGFloat constant;

+ (id)slopeLineWithSlope:(CGFloat)slope constant:(CGFloat)constant;
- (id)initWithSlope:(CGFloat)slope constant:(CGFloat)constant;
- (ODClassType*)type;
- (BOOL)containsPoint:(EGVec2)point;
- (BOOL)isVertical;
- (BOOL)isHorizontal;
- (CGFloat)xIntersectionWithLine:(EGLine*)line;
- (CGFloat)yForX:(CGFloat)x;
- (id)intersectionWithLine:(EGLine*)line;
- (BOOL)isRightPoint:(EGVec2)point;
- (id)moveWithDistance:(CGFloat)distance;
- (CGFloat)angle;
- (EGLine*)perpendicularWithPoint:(EGVec2)point;
+ (ODClassType*)type;
@end


@interface EGVerticalLine : EGLine
@property (nonatomic, readonly) CGFloat x;

+ (id)verticalLineWithX:(CGFloat)x;
- (id)initWithX:(CGFloat)x;
- (ODClassType*)type;
- (BOOL)containsPoint:(EGVec2)point;
- (BOOL)isVertical;
- (BOOL)isHorizontal;
- (CGFloat)xIntersectionWithLine:(EGLine*)line;
- (id)intersectionWithLine:(EGLine*)line;
- (BOOL)isRightPoint:(EGVec2)point;
- (CGFloat)slope;
- (id)moveWithDistance:(CGFloat)distance;
- (CGFloat)angle;
- (EGLine*)perpendicularWithPoint:(EGVec2)point;
+ (ODClassType*)type;
@end


@protocol EGFigure<NSObject>
- (EGRect)boundingRect;
- (id<CNSeq>)segments;
@end


@interface EGLineSegment : NSObject<EGFigure>
@property (nonatomic, readonly) EGVec2 p0;
@property (nonatomic, readonly) EGVec2 p1;
@property (nonatomic, readonly) EGRect boundingRect;

+ (id)lineSegmentWithP0:(EGVec2)p0 p1:(EGVec2)p1;
- (id)initWithP0:(EGVec2)p0 p1:(EGVec2)p1;
- (ODClassType*)type;
+ (EGLineSegment*)newWithP0:(EGVec2)p0 p1:(EGVec2)p1;
+ (EGLineSegment*)newWithX1:(CGFloat)x1 y1:(CGFloat)y1 x2:(CGFloat)x2 y2:(CGFloat)y2;
- (BOOL)isVertical;
- (BOOL)isHorizontal;
- (EGLine*)line;
- (BOOL)containsPoint:(EGVec2)point;
- (BOOL)containsInBoundingRectPoint:(EGVec2)point;
- (id)intersectionWithSegment:(EGLineSegment*)segment;
- (BOOL)endingsContainPoint:(EGVec2)point;
- (id<CNSeq>)segments;
- (EGLineSegment*)moveWithPoint:(EGVec2)point;
- (EGLineSegment*)moveWithX:(CGFloat)x y:(CGFloat)y;
- (EGVec2)mid;
- (CGFloat)angle;
- (CGFloat)degreeAngle;
- (CGFloat)length;
- (EGVec2)vec;
- (EGVec2)vec1;
+ (ODClassType*)type;
@end


@interface EGPolygon : NSObject<EGFigure>
@property (nonatomic, readonly) id<CNSeq> points;
@property (nonatomic, readonly) id<CNSeq> segments;

+ (id)polygonWithPoints:(id<CNSeq>)points;
- (id)initWithPoints:(id<CNSeq>)points;
- (ODClassType*)type;
- (EGRect)boundingRect;
+ (ODClassType*)type;
@end


@interface EGThickLineSegment : NSObject<EGFigure>
@property (nonatomic, readonly) EGLineSegment* segment;
@property (nonatomic, readonly) CGFloat thickness;
@property (nonatomic, readonly) CGFloat thickness_2;

+ (id)thickLineSegmentWithSegment:(EGLineSegment*)segment thickness:(CGFloat)thickness;
- (id)initWithSegment:(EGLineSegment*)segment thickness:(CGFloat)thickness;
- (ODClassType*)type;
- (EGRect)boundingRect;
- (id<CNSeq>)segments;
+ (ODClassType*)type;
@end


