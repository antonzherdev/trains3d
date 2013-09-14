#import "objd.h"
#import "GEVec.h"
#import "GERect.h"

@class GELine;
@class GESlopeLine;
@class GEVerticalLine;
@class GELineSegment;
@class GEPolygon;
@class GEThickLineSegment;
@protocol GEFigure;

@interface GELine : NSObject
+ (id)line;
- (id)init;
- (ODClassType*)type;
+ (GELine*)applySlope:(CGFloat)slope point:(GEVec2)point;
+ (GELine*)applyP0:(GEVec2)p0 p1:(GEVec2)p1;
+ (CGFloat)calculateSlopeWithP0:(GEVec2)p0 p1:(GEVec2)p1;
+ (CGFloat)calculateConstantWithSlope:(CGFloat)slope point:(GEVec2)point;
- (BOOL)containsPoint:(GEVec2)point;
- (BOOL)isVertical;
- (BOOL)isHorizontal;
- (id)intersectionWithLine:(GELine*)line;
- (CGFloat)xIntersectionWithLine:(GELine*)line;
- (BOOL)isRightPoint:(GEVec2)point;
- (CGFloat)slope;
- (id)moveWithDistance:(CGFloat)distance;
- (CGFloat)angle;
- (CGFloat)degreeAngle;
- (GELine*)perpendicularWithPoint:(GEVec2)point;
+ (ODClassType*)type;
@end


@interface GESlopeLine : GELine
@property (nonatomic, readonly) CGFloat slope;
@property (nonatomic, readonly) CGFloat constant;

+ (id)slopeLineWithSlope:(CGFloat)slope constant:(CGFloat)constant;
- (id)initWithSlope:(CGFloat)slope constant:(CGFloat)constant;
- (ODClassType*)type;
- (BOOL)containsPoint:(GEVec2)point;
- (BOOL)isVertical;
- (BOOL)isHorizontal;
- (CGFloat)xIntersectionWithLine:(GELine*)line;
- (CGFloat)yForX:(CGFloat)x;
- (id)intersectionWithLine:(GELine*)line;
- (BOOL)isRightPoint:(GEVec2)point;
- (id)moveWithDistance:(CGFloat)distance;
- (CGFloat)angle;
- (GELine*)perpendicularWithPoint:(GEVec2)point;
+ (ODClassType*)type;
@end


@interface GEVerticalLine : GELine
@property (nonatomic, readonly) CGFloat x;

+ (id)verticalLineWithX:(CGFloat)x;
- (id)initWithX:(CGFloat)x;
- (ODClassType*)type;
- (BOOL)containsPoint:(GEVec2)point;
- (BOOL)isVertical;
- (BOOL)isHorizontal;
- (CGFloat)xIntersectionWithLine:(GELine*)line;
- (id)intersectionWithLine:(GELine*)line;
- (BOOL)isRightPoint:(GEVec2)point;
- (CGFloat)slope;
- (id)moveWithDistance:(CGFloat)distance;
- (CGFloat)angle;
- (GELine*)perpendicularWithPoint:(GEVec2)point;
+ (ODClassType*)type;
@end


@protocol GEFigure<NSObject>
- (GERect)boundingRect;
- (id<CNSeq>)segments;
@end


@interface GELineSegment : NSObject<GEFigure>
@property (nonatomic, readonly) GEVec2 p0;
@property (nonatomic, readonly) GEVec2 p1;
@property (nonatomic, readonly) GERect boundingRect;

+ (id)lineSegmentWithP0:(GEVec2)p0 p1:(GEVec2)p1;
- (id)initWithP0:(GEVec2)p0 p1:(GEVec2)p1;
- (ODClassType*)type;
+ (GELineSegment*)newWithP0:(GEVec2)p0 p1:(GEVec2)p1;
+ (GELineSegment*)newWithX1:(CGFloat)x1 y1:(CGFloat)y1 x2:(CGFloat)x2 y2:(CGFloat)y2;
- (BOOL)isVertical;
- (BOOL)isHorizontal;
- (GELine*)line;
- (BOOL)containsPoint:(GEVec2)point;
- (BOOL)containsInBoundingRectPoint:(GEVec2)point;
- (id)intersectionWithSegment:(GELineSegment*)segment;
- (BOOL)endingsContainPoint:(GEVec2)point;
- (id<CNSeq>)segments;
- (GELineSegment*)moveWithPoint:(GEVec2)point;
- (GELineSegment*)moveWithX:(CGFloat)x y:(CGFloat)y;
- (GEVec2)mid;
- (CGFloat)angle;
- (CGFloat)degreeAngle;
- (CGFloat)length;
- (GEVec2)vec;
- (GEVec2)vec1;
+ (ODClassType*)type;
@end


@interface GEPolygon : NSObject<GEFigure>
@property (nonatomic, readonly) id<CNSeq> points;
@property (nonatomic, readonly) id<CNSeq> segments;

+ (id)polygonWithPoints:(id<CNSeq>)points;
- (id)initWithPoints:(id<CNSeq>)points;
- (ODClassType*)type;
- (GERect)boundingRect;
+ (ODClassType*)type;
@end


@interface GEThickLineSegment : NSObject<GEFigure>
@property (nonatomic, readonly) GELineSegment* segment;
@property (nonatomic, readonly) CGFloat thickness;
@property (nonatomic, readonly) CGFloat thickness_2;

+ (id)thickLineSegmentWithSegment:(GELineSegment*)segment thickness:(CGFloat)thickness;
- (id)initWithSegment:(GELineSegment*)segment thickness:(CGFloat)thickness;
- (ODClassType*)type;
- (GERect)boundingRect;
- (id<CNSeq>)segments;
+ (ODClassType*)type;
@end


