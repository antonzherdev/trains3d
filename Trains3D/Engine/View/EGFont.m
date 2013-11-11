#import "EGFont.h"

#import "EGVertex.h"
#import "EGTexture.h"
#import "GL.h"
#import "EGContext.h"
#import "GEMat4.h"
#import "EGMesh.h"
#import "EGIndex.h"
#import "EGDirector.h"
#import "EGMaterial.h"
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
}
static EGFontSymbolDesc* _EGFont_newLineDesc;
static EGVertexBufferDesc* _EGFont_vbDesc;
static ODClassType* _EGFont_type;
@synthesize name = _name;
@synthesize texture = _texture;
@synthesize height = _height;
@synthesize size = _size;

+ (id)fontWithName:(NSString*)name {
    return [[EGFont alloc] initWithName:name];
}

- (id)initWithName:(NSString*)name {
    self = [super init];
    if(self) {
        _name = name;
        _texture = [EGFileTexture fileTextureWithFile:[NSString stringWithFormat:@"%@.png", _name] scale:1.0 magFilter:GL_NEAREST minFilter:GL_NEAREST];
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
    [[[OSBundle readToStringResource:[NSString stringWithFormat:@"%@.fnt", _name]] splitBy:@"\n"] forEach:^void(NSString* line) {
        CNTuple* t = [[line tupleBy:@" "] get];
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
                    [charMap setKey:nums(code) value:[EGFontSymbolDesc fontSymbolDescWithWidth:width offset:geVec2ApplyVec2i(offset) size:r.size textureRect:geRectDivVec2(r, ts) isNewLine:NO]];
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

- (GEVec2)measureInPixelsText:(NSString*)text {
    __block NSInteger newLines = 0;
    id<CNSeq> symbolsArr = [[[text chain] flatMap:^id(id s) {
        if(unumi(s) == 10) {
            newLines++;
            return [CNOption someValue:_EGFont_newLineDesc];
        } else {
            return [_symbols optKey:s];
        }
    }] toArray];
    __block NSInteger fullWidth = 0;
    __block NSInteger lineWidth = 0;
    [symbolsArr forEach:^void(EGFontSymbolDesc* s) {
        if(((EGFontSymbolDesc*)(s)).isNewLine) {
            if(lineWidth > fullWidth) fullWidth = lineWidth;
            lineWidth = 0;
        } else {
            lineWidth += ((NSInteger)(((EGFontSymbolDesc*)(s)).width));
        }
    }];
    if(lineWidth > fullWidth) fullWidth = lineWidth;
    return GEVec2Make(((float)(fullWidth)), ((float)(_height)) * (newLines + 1));
}

- (GEVec2)measurePText:(NSString*)text {
    return geVec2DivVec2(geVec2MulF([self measureInPixelsText:text], 2.0), geVec2ApplyVec2i([EGGlobal.context viewport].size));
}

- (GEVec2)measureCText:(NSString*)text {
    return geVec4Xy([[EGGlobal.matrix p] divBySelfVec4:geVec4ApplyVec2ZW([self measurePText:text], 0.0, 0.0)]);
}

- (EGSimpleVertexArray*)vaoText:(NSString*)text at:(GEVec3)at alignment:(EGTextAlignment)alignment {
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
        __block NSInteger lineWidth = 0;
        [symbolsArr forEach:^void(EGFontSymbolDesc* s) {
            if(((EGFontSymbolDesc*)(s)).isNewLine) {
                [linesWidth appendItem:numi(lineWidth)];
                lineWidth = 0;
            } else {
                lineWidth += ((NSInteger)(((EGFontSymbolDesc*)(s)).width));
            }
        }];
        [linesWidth appendItem:numi(lineWidth)];
        linesWidthIterator = [linesWidth iterator];
        x = pos.x - unumi([linesWidthIterator next]) / vpSize.x * (alignment.x / 2 + 0.5);
    }
    float hh = ((float)(_height)) / vpSize.y;
    __block float y = ((alignment.baseline) ? pos.y + ((float)(_size)) / vpSize.y : pos.y - hh * (newLines + 1) * (alignment.y / 2 - 0.5));
    [symbolsArr forEach:^void(EGFontSymbolDesc* s) {
        if(((EGFontSymbolDesc*)(s)).isNewLine) {
            x = ((eqf4(alignment.x, -1)) ? pos.x : pos.x - unumi([linesWidthIterator next]) / vpSize.x * (alignment.x / 2 + 0.5));
            y -= hh;
        } else {
            GEVec2 size = geVec2DivVec2(((EGFontSymbolDesc*)(s)).size, vpSize);
            GERect tr = ((EGFontSymbolDesc*)(s)).textureRect;
            GEVec2 v0 = GEVec2Make(x + ((EGFontSymbolDesc*)(s)).offset.x / vpSize.x, y - ((EGFontSymbolDesc*)(s)).offset.y / vpSize.y);
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
            x += ((EGFontSymbolDesc*)(s)).width / vpSize.x;
            n += 4;
        }
    }];
    id<EGVertexBuffer> vb = [EGVBO applyDesc:_EGFont_vbDesc array:vertexes];
    EGImmutableIndexBuffer* ib = [EGIBO applyArray:indexes];
    cnVoidRefArrayFree(vertexes);
    cnVoidRefArrayFree(indexes);
    return [EGFontShader.instance vaoVbo:vb ibo:ib];
}

- (ODClassType*)type {
    return [EGFont type];
}

+ (EGVertexBufferDesc*)vbDesc {
    return _EGFont_vbDesc;
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


@implementation EGText{
    CNNotificationObserver* _obs;
    BOOL __changed;
    EGFont* __font;
    NSString* __text;
    GEVec3 __position;
    EGTextAlignment __alignment;
    EGSimpleVertexArray* __vao;
    GEVec4 _color;
}
static ODClassType* _EGText_type;
@synthesize _changed = __changed;
@synthesize color = _color;

+ (id)text {
    return [[EGText alloc] init];
}

- (id)init {
    self = [super init];
    __weak EGText* _weakSelf = self;
    if(self) {
        _obs = [EGDirector.reshapeNotification observeBy:^void(id _) {
            _weakSelf._changed = YES;
        }];
        __changed = YES;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGText_type = [ODClassType classTypeWithCls:[EGText class]];
}

+ (EGText*)applyFont:(EGFont*)font text:(NSString*)text position:(GEVec3)position alignment:(EGTextAlignment)alignment color:(GEVec4)color {
    EGText* t = [EGText text];
    [t setFont:font];
    [t setText:text];
    [t setPosition:position];
    [t setAlignment:alignment];
    t.color = color;
    return t;
}

- (EGFont*)font {
    return __font;
}

- (void)setFont:(EGFont*)font {
    if(!([font isEqual:__font])) {
        __changed = YES;
        __font = font;
    }
}

- (NSString*)text {
    return __text;
}

- (void)setText:(NSString*)text {
    if(!([text isEqual:__text])) {
        __changed = YES;
        __text = text;
    }
}

- (GEVec3)position {
    return __position;
}

- (void)setPosition:(GEVec3)position {
    if(!(GEVec3Eq(position, __position))) {
        __changed = YES;
        __position = position;
    }
}

- (EGTextAlignment)alignment {
    return __alignment;
}

- (void)setAlignment:(EGTextAlignment)alignment {
    if(!(EGTextAlignmentEq(alignment, __alignment))) {
        __changed = YES;
        __alignment = alignment;
    }
}

- (void)draw {
    if(__changed) {
        __vao = [__font vaoText:__text at:__position alignment:__alignment];
        __changed = NO;
    }
    [EGGlobal.context.cullFace disabledF:^void() {
        [__vao drawParam:[EGFontShaderParam fontShaderParamWithTexture:__font.texture color:_color]];
    }];
}

- (GEVec2)measureInPixels {
    return [__font measureInPixelsText:__text];
}

- (GEVec2)measureP {
    return [__font measurePText:__text];
}

- (GEVec2)measureC {
    return [__font measureCText:__text];
}

- (ODClassType*)type {
    return [EGText type];
}

+ (ODClassType*)type {
    return _EGText_type;
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


@implementation EGFontShaderBuilder
static ODClassType* _EGFontShaderBuilder_type;

+ (id)fontShaderBuilder {
    return [[EGFontShaderBuilder alloc] init];
}

- (id)init {
    self = [super init];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGFontShaderBuilder_type = [ODClassType classTypeWithCls:[EGFontShaderBuilder class]];
}

- (NSString*)vertex {
    return [NSString stringWithFormat:@"%@\n"
        "%@ highp vec2 position;\n"
        "%@ mediump vec2 vertexUV;\n"
        "\n"
        "%@ mediump vec2 UV;\n"
        "\n"
        "void main(void) {\n"
        "    gl_Position = vec4(position.x, position.y, 0, 1);\n"
        "    UV = vertexUV;\n"
        "}", [self vertexHeader], [self ain], [self ain], [self out]];
}

- (NSString*)fragment {
    return [NSString stringWithFormat:@"%@\n"
        "%@ mediump vec2 UV;\n"
        "uniform lowp sampler2D txt;\n"
        "uniform lowp vec4 color;\n"
        "\n"
        "void main(void) {\n"
        "    %@ = color * %@(txt, UV);\n"
        "}", [self fragmentHeader], [self in], [self fragColor], [self texture2D]];
}

- (EGShaderProgram*)program {
    return [EGShaderProgram applyName:@"Font" vertex:[self vertex] fragment:[self fragment]];
}

- (NSString*)versionString {
    return [NSString stringWithFormat:@"#version %ld", (long)[self version]];
}

- (NSString*)vertexHeader {
    return [NSString stringWithFormat:@"#version %ld", (long)[self version]];
}

- (NSString*)fragmentHeader {
    return [NSString stringWithFormat:@"#version %ld\n"
        "%@", (long)[self version], [self fragColorDeclaration]];
}

- (NSString*)fragColorDeclaration {
    if([self isFragColorDeclared]) return @"";
    else return @"out lowp vec4 fragColor;";
}

- (BOOL)isFragColorDeclared {
    return EGShaderProgram.version < 110;
}

- (NSInteger)version {
    return EGShaderProgram.version;
}

- (NSString*)ain {
    if([self version] < 150) return @"attribute";
    else return @"in";
}

- (NSString*)in {
    if([self version] < 150) return @"varying";
    else return @"in";
}

- (NSString*)out {
    if([self version] < 150) return @"varying";
    else return @"out";
}

- (NSString*)fragColor {
    if([self version] > 100) return @"fragColor";
    else return @"gl_FragColor";
}

- (NSString*)texture2D {
    if([self version] > 100) return @"texture";
    else return @"texture2D";
}

- (NSString*)shadowExt {
    if([self version] == 100) return @"#extension GL_EXT_shadow_samplers : require";
    else return @"";
}

- (NSString*)shadow2D {
    if([self version] == 100) return @"shadow2DEXT";
    else return @"texture";
}

- (NSString*)blendMode:(EGBlendMode*)mode a:(NSString*)a b:(NSString*)b {
    return mode.blend(a, b);
}

- (ODClassType*)type {
    return [EGFontShaderBuilder type];
}

+ (ODClassType*)type {
    return _EGFontShaderBuilder_type;
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


@implementation EGFontShader{
    EGShaderAttribute* _uvSlot;
    EGShaderAttribute* _positionSlot;
    EGShaderUniformVec4* _colorUniform;
}
static EGFontShader* _EGFontShader_instance;
static ODClassType* _EGFontShader_type;
@synthesize uvSlot = _uvSlot;
@synthesize positionSlot = _positionSlot;
@synthesize colorUniform = _colorUniform;

+ (id)fontShader {
    return [[EGFontShader alloc] init];
}

- (id)init {
    self = [super initWithProgram:[[EGFontShaderBuilder fontShaderBuilder] program]];
    if(self) {
        _uvSlot = [self attributeForName:@"vertexUV"];
        _positionSlot = [self attributeForName:@"position"];
        _colorUniform = [self uniformVec4Name:@"color"];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGFontShader_type = [ODClassType classTypeWithCls:[EGFontShader class]];
    _EGFontShader_instance = [EGFontShader fontShader];
}

- (void)loadAttributesVbDesc:(EGVertexBufferDesc*)vbDesc {
    [_positionSlot setFromBufferWithStride:((NSUInteger)([vbDesc stride])) valuesCount:2 valuesType:GL_FLOAT shift:((NSUInteger)(vbDesc.position))];
    [_uvSlot setFromBufferWithStride:((NSUInteger)([vbDesc stride])) valuesCount:2 valuesType:GL_FLOAT shift:((NSUInteger)(vbDesc.uv))];
}

- (void)loadUniformsParam:(EGFontShaderParam*)param {
    [EGGlobal.context bindTextureTexture:param.texture];
    [_colorUniform applyVec4:param.color];
}

- (ODClassType*)type {
    return [EGFontShader type];
}

+ (EGFontShader*)instance {
    return _EGFontShader_instance;
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



