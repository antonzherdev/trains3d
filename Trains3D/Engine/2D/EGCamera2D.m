#import "EGCamera2D.h"

#import "EG.h"
@implementation EGCamera2D{
    EGVec2 _size;
    EGVec3 _eyeDirection;
}
static ODClassType* _EGCamera2D_type;
@synthesize size = _size;
@synthesize eyeDirection = _eyeDirection;

+ (id)camera2DWithSize:(EGVec2)size {
    return [[EGCamera2D alloc] initWithSize:size];
}

- (id)initWithSize:(EGVec2)size {
    self = [super init];
    if(self) {
        _size = size;
        _eyeDirection = EGVec3Make(0.0, 0.0, 1.0);
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGCamera2D_type = [ODClassType classTypeWithCls:[EGCamera2D class]];
}

- (CGFloat)factorForViewSize:(EGVec2)viewSize {
    return min(viewSize.x / _size.x, viewSize.y / _size.y);
}

- (EGRect)viewportRectForViewSize:(EGVec2)viewSize {
    return [self viewportRectForViewSize:viewSize factor:[self factorForViewSize:viewSize]];
}

- (EGRect)viewportRectForViewSize:(EGVec2)viewSize factor:(CGFloat)factor {
    return egRectMoveToCenterFor(EGRectMake(0.0, _size.x * factor, 0.0, _size.y * factor), viewSize);
}

- (void)focusForViewSize:(EGVec2)viewSize {
    egViewport(egRectIApply([self viewportRectForViewSize:viewSize]));
    [EG.context clearMatrix];
    [EG.context.projectionMatrix orthoLeft:0.0 right:_size.x bottom:0.0 top:_size.y zNear:0.0 zFar:1.0];
}

- (EGVec2)translateWithViewSize:(EGVec2)viewSize viewPoint:(EGVec2)viewPoint {
    CGFloat factor = [self factorForViewSize:viewSize];
    EGRect viewport = [self viewportRectForViewSize:viewSize factor:factor];
    return egVec2Div(egVec2Sub(viewPoint, egRectPoint(viewport)), factor);
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
    return EGVec2Eq(self.size, o.size);
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + EGVec2Hash(self.size);
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"size=%@", EGVec2Description(self.size)];
    [description appendString:@">"];
    return description;
}

@end


