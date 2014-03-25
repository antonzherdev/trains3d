#import "EGCamera2D.h"

#import "EGMatrixModel.h"
#import "GEMat4.h"
#import "GL.h"
@implementation EGCamera2D
static ODClassType* _EGCamera2D_type;
@synthesize size = _size;
@synthesize viewportRatio = _viewportRatio;
@synthesize matrixModel = _matrixModel;

+ (instancetype)camera2DWithSize:(GEVec2)size {
    return [[EGCamera2D alloc] initWithSize:size];
}

- (instancetype)initWithSize:(GEVec2)size {
    self = [super init];
    if(self) {
        _size = size;
        _viewportRatio = ((CGFloat)(_size.x / _size.y));
        _matrixModel = [EGImMatrixModel imMatrixModelWithM:[GEMat4 identity] w:[GEMat4 identity] c:[GEMat4 identity] p:[GEMat4 orthoLeft:0.0 right:_size.x bottom:0.0 top:_size.y zNear:-1.0 zFar:1.0]];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGCamera2D class]) _EGCamera2D_type = [ODClassType classTypeWithCls:[EGCamera2D class]];
}

- (NSUInteger)cullFace {
    return ((NSUInteger)(GL_NONE));
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

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"size=%@", GEVec2Description(self.size)];
    [description appendString:@">"];
    return description;
}

@end


