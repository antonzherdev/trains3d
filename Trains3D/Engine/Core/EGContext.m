#import "EGContext.h"

#import "EGDirector.h"
#import "EGTexture.h"
#import "EGFont.h"
#import "EGShader.h"
#import "EGVertex.h"
#import "EGShadow.h"
#import "GEMat4.h"
@implementation EGGlobal
static EGContext* _EGGlobal_context;
static EGMatrixStack* _EGGlobal_matrix;
static ODClassType* _EGGlobal_type;

+ (void)initialize {
    [super initialize];
    _EGGlobal_type = [ODClassType classTypeWithCls:[EGGlobal class]];
    _EGGlobal_context = [EGContext context];
    _EGGlobal_matrix = _EGGlobal_context.matrixStack;
}

+ (EGDirector*)director {
    return _EGGlobal_context.director;
}

+ (EGTexture*)textureForFile:(NSString*)file {
    return [_EGGlobal_context textureForFile:file magFilter:GL_LINEAR minFilter:GL_LINEAR];
}

+ (EGTexture*)nearestTextureForFile:(NSString*)file {
    return [_EGGlobal_context textureForFile:file magFilter:GL_NEAREST minFilter:GL_NEAREST];
}

+ (EGTexture*)textureForFile:(NSString*)file magFilter:(unsigned int)magFilter minFilter:(unsigned int)minFilter {
    return [_EGGlobal_context textureForFile:file magFilter:magFilter minFilter:minFilter];
}

+ (EGFont*)fontWithName:(NSString*)name {
    return [_EGGlobal_context fontWithName:name];
}

- (ODClassType*)type {
    return [EGGlobal type];
}

+ (EGContext*)context {
    return _EGGlobal_context;
}

+ (EGMatrixStack*)matrix {
    return _EGGlobal_matrix;
}

+ (ODClassType*)type {
    return _EGGlobal_type;
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
    GLint _defaultFramebuffer;
    NSMutableDictionary* _textureCache;
    NSMutableDictionary* _fontCache;
    EGDirector* _director;
    EGEnvironment* _environment;
    EGMatrixStack* _matrixStack;
    EGRenderTarget* _renderTarget;
    BOOL _considerShadows;
    CNList* __viewportStack;
    GERectI __viewport;
    GLuint __lastTexture2D;
    GLuint __lastShaderProgram;
    GLuint __lastVertexBufferId;
    unsigned int __lastVertexBufferCount;
    GLuint __lastIndexBuffer;
    GLuint __lastVertexArray;
    GLuint _defaultVertexArray;
    EGEnablingState* _cullFace;
    EGEnablingState* _blend;
    EGEnablingState* _depthTest;
}
static ODClassType* _EGContext_type;
@synthesize defaultFramebuffer = _defaultFramebuffer;
@synthesize director = _director;
@synthesize environment = _environment;
@synthesize matrixStack = _matrixStack;
@synthesize renderTarget = _renderTarget;
@synthesize considerShadows = _considerShadows;
@synthesize defaultVertexArray = _defaultVertexArray;
@synthesize cullFace = _cullFace;
@synthesize blend = _blend;
@synthesize depthTest = _depthTest;

+ (id)context {
    return [[EGContext alloc] init];
}

- (id)init {
    self = [super init];
    if(self) {
        _defaultFramebuffer = 0;
        _textureCache = [NSMutableDictionary mutableDictionary];
        _fontCache = [NSMutableDictionary mutableDictionary];
        _environment = EGEnvironment.aDefault;
        _matrixStack = [EGMatrixStack matrixStack];
        _renderTarget = [EGSceneRenderTarget sceneRenderTarget];
        _considerShadows = YES;
        __viewportStack = [CNList apply];
        __lastTexture2D = 0;
        __lastShaderProgram = 0;
        __lastVertexBufferId = 0;
        __lastVertexBufferCount = 0;
        __lastIndexBuffer = 0;
        __lastVertexArray = 0;
        _defaultVertexArray = 0;
        _cullFace = [EGEnablingState enablingStateWithTp:GL_CULL_FACE];
        _blend = [EGEnablingState enablingStateWithTp:GL_BLEND];
        _depthTest = [EGEnablingState enablingStateWithTp:GL_DEPTH_TEST];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGContext_type = [ODClassType classTypeWithCls:[EGContext class]];
}

- (EGTexture*)textureForFile:(NSString*)file magFilter:(unsigned int)magFilter minFilter:(unsigned int)minFilter {
    return ((EGFileTexture*)([_textureCache objectForKey:tuple3(file, numui4(((unsigned int)(magFilter))), numui4(((unsigned int)(minFilter)))) orUpdateWith:^EGFileTexture*() {
        return [EGFileTexture fileTextureWithFile:file magFilter:magFilter minFilter:minFilter];
    }]));
}

- (EGFont*)fontWithName:(NSString*)name {
    return ((EGFont*)([_fontCache objectForKey:name orUpdateWith:^EGFont*() {
        return [EGFont fontWithName:name];
    }]));
}

- (void)clear {
    [_matrixStack clear];
    _considerShadows = YES;
    __viewport = geRectIApplyXYWidthHeight(0.0, 0.0, 0.0, 0.0);
    __lastTexture2D = 0;
    __lastShaderProgram = 0;
    __lastIndexBuffer = 0;
    __lastVertexBufferId = 0;
    __lastVertexBufferCount = 0;
}

- (GERectI)viewport {
    return __viewport;
}

- (void)setViewport:(GERectI)viewport {
    if(!(GERectIEq(__viewport, viewport))) {
        __viewport = viewport;
        egViewport(viewport);
    }
}

- (void)pushViewport {
    __viewportStack = [CNList applyItem:wrap(GERectI, [self viewport]) tail:__viewportStack];
}

- (void)popViewport {
    [self setViewport:uwrap(GERectI, [__viewportStack head])];
    __viewportStack = [__viewportStack tail];
}

- (void)restoreDefaultFramebuffer {
    glBindFramebuffer(GL_FRAMEBUFFER, _defaultFramebuffer);
}

- (void)bindTextureTexture:(EGTexture*)texture {
    GLuint id = [texture id];
    if(!(GLuintEq(__lastTexture2D, id))) {
        __lastTexture2D = id;
        glBindTexture(GL_TEXTURE_2D, id);
    }
}

- (void)bindTextureSlot:(unsigned int)slot target:(unsigned int)target texture:(EGTexture*)texture {
    GLuint id = [texture id];
    if(slot != GL_TEXTURE0) {
        glActiveTexture(slot);
        glBindTexture(target, id);
        glActiveTexture(GL_TEXTURE0);
    } else {
        if(target == GL_TEXTURE_2D) {
            if(!(GLuintEq(__lastTexture2D, id))) {
                __lastTexture2D = id;
                glBindTexture(target, id);
            }
        } else {
            glBindTexture(target, id);
        }
    }
}

- (void)bindShaderProgramProgram:(EGShaderProgram*)program {
    GLuint id = program.handle;
    if(!(GLuintEq(id, __lastShaderProgram))) {
        __lastShaderProgram = id;
        glUseProgram(id);
    }
}

- (void)bindVertexBufferBuffer:(id<EGVertexBuffer>)buffer {
    GLuint handle = [buffer handle];
    if(!(GLuintEq(handle, __lastVertexBufferId))) {
        __lastVertexBufferId = handle;
        __lastVertexBufferCount = ((unsigned int)([buffer count]));
        glBindBuffer(GL_ARRAY_BUFFER, handle);
    }
}

- (unsigned int)vertexBufferCount {
    return __lastVertexBufferCount;
}

- (void)bindIndexBufferHandle:(GLuint)handle {
    if(!(GLuintEq(handle, __lastIndexBuffer))) {
        __lastIndexBuffer = handle;
        glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, handle);
    }
}

- (void)bindVertexArrayHandle:(GLuint)handle vertexCount:(unsigned int)vertexCount {
    if(!(GLuintEq(handle, __lastVertexArray))) {
        __lastVertexArray = handle;
        __lastVertexBufferCount = vertexCount;
        __lastVertexBufferId = 0;
        __lastIndexBuffer = 0;
        egBindVertexArray(handle);
    }
}

- (void)bindDefaultVertexArray {
    if(!(GLuintEq(__lastVertexArray, _defaultVertexArray))) {
        __lastVertexArray = _defaultVertexArray;
        __lastVertexBufferId = 0;
        __lastIndexBuffer = 0;
        __lastVertexBufferCount = 0;
        egBindVertexArray(_defaultVertexArray);
    }
}

- (void)draw {
    [_cullFace draw];
    [_blend draw];
    [_depthTest draw];
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


@implementation EGEnablingState{
    unsigned int _tp;
    BOOL __last;
    BOOL __coming;
}
static ODClassType* _EGEnablingState_type;
@synthesize tp = _tp;

+ (id)enablingStateWithTp:(unsigned int)tp {
    return [[EGEnablingState alloc] initWithTp:tp];
}

- (id)initWithTp:(unsigned int)tp {
    self = [super init];
    if(self) {
        _tp = tp;
        __last = NO;
        __coming = NO;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGEnablingState_type = [ODClassType classTypeWithCls:[EGEnablingState class]];
}

- (void)enable {
    __coming = YES;
}

- (void)disable {
    __coming = NO;
}

- (void)draw {
    if(__last != __coming) {
        if(__coming) glEnable(_tp);
        else glDisable(_tp);
        __last = __coming;
    }
}

- (void)clear {
    __last = NO;
    __coming = NO;
}

- (void)disabledF:(void(^)())f {
    if(__coming) {
        __coming = NO;
        ((void(^)())(f))();
        __coming = YES;
    } else {
        ((void(^)())(f))();
    }
}

- (void)enabledF:(void(^)())f {
    if(!(__coming)) {
        __coming = YES;
        ((void(^)())(f))();
        __coming = NO;
    } else {
        ((void(^)())(f))();
    }
}

- (ODClassType*)type {
    return [EGEnablingState type];
}

+ (ODClassType*)type {
    return _EGEnablingState_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGEnablingState* o = ((EGEnablingState*)(other));
    return self.tp == o.tp;
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + self.tp;
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"tp=%d", self.tp];
    [description appendString:@">"];
    return description;
}

@end


@implementation EGRenderTarget
static ODClassType* _EGRenderTarget_type;

+ (id)renderTarget {
    return [[EGRenderTarget alloc] init];
}

- (id)init {
    self = [super init];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGRenderTarget_type = [ODClassType classTypeWithCls:[EGRenderTarget class]];
}

- (ODClassType*)type {
    return [EGRenderTarget type];
}

+ (ODClassType*)type {
    return _EGRenderTarget_type;
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


@implementation EGSceneRenderTarget
static ODClassType* _EGSceneRenderTarget_type;

+ (id)sceneRenderTarget {
    return [[EGSceneRenderTarget alloc] init];
}

- (id)init {
    self = [super init];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGSceneRenderTarget_type = [ODClassType classTypeWithCls:[EGSceneRenderTarget class]];
}

- (ODClassType*)type {
    return [EGSceneRenderTarget type];
}

+ (ODClassType*)type {
    return _EGSceneRenderTarget_type;
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


@implementation EGShadowRenderTarget{
    EGLight* _shadowLight;
}
static EGShadowRenderTarget* _EGShadowRenderTarget_default;
static ODClassType* _EGShadowRenderTarget_type;
@synthesize shadowLight = _shadowLight;

+ (id)shadowRenderTargetWithShadowLight:(EGLight*)shadowLight {
    return [[EGShadowRenderTarget alloc] initWithShadowLight:shadowLight];
}

- (id)initWithShadowLight:(EGLight*)shadowLight {
    self = [super init];
    if(self) _shadowLight = shadowLight;
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGShadowRenderTarget_type = [ODClassType classTypeWithCls:[EGShadowRenderTarget class]];
    _EGShadowRenderTarget_default = [EGShadowRenderTarget shadowRenderTargetWithShadowLight:EGLight.aDefault];
}

- (ODClassType*)type {
    return [EGShadowRenderTarget type];
}

+ (EGShadowRenderTarget*)aDefault {
    return _EGShadowRenderTarget_default;
}

+ (ODClassType*)type {
    return _EGShadowRenderTarget_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGShadowRenderTarget* o = ((EGShadowRenderTarget*)(other));
    return [self.shadowLight isEqual:o.shadowLight];
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.shadowLight hash];
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"shadowLight=%@", self.shadowLight];
    [description appendString:@">"];
    return description;
}

@end


@implementation EGEnvironment{
    GEVec4 _ambientColor;
    id<CNSeq> _lights;
}
static EGEnvironment* _EGEnvironment_default;
static ODClassType* _EGEnvironment_type;
@synthesize ambientColor = _ambientColor;
@synthesize lights = _lights;

+ (id)environmentWithAmbientColor:(GEVec4)ambientColor lights:(id<CNSeq>)lights {
    return [[EGEnvironment alloc] initWithAmbientColor:ambientColor lights:lights];
}

- (id)initWithAmbientColor:(GEVec4)ambientColor lights:(id<CNSeq>)lights {
    self = [super init];
    if(self) {
        _ambientColor = ambientColor;
        _lights = lights;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGEnvironment_type = [ODClassType classTypeWithCls:[EGEnvironment class]];
    _EGEnvironment_default = [EGEnvironment environmentWithAmbientColor:GEVec4Make(1.0, 1.0, 1.0, 1.0) lights:(@[])];
}

+ (EGEnvironment*)applyLights:(id<CNSeq>)lights {
    return [EGEnvironment environmentWithAmbientColor:GEVec4Make(1.0, 1.0, 1.0, 1.0) lights:lights];
}

+ (EGEnvironment*)applyLight:(EGLight*)light {
    return [EGEnvironment environmentWithAmbientColor:GEVec4Make(1.0, 1.0, 1.0, 1.0) lights:(@[light])];
}

- (ODClassType*)type {
    return [EGEnvironment type];
}

+ (EGEnvironment*)aDefault {
    return _EGEnvironment_default;
}

+ (ODClassType*)type {
    return _EGEnvironment_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGEnvironment* o = ((EGEnvironment*)(other));
    return GEVec4Eq(self.ambientColor, o.ambientColor) && [self.lights isEqual:o.lights];
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + GEVec4Hash(self.ambientColor);
    hash = hash * 31 + [self.lights hash];
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"ambientColor=%@", GEVec4Description(self.ambientColor)];
    [description appendFormat:@", lights=%@", self.lights];
    [description appendString:@">"];
    return description;
}

@end


@implementation EGLight{
    GEVec4 _color;
    BOOL _hasShadows;
    CNLazy* __lazy_shadowMap;
}
static EGLight* _EGLight_default;
static ODClassType* _EGLight_type;
@synthesize color = _color;
@synthesize hasShadows = _hasShadows;

+ (id)lightWithColor:(GEVec4)color hasShadows:(BOOL)hasShadows {
    return [[EGLight alloc] initWithColor:color hasShadows:hasShadows];
}

- (id)initWithColor:(GEVec4)color hasShadows:(BOOL)hasShadows {
    self = [super init];
    if(self) {
        _color = color;
        _hasShadows = hasShadows;
        __lazy_shadowMap = [CNLazy lazyWithF:^EGShadowMap*() {
            return [EGShadowMap shadowMapWithSize:geVec2iApplyVec2(GEVec2Make(1024.0, 1024.0))];
        }];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGLight_type = [ODClassType classTypeWithCls:[EGLight class]];
    _EGLight_default = [EGLight lightWithColor:GEVec4Make(1.0, 1.0, 1.0, 1.0) hasShadows:YES];
}

- (EGShadowMap*)shadowMap {
    return ((EGShadowMap*)([__lazy_shadowMap get]));
}

- (EGMatrixModel*)shadowMatrixModel:(EGMatrixModel*)model {
    @throw [NSString stringWithFormat:@"Shadows are not supported for %@", _EGLight_type];
}

- (ODClassType*)type {
    return [EGLight type];
}

+ (EGLight*)aDefault {
    return _EGLight_default;
}

+ (ODClassType*)type {
    return _EGLight_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGLight* o = ((EGLight*)(other));
    return GEVec4Eq(self.color, o.color) && self.hasShadows == o.hasShadows;
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + GEVec4Hash(self.color);
    hash = hash * 31 + self.hasShadows;
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"color=%@", GEVec4Description(self.color)];
    [description appendFormat:@", hasShadows=%d", self.hasShadows];
    [description appendString:@">"];
    return description;
}

@end


@implementation EGDirectLight{
    GEVec3 _direction;
    GEMat4* _shadowsProjectionMatrix;
}
static ODClassType* _EGDirectLight_type;
@synthesize direction = _direction;
@synthesize shadowsProjectionMatrix = _shadowsProjectionMatrix;

+ (id)directLightWithColor:(GEVec4)color direction:(GEVec3)direction hasShadows:(BOOL)hasShadows shadowsProjectionMatrix:(GEMat4*)shadowsProjectionMatrix {
    return [[EGDirectLight alloc] initWithColor:color direction:direction hasShadows:hasShadows shadowsProjectionMatrix:shadowsProjectionMatrix];
}

- (id)initWithColor:(GEVec4)color direction:(GEVec3)direction hasShadows:(BOOL)hasShadows shadowsProjectionMatrix:(GEMat4*)shadowsProjectionMatrix {
    self = [super initWithColor:color hasShadows:hasShadows];
    if(self) {
        _direction = direction;
        _shadowsProjectionMatrix = shadowsProjectionMatrix;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGDirectLight_type = [ODClassType classTypeWithCls:[EGDirectLight class]];
}

+ (EGDirectLight*)applyColor:(GEVec4)color direction:(GEVec3)direction {
    return [EGDirectLight directLightWithColor:color direction:direction hasShadows:NO shadowsProjectionMatrix:[GEMat4 identity]];
}

+ (EGDirectLight*)applyColor:(GEVec4)color direction:(GEVec3)direction shadowsProjectionMatrix:(GEMat4*)shadowsProjectionMatrix {
    return [EGDirectLight directLightWithColor:color direction:direction hasShadows:YES shadowsProjectionMatrix:shadowsProjectionMatrix];
}

- (EGMatrixModel*)shadowMatrixModel:(EGMatrixModel*)model {
    return [[model modifyC:^GEMat4*(GEMat4* _) {
        return [GEMat4 lookAtEye:geVec3Negate(geVec3Normalize(geVec4Xyz([model.w mulVec4:geVec4ApplyVec3W(_direction, 0.0)]))) center:GEVec3Make(0.0, 0.0, 0.0) up:GEVec3Make(0.0, 1.0, 0.0)];
    }] modifyP:^GEMat4*(GEMat4* _) {
        return _shadowsProjectionMatrix;
    }];
}

- (ODClassType*)type {
    return [EGDirectLight type];
}

+ (ODClassType*)type {
    return _EGDirectLight_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGDirectLight* o = ((EGDirectLight*)(other));
    return GEVec4Eq(self.color, o.color) && GEVec3Eq(self.direction, o.direction) && self.hasShadows == o.hasShadows && [self.shadowsProjectionMatrix isEqual:o.shadowsProjectionMatrix];
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + GEVec4Hash(self.color);
    hash = hash * 31 + GEVec3Hash(self.direction);
    hash = hash * 31 + self.hasShadows;
    hash = hash * 31 + [self.shadowsProjectionMatrix hash];
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"color=%@", GEVec4Description(self.color)];
    [description appendFormat:@", direction=%@", GEVec3Description(self.direction)];
    [description appendFormat:@", hasShadows=%d", self.hasShadows];
    [description appendFormat:@", shadowsProjectionMatrix=%@", self.shadowsProjectionMatrix];
    [description appendString:@">"];
    return description;
}

@end


@implementation EGMatrixStack{
    CNList* _stack;
    EGMatrixModel* _value;
}
static ODClassType* _EGMatrixStack_type;
@synthesize value = _value;

+ (id)matrixStack {
    return [[EGMatrixStack alloc] init];
}

- (id)init {
    self = [super init];
    if(self) {
        _stack = [CNList apply];
        _value = EGMatrixModel.identity;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGMatrixStack_type = [ODClassType classTypeWithCls:[EGMatrixStack class]];
}

- (void)clear {
    _value = EGMatrixModel.identity;
    _stack = [CNList apply];
}

- (void)push {
    _stack = [CNList applyItem:_value tail:_stack];
}

- (void)pop {
    _value = ((EGMatrixModel*)([_stack head]));
    _stack = [_stack tail];
}

- (void)applyModify:(EGMatrixModel*(^)(EGMatrixModel*))modify f:(void(^)())f {
    [self push];
    _value = modify(_value);
    ((void(^)())(f))();
    [self pop];
}

- (GEMat4*)m {
    return _value.m;
}

- (GEMat4*)w {
    return _value.w;
}

- (GEMat4*)c {
    return _value.c;
}

- (GEMat4*)p {
    return _value.p;
}

- (GEMat4*)mw {
    return [_value mw];
}

- (GEMat4*)mwc {
    return [_value mwc];
}

- (GEMat4*)mwcp {
    return [_value mwcp];
}

- (GEMat4*)wc {
    return [_value wc];
}

- (GEMat4*)wcp {
    return [_value wcp];
}

- (GEMat4*)cp {
    return [_value cp];
}

- (ODClassType*)type {
    return [EGMatrixStack type];
}

+ (ODClassType*)type {
    return _EGMatrixStack_type;
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


@implementation EGMatrixModel{
    GEMat4* _m;
    GEMat4* _w;
    GEMat4* _c;
    GEMat4* _p;
    CNLazy* __mw;
    CNLazy* __mwc;
    CNLazy* __mwcp;
    CNLazy* __cp;
    CNLazy* __wcp;
    CNLazy* __wc;
}
static EGMatrixModel* _EGMatrixModel_identity;
static ODClassType* _EGMatrixModel_type;
@synthesize m = _m;
@synthesize w = _w;
@synthesize c = _c;
@synthesize p = _p;
@synthesize _mw = __mw;
@synthesize _mwc = __mwc;
@synthesize _mwcp = __mwcp;
@synthesize _cp = __cp;
@synthesize _wcp = __wcp;
@synthesize _wc = __wc;

+ (id)matrixModelWithM:(GEMat4*)m w:(GEMat4*)w c:(GEMat4*)c p:(GEMat4*)p _mw:(CNLazy*)_mw _mwc:(CNLazy*)_mwc _mwcp:(CNLazy*)_mwcp _cp:(CNLazy*)_cp _wcp:(CNLazy*)_wcp _wc:(CNLazy*)_wc {
    return [[EGMatrixModel alloc] initWithM:m w:w c:c p:p _mw:_mw _mwc:_mwc _mwcp:_mwcp _cp:_cp _wcp:_wcp _wc:_wc];
}

- (id)initWithM:(GEMat4*)m w:(GEMat4*)w c:(GEMat4*)c p:(GEMat4*)p _mw:(CNLazy*)_mw _mwc:(CNLazy*)_mwc _mwcp:(CNLazy*)_mwcp _cp:(CNLazy*)_cp _wcp:(CNLazy*)_wcp _wc:(CNLazy*)_wc {
    self = [super init];
    if(self) {
        _m = m;
        _w = w;
        _c = c;
        _p = p;
        __mw = _mw;
        __mwc = _mwc;
        __mwcp = _mwcp;
        __cp = _cp;
        __wcp = _wcp;
        __wc = _wc;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGMatrixModel_type = [ODClassType classTypeWithCls:[EGMatrixModel class]];
    _EGMatrixModel_identity = [EGMatrixModel applyM:[GEMat4 identity] w:[GEMat4 identity] c:[GEMat4 identity] p:[GEMat4 identity]];
}

+ (EGMatrixModel*)applyM:(GEMat4*)m w:(GEMat4*)w c:(GEMat4*)c p:(GEMat4*)p {
    CNLazy* _mw = [CNLazy lazyWithF:^GEMat4*() {
        return [w mulMatrix:m];
    }];
    CNLazy* _mwc = [CNLazy lazyWithF:^GEMat4*() {
        return [c mulMatrix:((GEMat4*)([_mw get]))];
    }];
    CNLazy* _cp = [CNLazy lazyWithF:^GEMat4*() {
        return [p mulMatrix:c];
    }];
    CNLazy* _mwcp = [CNLazy lazyWithF:^GEMat4*() {
        return [((GEMat4*)([_cp get])) mulMatrix:((GEMat4*)([_mw get]))];
    }];
    CNLazy* _wc = [CNLazy lazyWithF:^GEMat4*() {
        return [c mulMatrix:w];
    }];
    CNLazy* _wcp = [CNLazy lazyWithF:^GEMat4*() {
        return [p mulMatrix:((GEMat4*)([_wc get]))];
    }];
    return [EGMatrixModel matrixModelWithM:m w:w c:c p:p _mw:_mw _mwc:_mwc _mwcp:_mwcp _cp:_cp _wcp:_wcp _wc:_wc];
}

- (GEMat4*)mw {
    return ((GEMat4*)([__mw get]));
}

- (GEMat4*)mwc {
    return ((GEMat4*)([__mwc get]));
}

- (GEMat4*)mwcp {
    return ((GEMat4*)([__mwcp get]));
}

- (GEMat4*)cp {
    return ((GEMat4*)([__cp get]));
}

- (GEMat4*)wcp {
    return ((GEMat4*)([__wcp get]));
}

- (GEMat4*)wc {
    return ((GEMat4*)([__wc get]));
}

- (EGMatrixModel*)modifyM:(GEMat4*(^)(GEMat4*))m {
    GEMat4* mm = m(_m);
    CNLazy* _mw = [CNLazy lazyWithF:^GEMat4*() {
        return [_w mulMatrix:mm];
    }];
    CNLazy* _mwc = [CNLazy lazyWithF:^GEMat4*() {
        return [_c mulMatrix:((GEMat4*)([_mw get]))];
    }];
    CNLazy* _mwcp = [CNLazy lazyWithF:^GEMat4*() {
        return [((GEMat4*)([__cp get])) mulMatrix:((GEMat4*)([_mw get]))];
    }];
    return [EGMatrixModel matrixModelWithM:mm w:_w c:_c p:_p _mw:_mw _mwc:_mwc _mwcp:_mwcp _cp:__cp _wcp:__wcp _wc:__wc];
}

- (EGMatrixModel*)modifyW:(GEMat4*(^)(GEMat4*))w {
    GEMat4* ww = w(_w);
    CNLazy* _mw = [CNLazy lazyWithF:^GEMat4*() {
        return [ww mulMatrix:_m];
    }];
    CNLazy* _mwc = [CNLazy lazyWithF:^GEMat4*() {
        return [_c mulMatrix:((GEMat4*)([_mw get]))];
    }];
    CNLazy* _mwcp = [CNLazy lazyWithF:^GEMat4*() {
        return [((GEMat4*)([__cp get])) mulMatrix:((GEMat4*)([_mw get]))];
    }];
    CNLazy* _wc = [CNLazy lazyWithF:^GEMat4*() {
        return [_c mulMatrix:ww];
    }];
    CNLazy* _wcp = [CNLazy lazyWithF:^GEMat4*() {
        return [_p mulMatrix:((GEMat4*)([_wc get]))];
    }];
    return [EGMatrixModel matrixModelWithM:_m w:ww c:_c p:_p _mw:_mw _mwc:_mwc _mwcp:_mwcp _cp:__cp _wcp:_wcp _wc:_wc];
}

- (EGMatrixModel*)modifyC:(GEMat4*(^)(GEMat4*))c {
    GEMat4* cc = c(_c);
    CNLazy* _mwc = [CNLazy lazyWithF:^GEMat4*() {
        return [cc mulMatrix:((GEMat4*)([__mw get]))];
    }];
    CNLazy* _cp = [CNLazy lazyWithF:^GEMat4*() {
        return [_p mulMatrix:cc];
    }];
    CNLazy* _mwcp = [CNLazy lazyWithF:^GEMat4*() {
        return [((GEMat4*)([_cp get])) mulMatrix:((GEMat4*)([__mw get]))];
    }];
    CNLazy* _wc = [CNLazy lazyWithF:^GEMat4*() {
        return [cc mulMatrix:_w];
    }];
    CNLazy* _wcp = [CNLazy lazyWithF:^GEMat4*() {
        return [_p mulMatrix:((GEMat4*)([_wc get]))];
    }];
    return [EGMatrixModel matrixModelWithM:_m w:_w c:cc p:_p _mw:__mw _mwc:_mwc _mwcp:_mwcp _cp:_cp _wcp:_wcp _wc:_wc];
}

- (EGMatrixModel*)modifyP:(GEMat4*(^)(GEMat4*))p {
    GEMat4* pp = p(_p);
    CNLazy* _cp = [CNLazy lazyWithF:^GEMat4*() {
        return [pp mulMatrix:_c];
    }];
    CNLazy* _mwcp = [CNLazy lazyWithF:^GEMat4*() {
        return [((GEMat4*)([_cp get])) mulMatrix:((GEMat4*)([__mw get]))];
    }];
    CNLazy* _wcp = [CNLazy lazyWithF:^GEMat4*() {
        return [pp mulMatrix:((GEMat4*)([__wc get]))];
    }];
    return [EGMatrixModel matrixModelWithM:_m w:_w c:_c p:pp _mw:__mw _mwc:__mwc _mwcp:_mwcp _cp:_cp _wcp:_wcp _wc:__wc];
}

- (ODClassType*)type {
    return [EGMatrixModel type];
}

+ (EGMatrixModel*)identity {
    return _EGMatrixModel_identity;
}

+ (ODClassType*)type {
    return _EGMatrixModel_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGMatrixModel* o = ((EGMatrixModel*)(other));
    return [self.m isEqual:o.m] && [self.w isEqual:o.w] && [self.c isEqual:o.c] && [self.p isEqual:o.p] && [self._mw isEqual:o._mw] && [self._mwc isEqual:o._mwc] && [self._mwcp isEqual:o._mwcp] && [self._cp isEqual:o._cp] && [self._wcp isEqual:o._wcp] && [self._wc isEqual:o._wc];
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.m hash];
    hash = hash * 31 + [self.w hash];
    hash = hash * 31 + [self.c hash];
    hash = hash * 31 + [self.p hash];
    hash = hash * 31 + [self._mw hash];
    hash = hash * 31 + [self._mwc hash];
    hash = hash * 31 + [self._mwcp hash];
    hash = hash * 31 + [self._cp hash];
    hash = hash * 31 + [self._wcp hash];
    hash = hash * 31 + [self._wc hash];
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"m=%@", self.m];
    [description appendFormat:@", w=%@", self.w];
    [description appendFormat:@", c=%@", self.c];
    [description appendFormat:@", p=%@", self.p];
    [description appendFormat:@", _mw=%@", self._mw];
    [description appendFormat:@", _mwc=%@", self._mwc];
    [description appendFormat:@", _mwcp=%@", self._mwcp];
    [description appendFormat:@", _cp=%@", self._cp];
    [description appendFormat:@", _wcp=%@", self._wcp];
    [description appendFormat:@", _wc=%@", self._wc];
    [description appendString:@">"];
    return description;
}

@end


