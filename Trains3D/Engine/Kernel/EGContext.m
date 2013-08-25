#import "EGContext.h"

#import "EGTexture.h"
#import "EGMatrix.h"
@implementation EGContext{
    NSMutableDictionary* _textureCache;
    EGMutableMatrix* _modelMatrix;
    EGMutableMatrix* _viewMatrix;
    EGMutableMatrix* _projectionMatrix;
}
@synthesize modelMatrix = _modelMatrix;
@synthesize viewMatrix = _viewMatrix;
@synthesize projectionMatrix = _projectionMatrix;

+ (id)context {
    return [[EGContext alloc] init];
}

- (id)init {
    self = [super init];
    if(self) {
        _textureCache = [NSMutableDictionary mutableDictionary];
        _modelMatrix = [EGMutableMatrix mutableMatrix];
        _viewMatrix = [EGMutableMatrix mutableMatrix];
        _projectionMatrix = [EGMutableMatrix mutableMatrix];
    }
    
    return self;
}

- (EGTexture*)textureForFile:(NSString*)file {
    return ((EGTexture*)([_textureCache objectForKey:file orUpdateWith:^EGTexture*() {
        return [EGTexture textureWithFile:file];
    }]));
}

- (EGMatrix*)mvp {
    return [[[_modelMatrix value] multiply:[_viewMatrix value]] multiply:[_projectionMatrix value]];
}

- (void)clearMatrix {
    [_modelMatrix clear];
    [_viewMatrix clear];
    [_projectionMatrix clear];
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    return YES;
}

- (NSUInteger)hash {
    return 0;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendString:@">"];
    return description;
}

@end


@implementation EGMutableMatrix{
    CNList* __stack;
    EGMatrix* __value;
}

+ (id)mutableMatrix {
    return [[EGMutableMatrix alloc] init];
}

- (id)init {
    self = [super init];
    if(self) {
        __stack = [CNList apply];
        __value = [EGMatrix identity];
    }
    
    return self;
}

- (void)push {
    __stack = [CNList applyObject:__value tail:__stack];
}

- (void)pop {
    __value = ((EGMatrix*)([[__stack head] get]));
    __stack = [__stack tail];
}

- (EGMatrix*)value {
    return __value;
}

- (void)setValue:(EGMatrix*)value {
    __value = value;
}

- (void)setIdentity {
    glLoadIdentity();
    __value = [EGMatrix identity];
}

- (void)clear {
    [self setIdentity];
    __stack = [CNList apply];
}

- (void)rotateAngle:(CGFloat)angle x:(CGFloat)x y:(CGFloat)y z:(CGFloat)z {
    egRotate(angle, x, y, z);
    __value = [__value rotateAngle:angle x:x y:y z:z];
}

- (void)scaleX:(CGFloat)x y:(CGFloat)y z:(CGFloat)z {
    egScale(x, y, z);
    __value = [__value scaleX:x y:y z:z];
}

- (void)translateX:(CGFloat)x y:(CGFloat)y z:(CGFloat)z {
    egTranslate(x, y, z);
    __value = [__value translateX:x y:y z:z];
}

- (void)orthoLeft:(CGFloat)left right:(CGFloat)right bottom:(CGFloat)bottom top:(CGFloat)top zNear:(CGFloat)zNear zFar:(CGFloat)zFar {
    glOrtho(left, right, bottom, top, zNear, zFar);
    __value = [EGMatrix orthoLeft:left right:right bottom:bottom top:top zNear:zNear zFar:zFar];
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendString:@">"];
    return description;
}

@end


