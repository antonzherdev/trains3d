#import "EG.h"

#import "EGDirector.h"
#import "EGTexture.h"
#import "EGMatrix.h"
@implementation EG
static EGContext* _EG_context;
static ODClassType* _EG_type;

+ (id)g {
    return [[EG alloc] init];
}

- (id)init {
    self = [super init];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EG_type = [ODClassType classTypeWithCls:[EG class]];
    _EG_context = [EGContext context];
}

+ (EGDirector*)director {
    return _EG_context.director;
}

+ (EGFileTexture*)textureForFile:(NSString*)file {
    return [_EG_context textureForFile:file];
}

+ (EGMutableMatrix*)projectionMatrix {
    return _EG_context.projectionMatrix;
}

+ (EGMutableMatrix*)cameraMatrix {
    return _EG_context.cameraMatrix;
}

+ (EGMutableMatrix*)worldMatrix {
    return _EG_context.worldMatrix;
}

+ (EGMutableMatrix*)modelMatrix {
    return _EG_context.modelMatrix;
}

+ (void)keepMWF:(void(^)())f {
    [_EG_context.modelMatrix push];
    [_EG_context.worldMatrix push];
    ((void(^)())(f))();
    [_EG_context.modelMatrix pop];
    [_EG_context.worldMatrix pop];
}

- (ODClassType*)type {
    return [EG type];
}

+ (EGContext*)context {
    return _EG_context;
}

+ (ODClassType*)type {
    return _EG_type;
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


@implementation EGContext{
    NSMutableDictionary* _textureCache;
    EGDirector* _director;
    EGVec3 _eyeDirection;
    EGEnvironment* _environment;
    EGMutableMatrix* _modelMatrix;
    EGMutableMatrix* _worldMatrix;
    EGMutableMatrix* _cameraMatrix;
    EGMutableMatrix* _projectionMatrix;
}
static ODClassType* _EGContext_type;
@synthesize director = _director;
@synthesize eyeDirection = _eyeDirection;
@synthesize environment = _environment;
@synthesize modelMatrix = _modelMatrix;
@synthesize worldMatrix = _worldMatrix;
@synthesize cameraMatrix = _cameraMatrix;
@synthesize projectionMatrix = _projectionMatrix;

+ (id)context {
    return [[EGContext alloc] init];
}

- (id)init {
    self = [super init];
    if(self) {
        _textureCache = [NSMutableDictionary mutableDictionary];
        _eyeDirection = EGVec3Make(0.0, 0.0, 0.0);
        _environment = EGEnvironment.aDefault;
        _modelMatrix = [EGMutableMatrix mutableMatrix];
        _worldMatrix = [EGMutableMatrix mutableMatrix];
        _cameraMatrix = [EGMutableMatrix mutableMatrix];
        _projectionMatrix = [EGMutableMatrix mutableMatrix];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGContext_type = [ODClassType classTypeWithCls:[EGContext class]];
}

- (EGFileTexture*)textureForFile:(NSString*)file {
    return ((EGFileTexture*)([_textureCache objectForKey:file orUpdateWith:^EGFileTexture*() {
        return [EGFileTexture fileTextureWithFile:file];
    }]));
}

- (EGMatrix*)m {
    return [_modelMatrix value];
}

- (EGMatrix*)w {
    return [_worldMatrix value];
}

- (EGMatrix*)c {
    return [_cameraMatrix value];
}

- (EGMatrix*)p {
    return [_projectionMatrix value];
}

- (EGMatrix*)mw {
    return [[_worldMatrix value] multiply:[_modelMatrix value]];
}

- (EGMatrix*)mwc {
    return [[_cameraMatrix value] multiply:[[_worldMatrix value] multiply:[_modelMatrix value]]];
}

- (EGMatrix*)mwcp {
    return [[[[_projectionMatrix value] multiply:[_cameraMatrix value]] multiply:[_worldMatrix value]] multiply:[_modelMatrix value]];
}

- (EGMatrix*)cp {
    return [[_projectionMatrix value] multiply:[_cameraMatrix value]];
}

- (EGMatrix*)wcp {
    return [[[_projectionMatrix value] multiply:[_cameraMatrix value]] multiply:[_worldMatrix value]];
}

- (void)clearMatrix {
    [_modelMatrix clear];
    [_worldMatrix clear];
    [_cameraMatrix clear];
    [_projectionMatrix clear];
}

- (ODClassType*)type {
    return [EGContext type];
}

+ (ODClassType*)type {
    return _EGContext_type;
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
static ODClassType* _EGMutableMatrix_type;

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

+ (void)initialize {
    [super initialize];
    _EGMutableMatrix_type = [ODClassType classTypeWithCls:[EGMutableMatrix class]];
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
    __value = [EGMatrix identity];
}

- (void)clear {
    [self setIdentity];
    __stack = [CNList apply];
}

- (void)rotateAngle:(CGFloat)angle x:(CGFloat)x y:(CGFloat)y z:(CGFloat)z {
    __value = [__value rotateAngle:((float)(angle)) x:((float)(x)) y:((float)(y)) z:((float)(z))];
}

- (void)scaleX:(CGFloat)x y:(CGFloat)y z:(CGFloat)z {
    __value = [__value scaleX:((float)(x)) y:((float)(y)) z:((float)(z))];
}

- (void)translateX:(CGFloat)x y:(CGFloat)y z:(CGFloat)z {
    __value = [__value translateX:((float)(x)) y:((float)(y)) z:((float)(z))];
}

- (void)orthoLeft:(CGFloat)left right:(CGFloat)right bottom:(CGFloat)bottom top:(CGFloat)top zNear:(CGFloat)zNear zFar:(CGFloat)zFar {
    __value = [EGMatrix orthoLeft:((float)(left)) right:((float)(right)) bottom:((float)(bottom)) top:((float)(top)) zNear:((float)(zNear)) zFar:((float)(zFar))];
}

- (void)keepF:(void(^)())f {
    [self push];
    ((void(^)())(f))();
    [self pop];
}

- (ODClassType*)type {
    return [EGMutableMatrix type];
}

+ (ODClassType*)type {
    return _EGMutableMatrix_type;
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


