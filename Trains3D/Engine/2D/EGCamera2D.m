#import "EGCamera2D.h"

#import "EGGL.h"
@implementation EGCamera2D{
    EGSize _size;
}
@synthesize size = _size;

+ (id)camera2DWithSize:(EGSize)size {
    return [[EGCamera2D alloc] initWithSize:size];
}

- (id)initWithSize:(EGSize)size {
    self = [super init];
    if(self) _size = size;
    
    return self;
}

- (double)factorForViewSize:(EGSize)viewSize {
    return min(viewSize.width / _size.width, viewSize.height / _size.height);
}

- (EGRect)viewportRectForViewSize:(EGSize)viewSize {
    return [self viewportRectForViewSize:viewSize factor:[self factorForViewSize:viewSize]];
}

- (EGRect)viewportRectForViewSize:(EGSize)viewSize factor:(double)factor {
    return egRectMoveToCenterFor(EGRectMake(0, _size.width * factor, 0, _size.height * factor), viewSize);
}

- (void)focusForViewSize:(EGSize)viewSize {
    egViewport(egRectIApply([self viewportRectForViewSize:viewSize]));
    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
    glOrtho(0, _size.width, 0, _size.height, 0, 1);
    glMatrixMode(GL_MODELVIEW);
    glLoadIdentity();
}

- (EGPoint)translateWithViewSize:(EGSize)viewSize viewPoint:(EGPoint)viewPoint {
    double factor = [self factorForViewSize:viewSize];
    EGRect viewport = [self viewportRectForViewSize:viewSize factor:factor];
    return egPointDiv(egPointSub(viewPoint, egRectPoint(viewport)), factor);
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end


