#import "objd.h"
#import "GEVec.h"
@class CNChain;

@class GELine;
@class GESlopeLine;
@class GEVerticalLine;
@class GEFigure_impl;
@class GELineSegment;
@class GEPolygon;
@class GEThickLineSegment;
@protocol GEFigure;

@interface GELine : NSObject
+ (instancetype)line;
- (instancetype)init;
- (CNClassType*)type;
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
- (NSString*)description;
+ (CNClassType*)type;
@end


@interface GESlopeLine : GELine {
@protected
    CGFloat _slope;
    CGFloat _constant;
}
@property (nonatomic, readonly) CGFloat slope;
@property (nonatomic, readonly) CGFloat constant;

+ (instancetype)slopeLineWithSlope:(CGFloat)slope constant:(CGFloat)constant;
- (instancetype)initWithSlope:(CGFloat)slope constant:(CGFloat)constant;
- (CNClassType*)type;
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
- (NSString*)description;
- (BOOL)isEqual:(id)to;
- (NSUInteger)hash;
+ (CNClassType*)type;
@end


@interface GEVerticalLine : GELine {
@protected
    CGFloat _x;
}
@property (nonatomic, readonly) CGFloat x;

+ (instancetype)verticalLineWithX:(CGFloat)x;
- (instancetype)initWithX:(CGFloat)x;
- (CNClassType*)type;
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
- (NSString*)description;
- (BOOL)isEqual:(id)to;
- (NSUInteger)hash;
+ (CNClassType*)type;
@end


@protocol GEFigure<NSObject>
- (GERect)boundingRect;
- (NSArray*)segments;
- (NSString*)description;
@end


@interface GEFigure_impl : NSObject<GEFigure>
+ (instancetype)figure_impl;
- (instancetype)init;
@end


@interface GELineSegment : GEFigure_impl {
@protected
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
- (CNClassType*)type;
+ (GELineSegment*)newWithP0:(GEVec2)p0 p1:(GEVec2)p1;
+ (GELineSegment*)newWithX1:(CGFloat)x1 y1:(CGFloat)y1 x2:(CGFloat)x2 y2:(CGFloat)y2;
- (BOOL)isVertical;
- (BOOL)isHorizontal;
- (GELine*)line;
- (BOOL)containsPoint:(GEVec2)point;
- (BOOL)containsInBoundingRectPoint:(GEVec2)point;
- (id)intersectionWithSegment:(GELineSegment*)segment;
- (BOOL)endingsContainPoint:(GEVec2)point;
- (NSArray*)segments;
- (GELineSegment*)moveWithPoint:(GEVec2)point;
- (GELineSegment*)moveWithX:(CGFloat)x y:(CGFloat)y;
- (GEVec2)mid;
- (CGFloat)angle;
- (CGFloat)degreeAngle;
- (float)length;
- (GEVec2)vec;
- (GEVec2)vec1;
- (NSString*)description;
- (BOOL)isEqual:(id)to;
- (NSUInteger)hash;
+ (CNClassType*)type;
@end


@interface GEPolygon : GEFigure_impl {
@protected
    NSArray* _points;
    NSArray* _segments;
}
@property (nonatomic, readonly) NSArray* points;
@property (nonatomic, readonly) NSArray* segments;

+ (instancetype)polygonWithPoints:(NSArray*)points;
- (instancetype)initWithPoints:(NSArray*)points;
- (CNClassType*)type;
- (GERect)boundingRect;
- (NSString*)description;
- (BOOL)isEqual:(id)to;
- (NSUInteger)hash;
+ (CNClassType*)type;
@end


@interface GEThickLineSegment : GEFigure_impl {
@protected
    GELineSegment* _segment;
    CGFloat _thickness;
    CGFloat _thickness_2;
    NSArray* __segments;
}
@property (nonatomic, readonly) GELineSegment* segment;
@property (nonatomic, readonly) CGFloat thickness;
@property (nonatomic, readonly) CGFloat thickness_2;

+ (instancetype)thickLineSegmentWithSegment:(GELineSegment*)segment thickness:(CGFloat)thickness;
- (instancetype)initWithSegment:(GELineSegment*)segment thickness:(CGFloat)thickness;
- (CNClassType*)type;
- (GERect)boundingRect;
- (NSArray*)segments;
- (NSString*)description;
- (BOOL)isEqual:(id)to;
- (NSUInteger)hash;
+ (CNClassType*)type;
@end


