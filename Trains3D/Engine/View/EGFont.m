#import "EGFont.h"

#import "EGMesh.h"
#import "EGTexture.h"
#import "GL.h"
#import "EGContext.h"
#import "GEMat4.h"
NSString* EGTextAlignmentDescription(EGTextAlignment self) {
    NSMutableString* description = [NSMutableString stringWithString:@"<EGTextAlignment: "];
    [description appendFormat:@"x=%f", self.x];
    [description appendFormat:@", y=%f", self.y];
    [description appendFormat:@", baseline=%d", self.baseline];
    [description appendFormat:@", shift=%@", GEVec3Description(self.shift)];
    [description appendString:@">"];
    return description;
}
EGTextAlignment egTextAlignmentApplyXY(float x, float y) {
    return EGTextAlignmentMake(x, y, NO, GEVec3Make(0.0, 0.0, 0.0));
}
EGTextAlignment egTextAlignmentBaselineX(float x) {
    return EGTextAlignmentMake(x, 0.0, YES, GEVec3Make(0.0, 0.0, 0.0));
}
EGTextAlignment egTextAlignmentLeft() {
    static EGTextAlignment _ret = (EGTextAlignment){-1.0, 0.0, YES, {0.0, 0.0, 0.0}};
    return _ret;
}
EGTextAlignment egTextAlignmentRight() {
    static EGTextAlignment _ret = (EGTextAlignment){1.0, 0.0, YES, {0.0, 0.0, 0.0}};
    return _ret;
}
EGTextAlignment egTextAlignmentCenter() {
    static EGTextAlignment _ret = (EGTextAlignment){0.0, 0.0, YES, {0.0, 0.0, 0.0}};
    return _ret;
}
ODPType* egTextAlignmentType() {
    static ODPType* _ret = nil;
    if(_ret == nil) _ret = [ODPType typeWithCls:[EGTextAlignmentWrap class] name:@"EGTextAlignment" size:sizeof(EGTextAlignment) wrap:^id(void* data, NSUInteger i) {
        return wrap(EGTextAlignment, ((EGTextAlignment*)(data))[i]);
    }];
    return _ret;
}
@implementation EGTextAlignmentWrap{
    EGTextAlignment _value;
}
@synthesize value = _value;

+ (id)wrapWithValue:(EGTextAlignment)value {
    return [[EGTextAlignmentWrap alloc] initWithValue:value];
}

- (id)initWithValue:(EGTextAlignment)value {
    self = [super init];
    if(self) _value = value;
    return self;
}

- (NSString*)description {
    return EGTextAlignmentDescription(_value);
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGTextAlignmentWrap* o = ((EGTextAlignmentWrap*)(other));
    return EGTextAlignmentEq(_value, o.value);
}

- (NSUInteger)hash {
    return EGTextAlignmentHash(_value);
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end



@implementation EGFont{
    NSString* _name;
    EGFileTexture* _texture;
    id<CNMap> _symbols;
    NSUInteger _height;
    NSUInteger _size;
    EGVertexBuffer* _vb;
    EGIndexBuffer* _ib;
    EGMesh* _mesh;
}
static EGFontSymbolDesc* _EGFont_newLineDesc;
static EGVertexBufferDesc* _EGFont_vbDesc;
static ODClassType* _EGFont_type;
@synthesize name = _name;
@synthesize height = _height;
@synthesize size = _size;

+ (id)fontWithName:(NSString*)name {
    return [[EGFont alloc] initWithName:name];
}

- (id)initWithName:(NSString*)name {
    self = [super init];
    if(self) {
        _name = name;
        _texture = [EGFileTexture fileTextureWithFile:[NSString stringWithFormat:@"%@.png", _name] magFilter:GL_NEAREST minFilter:GL_NEAREST];
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
    _EGFont_newLineDesc = [EGFontSymbolDesc fontSymbolDescWithWidth:0.0 offset:GEVec2Make(0.0, 0.0) size:GEVec2Make(0.0, 0.0) textureRect:geRectApplyXYWidthHeight(0.0, 0.0, 0.0, 0.0) isNewLine:YES];
    _EGFont_vbDesc = [EGVertexBufferDesc vertexBufferDescWithDataType:egFontPrintDataType() position:0 uv:((int)(2 * 4)) normal:-1 color:-1 model:-1];
}

- (void)_init {
    NSMutableDictionary* charMap = [NSMutableDictionary mutableDictionary];
    GEVec2 ts = [_texture size];
    [[[CNBundle readToStringResource:[NSString stringWithFormat:@"%@.fnt", _name]] splitBy:@"\n"] forEach:^void(NSString* line) {
        CNTuple* t = ((CNTuple*)([[line tupleBy:@" "] get]));
        NSString* name = t.a;
        id<CNMap> map = [[[[t.b splitBy:@" "] chain] flatMap:^id(NSString* _) {
            return [_ tupleBy:@"="];
        }] toMap];
        if([name isEqual:@"info"]) {
            _size = [[map applyKey:@"size"] toUInt];
        } else {
            if([name isEqual:@"common"]) {
                _height = [[map applyKey:@"lineHeight"] toUInt];
            } else {
                if([name isEqual:@"char"]) {
                    unichar code = [[map applyKey:@"id"] toInt];
                    float width = ((float)([[map applyKey:@"xadvance"] toFloat]));
                    GEVec2i offset = GEVec2iMake([[map applyKey:@"xoffset"] toInt], [[map applyKey:@"yoffset"] toInt]);
                    GERect r = geRectApplyXYWidthHeight(((float)([[map applyKey:@"x"] toFloat])), ((float)([[map applyKey:@"y"] toFloat])), ((float)([[map applyKey:@"width"] toFloat])), ((float)([[map applyKey:@"height"] toFloat])));
                    [charMap setValue:[EGFontSymbolDesc fontSymbolDescWithWidth:width offset:geVec2ApplyVec2i(offset) size:r.size textureRect:geRectDivVec2(r, ts) isNewLine:NO] forKey:nums(code)];
                }
            }
        }
    }];
    _symbols = charMap;
}

- (GERect)parse_rect:(NSString*)_rect {
    id<CNSeq> parts = [[[_rect splitBy:@" "] chain] toArray];
    CGFloat y = [[parts applyIndex:1] toFloat];
    CGFloat h = [[parts applyIndex:3] toFloat];
    return geRectApplyXYWidthHeight(((float)([[parts applyIndex:0] toFloat])), ((float)(y)), ((float)([[parts applyIndex:2] toFloat])), ((float)(h)));
}

- (void)drawText:(NSString*)text color:(GEVec4)color at:(GEVec3)at alignment:(EGTextAlignment)alignment {
    GEVec2 pos = ((geVec3IsEmpty(alignment.shift)) ? geVec4Xy([[EGGlobal.matrix wcp] mulVec4:geVec4ApplyVec3W(at, 1.0)]) : geVec4Xy([[EGGlobal.matrix p] mulVec4:geVec4AddVec3([[EGGlobal.matrix wc] mulVec4:geVec4ApplyVec3W(at, 1.0)], alignment.shift)]));
    __block NSInteger newLines = 0;
    id<CNSeq> symbolsArr = [[[text chain] flatMap:^id(id s) {
        if(unumi(s) == 10) {
            newLines++;
            return [CNOption someValue:_EGFont_newLineDesc];
        } else {
            return [_symbols optKey:s];
        }
    }] toArray];
    NSUInteger symbolsCount = [symbolsArr count] - newLines;
    CNVoidRefArray vertexes = cnVoidRefArrayApplyTpCount(egFontPrintDataType(), symbolsCount * 4);
    CNVoidRefArray indexes = cnVoidRefArrayApplyTpCount(oduInt4Type(), symbolsCount * 6);
    GEVec2 vpSize = geVec2iDivF([EGGlobal.context viewport].size, 2.0);
    __block CNVoidRefArray vp = vertexes;
    __block CNVoidRefArray ip = indexes;
    __block NSInteger n = 0;
    NSMutableArray* linesWidth = [NSMutableArray mutableArray];
    id<CNIterator> linesWidthIterator;
    __block float x = pos.x;
    if(!(eqf4(alignment.x, -1))) {
        __block NSInteger fullWidth = 0;
        __block NSInteger lineWidth = 0;
        [symbolsArr forEach:^void(EGFontSymbolDesc* s) {
            if(s.isNewLine) {
                [linesWidth appendItem:numi(lineWidth)];
                if(lineWidth > fullWidth) fullWidth = lineWidth;
                lineWidth = 0;
            } else {
                lineWidth += ((NSInteger)(s.width));
            }
        }];
        [linesWidth appendItem:numi(lineWidth)];
        linesWidthIterator = [linesWidth iterator];
        x = pos.x - unumi([linesWidthIterator next]) / vpSize.x * (alignment.x / 2 + 0.5);
    }
    float hh = ((float)(_height)) / vpSize.y;
    __block float y = ((alignment.baseline) ? pos.y + ((float)(_size)) / vpSize.y : pos.y - hh * (newLines + 1) * (alignment.y / 2 - 0.5));
    [symbolsArr forEach:^void(EGFontSymbolDesc* s) {
        if(s.isNewLine) {
            x = ((eqf4(alignment.x, -1)) ? pos.x : pos.x - unumi([linesWidthIterator next]) / vpSize.x * (alignment.x / 2 + 0.5));
            y -= hh;
        } else {
            GEVec2 size = geVec2DivVec2(s.size, vpSize);
            GERect tr = s.textureRect;
            GEVec2 v0 = GEVec2Make(x + s.offset.x / vpSize.x, y - s.offset.y / vpSize.y);
            vp = cnVoidRefArrayWriteTpItem(vp, GEVec2, v0);
            vp = cnVoidRefArrayWriteTpItem(vp, GEVec2, tr.p0);
            vp = cnVoidRefArrayWriteTpItem(vp, GEVec2, GEVec2Make(v0.x, v0.y - size.y));
            vp = cnVoidRefArrayWriteTpItem(vp, GEVec2, geRectP1(tr));
            vp = cnVoidRefArrayWriteTpItem(vp, GEVec2, GEVec2Make(v0.x + size.x, v0.y - size.y));
            vp = cnVoidRefArrayWriteTpItem(vp, GEVec2, geRectP3(tr));
            vp = cnVoidRefArrayWriteTpItem(vp, GEVec2, GEVec2Make(v0.x + size.x, v0.y));
            vp = cnVoidRefArrayWriteTpItem(vp, GEVec2, geRectP2(tr));
            ip = cnVoidRefArrayWriteUInt4(ip, ((unsigned int)(n)));
            ip = cnVoidRefArrayWriteUInt4(ip, ((unsigned int)(n + 1)));
            ip = cnVoidRefArrayWriteUInt4(ip, ((unsigned int)(n + 2)));
            ip = cnVoidRefArrayWriteUInt4(ip, ((unsigned int)(n + 2)));
            ip = cnVoidRefArrayWriteUInt4(ip, ((unsigned int)(n + 3)));
            ip = cnVoidRefArrayWriteUInt4(ip, ((unsigned int)(n)));
            x += s.width / vpSize.x;
            n += 4;
        }
    }];
    [_vb setArray:vertexes usage:GL_DYNAMIC_DRAW];
    [_ib setArray:indexes usage:GL_DYNAMIC_DRAW];
    glDisable(GL_CULL_FACE);
    [EGFontShader.instance drawParam:[EGFontShaderParam fontShaderParamWithTexture:_texture color:color] mesh:_mesh];
    glEnable(GL_CULL_FACE);
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
    return [self.name isEqual:o.name];
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.name hash];
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"name=%@", self.name];
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
    BOOL _isNewLine;
}
static ODClassType* _EGFontSymbolDesc_type;
@synthesize width = _width;
@synthesize offset = _offset;
@synthesize size = _size;
@synthesize textureRect = _textureRect;
@synthesize isNewLine = _isNewLine;

+ (id)fontSymbolDescWithWidth:(float)width offset:(GEVec2)offset size:(GEVec2)size textureRect:(GERect)textureRect isNewLine:(BOOL)isNewLine {
    return [[EGFontSymbolDesc alloc] initWithWidth:width offset:offset size:size textureRect:textureRect isNewLine:isNewLine];
}

- (id)initWithWidth:(float)width offset:(GEVec2)offset size:(GEVec2)size textureRect:(GERect)textureRect isNewLine:(BOOL)isNewLine {
    self = [super init];
    if(self) {
        _width = width;
        _offset = offset;
        _size = size;
        _textureRect = textureRect;
        _isNewLine = isNewLine;
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
    return eqf4(self.width, o.width) && GEVec2Eq(self.offset, o.offset) && GEVec2Eq(self.size, o.size) && GERectEq(self.textureRect, o.textureRect) && self.isNewLine == o.isNewLine;
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + float4Hash(self.width);
    hash = hash * 31 + GEVec2Hash(self.offset);
    hash = hash * 31 + GEVec2Hash(self.size);
    hash = hash * 31 + GERectHash(self.textureRect);
    hash = hash * 31 + self.isNewLine;
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"width=%f", self.width];
    [description appendFormat:@", offset=%@", GEVec2Description(self.offset)];
    [description appendFormat:@", size=%@", GEVec2Description(self.size)];
    [description appendFormat:@", textureRect=%@", GERectDescription(self.textureRect)];
    [description appendFormat:@", isNewLine=%d", self.isNewLine];
    [description appendString:@">"];
    return description;
}

@end


NSString* EGFontPrintDataDescription(EGFontPrintData self) {
    NSMutableString* description = [NSMutableString stringWithString:@"<EGFontPrintData: "];
    [description appendFormat:@"position=%@", GEVec2Description(self.position)];
    [description appendFormat:@", uv=%@", GEVec2Description(self.uv)];
    [description appendString:@">"];
    return description;
}
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



