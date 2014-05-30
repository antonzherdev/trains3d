#import "EGContext.h"

#import "EGMatrixModel.h"
#import "EGDirector.h"
#import "EGFont.h"
#import "CNReact.h"
#import "GL.h"
#import "EGMaterial.h"
#import "EGBMFont.h"
#import "EGTTFFont.h"
#import "EGShader.h"
#import "EGVertex.h"
#import "CNChain.h"
#import "EGShadow.h"
#import "GEMat4.h"
#import "CNObserver.h"
@implementation EGGlobal
static EGContext* _EGGlobal_context;
static EGSettings* _EGGlobal_settings;
static EGMatrixStack* _EGGlobal_matrix;
static CNClassType* _EGGlobal_type;

+ (void)initialize {
    [super initialize];
    if(self == [EGGlobal class]) {
        _EGGlobal_type = [CNClassType classTypeWithCls:[EGGlobal class]];
        _EGGlobal_context = [EGContext context];
        _EGGlobal_settings = [EGSettings settings];
        _EGGlobal_matrix = _EGGlobal_context.matrixStack;
    }
}

+ (EGTexture*)compressedTextureForFile:(NSString*)file {
    return [_EGGlobal_context textureForName:file fileFormat:EGTextureFileFormat_compressed format:EGTextureFormat_RGBA8 scale:1.0 filter:EGTextureFilter_linear];
}

+ (EGTexture*)compressedTextureForFile:(NSString*)file filter:(EGTextureFilterR)filter {
    return [_EGGlobal_context textureForName:file fileFormat:EGTextureFileFormat_compressed format:EGTextureFormat_RGBA8 scale:1.0 filter:filter];
}

+ (EGTexture*)textureForFile:(NSString*)file fileFormat:(EGTextureFileFormatR)fileFormat format:(EGTextureFormatR)format filter:(EGTextureFilterR)filter {
    return [_EGGlobal_context textureForName:file fileFormat:fileFormat format:format scale:1.0 filter:filter];
}

+ (EGTexture*)textureForFile:(NSString*)file fileFormat:(EGTextureFileFormatR)fileFormat format:(EGTextureFormatR)format {
    return [EGGlobal textureForFile:file fileFormat:fileFormat format:format filter:EGTextureFilter_linear];
}

+ (EGTexture*)textureForFile:(NSString*)file fileFormat:(EGTextureFileFormatR)fileFormat filter:(EGTextureFilterR)filter {
    return [EGGlobal textureForFile:file fileFormat:fileFormat format:EGTextureFormat_RGBA8 filter:filter];
}

+ (EGTexture*)textureForFile:(NSString*)file fileFormat:(EGTextureFileFormatR)fileFormat {
    return [EGGlobal textureForFile:file fileFormat:fileFormat format:EGTextureFormat_RGBA8 filter:EGTextureFilter_linear];
}

+ (EGTexture*)textureForFile:(NSString*)file format:(EGTextureFormatR)format filter:(EGTextureFilterR)filter {
    return [EGGlobal textureForFile:file fileFormat:EGTextureFileFormat_PNG format:format filter:filter];
}

+ (EGTexture*)textureForFile:(NSString*)file format:(EGTextureFormatR)format {
    return [EGGlobal textureForFile:file fileFormat:EGTextureFileFormat_PNG format:format filter:EGTextureFilter_linear];
}

+ (EGTexture*)textureForFile:(NSString*)file filter:(EGTextureFilterR)filter {
    return [EGGlobal textureForFile:file fileFormat:EGTextureFileFormat_PNG format:EGTextureFormat_RGBA8 filter:filter];
}

+ (EGTexture*)textureForFile:(NSString*)file {
    return [EGGlobal textureForFile:file fileFormat:EGTextureFileFormat_PNG format:EGTextureFormat_RGBA8 filter:EGTextureFilter_linear];
}

+ (EGTexture*)scaledTextureForName:(NSString*)name fileFormat:(EGTextureFileFormatR)fileFormat format:(EGTextureFormatR)format {
    return [_EGGlobal_context textureForName:name fileFormat:fileFormat format:format scale:[[EGDirector current] scale] filter:EGTextureFilter_nearest];
}

+ (EGTexture*)scaledTextureForName:(NSString*)name fileFormat:(EGTextureFileFormatR)fileFormat {
    return [EGGlobal scaledTextureForName:name fileFormat:fileFormat format:EGTextureFormat_RGBA8];
}

+ (EGTexture*)scaledTextureForName:(NSString*)name format:(EGTextureFormatR)format {
    return [EGGlobal scaledTextureForName:name fileFormat:EGTextureFileFormat_PNG format:format];
}

+ (EGTexture*)scaledTextureForName:(NSString*)name {
    return [EGGlobal scaledTextureForName:name fileFormat:EGTextureFileFormat_PNG format:EGTextureFormat_RGBA8];
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

- (CNClassType*)type {
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

+ (CNClassType*)type {
    return _EGGlobal_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation EGContext
static CNClassType* _EGContext_type;
@synthesize viewSize = _viewSize;
@synthesize scaledViewSize = _scaledViewSize;
@synthesize ttf = _ttf;
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

+ (instancetype)context {
    return [[EGContext alloc] init];
}

- (instancetype)init {
    self = [super init];
    if(self) {
        _viewSize = [CNVar varWithInitial:wrap(GEVec2i, (GEVec2iMake(0, 0)))];
        _scaledViewSize = [_viewSize mapF:^id(id _) {
            return wrap(GEVec2, (geVec2iDivF4((uwrap(GEVec2i, _)), ((float)([[EGDirector current] scale])))));
        }];
        _ttf = YES;
        _textureCache = [CNMHashMap hashMap];
        _fontCache = [CNMHashMap hashMap];
        _environment = EGEnvironment.aDefault;
        _matrixStack = [EGMatrixStack matrixStack];
        _renderTarget = [EGSceneRenderTarget sceneRenderTarget];
        _considerShadows = YES;
        _redrawShadows = YES;
        _redrawFrame = YES;
        __viewport = geRectIApplyXYWidthHeight(0.0, 0.0, 0.0, 0.0);
        __lastTexture2D = 0;
        __lastTextures = [CNMHashMap hashMap];
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
        __blendFunctionChanged = NO;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGContext class]) _EGContext_type = [CNClassType classTypeWithCls:[EGContext class]];
}

- (EGTexture*)textureForName:(NSString*)name fileFormat:(EGTextureFileFormatR)fileFormat format:(EGTextureFormatR)format scale:(CGFloat)scale filter:(EGTextureFilterR)filter {
    return [_textureCache applyKey:name orUpdateWith:^EGFileTexture*() {
        return [EGFileTexture fileTextureWithName:name fileFormat:fileFormat format:format scale:scale filter:filter];
    }];
}

- (EGFont*)fontWithName:(NSString*)name {
    return [_fontCache applyKey:name orUpdateWith:^EGFont*() {
        return [EGBMFont fontWithName:name];
    }];
}

- (EGFont*)mainFontWithSize:(NSUInteger)size {
    return [self fontWithName:@"Helvetica" size:size];
}

- (EGFont*)fontWithName:(NSString*)name size:(NSUInteger)size {
    CGFloat scale = [[EGDirector current] scale];
    NSString* nm = [NSString stringWithFormat:@"%@ %lu", name, (unsigned long)((NSUInteger)(size * scale))];
    if(_ttf) return [_fontCache applyKey:nm orUpdateWith:^EGFont*() {
        return [EGTTFFont fontWithName:name size:((NSUInteger)(size * scale))];
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
    if(!(geRectIIsEqualTo(__viewport, viewport))) {
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
    [[EGDirector current] onGLThreadF:^void() {
        egDeleteTexture(id);
        if(__lastTexture2D == id) __lastTexture2D = 0;
        [__lastTextures clear];
    }];
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
    [[EGDirector current] onGLThreadF:^void() {
        egDeleteRenderBuffer(id);
        if(id == __lastRenderBuffer) __lastRenderBuffer = 0;
    }];
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
    [[EGDirector current] onGLThreadF:^void() {
        egDeleteBuffer(id);
        if(id == __lastVertexBufferId) {
            __lastVertexBufferId = 0;
            __lastVertexBufferCount = 0;
        }
        if(id == __lastIndexBuffer) __lastIndexBuffer = 0;
    }];
}

- (void)bindVertexArrayHandle:(unsigned int)handle vertexCount:(unsigned int)vertexCount mutable:(BOOL)mutable {
    if(handle != __lastVertexArray || mutable) {
        __lastVertexArray = handle;
        __lastIndexBuffer = 0;
        egBindVertexArray(handle);
    }
    __needBindDefaultVertexArray = NO;
    __lastVertexBufferCount = vertexCount;
}

- (void)deleteVertexArrayId:(unsigned int)id {
    [[EGDirector current] onGLThreadF:^void() {
        egDeleteVertexArray(id);
        if(id == __lastVertexArray) __lastVertexArray = 0;
    }];
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
    [_depthTest draw];
    if(__blendFunctionChanged) {
        [((EGBlendFunction*)(nonnil(__blendFunctionComing))) bind];
        __blendFunctionChanged = NO;
        __blendFunction = __blendFunctionComing;
    }
    [_blend draw];
}

- (void)clearColorColor:(GEVec4)color {
    if(!(geVec4IsEqualTo(__lastClearColor, color))) {
        __lastClearColor = color;
        glClearColor(color.x, color.y, color.z, color.w);
    }
}

- (EGBlendFunction*)blendFunction {
    return __blendFunction;
}

- (void)setBlendFunction:(EGBlendFunction*)blendFunction {
    __blendFunctionComing = blendFunction;
    __blendFunctionChanged = __blendFunction == nil || !([__blendFunction isEqual:blendFunction]);
}

- (NSString*)description {
    return @"Context";
}

- (CNClassType*)type {
    return [EGContext type];
}

+ (CNClassType*)type {
    return _EGContext_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation EGEnablingState
static CNClassType* _EGEnablingState_type;
@synthesize tp = _tp;

+ (instancetype)enablingStateWithTp:(unsigned int)tp {
    return [[EGEnablingState alloc] initWithTp:tp];
}

- (instancetype)initWithTp:(unsigned int)tp {
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
    if(self == [EGEnablingState class]) _EGEnablingState_type = [CNClassType classTypeWithCls:[EGEnablingState class]];
}

- (BOOL)enable {
    if(!(__coming)) {
        __coming = YES;
        return YES;
    } else {
        return NO;
    }
}

- (BOOL)disable {
    if(__coming) {
        __coming = NO;
        return YES;
    } else {
        return NO;
    }
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
    BOOL changed = [self disable];
    f();
    if(changed) [self enable];
}

- (void)enabledF:(void(^)())f {
    BOOL changed = [self enable];
    f();
    if(changed) [self disable];
}

- (NSString*)description {
    return [NSString stringWithFormat:@"EnablingState(%u)", _tp];
}

- (CNClassType*)type {
    return [EGEnablingState type];
}

+ (CNClassType*)type {
    return _EGEnablingState_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation EGCullFace
static CNClassType* _EGCullFace_type;

+ (instancetype)cullFace {
    return [[EGCullFace alloc] init];
}

- (instancetype)init {
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
    if(self == [EGCullFace class]) _EGCullFace_type = [CNClassType classTypeWithCls:[EGCullFace class]];
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

- (unsigned int)disable {
    unsigned int old = __comingValue;
    __comingValue = GL_NONE;
    return old;
}

- (void)disabledF:(void(^)())f {
    unsigned int oldValue = [self disable];
    f();
    if(oldValue != GL_NONE) [self setValue:oldValue];
}

- (unsigned int)invert {
    unsigned int old = __comingValue;
    __comingValue = ((old == GL_FRONT) ? GL_BACK : GL_FRONT);
    return old;
}

- (void)invertedF:(void(^)())f {
    unsigned int oldValue = [self invert];
    f();
    if(oldValue != GL_NONE) [self setValue:oldValue];
}

- (NSString*)description {
    return @"CullFace";
}

- (CNClassType*)type {
    return [EGCullFace type];
}

+ (CNClassType*)type {
    return _EGCullFace_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation EGRenderTarget
static CNClassType* _EGRenderTarget_type;

+ (instancetype)renderTarget {
    return [[EGRenderTarget alloc] init];
}

- (instancetype)init {
    self = [super init];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGRenderTarget class]) _EGRenderTarget_type = [CNClassType classTypeWithCls:[EGRenderTarget class]];
}

- (BOOL)isShadow {
    return NO;
}

- (NSString*)description {
    return @"RenderTarget";
}

- (CNClassType*)type {
    return [EGRenderTarget type];
}

+ (CNClassType*)type {
    return _EGRenderTarget_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation EGSceneRenderTarget
static CNClassType* _EGSceneRenderTarget_type;

+ (instancetype)sceneRenderTarget {
    return [[EGSceneRenderTarget alloc] init];
}

- (instancetype)init {
    self = [super init];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGSceneRenderTarget class]) _EGSceneRenderTarget_type = [CNClassType classTypeWithCls:[EGSceneRenderTarget class]];
}

- (NSString*)description {
    return @"SceneRenderTarget";
}

- (CNClassType*)type {
    return [EGSceneRenderTarget type];
}

+ (CNClassType*)type {
    return _EGSceneRenderTarget_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation EGShadowRenderTarget
static EGShadowRenderTarget* _EGShadowRenderTarget_default;
static CNClassType* _EGShadowRenderTarget_type;
@synthesize shadowLight = _shadowLight;

+ (instancetype)shadowRenderTargetWithShadowLight:(EGLight*)shadowLight {
    return [[EGShadowRenderTarget alloc] initWithShadowLight:shadowLight];
}

- (instancetype)initWithShadowLight:(EGLight*)shadowLight {
    self = [super init];
    if(self) _shadowLight = shadowLight;
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGShadowRenderTarget class]) {
        _EGShadowRenderTarget_type = [CNClassType classTypeWithCls:[EGShadowRenderTarget class]];
        _EGShadowRenderTarget_default = [EGShadowRenderTarget shadowRenderTargetWithShadowLight:EGLight.aDefault];
    }
}

- (BOOL)isShadow {
    return YES;
}

- (NSString*)description {
    return [NSString stringWithFormat:@"ShadowRenderTarget(%@)", _shadowLight];
}

- (CNClassType*)type {
    return [EGShadowRenderTarget type];
}

+ (EGShadowRenderTarget*)aDefault {
    return _EGShadowRenderTarget_default;
}

+ (CNClassType*)type {
    return _EGShadowRenderTarget_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation EGEnvironment
static EGEnvironment* _EGEnvironment_default;
static CNClassType* _EGEnvironment_type;
@synthesize ambientColor = _ambientColor;
@synthesize lights = _lights;
@synthesize directLights = _directLights;
@synthesize directLightsWithShadows = _directLightsWithShadows;
@synthesize directLightsWithoutShadows = _directLightsWithoutShadows;

+ (instancetype)environmentWithAmbientColor:(GEVec4)ambientColor lights:(NSArray*)lights {
    return [[EGEnvironment alloc] initWithAmbientColor:ambientColor lights:lights];
}

- (instancetype)initWithAmbientColor:(GEVec4)ambientColor lights:(NSArray*)lights {
    self = [super init];
    if(self) {
        _ambientColor = ambientColor;
        _lights = lights;
        _directLights = [[[lights chain] filterCastTo:EGDirectLight.type] toArray];
        _directLightsWithShadows = [[[[lights chain] filterCastTo:EGDirectLight.type] filterWhen:^BOOL(EGDirectLight* _) {
            return ((EGDirectLight*)(_)).hasShadows;
        }] toArray];
        _directLightsWithoutShadows = [[[[lights chain] filterCastTo:EGDirectLight.type] filterWhen:^BOOL(EGDirectLight* _) {
            return !(((EGDirectLight*)(_)).hasShadows);
        }] toArray];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGEnvironment class]) {
        _EGEnvironment_type = [CNClassType classTypeWithCls:[EGEnvironment class]];
        _EGEnvironment_default = [EGEnvironment environmentWithAmbientColor:GEVec4Make(1.0, 1.0, 1.0, 1.0) lights:((NSArray*)((@[])))];
    }
}

+ (EGEnvironment*)applyLights:(NSArray*)lights {
    return [EGEnvironment environmentWithAmbientColor:GEVec4Make(1.0, 1.0, 1.0, 1.0) lights:lights];
}

+ (EGEnvironment*)applyLight:(EGLight*)light {
    return [EGEnvironment environmentWithAmbientColor:GEVec4Make(1.0, 1.0, 1.0, 1.0) lights:(@[light])];
}

- (NSString*)description {
    return [NSString stringWithFormat:@"Environment(%@, %@)", geVec4Description(_ambientColor), _lights];
}

- (CNClassType*)type {
    return [EGEnvironment type];
}

+ (EGEnvironment*)aDefault {
    return _EGEnvironment_default;
}

+ (CNClassType*)type {
    return _EGEnvironment_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation EGLight
static EGLight* _EGLight_default;
static CNClassType* _EGLight_type;
@synthesize color = _color;
@synthesize hasShadows = _hasShadows;

+ (instancetype)lightWithColor:(GEVec4)color hasShadows:(BOOL)hasShadows {
    return [[EGLight alloc] initWithColor:color hasShadows:hasShadows];
}

- (instancetype)initWithColor:(GEVec4)color hasShadows:(BOOL)hasShadows {
    self = [super init];
    if(self) {
        _color = color;
        _hasShadows = hasShadows;
        __lazy_shadowMap = [CNLazy lazyWithF:^EGShadowMap*() {
            return [EGShadowMap shadowMapWithSize:geVec2iApplyVec2((GEVec2Make(2048.0, 2048.0)))];
        }];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGLight class]) {
        _EGLight_type = [CNClassType classTypeWithCls:[EGLight class]];
        _EGLight_default = [EGLight lightWithColor:GEVec4Make(1.0, 1.0, 1.0, 1.0) hasShadows:YES];
    }
}

- (EGShadowMap*)shadowMap {
    return [__lazy_shadowMap get];
}

- (EGMatrixModel*)shadowMatrixModel:(EGMatrixModel*)model {
    @throw [NSString stringWithFormat:@"Shadows are not supported for %@", _EGLight_type];
}

- (NSString*)description {
    return [NSString stringWithFormat:@"Light(%@, %d)", geVec4Description(_color), _hasShadows];
}

- (CNClassType*)type {
    return [EGLight type];
}

+ (EGLight*)aDefault {
    return _EGLight_default;
}

+ (CNClassType*)type {
    return _EGLight_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation EGDirectLight
static CNClassType* _EGDirectLight_type;
@synthesize direction = _direction;
@synthesize shadowsProjectionMatrix = _shadowsProjectionMatrix;

+ (instancetype)directLightWithColor:(GEVec4)color direction:(GEVec3)direction hasShadows:(BOOL)hasShadows shadowsProjectionMatrix:(GEMat4*)shadowsProjectionMatrix {
    return [[EGDirectLight alloc] initWithColor:color direction:direction hasShadows:hasShadows shadowsProjectionMatrix:shadowsProjectionMatrix];
}

- (instancetype)initWithColor:(GEVec4)color direction:(GEVec3)direction hasShadows:(BOOL)hasShadows shadowsProjectionMatrix:(GEMat4*)shadowsProjectionMatrix {
    self = [super initWithColor:color hasShadows:hasShadows];
    if(self) {
        _direction = direction;
        _shadowsProjectionMatrix = shadowsProjectionMatrix;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGDirectLight class]) _EGDirectLight_type = [CNClassType classTypeWithCls:[EGDirectLight class]];
}

+ (EGDirectLight*)applyColor:(GEVec4)color direction:(GEVec3)direction {
    return [EGDirectLight directLightWithColor:color direction:direction hasShadows:NO shadowsProjectionMatrix:[GEMat4 identity]];
}

+ (EGDirectLight*)applyColor:(GEVec4)color direction:(GEVec3)direction shadowsProjectionMatrix:(GEMat4*)shadowsProjectionMatrix {
    return [EGDirectLight directLightWithColor:color direction:direction hasShadows:YES shadowsProjectionMatrix:shadowsProjectionMatrix];
}

- (EGMatrixModel*)shadowMatrixModel:(EGMatrixModel*)model {
    return [[[model mutable] modifyC:^GEMat4*(GEMat4* _) {
        return [GEMat4 lookAtEye:geVec3Negate((geVec3Normalize((geVec4Xyz(([[model w] mulVec4:geVec4ApplyVec3W(_direction, 0.0)])))))) center:GEVec3Make(0.0, 0.0, 0.0) up:GEVec3Make(0.0, 1.0, 0.0)];
    }] modifyP:^GEMat4*(GEMat4* _) {
        return _shadowsProjectionMatrix;
    }];
}

- (NSString*)description {
    return [NSString stringWithFormat:@"DirectLight(%@, %@)", geVec3Description(_direction), _shadowsProjectionMatrix];
}

- (CNClassType*)type {
    return [EGDirectLight type];
}

+ (CNClassType*)type {
    return _EGDirectLight_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

EGShadowType* EGShadowType_Values[4];
EGShadowType* EGShadowType_no_Desc;
EGShadowType* EGShadowType_shadow2d_Desc;
EGShadowType* EGShadowType_sample2d_Desc;
@implementation EGShadowType{
    BOOL _isOn;
}
@synthesize isOn = _isOn;

+ (instancetype)shadowTypeWithOrdinal:(NSUInteger)ordinal name:(NSString*)name isOn:(BOOL)isOn {
    return [[EGShadowType alloc] initWithOrdinal:ordinal name:name isOn:isOn];
}

- (instancetype)initWithOrdinal:(NSUInteger)ordinal name:(NSString*)name isOn:(BOOL)isOn {
    self = [super initWithOrdinal:ordinal name:name];
    if(self) _isOn = isOn;
    
    return self;
}

+ (void)load {
    [super load];
    EGShadowType_no_Desc = [EGShadowType shadowTypeWithOrdinal:0 name:@"no" isOn:NO];
    EGShadowType_shadow2d_Desc = [EGShadowType shadowTypeWithOrdinal:1 name:@"shadow2d" isOn:YES];
    EGShadowType_sample2d_Desc = [EGShadowType shadowTypeWithOrdinal:2 name:@"sample2d" isOn:YES];
    EGShadowType_Values[0] = nil;
    EGShadowType_Values[1] = EGShadowType_no_Desc;
    EGShadowType_Values[2] = EGShadowType_shadow2d_Desc;
    EGShadowType_Values[3] = EGShadowType_sample2d_Desc;
}

- (BOOL)isOff {
    return !(_isOn);
}

+ (NSArray*)values {
    return (@[EGShadowType_no_Desc, EGShadowType_shadow2d_Desc, EGShadowType_sample2d_Desc]);
}

@end

@implementation EGSettings
static CNClassType* _EGSettings_type;
@synthesize shadowTypeChanged = _shadowTypeChanged;

+ (instancetype)settings {
    return [[EGSettings alloc] init];
}

- (instancetype)init {
    self = [super init];
    if(self) {
        _shadowTypeChanged = [CNSignal signal];
        __shadowType = EGShadowType_sample2d;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGSettings class]) _EGSettings_type = [CNClassType classTypeWithCls:[EGSettings class]];
}

- (EGShadowTypeR)shadowType {
    return __shadowType;
}

- (void)setShadowType:(EGShadowTypeR)shadowType {
    if(__shadowType != shadowType) {
        __shadowType = shadowType;
        [_shadowTypeChanged postData:EGShadowType_Values[shadowType]];
    }
}

- (NSString*)description {
    return @"Settings";
}

- (CNClassType*)type {
    return [EGSettings type];
}

+ (CNClassType*)type {
    return _EGSettings_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

