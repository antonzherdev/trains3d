#import "EGContext.h"

#import "EGMatrixModel.h"
#import "EGTexture.h"
#import "EGFont.h"
#import "GL.h"
#import "EGTTFFont.h"
#import "EGShader.h"
#import "EGVertex.h"
#import "EGShadow.h"
#import "GEMat4.h"
@implementation EGGlobal
static EGContext* _EGGlobal_context;
static EGSettings* _EGGlobal_settings;
static EGMatrixStack* _EGGlobal_matrix;
static ODClassType* _EGGlobal_type;

+ (void)initialize {
    [super initialize];
    if(self == [EGGlobal class]) {
        _EGGlobal_type = [ODClassType classTypeWithCls:[EGGlobal class]];
        _EGGlobal_context = [EGContext context];
        _EGGlobal_settings = [EGSettings settings];
        _EGGlobal_matrix = _EGGlobal_context.matrixStack;
    }
}

+ (EGTexture*)textureForFile:(NSString*)file {
    return [_EGGlobal_context textureForName:file fileFormat:EGTextureFileFormat.PNG format:EGTextureFormat.RGBA8888 scale:1.0 filter:EGTextureFilter.linear];
}

+ (EGTexture*)textureForFile:(NSString*)file fileFormat:(EGTextureFileFormat*)fileFormat {
    return [_EGGlobal_context textureForName:file fileFormat:fileFormat format:EGTextureFormat.RGBA8888 scale:1.0 filter:EGTextureFilter.linear];
}

+ (EGTexture*)textureForFile:(NSString*)file filter:(EGTextureFilter*)filter {
    return [_EGGlobal_context textureForName:file fileFormat:EGTextureFileFormat.PNG format:EGTextureFormat.RGBA8888 scale:1.0 filter:filter];
}

+ (EGTexture*)scaledTextureForName:(NSString*)name {
    return [_EGGlobal_context textureForName:name fileFormat:EGTextureFileFormat.PNG format:EGTextureFormat.RGBA8888 scale:_EGGlobal_context.scale filter:EGTextureFilter.nearest];
}

+ (EGFont*)fontWithName:(NSString*)name {
    return [_EGGlobal_context fontWithName:name];
}

+ (EGFont*)fontWithName:(NSString*)name size:(NSUInteger)size {
    return [_EGGlobal_context fontWithName:name size:size];
}

+ (EGFont*)mainFontWithSize:(NSUInteger)size {
    return [_EGGlobal_context mainFontWithSize:size];
}

- (ODClassType*)type {
    return [EGGlobal type];
}

+ (EGContext*)context {
    return _EGGlobal_context;
}

+ (EGSettings*)settings {
    return _EGGlobal_settings;
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
    GEVec2i _viewSize;
    BOOL _ttf;
    CGFloat _scale;
    NSMutableDictionary* _textureCache;
    NSMutableDictionary* _fontCache;
    EGEnvironment* _environment;
    EGMatrixStack* _matrixStack;
    EGRenderTarget* _renderTarget;
    BOOL _considerShadows;
    BOOL _redrawShadows;
    BOOL _redrawFrame;
    GERectI __viewport;
    unsigned int __lastTexture2D;
    NSMutableDictionary* __lastTextures;
    unsigned int __lastShaderProgram;
    unsigned int __lastRenderBuffer;
    unsigned int __lastVertexBufferId;
    unsigned int __lastVertexBufferCount;
    unsigned int __lastIndexBuffer;
    unsigned int __lastVertexArray;
    unsigned int _defaultVertexArray;
    BOOL __needBindDefaultVertexArray;
    EGCullFace* _cullFace;
    EGEnablingState* _blend;
    EGEnablingState* _depthTest;
    GEVec4 __lastClearColor;
}
static ODClassType* _EGContext_type;
@synthesize viewSize = _viewSize;
@synthesize ttf = _ttf;
@synthesize scale = _scale;
@synthesize environment = _environment;
@synthesize matrixStack = _matrixStack;
@synthesize renderTarget = _renderTarget;
@synthesize considerShadows = _considerShadows;
@synthesize redrawShadows = _redrawShadows;
@synthesize redrawFrame = _redrawFrame;
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
        _viewSize = GEVec2iMake(0, 0);
        _ttf = YES;
        _scale = 1.0;
        _textureCache = [NSMutableDictionary mutableDictionary];
        _fontCache = [NSMutableDictionary mutableDictionary];
        _environment = EGEnvironment.aDefault;
        _matrixStack = [EGMatrixStack matrixStack];
        _renderTarget = [EGSceneRenderTarget sceneRenderTarget];
        _considerShadows = YES;
        _redrawShadows = YES;
        _redrawFrame = YES;
        __lastTexture2D = 0;
        __lastTextures = [NSMutableDictionary mutableDictionary];
        __lastShaderProgram = 0;
        __lastRenderBuffer = 0;
        __lastVertexBufferId = 0;
        __lastVertexBufferCount = 0;
        __lastIndexBuffer = 0;
        __lastVertexArray = 0;
        _defaultVertexArray = 0;
        __needBindDefaultVertexArray = NO;
        _cullFace = [EGCullFace cullFace];
        _blend = [EGEnablingState enablingStateWithTp:GL_BLEND];
        _depthTest = [EGEnablingState enablingStateWithTp:GL_DEPTH_TEST];
        __lastClearColor = GEVec4Make(0.0, 0.0, 0.0, 0.0);
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGContext class]) _EGContext_type = [ODClassType classTypeWithCls:[EGContext class]];
}

- (EGTexture*)textureForName:(NSString*)name fileFormat:(EGTextureFileFormat*)fileFormat format:(EGTextureFormat*)format scale:(CGFloat)scale filter:(EGTextureFilter*)filter {
    return [_textureCache objectForKey:name orUpdateWith:^EGFileTexture*() {
        return [EGFileTexture fileTextureWithName:name fileFormat:fileFormat format:format scale:scale filter:filter];
    }];
}

- (EGFont*)fontWithName:(NSString*)name {
    return [_fontCache objectForKey:name orUpdateWith:^EGFont*() {
        return [EGBMFont fontWithName:name];
    }];
}

- (EGFont*)mainFontWithSize:(NSUInteger)size {
    return [self fontWithName:@"Helvetica" size:size];
}

- (EGFont*)fontWithName:(NSString*)name size:(NSUInteger)size {
    NSString* nm = [NSString stringWithFormat:@"%@ %lu", name, (unsigned long)((NSUInteger)(size * _scale))];
    if(_ttf) return [_fontCache objectForKey:nm orUpdateWith:^EGFont*() {
        return [EGTTFFont fontWithName:name size:((NSUInteger)(size * _scale))];
    }];
    else return [self fontWithName:nm];
}

- (void)clear {
    [_matrixStack clear];
    _considerShadows = YES;
    _redrawShadows = YES;
    _redrawFrame = YES;
}

- (void)clearCache {
    [_textureCache clear];
    [_fontCache clear];
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

- (void)bindTextureTextureId:(unsigned int)textureId {
    if(__lastTexture2D != textureId) {
        __lastTexture2D = textureId;
        glBindTexture(GL_TEXTURE_2D, textureId);
    }
}

- (void)bindTextureTexture:(EGTexture*)texture {
    unsigned int id = [texture id];
    if(__lastTexture2D != id) {
        __lastTexture2D = id;
        glBindTexture(GL_TEXTURE_2D, id);
    }
}

- (void)bindTextureSlot:(unsigned int)slot target:(unsigned int)target texture:(EGTexture*)texture {
    unsigned int id = [texture id];
    if(slot == GL_TEXTURE0 && target == GL_TEXTURE_2D) {
        if(__lastTexture2D != id) {
            __lastTexture2D = id;
            glBindTexture(target, id);
        }
    } else {
        unsigned int key = slot * 13 + target;
        if(!([__lastTextures isValueEqualKey:numui4(key) value:numui4(id)])) {
            if(slot != GL_TEXTURE0) {
                glActiveTexture(slot);
                glBindTexture(target, id);
                glActiveTexture(GL_TEXTURE0);
            } else {
                glBindTexture(target, id);
            }
            [__lastTextures setKey:numui4(key) value:numui4(id)];
        }
    }
}

- (void)deleteTextureId:(unsigned int)id {
    egDeleteTexture(id);
    if(__lastTexture2D == id) __lastTexture2D = 0;
    [__lastTextures clear];
}

- (void)bindShaderProgramProgram:(EGShaderProgram*)program {
    unsigned int id = program.handle;
    if(id != __lastShaderProgram) {
        __lastShaderProgram = id;
        glUseProgram(id);
    }
}

- (void)deleteShaderProgramId:(unsigned int)id {
    glDeleteProgram(id);
    if(id == __lastShaderProgram) __lastShaderProgram = 0;
}

- (void)bindRenderBufferId:(unsigned int)id {
    if(id != __lastRenderBuffer) {
        __lastRenderBuffer = id;
        glBindRenderbuffer(GL_RENDERBUFFER, id);
    }
}

- (void)deleteRenderBufferId:(unsigned int)id {
    egDeleteRenderBuffer(id);
    if(id == __lastRenderBuffer) __lastRenderBuffer = 0;
}

- (void)bindVertexBufferBuffer:(id<EGVertexBuffer>)buffer {
    unsigned int handle = [buffer handle];
    if(handle != __lastVertexBufferId) {
        [self checkBindDefaultVertexArray];
        __lastVertexBufferId = handle;
        __lastVertexBufferCount = ((unsigned int)([buffer count]));
        glBindBuffer(GL_ARRAY_BUFFER, handle);
    }
}

- (unsigned int)vertexBufferCount {
    return __lastVertexBufferCount;
}

- (void)bindIndexBufferHandle:(unsigned int)handle {
    if(handle != __lastIndexBuffer) {
        [self checkBindDefaultVertexArray];
        __lastIndexBuffer = handle;
        glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, handle);
    }
}

- (void)deleteBufferId:(unsigned int)id {
    egDeleteBuffer(id);
    if(id == __lastVertexBufferId) {
        __lastVertexBufferId = 0;
        __lastVertexBufferCount = 0;
    }
    if(id == __lastIndexBuffer) __lastIndexBuffer = 0;
}

- (void)bindVertexArrayHandle:(unsigned int)handle vertexCount:(unsigned int)vertexCount mutable:(BOOL)mutable {
    if(handle != __lastVertexArray || mutable) {
        __lastVertexArray = handle;
        __lastVertexBufferId = 0;
        __lastIndexBuffer = 0;
        egBindVertexArray(handle);
    }
    __needBindDefaultVertexArray = NO;
    __lastVertexBufferCount = vertexCount;
}

- (void)deleteVertexArrayId:(unsigned int)id {
    egDeleteVertexArray(id);
    if(id == __lastVertexArray) __lastVertexArray = 0;
}

- (void)bindDefaultVertexArray {
    __needBindDefaultVertexArray = YES;
}

- (void)checkBindDefaultVertexArray {
    if(__needBindDefaultVertexArray) {
        __lastIndexBuffer = 0;
        __lastVertexBufferCount = 0;
        __lastVertexBufferId = 0;
        egBindVertexArray(_defaultVertexArray);
        __needBindDefaultVertexArray = NO;
    }
}

- (void)draw {
    [_cullFace draw];
    [_blend draw];
    [_depthTest draw];
}

- (void)clearColorColor:(GEVec4)color {
    if(!(GEVec4Eq(__lastClearColor, color))) {
        __lastClearColor = color;
        glClearColor(color.x, color.y, color.z, color.w);
    }
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
    if(self == [EGEnablingState class]) _EGEnablingState_type = [ODClassType classTypeWithCls:[EGEnablingState class]];
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
    [description appendFormat:@"tp=%u", self.tp];
    [description appendString:@">"];
    return description;
}

@end


@implementation EGCullFace{
    unsigned int __lastActiveValue;
    unsigned int __value;
    unsigned int __comingValue;
}
static ODClassType* _EGCullFace_type;

+ (id)cullFace {
    return [[EGCullFace alloc] init];
}

- (id)init {
    self = [super init];
    if(self) {
        __lastActiveValue = GL_NONE;
        __value = GL_NONE;
        __comingValue = GL_NONE;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGCullFace class]) _EGCullFace_type = [ODClassType classTypeWithCls:[EGCullFace class]];
}

- (void)setValue:(unsigned int)value {
    __comingValue = value;
}

- (void)draw {
    if(__value != __comingValue) {
        if(__comingValue == GL_NONE) {
            glDisable(GL_CULL_FACE);
            __value = GL_NONE;
        } else {
            if(__value == GL_NONE) glEnable(GL_CULL_FACE);
            if(__lastActiveValue != __comingValue) {
                glCullFace(__comingValue);
                __lastActiveValue = __comingValue;
            }
            __value = __comingValue;
        }
    }
}

- (void)disabledF:(void(^)())f {
    if(__comingValue != GL_NONE) {
        unsigned int cm = __comingValue;
        __comingValue = GL_NONE;
        ((void(^)())(f))();
        __comingValue = cm;
    } else {
        ((void(^)())(f))();
    }
}

- (void)disable {
    __comingValue = GL_NONE;
}

- (void)invertedF:(void(^)())f {
    if(__comingValue != GL_NONE) {
        unsigned int cm = __comingValue;
        __comingValue = ((cm == GL_FRONT) ? GL_BACK : GL_FRONT);
        ((void(^)())(f))();
        __comingValue = cm;
    } else {
        ((void(^)())(f))();
    }
}

- (ODClassType*)type {
    return [EGCullFace type];
}

+ (ODClassType*)type {
    return _EGCullFace_type;
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
    if(self == [EGRenderTarget class]) _EGRenderTarget_type = [ODClassType classTypeWithCls:[EGRenderTarget class]];
}

- (BOOL)isShadow {
    return NO;
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
    if(self == [EGSceneRenderTarget class]) _EGSceneRenderTarget_type = [ODClassType classTypeWithCls:[EGSceneRenderTarget class]];
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
    if(self == [EGShadowRenderTarget class]) {
        _EGShadowRenderTarget_type = [ODClassType classTypeWithCls:[EGShadowRenderTarget class]];
        _EGShadowRenderTarget_default = [EGShadowRenderTarget shadowRenderTargetWithShadowLight:EGLight.aDefault];
    }
}

- (BOOL)isShadow {
    return YES;
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
    id<CNSeq> _directLights;
    id<CNSeq> _directLightsWithShadows;
    id<CNSeq> _directLightsWithoutShadows;
}
static EGEnvironment* _EGEnvironment_default;
static ODClassType* _EGEnvironment_type;
@synthesize ambientColor = _ambientColor;
@synthesize lights = _lights;
@synthesize directLights = _directLights;
@synthesize directLightsWithShadows = _directLightsWithShadows;
@synthesize directLightsWithoutShadows = _directLightsWithoutShadows;

+ (id)environmentWithAmbientColor:(GEVec4)ambientColor lights:(id<CNSeq>)lights {
    return [[EGEnvironment alloc] initWithAmbientColor:ambientColor lights:lights];
}

- (id)initWithAmbientColor:(GEVec4)ambientColor lights:(id<CNSeq>)lights {
    self = [super init];
    if(self) {
        _ambientColor = ambientColor;
        _lights = lights;
        _directLights = [[[_lights chain] filter:^BOOL(EGLight* _) {
            return [((EGLight*)(_)) isKindOfClass:[EGDirectLight class]];
        }] toArray];
        _directLightsWithShadows = [[[_lights chain] filter:^BOOL(EGLight* _) {
            return [((EGLight*)(_)) isKindOfClass:[EGDirectLight class]] && ((EGLight*)(_)).hasShadows;
        }] toArray];
        _directLightsWithoutShadows = [[[_lights chain] filter:^BOOL(EGLight* _) {
            return [((EGLight*)(_)) isKindOfClass:[EGDirectLight class]] && !(((EGLight*)(_)).hasShadows);
        }] toArray];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGEnvironment class]) {
        _EGEnvironment_type = [ODClassType classTypeWithCls:[EGEnvironment class]];
        _EGEnvironment_default = [EGEnvironment environmentWithAmbientColor:GEVec4Make(1.0, 1.0, 1.0, 1.0) lights:(@[])];
    }
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
            return [EGShadowMap shadowMapWithSize:geVec2iApplyVec2(GEVec2Make(2048.0, 2048.0))];
        }];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGLight class]) {
        _EGLight_type = [ODClassType classTypeWithCls:[EGLight class]];
        _EGLight_default = [EGLight lightWithColor:GEVec4Make(1.0, 1.0, 1.0, 1.0) hasShadows:YES];
    }
}

- (EGShadowMap*)shadowMap {
    return [__lazy_shadowMap get];
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
    if(self == [EGDirectLight class]) _EGDirectLight_type = [ODClassType classTypeWithCls:[EGDirectLight class]];
}

+ (EGDirectLight*)applyColor:(GEVec4)color direction:(GEVec3)direction {
    return [EGDirectLight directLightWithColor:color direction:direction hasShadows:NO shadowsProjectionMatrix:[GEMat4 identity]];
}

+ (EGDirectLight*)applyColor:(GEVec4)color direction:(GEVec3)direction shadowsProjectionMatrix:(GEMat4*)shadowsProjectionMatrix {
    return [EGDirectLight directLightWithColor:color direction:direction hasShadows:YES shadowsProjectionMatrix:shadowsProjectionMatrix];
}

- (EGMatrixModel*)shadowMatrixModel:(EGMatrixModel*)model {
    return [[[model mutable] modifyC:^GEMat4*(GEMat4* _) {
        return [GEMat4 lookAtEye:geVec3Negate(geVec3Normalize(geVec4Xyz([[model w] mulVec4:geVec4ApplyVec3W(_direction, 0.0)]))) center:GEVec3Make(0.0, 0.0, 0.0) up:GEVec3Make(0.0, 1.0, 0.0)];
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


@implementation EGSettings{
    EGShadowType* __shadowType;
}
static CNNotificationHandle* _EGSettings_shadowTypeChangedNotification;
static ODClassType* _EGSettings_type;

+ (id)settings {
    return [[EGSettings alloc] init];
}

- (id)init {
    self = [super init];
    if(self) __shadowType = EGShadowType.sample2d;
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGSettings class]) {
        _EGSettings_type = [ODClassType classTypeWithCls:[EGSettings class]];
        _EGSettings_shadowTypeChangedNotification = [CNNotificationHandle notificationHandleWithName:@"shadowTypeChangedNotification"];
    }
}

- (EGShadowType*)shadowType {
    return __shadowType;
}

- (void)setShadowType:(EGShadowType*)shadowType {
    if(__shadowType != shadowType) {
        __shadowType = shadowType;
        [_EGSettings_shadowTypeChangedNotification postSender:self data:shadowType];
    }
}

- (ODClassType*)type {
    return [EGSettings type];
}

+ (CNNotificationHandle*)shadowTypeChangedNotification {
    return _EGSettings_shadowTypeChangedNotification;
}

+ (ODClassType*)type {
    return _EGSettings_type;
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


@implementation EGShadowType{
    BOOL _isOn;
}
static EGShadowType* _EGShadowType_no;
static EGShadowType* _EGShadowType_shadow2d;
static EGShadowType* _EGShadowType_sample2d;
static NSArray* _EGShadowType_values;
@synthesize isOn = _isOn;

+ (id)shadowTypeWithOrdinal:(NSUInteger)ordinal name:(NSString*)name isOn:(BOOL)isOn {
    return [[EGShadowType alloc] initWithOrdinal:ordinal name:name isOn:isOn];
}

- (id)initWithOrdinal:(NSUInteger)ordinal name:(NSString*)name isOn:(BOOL)isOn {
    self = [super initWithOrdinal:ordinal name:name];
    if(self) _isOn = isOn;
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGShadowType_no = [EGShadowType shadowTypeWithOrdinal:0 name:@"no" isOn:NO];
    _EGShadowType_shadow2d = [EGShadowType shadowTypeWithOrdinal:1 name:@"shadow2d" isOn:YES];
    _EGShadowType_sample2d = [EGShadowType shadowTypeWithOrdinal:2 name:@"sample2d" isOn:YES];
    _EGShadowType_values = (@[_EGShadowType_no, _EGShadowType_shadow2d, _EGShadowType_sample2d]);
}

- (BOOL)isOff {
    return !(_isOn);
}

+ (EGShadowType*)no {
    return _EGShadowType_no;
}

+ (EGShadowType*)shadow2d {
    return _EGShadowType_shadow2d;
}

+ (EGShadowType*)sample2d {
    return _EGShadowType_sample2d;
}

+ (NSArray*)values {
    return _EGShadowType_values;
}

@end


