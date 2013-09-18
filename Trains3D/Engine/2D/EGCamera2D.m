#import "EGCamera2D.h"

#import "EGContext.h"
#import "GEMat4.h"
@implementation EGCamera2D{
    GEVec2 _size;
    EGMatrixModel* _matrixModel;
}
static ODClassType* _EGCamera2D_type;
@synthesize size = _size;
@synthesize matrixModel = _matrixModel;

+ (id)camera2DWithSize:(GEVec2)size {
    return [[EGCamera2D alloc] initWithSize:size];
}

- (id)initWithSize:(GEVec2)size {
    self = [super init];
    if(self) {
        _size = size;
        _matrixModel = [EGMatrixModel applyM:[GEMat4 identity] w:[GEMat4 identity] c:[GEMat4 identity] p:[GEMat4 orthoLeft:0.0 right:_size.x bottom:0.0 top:_size.y zNear:-1.0 zFar:1.0]];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGCamera2D_type = [ODClassType classTypeWithCls:[EGCamera2D class]];
}

- (float)factorForViewSize:(GEVec2)viewSize {
    return ((float)(min(((CGFloat)(viewSize.x / _size.x)), ((CGFloat)(viewSize.y / _size.y)))));
}

- (GERecti)viewportWithViewSize:(GEVec2)viewSize {
    return [self viewportWithViewSize:viewSize factor:[self factorForViewSize:viewSize]];
}

- (GERecti)viewportWithViewSize:(GEVec2)viewSize factor:(float)factor {
    return geRectiMoveToCenterForSize(geRectiApplyXYWidthHeight(0.0, 0.0, _size.x * factor, _size.y * factor), viewSize);
}

- (GEVec2)translateWithViewSize:(GEVec2)viewSize viewPoint:(GEVec2)viewPoint {
    float factor = [self factorForViewSize:viewSize];
    GERecti viewport = [self viewportWithViewSize:viewSize factor:factor];
    return geVec2DivValue(geVec2SubVec2(viewPoint, geVec2ApplyVec2i(viewport.origin)), factor);
}

- (void)focusForViewSize:(GEVec2)viewSize {
}

- (ODClassType*)type {
    return [EGCamera2D type];
}

+ (ODClassType*)type {
    return _EGCamera2D_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGCamera2D* o = ((EGCamera2D*)(other));
    return GEVec2Eq(self.size, o.size);
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + GEVec2Hash(self.size);
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"size=%@", GEVec2Description(self.size)];
    [description appendString:@">"];
    return description;
}

@end


