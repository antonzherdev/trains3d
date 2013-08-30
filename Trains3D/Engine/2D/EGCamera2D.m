#import "EGCamera2D.h"

@implementation EGCamera2D{
    EGSize _size;
    EGVec3 _eyeDirection;
}
static ODType* _EGCamera2D_type;
@synthesize size = _size;
@synthesize eyeDirection = _eyeDirection;

+ (id)camera2DWithSize:(EGSize)size {
    return [[EGCamera2D alloc] initWithSize:size];
}

- (id)initWithSize:(EGSize)size {
    self = [super init];
    if(self) {
        _size = size;
        _eyeDirection = EGVec3Make(0.0, 0.0, 1.0);
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGCamera2D_type = [ODType typeWithCls:[EGCamera2D class]];
}

- (CGFloat)factorForViewSize:(EGSize)viewSize {
    return min(viewSize.width / _size.width, viewSize.height / _size.height);
}

- (EGRect)viewportRectForViewSize:(EGSize)viewSize {
    return [self viewportRectForViewSize:viewSize factor:[self factorForViewSize:viewSize]];
}

- (EGRect)viewportRectForViewSize:(EGSize)viewSize factor:(CGFloat)factor {
    return egRectMoveToCenterFor(EGRectMake(0.0, _size.width * factor, 0.0, _size.height * factor), viewSize);
}

- (void)focusForViewSize:(EGSize)viewSize {
    egViewport(egRectIApply([self viewportRectForViewSize:viewSize]));
    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
    glOrtho(0.0, _size.width, 0.0, _size.height, 0.0, 1.0);
    glMatrixMode(GL_MODELVIEW);
    glLoadIdentity();
}

- (EGPoint)translateWithViewSize:(EGSize)viewSize viewPoint:(EGPoint)viewPoint {
    CGFloat factor = [self factorForViewSize:viewSize];
    EGRect viewport = [self viewportRectForViewSize:viewSize factor:factor];
    return egPointDiv(egPointSub(viewPoint, egRectPoint(viewport)), factor);
}

- (ODType*)type {
    return _EGCamera2D_type;
}

+ (ODType*)type {
    return _EGCamera2D_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGCamera2D* o = ((EGCamera2D*)(other));
    return EGSizeEq(self.size, o.size);
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + EGSizeHash(self.size);
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"size=%@", EGSizeDescription(self.size)];
    [description appendString:@">"];
    return description;
}

@end


