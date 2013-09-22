#import "EGFont.h"

#import "EGMesh.h"
#import "EGTexture.h"
#import "GL.h"
#import "EGContext.h"
@implementation EGFont{
    NSString* _name;
    unsigned int _size;
    EGFileTexture* _texture;
    id<CNMap> _symbols;
    NSUInteger _height;
    EGVertexBuffer* _vb;
    EGIndexBuffer* _ib;
    EGMesh* _mesh;
}
static EGVertexBufferDesc* _EGFont_vbDesc;
static ODClassType* _EGFont_type;
@synthesize name = _name;
@synthesize size = _size;

+ (id)fontWithName:(NSString*)name size:(unsigned int)size {
    return [[EGFont alloc] initWithName:name size:size];
}

- (id)initWithName:(NSString*)name size:(unsigned int)size {
    self = [super init];
    if(self) {
        _name = name;
        _size = size;
        _texture = [EGFileTexture fileTextureWithFile:[NSString stringWithFormat:@"%@_%d.png", _name, _size] magFilter:GL_NEAREST minFilter:GL_NEAREST];
        _vb = [EGVertexBuffer applyDesc:_EGFont_vbDesc];
        _ib = [EGIndexBuffer apply];
        _mesh = [EGMesh meshWithVertexBuffer:_vb indexBuffer:_ib];
        [self _init];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGFont_type = [ODClassType classTypeWithCls:[EGFont class]];
    _EGFont_vbDesc = [EGVertexBufferDesc vertexBufferDescWithDataType:egFontPrintDataType() position:0 uv:((int)(2 * 4)) normal:-1 color:-1 model:-1];
}

- (void)_init {
    CNXMLElement* font = [CNXML fileName:[NSString stringWithFormat:@"%@_%d.xml", _name, _size]];
    _height = [[[font applyName:@"height"] get] toUInt];
    GEVec2 ts = [_texture size];
    _symbols = [[[[font children] chain] map:^CNTuple*(CNXMLElement* ch) {
        unichar code = unums([[[[ch applyName:@"code"] get] head] getOrValue:@0]);
        float width = unumf4([[ch applyName:@"width"] get]);
        GEVec2i offset = [self parseOffset:[[ch applyName:@"offset"] get]];
        GERect r = [self parse_rect:[[ch applyName:@"rect"] get]];
        return tuple(nums(code), [EGFontSymbolDesc fontSymbolDescWithWidth:width offset:geVec2ApplyVec2i(offset) size:r.size textureRect:geRectDivVec2(r, ts)]);
    }] toMap];
}

- (GEVec2i)parseOffset:(NSString*)offset {
    CNTuple* t = ((CNTuple*)([[offset tupleBy:@" "] get]));
    return GEVec2iMake(unumi(t.a), unumi(t.b));
}

- (GERect)parse_rect:(NSString*)_rect {
    id<CNSeq> parts = [[[_rect splitBy:@" "] chain] toArray];
    CGFloat y = [[parts applyIndex:1] toFloat];
    CGFloat h = [[parts applyIndex:3] toFloat];
    return geRectApplyXYWidthHeight(((float)([[parts applyIndex:0] toFloat])), ((float)(y)), ((float)([[parts applyIndex:2] toFloat])), ((float)(h)));
}

- (void)drawText:(NSString*)text at:(GEVec2)at color:(GEVec4)color {
    id<CNSeq> symbolsArr = [[[text chain] flatMap:^id(id _) {
        return [_symbols applyKey:_];
    }] toArray];
    CNVoidRefArray vertexes = cnVoidRefArrayApplyTpCount(egFontPrintDataType(), [symbolsArr count] * 4);
    CNVoidRefArray indexes = cnVoidRefArrayApplyTpCount(oduInt4Type(), [symbolsArr count] * 6);
    GEVec2 vpSize = geVec2iDivF([EGGlobal.context viewport].size, 2.0);
    __block CNVoidRefArray vp = vertexes;
    __block CNVoidRefArray ip = indexes;
    __block float x = at.x;
    __block NSInteger n = 0;
    float h = ((float)(_height)) / vpSize.y;
    [symbolsArr forEach:^void(EGFontSymbolDesc* s) {
        GEVec2 size = geVec2DivVec2(s.size, vpSize);
        GERect tr = s.textureRect;
        GEVec2 v0 = GEVec2Make(x + s.offset.x / vpSize.x, at.y + h - s.offset.y / vpSize.y);
        vp = cnVoidRefArrayWriteTpItem(vp, GEVec2, v0);
        vp = cnVoidRefArrayWriteTpItem(vp, GEVec2, geRectLeftBottom(tr));
        vp = cnVoidRefArrayWriteTpItem(vp, GEVec2, GEVec2Make(v0.x, v0.y - size.y));
        vp = cnVoidRefArrayWriteTpItem(vp, GEVec2, geRectLeftTop(tr));
        vp = cnVoidRefArrayWriteTpItem(vp, GEVec2, GEVec2Make(v0.x + size.x, v0.y - size.y));
        vp = cnVoidRefArrayWriteTpItem(vp, GEVec2, geRectRightTop(tr));
        vp = cnVoidRefArrayWriteTpItem(vp, GEVec2, GEVec2Make(v0.x + size.x, v0.y));
        vp = cnVoidRefArrayWriteTpItem(vp, GEVec2, geRectRightBottom(tr));
        ip = cnVoidRefArrayWriteUInt4(ip, ((unsigned int)(n)));
        ip = cnVoidRefArrayWriteUInt4(ip, ((unsigned int)(n + 1)));
        ip = cnVoidRefArrayWriteUInt4(ip, ((unsigned int)(n + 2)));
        ip = cnVoidRefArrayWriteUInt4(ip, ((unsigned int)(n + 2)));
        ip = cnVoidRefArrayWriteUInt4(ip, ((unsigned int)(n + 3)));
        ip = cnVoidRefArrayWriteUInt4(ip, ((unsigned int)(n)));
        x += s.width / vpSize.x;
        n += 4;
    }];
    [_vb setArray:vertexes usage:GL_DYNAMIC_DRAW];
    [_ib setArray:indexes usage:GL_DYNAMIC_DRAW];
    egBlendFunctionApplyDraw(egBlendFunctionStandard(), ^void() {
        glDisable(GL_CULL_FACE);
        [EGFontShader.instance drawParam:[EGFontShaderParam fontShaderParamWithTexture:_texture color:color] mesh:_mesh];
        glEnable(GL_CULL_FACE);
    });
}

- (ODClassType*)type {
    return [EGFont type];
}

+ (ODClassType*)type {
    return _EGFont_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGFont* o = ((EGFont*)(other));
    return [self.name isEqual:o.name] && self.size == o.size;
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.name hash];
    hash = hash * 31 + self.size;
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"name=%@", self.name];
    [description appendFormat:@", size=%d", self.size];
    [description appendString:@">"];
    return description;
}

@end


@implementation EGFontShaderParam{
    EGTexture* _texture;
    GEVec4 _color;
}
static ODClassType* _EGFontShaderParam_type;
@synthesize texture = _texture;
@synthesize color = _color;

+ (id)fontShaderParamWithTexture:(EGTexture*)texture color:(GEVec4)color {
    return [[EGFontShaderParam alloc] initWithTexture:texture color:color];
}

- (id)initWithTexture:(EGTexture*)texture color:(GEVec4)color {
    self = [super init];
    if(self) {
        _texture = texture;
        _color = color;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGFontShaderParam_type = [ODClassType classTypeWithCls:[EGFontShaderParam class]];
}

- (ODClassType*)type {
    return [EGFontShaderParam type];
}

+ (ODClassType*)type {
    return _EGFontShaderParam_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGFontShaderParam* o = ((EGFontShaderParam*)(other));
    return [self.texture isEqual:o.texture] && GEVec4Eq(self.color, o.color);
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.texture hash];
    hash = hash * 31 + GEVec4Hash(self.color);
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"texture=%@", self.texture];
    [description appendFormat:@", color=%@", GEVec4Description(self.color)];
    [description appendString:@">"];
    return description;
}

@end


@implementation EGFontShader{
    EGShaderAttribute* _uvSlot;
    EGShaderAttribute* _positionSlot;
    EGShaderUniform* _colorUniform;
}
static EGFontShader* _EGFontShader_instance;
static NSString* _EGFontShader_vertex = @"attribute vec2 position;\n"
    "attribute vec2 vertexUV;\n"
    "\n"
    "varying vec2 UV;\n"
    "\n"
    "void main(void) {\n"
    "   gl_Position = vec4(position.x, position.y, 0, 1);\n"
    "   UV = vertexUV;\n"
    "}";
static NSString* _EGFontShader_fragment = @"varying vec2 UV;\n"
    "uniform sampler2D texture;\n"
    "uniform vec4 color;\n"
    "\n"
    "void main(void) {\n"
    "   gl_FragColor = color * texture2D(texture, UV);\n"
    "}";
static ODClassType* _EGFontShader_type;
@synthesize uvSlot = _uvSlot;
@synthesize positionSlot = _positionSlot;
@synthesize colorUniform = _colorUniform;

+ (id)fontShader {
    return [[EGFontShader alloc] init];
}

- (id)init {
    self = [super initWithProgram:[EGShaderProgram applyVertex:EGFontShader.vertex fragment:EGFontShader.fragment]];
    if(self) {
        _uvSlot = [self attributeForName:@"vertexUV"];
        _positionSlot = [self attributeForName:@"position"];
        _colorUniform = [self uniformForName:@"color"];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGFontShader_type = [ODClassType classTypeWithCls:[EGFontShader class]];
    _EGFontShader_instance = [EGFontShader fontShader];
}

- (void)loadVbDesc:(EGVertexBufferDesc*)vbDesc param:(EGFontShaderParam*)param {
    [param.texture bind];
    [_positionSlot setFromBufferWithStride:((NSUInteger)([vbDesc stride])) valuesCount:2 valuesType:GL_FLOAT shift:((NSUInteger)(vbDesc.position))];
    [_uvSlot setFromBufferWithStride:((NSUInteger)([vbDesc stride])) valuesCount:2 valuesType:GL_FLOAT shift:((NSUInteger)(vbDesc.uv))];
    [_colorUniform setVec4:param.color];
}

- (void)unloadParam:(EGFontShaderParam*)param {
    [EGTexture unbind];
}

- (ODClassType*)type {
    return [EGFontShader type];
}

+ (EGFontShader*)instance {
    return _EGFontShader_instance;
}

+ (NSString*)vertex {
    return _EGFontShader_vertex;
}

+ (NSString*)fragment {
    return _EGFontShader_fragment;
}

+ (ODClassType*)type {
    return _EGFontShader_type;
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


@implementation EGFontSymbolDesc{
    float _width;
    GEVec2 _offset;
    GEVec2 _size;
    GERect _textureRect;
}
static ODClassType* _EGFontSymbolDesc_type;
@synthesize width = _width;
@synthesize offset = _offset;
@synthesize size = _size;
@synthesize textureRect = _textureRect;

+ (id)fontSymbolDescWithWidth:(float)width offset:(GEVec2)offset size:(GEVec2)size textureRect:(GERect)textureRect {
    return [[EGFontSymbolDesc alloc] initWithWidth:width offset:offset size:size textureRect:textureRect];
}

- (id)initWithWidth:(float)width offset:(GEVec2)offset size:(GEVec2)size textureRect:(GERect)textureRect {
    self = [super init];
    if(self) {
        _width = width;
        _offset = offset;
        _size = size;
        _textureRect = textureRect;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGFontSymbolDesc_type = [ODClassType classTypeWithCls:[EGFontSymbolDesc class]];
}

- (ODClassType*)type {
    return [EGFontSymbolDesc type];
}

+ (ODClassType*)type {
    return _EGFontSymbolDesc_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGFontSymbolDesc* o = ((EGFontSymbolDesc*)(other));
    return eqf4(self.width, o.width) && GEVec2Eq(self.offset, o.offset) && GEVec2Eq(self.size, o.size) && GERectEq(self.textureRect, o.textureRect);
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + float4Hash(self.width);
    hash = hash * 31 + GEVec2Hash(self.offset);
    hash = hash * 31 + GEVec2Hash(self.size);
    hash = hash * 31 + GERectHash(self.textureRect);
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"width=%f", self.width];
    [description appendFormat:@", offset=%@", GEVec2Description(self.offset)];
    [description appendFormat:@", size=%@", GEVec2Description(self.size)];
    [description appendFormat:@", textureRect=%@", GERectDescription(self.textureRect)];
    [description appendString:@">"];
    return description;
}

@end


ODPType* egFontPrintDataType() {
    static ODPType* _ret = nil;
    if(_ret == nil) _ret = [ODPType typeWithCls:[EGFontPrintDataWrap class] name:@"EGFontPrintData" size:sizeof(EGFontPrintData) wrap:^id(void* data, NSUInteger i) {
        return wrap(EGFontPrintData, ((EGFontPrintData*)(data))[i]);
    }];
    return _ret;
}
@implementation EGFontPrintDataWrap{
    EGFontPrintData _value;
}
@synthesize value = _value;

+ (id)wrapWithValue:(EGFontPrintData)value {
    return [[EGFontPrintDataWrap alloc] initWithValue:value];
}

- (id)initWithValue:(EGFontPrintData)value {
    self = [super init];
    if(self) _value = value;
    return self;
}

- (NSString*)description {
    return EGFontPrintDataDescription(_value);
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGFontPrintDataWrap* o = ((EGFontPrintDataWrap*)(other));
    return EGFontPrintDataEq(_value, o.value);
}

- (NSUInteger)hash {
    return EGFontPrintDataHash(_value);
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end



