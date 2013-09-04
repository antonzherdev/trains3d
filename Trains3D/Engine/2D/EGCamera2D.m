#import "EGCamera2D.h"

#import "EG.h"
#import "EGContext.h"
@implementation EGCamera2D{
    EGSize _size;
    EGVec3 _eyeDirection;
}
static ODClassType* _EGCamera2D_type;
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
    _EGCamera2D_type = [ODClassType classTypeWithCls:[EGCamera2D class]];
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
    [[EG context] clearMatrix];
    [[EG context].projectionMatrix orthoLeft:0.0 right:_size.width bottom:0.0 top:_size.height zNear:0.0 zFar:1.0];
}

- (EGVec2)translateWithViewSize:(EGSize)viewSize viewPoint:(EGVec2)viewPoint {
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


