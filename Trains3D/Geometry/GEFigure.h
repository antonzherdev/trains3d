#import "objd.h"
#import "GEVec.h"

@class GELine;
@class GESlopeLine;
@class GEVerticalLine;
@class GELineSegment;
@class GEPolygon;
@class GEThickLineSegment;
@protocol GEFigure;

@interface GELine : NSObject
+ (instancetype)line;
- (instancetype)init;
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


@interface GESlopeLine : GELine {
@private
    CGFloat _slope;
    CGFloat _constant;
}
@property (nonatomic, readonly) CGFloat slope;
@property (nonatomic, readonly) CGFloat constant;

+ (instancetype)slopeLineWithSlope:(CGFloat)slope constant:(CGFloat)constant;
- (instancetype)initWithSlope:(CGFloat)slope constant:(CGFloat)constant;
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


@interface GEVerticalLine : GELine {
@private
    CGFloat _x;
}
@property (nonatomic, readonly) CGFloat x;

+ (instancetype)verticalLineWithX:(CGFloat)x;
- (instancetype)initWithX:(CGFloat)x;
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
- (id<CNImSeq>)segments;
@end


@interface GELineSegment : NSObject<GEFigure> {
@private
    GEVec2 _p0;
    GEVec2 _p1;
    BOOL _dir;
    GELine* __line;
    GERect _boundingRect;
}
@property (nonatomic, readonly) GEVec2 p0;
@property (nonatomic, readonly) GEVec2 p1;
@property (nonatomic, readonly) GERect boundingRect;

+ (instancetype)lineSegmentWithP0:(GEVec2)p0 p1:(GEVec2)p1;
- (instancetype)initWithP0:(GEVec2)p0 p1:(GEVec2)p1;
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
- (id<CNImSeq>)segments;
- (GELineSegment*)moveWithPoint:(GEVec2)point;
- (GELineSegment*)moveWithX:(CGFloat)x y:(CGFloat)y;
- (GEVec2)mid;
- (CGFloat)angle;
- (CGFloat)degreeAngle;
- (float)length;
- (GEVec2)vec;
- (GEVec2)vec1;
+ (ODClassType*)type;
@end


@interface GEPolygon : NSObject<GEFigure> {
@private
    id<CNImSeq> _points;
    id<CNImSeq> _segments;
}
@property (nonatomic, readonly) id<CNImSeq> points;
@property (nonatomic, readonly) id<CNImSeq> segments;

+ (instancetype)polygonWithPoints:(id<CNImSeq>)points;
- (instancetype)initWithPoints:(id<CNImSeq>)points;
- (ODClassType*)type;
- (GERect)boundingRect;
+ (ODClassType*)type;
@end


@interface GEThickLineSegment : NSObject<GEFigure> {
@private
    GELineSegment* _segment;
    CGFloat _thickness;
    CGFloat _thickness_2;
    id<CNImSeq> __segments;
}
@property (nonatomic, readonly) GELineSegment* segment;
@property (nonatomic, readonly) CGFloat thickness;
@property (nonatomic, readonly) CGFloat thickness_2;

+ (instancetype)thickLineSegmentWithSegment:(GELineSegment*)segment thickness:(CGFloat)thickness;
- (instancetype)initWithSegment:(GELineSegment*)segment thickness:(CGFloat)thickness;
- (ODClassType*)type;
- (GERect)boundingRect;
- (id<CNImSeq>)segments;
+ (ODClassType*)type;
@end


