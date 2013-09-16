#import "EGSurface.h"

#import "EGTexture.h"
#import "EGMesh.h"
#import "EGShader.h"
@implementation EGSurface{
    NSUInteger _width;
    NSUInteger _height;
    GLuint _frameBuffer;
    EGTexture* _texture;
    CNLazy* __lazy_fullScreenVertexBuffer;
    CNLazy* __lazy_fullScreenIndexBuffer;
    CNLazy* __lazy_shader;
}
static ODType* _EGSurface_type;
@synthesize width = _width;
@synthesize height = _height;
@synthesize texture = _texture;

+ (id)surfaceWithWidth:(NSUInteger)width height:(NSUInteger)height {
    return [[EGSurface alloc] initWithWidth:width height:height];
}

- (id)initWithWidth:(NSUInteger)width height:(NSUInteger)height {
    self = [super init];
    if(self) {
        _width = width;
        _height = height;
        _frameBuffer = egGenFrameBuffer();
        _texture = [EGTexture texture];
        __lazy_fullScreenVertexBuffer = [CNLazy lazyWithF:^EGVertexBuffer*() {
            return [[EGVertexBuffer applyDataType:geVec2Type()] setData:[ arrs(GEVec2, 8) {0, 0, 1, 0, 1, 1, 0, 1}]];
        }];
        __lazy_fullScreenIndexBuffer = [CNLazy lazyWithF:^EGIndexBuffer*() {
            return [[EGIndexBuffer apply] setData:[ arrui4(6) {0, 1, 2, 2, 3, 0}]];
        }];
        __lazy_shader = [CNLazy lazyWithF:^EGSurfaceShader*() {
            return [EGSurfaceShader surfaceShader];
        }];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGSurface_type = [ODClassType classTypeWithCls:[EGSurface class]];
}

- (EGVertexBuffer*)fullScreenVertexBuffer {
    return [__lazy_fullScreenVertexBuffer get];
}

- (EGIndexBuffer*)fullScreenIndexBuffer {
    return [__lazy_fullScreenIndexBuffer get];
}

- (EGSurfaceShader*)shader {
    return [__lazy_shader get];
}

- (EGSurface*)init {
    glBindFramebuffer(GL_FRAMEBUFFER, _frameBuffer);
    glBindTexture(GL_TEXTURE_2D, _texture.id);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, _width, _height, 0, GL_RGBA, GL_UNSIGNED_BYTE, 0);
    glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, _texture.id, 0);
    glBindTexture(GL_TEXTURE_2D, 0);
    glBindFramebuffer(GL_FRAMEBUFFER, 0);
    return self;
}

- (void)dealloc {
    egDeleteFrameBuffer(_frameBuffer);
}

- (void)applyDraw:(void(^)())draw {
    [self bind];
    ((void(^)())(draw))();
    [self unbind];
}

- (void)bind {
    glPushAttrib(GL_VIEWPORT_BIT);
    glBindFramebuffer(GL_FRAMEBUFFER, _frameBuffer);
    glViewport(0, 0, _width, _height);
}

- (void)unbind {
    glBindFramebuffer(GL_FRAMEBUFFER, 0);
    glPopAttrib();
}

- (void)drawFullScreen {
    [_texture applyDraw:^void() {
        [[self fullScreenVertexBuffer] applyDraw:^void() {
            [[self shader] applyDraw:^void() {
                [[self fullScreenIndexBuffer] draw];
            }];
        }];
    }];
}

- (ODClassType*)type {
    return [EGSurface type];
}

+ (ODType*)type {
    return _EGSurface_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGSurface* o = ((EGSurface*)(other));
    return self.width == o.width && self.height == o.height;
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + self.width;
    hash = hash * 31 + self.height;
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"width=%li", self.width];
    [description appendFormat:@", height=%li", self.height];
    [description appendString:@">"];
    return description;
}

@end


@implementation EGSurfaceShader{
    EGShaderProgram* _program;
    EGShaderAttribute* _positionSlot;
}
static NSString* _EGSurfaceShader_vertex = @"attribute vec2 position;\n"
    "varying vec2 UV;\n"
    "\n"
    "void main(void) {\n"
    "   gl_Position = vec4(2.0*position.x - 1.0, 2.0*position.y - 1.0, 0, 1);\n"
    "   UV = position;\n"
    "}";
static NSString* _EGSurfaceShader_fragment = @"varying vec2 UV;\n"
    "\n"
    "uniform sampler2D texture;\n"
    "\n"
    "void main(void) {\n"
    "   gl_FragColor = texture2D(texture, UV);\n"
    "}";
static ODType* _EGSurfaceShader_type;
@synthesize program = _program;
@synthesize positionSlot = _positionSlot;

+ (id)surfaceShader {
    return [[EGSurfaceShader alloc] init];
}

- (id)init {
    self = [super init];
    if(self) {
        _program = [EGShaderProgram applyVertex:_EGSurfaceShader_vertex fragment:_EGSurfaceShader_fragment];
        _positionSlot = [_program attributeForName:@"position"];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGSurfaceShader_type = [ODClassType classTypeWithCls:[EGSurfaceShader class]];
}

- (void)applyDraw:(void(^)())draw {
    [_program applyDraw:^void() {
        [_positionSlot setFromBufferWithStride:((NSUInteger)(2 * 4)) valuesCount:2 valuesType:GL_FLOAT shift:0];
        ((void(^)())(draw))();
    }];
}

- (ODClassType*)type {
    return [EGSurfaceShader type];
}

+ (NSString*)vertex {
    return _EGSurfaceShader_vertex;
}

+ (NSString*)fragment {
    return _EGSurfaceShader_fragment;
}

+ (ODType*)type {
    return _EGSurfaceShader_type;
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


