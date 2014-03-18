#import "EGFont.h"

#import "EGVertex.h"
#import "EGTexture.h"
#import "EGContext.h"
#import "EGMatrixModel.h"
#import "GEMat4.h"
#import "EGVertexArray.h"
#import "EGIndex.h"
#import "ATReact.h"
#import "EGMaterial.h"
#import "GL.h"
NSString* EGTextAlignmentDescription(EGTextAlignment self) {
    NSMutableString* description = [NSMutableString stringWithString:@"<EGTextAlignment: "];
    [description appendFormat:@"x=%f", self.x];
    [description appendFormat:@", y=%f", self.y];
    [description appendFormat:@", baseline=%d", self.baseline];
    [description appendFormat:@", shift=%@", GEVec2Description(self.shift)];
    [description appendString:@">"];
    return description;
}
EGTextAlignment egTextAlignmentApplyXY(float x, float y) {
    return EGTextAlignmentMake(x, y, NO, (GEVec2Make(0.0, 0.0)));
}
EGTextAlignment egTextAlignmentApplyXYShift(float x, float y, GEVec2 shift) {
    return EGTextAlignmentMake(x, y, NO, shift);
}
EGTextAlignment egTextAlignmentBaselineX(float x) {
    return EGTextAlignmentMake(x, 0.0, YES, (GEVec2Make(0.0, 0.0)));
}
EGTextAlignment egTextAlignmentLeft() {
    static EGTextAlignment _ret = (EGTextAlignment){-1.0, 0.0, YES, {0.0, 0.0}};
    return _ret;
}
EGTextAlignment egTextAlignmentRight() {
    static EGTextAlignment _ret = (EGTextAlignment){1.0, 0.0, YES, {0.0, 0.0}};
    return _ret;
}
EGTextAlignment egTextAlignmentCenter() {
    static EGTextAlignment _ret = (EGTextAlignment){0.0, 0.0, YES, {0.0, 0.0}};
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



@implementation EGFont
static CNNotificationHandle* _EGFont_fontChangeNotification;
static EGFontSymbolDesc* _EGFont_newLineDesc;
static EGFontSymbolDesc* _EGFont_zeroDesc;
static EGVertexBufferDesc* _EGFont_vbDesc;
static ODClassType* _EGFont_type;

+ (instancetype)font {
    return [[EGFont alloc] init];
}

- (instancetype)init {
    self = [super init];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGFont class]) {
        _EGFont_type = [ODClassType classTypeWithCls:[EGFont class]];
        _EGFont_fontChangeNotification = [CNNotificationHandle notificationHandleWithName:@"fontChangeNotification"];
        _EGFont_newLineDesc = [EGFontSymbolDesc fontSymbolDescWithWidth:0.0 offset:GEVec2Make(0.0, 0.0) size:GEVec2Make(0.0, 0.0) textureRect:geRectApplyXYWidthHeight(0.0, 0.0, 0.0, 0.0) isNewLine:YES];
        _EGFont_zeroDesc = [EGFontSymbolDesc fontSymbolDescWithWidth:0.0 offset:GEVec2Make(0.0, 0.0) size:GEVec2Make(0.0, 0.0) textureRect:geRectApplyXYWidthHeight(0.0, 0.0, 0.0, 0.0) isNewLine:NO];
        _EGFont_vbDesc = [EGVertexBufferDesc vertexBufferDescWithDataType:egFontPrintDataType() position:0 uv:((int)(2 * 4)) normal:-1 color:-1 model:-1];
    }
}

- (EGTexture*)texture {
    @throw @"Method texture is abstract";
}

- (NSUInteger)height {
    @throw @"Method height is abstract";
}

- (NSUInteger)size {
    @throw @"Method size is abstract";
}

- (GEVec2)measureInPixelsText:(NSString*)text {
    CNTuple* pair = [self buildSymbolArrayText:text];
    id<CNImSeq> symbolsArr = pair.a;
    NSInteger newLines = unumi(pair.b);
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
    return GEVec2Make(((float)(fullWidth)), ((float)([self height])) * (newLines + 1));
}

- (id)symbolOptSmb:(unichar)smb {
    @throw @"Method symbolOpt is abstract";
}

- (GEVec2)measurePText:(NSString*)text {
    return geVec2DivVec2((geVec2MulF([self measureInPixelsText:text], 2.0)), geVec2ApplyVec2i([EGGlobal.context viewport].size));
}

- (GEVec2)measureCText:(NSString*)text {
    return geVec4Xy(([[EGGlobal.matrix p] divBySelfVec4:geVec4ApplyVec2ZW([self measurePText:text], 0.0, 0.0)]));
}

- (BOOL)resymbol {
    return NO;
}

- (CNTuple*)buildSymbolArrayText:(NSString*)text {
    __block NSInteger newLines = 0;
    id<CNImSeq> symbolsArr = [[[text chain] flatMap:^id(id s) {
        if(unumi(s) == 10) {
            newLines++;
            return [CNOption someValue:_EGFont_newLineDesc];
        } else {
            return [self symbolOptSmb:unums(s)];
        }
    }] toArray];
    if([self resymbol]) symbolsArr = [[[text chain] flatMap:^id(id s) {
        if(unumi(s) == 10) return [CNOption someValue:_EGFont_newLineDesc];
        else return [self symbolOptSmb:unums(s)];
    }] toArray];
    return tuple(symbolsArr, numi(newLines));
}

- (EGSimpleVertexArray*)vaoText:(NSString*)text at:(GEVec3)at alignment:(EGTextAlignment)alignment {
    GEVec2 pos = geVec2AddVec2((geVec4Xy(([[EGGlobal.matrix wcp] mulVec4:geVec4ApplyVec3W(at, 1.0)]))), (geVec2MulI((geVec2DivVec2(alignment.shift, geVec2ApplyVec2i([EGGlobal.context viewport].size))), 2)));
    CNTuple* pair = [self buildSymbolArrayText:text];
    id<CNImSeq> symbolsArr = pair.a;
    NSInteger newLines = unumi(pair.b);
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
    float hh = ((float)([self height])) / vpSize.y;
    __block float y = ((alignment.baseline) ? pos.y + ((float)([self size])) / vpSize.y : pos.y - hh * (newLines + 1) * (alignment.y / 2 - 0.5));
    [symbolsArr forEach:^void(EGFontSymbolDesc* s) {
        if(((EGFontSymbolDesc*)(s)).isNewLine) {
            x = ((eqf4(alignment.x, -1)) ? pos.x : pos.x - unumi([linesWidthIterator next]) / vpSize.x * (alignment.x / 2 + 0.5));
            y -= hh;
        } else {
            GEVec2 size = geVec2DivVec2(((EGFontSymbolDesc*)(s)).size, vpSize);
            GERect tr = ((EGFontSymbolDesc*)(s)).textureRect;
            GEVec2 v0 = GEVec2Make(x + ((EGFontSymbolDesc*)(s)).offset.x / vpSize.x, y - ((EGFontSymbolDesc*)(s)).offset.y / vpSize.y);
            vp = cnVoidRefArrayWriteTpItem(vp, GEVec2, v0);
            vp = cnVoidRefArrayWriteTpItem(vp, GEVec2, tr.p);
            vp = cnVoidRefArrayWriteTpItem(vp, GEVec2, (GEVec2Make(v0.x, v0.y - size.y)));
            vp = cnVoidRefArrayWriteTpItem(vp, GEVec2, geRectPh(tr));
            vp = cnVoidRefArrayWriteTpItem(vp, GEVec2, (GEVec2Make(v0.x + size.x, v0.y - size.y)));
            vp = cnVoidRefArrayWriteTpItem(vp, GEVec2, geRectPhw(tr));
            vp = cnVoidRefArrayWriteTpItem(vp, GEVec2, (GEVec2Make(v0.x + size.x, v0.y)));
            vp = cnVoidRefArrayWriteTpItem(vp, GEVec2, geRectPw(tr));
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

- (void)drawText:(NSString*)text at:(GEVec3)at alignment:(EGTextAlignment)alignment color:(GEVec4)color {
    EGSimpleVertexArray* vao = [self vaoText:text at:at alignment:alignment];
    [EGGlobal.context.cullFace disabledF:^void() {
        [vao drawParam:[EGFontShaderParam fontShaderParamWithTexture:[self texture] color:color shift:GEVec2Make(0.0, 0.0)]];
    }];
}

- (EGFont*)beReadyForText:(NSString*)text {
    [[text chain] forEach:^void(id s) {
        [self symbolOptSmb:unums(s)];
    }];
    return self;
}

- (ODClassType*)type {
    return [EGFont type];
}

+ (CNNotificationHandle*)fontChangeNotification {
    return _EGFont_fontChangeNotification;
}

+ (EGFontSymbolDesc*)newLineDesc {
    return _EGFont_newLineDesc;
}

+ (EGFontSymbolDesc*)zeroDesc {
    return _EGFont_zeroDesc;
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


@implementation EGBMFont
static ODClassType* _EGBMFont_type;
@synthesize name = _name;
@synthesize texture = _texture;
@synthesize height = _height;
@synthesize size = _size;

+ (instancetype)fontWithName:(NSString*)name {
    return [[EGBMFont alloc] initWithName:name];
}

- (instancetype)initWithName:(NSString*)name {
    self = [super init];
    if(self) {
        _name = name;
        _texture = [EGFileTexture fileTextureWithName:_name fileFormat:EGTextureFileFormat.PNG format:EGTextureFormat.RGBA8 scale:1.0 filter:EGTextureFilter.nearest];
        if([self class] == [EGBMFont class]) [self _init];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGBMFont class]) _EGBMFont_type = [ODClassType classTypeWithCls:[EGBMFont class]];
}

- (void)_init {
    NSMutableDictionary* charMap = [NSMutableDictionary mutableDictionary];
    GEVec2 ts = [_texture size];
    [[[OSBundle readToStringResource:[NSString stringWithFormat:@"%@.fnt", _name]] splitBy:@"\n"] forEach:^void(NSString* line) {
        CNTuple* t = [[line tupleBy:@" "] get];
        NSString* name = t.a;
        id<CNImMap> map = [[[[t.b splitBy:@" "] chain] flatMap:^id(NSString* _) {
            return [_ tupleBy:@"="];
        }] toMap];
        if([name isEqual:@"info"]) {
            _size = [[map applyKey:@"size"] toUInt];
        } else {
            if([name isEqual:@"common"]) {
                _height = [[map applyKey:@"lineHeight"] toUInt];
            } else {
                if([name isEqual:@"char"]) {
                    unichar code = ((unichar)([[map applyKey:@"id"] toInt]));
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
    id<CNImSeq> parts = [[[_rect splitBy:@" "] chain] toArray];
    CGFloat y = [[parts applyIndex:1] toFloat];
    CGFloat h = [[parts applyIndex:3] toFloat];
    return geRectApplyXYWidthHeight(((float)([[parts applyIndex:0] toFloat])), ((float)(y)), ((float)([[parts applyIndex:2] toFloat])), ((float)(h)));
}

- (id)symbolOptSmb:(unichar)smb {
    return [_symbols optKey:nums(smb)];
}

- (ODClassType*)type {
    return [EGBMFont type];
}

+ (ODClassType*)type {
    return _EGBMFont_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGBMFont* o = ((EGBMFont*)(other));
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


@implementation EGText
static ODClassType* _EGText_type;
@synthesize visible = _visible;
@synthesize font = _font;
@synthesize text = _text;
@synthesize position = _position;
@synthesize alignment = _alignment;
@synthesize color = _color;
@synthesize shadow = _shadow;

+ (instancetype)textWithVisible:(ATReact*)visible font:(ATReact*)font text:(ATReact*)text position:(ATReact*)position alignment:(ATReact*)alignment color:(ATReact*)color shadow:(ATReact*)shadow {
    return [[EGText alloc] initWithVisible:visible font:font text:text position:position alignment:alignment color:color shadow:shadow];
}

- (instancetype)initWithVisible:(ATReact*)visible font:(ATReact*)font text:(ATReact*)text position:(ATReact*)position alignment:(ATReact*)alignment color:(ATReact*)color shadow:(ATReact*)shadow {
    self = [super init];
    __weak EGText* _weakSelf = self;
    if(self) {
        _visible = visible;
        _font = font;
        _text = text;
        _position = position;
        _alignment = alignment;
        _color = color;
        _shadow = shadow;
        __changed = [ATReactFlag reactFlagWithInitial:YES reacts:(@[_font, _text, _position, _alignment, _shadow, EGGlobal.context.viewSize])];
        _fontObserver = [_font mapF:^CNNotificationObserver*(EGFont* newFont) {
            return [EGFont.fontChangeNotification observeSender:newFont by:^void(id _) {
                EGText* _self = _weakSelf;
                [_self->__changed set];
            }];
        }];
        __lazy_sizeInPixels = [CNLazy lazyWithF:^ATReact*() {
            EGText* _self = _weakSelf;
            return [ATReact asyncQueue:CNDispatchQueue.mainThread a:_self->_font b:_self->_text f:^id(EGFont* f, NSString* t) {
                return wrap(GEVec2, [((EGFont*)(f)) measureInPixelsText:t]);
            }];
        }];
        __lazy_sizeInP = [CNLazy lazyWithF:^ATReact*() {
            EGText* _self = _weakSelf;
            return [ATReact asyncQueue:CNDispatchQueue.mainThread a:[_self sizeInPixels] b:EGGlobal.context.viewSize f:^id(id s, id vs) {
                return wrap(GEVec2, (geVec2DivVec2((geVec2MulI((uwrap(GEVec2, s)), 2)), (geVec2ApplyVec2i((uwrap(GEVec2i, vs)))))));
            }];
        }];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGText class]) _EGText_type = [ODClassType classTypeWithCls:[EGText class]];
}

- (ATReact*)sizeInPixels {
    return [__lazy_sizeInPixels get];
}

- (ATReact*)sizeInP {
    return [__lazy_sizeInP get];
}

- (void)draw {
    if(!(unumb([_visible value]))) return ;
    if(unumb([__changed value])) {
        __vao = [((EGFont*)([_font value])) vaoText:[_text value] at:uwrap(GEVec3, [_position value]) alignment:uwrap(EGTextAlignment, [_alignment value])];
        [__changed clear];
        __param = [EGFontShaderParam fontShaderParamWithTexture:[((EGFont*)([_font value])) texture] color:uwrap(GEVec4, [_color value]) shift:GEVec2Make(0.0, 0.0)];
        if([[_shadow value] isDefined]) {
            EGTextShadow* sh = [[_shadow value] get];
            __shadowParam = [EGFontShaderParam fontShaderParamWithTexture:[((EGFont*)([_font value])) texture] color:geVec4MulK(sh.color, (uwrap(GEVec4, [_color value]).w)) shift:sh.shift];
        } else {
            __shadowParam = nil;
        }
    }
    if(__shadowParam != nil) [__vao drawParam:__shadowParam];
    [__vao drawParam:__param];
}

- (GEVec2)measureInPixels {
    return [((EGFont*)([_font value])) measureInPixelsText:[_text value]];
}

- (GEVec2)measureP {
    return [((EGFont*)([_font value])) measurePText:[_text value]];
}

- (GEVec2)measureC {
    return [((EGFont*)([_font value])) measureCText:[_text value]];
}

+ (EGText*)applyVisible:(ATReact*)visible font:(ATReact*)font text:(ATReact*)text position:(ATReact*)position alignment:(ATReact*)alignment color:(ATReact*)color {
    return [EGText textWithVisible:visible font:font text:text position:position alignment:alignment color:color shadow:[ATReact applyValue:[CNOption none]]];
}

+ (EGText*)applyFont:(ATReact*)font text:(ATReact*)text position:(ATReact*)position alignment:(ATReact*)alignment color:(ATReact*)color shadow:(ATReact*)shadow {
    return [EGText textWithVisible:[ATReact applyValue:@YES] font:font text:text position:position alignment:alignment color:color shadow:shadow];
}

+ (EGText*)applyFont:(ATReact*)font text:(ATReact*)text position:(ATReact*)position alignment:(ATReact*)alignment color:(ATReact*)color {
    return [EGText textWithVisible:[ATReact applyValue:@YES] font:font text:text position:position alignment:alignment color:color shadow:[ATReact applyValue:[CNOption none]]];
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
    EGText* o = ((EGText*)(other));
    return [self.visible isEqual:o.visible] && [self.font isEqual:o.font] && [self.text isEqual:o.text] && [self.position isEqual:o.position] && [self.alignment isEqual:o.alignment] && [self.color isEqual:o.color] && [self.shadow isEqual:o.shadow];
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.visible hash];
    hash = hash * 31 + [self.font hash];
    hash = hash * 31 + [self.text hash];
    hash = hash * 31 + [self.position hash];
    hash = hash * 31 + [self.alignment hash];
    hash = hash * 31 + [self.color hash];
    hash = hash * 31 + [self.shadow hash];
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"visible=%@", self.visible];
    [description appendFormat:@", font=%@", self.font];
    [description appendFormat:@", text=%@", self.text];
    [description appendFormat:@", position=%@", self.position];
    [description appendFormat:@", alignment=%@", self.alignment];
    [description appendFormat:@", color=%@", self.color];
    [description appendFormat:@", shadow=%@", self.shadow];
    [description appendString:@">"];
    return description;
}

@end


@implementation EGTextShadow
static ODClassType* _EGTextShadow_type;
@synthesize color = _color;
@synthesize shift = _shift;

+ (instancetype)textShadowWithColor:(GEVec4)color shift:(GEVec2)shift {
    return [[EGTextShadow alloc] initWithColor:color shift:shift];
}

- (instancetype)initWithColor:(GEVec4)color shift:(GEVec2)shift {
    self = [super init];
    if(self) {
        _color = color;
        _shift = shift;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGTextShadow class]) _EGTextShadow_type = [ODClassType classTypeWithCls:[EGTextShadow class]];
}

- (ODClassType*)type {
    return [EGTextShadow type];
}

+ (ODClassType*)type {
    return _EGTextShadow_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGTextShadow* o = ((EGTextShadow*)(other));
    return GEVec4Eq(self.color, o.color) && GEVec2Eq(self.shift, o.shift);
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + GEVec4Hash(self.color);
    hash = hash * 31 + GEVec2Hash(self.shift);
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"color=%@", GEVec4Description(self.color)];
    [description appendFormat:@", shift=%@", GEVec2Description(self.shift)];
    [description appendString:@">"];
    return description;
}

@end


@implementation EGFontShaderParam
static ODClassType* _EGFontShaderParam_type;
@synthesize texture = _texture;
@synthesize color = _color;
@synthesize shift = _shift;

+ (instancetype)fontShaderParamWithTexture:(EGTexture*)texture color:(GEVec4)color shift:(GEVec2)shift {
    return [[EGFontShaderParam alloc] initWithTexture:texture color:color shift:shift];
}

- (instancetype)initWithTexture:(EGTexture*)texture color:(GEVec4)color shift:(GEVec2)shift {
    self = [super init];
    if(self) {
        _texture = texture;
        _color = color;
        _shift = shift;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGFontShaderParam class]) _EGFontShaderParam_type = [ODClassType classTypeWithCls:[EGFontShaderParam class]];
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
    return [self.texture isEqual:o.texture] && GEVec4Eq(self.color, o.color) && GEVec2Eq(self.shift, o.shift);
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.texture hash];
    hash = hash * 31 + GEVec4Hash(self.color);
    hash = hash * 31 + GEVec2Hash(self.shift);
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"texture=%@", self.texture];
    [description appendFormat:@", color=%@", GEVec4Description(self.color)];
    [description appendFormat:@", shift=%@", GEVec2Description(self.shift)];
    [description appendString:@">"];
    return description;
}

@end


@implementation EGFontShaderBuilder
static ODClassType* _EGFontShaderBuilder_type;

+ (instancetype)fontShaderBuilder {
    return [[EGFontShaderBuilder alloc] init];
}

- (instancetype)init {
    self = [super init];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGFontShaderBuilder class]) _EGFontShaderBuilder_type = [ODClassType classTypeWithCls:[EGFontShaderBuilder class]];
}

- (NSString*)vertex {
    return [NSString stringWithFormat:@"%@\n"
        "uniform highp vec2 shift;\n"
        "%@ highp vec2 position;\n"
        "%@ mediump vec2 vertexUV;\n"
        "\n"
        "%@ mediump vec2 UV;\n"
        "\n"
        "void main(void) {\n"
        "    gl_Position = vec4(position.x + shift.x, position.y + shift.y, 0, 1);\n"
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
    if([self version] == 100 && [EGGlobal.settings shadowType] == EGShadowType.shadow2d) return @"#extension GL_EXT_shadow_samplers : require";
    else return @"";
}

- (NSString*)sampler2DShadow {
    if([EGGlobal.settings shadowType] == EGShadowType.shadow2d) return @"sampler2DShadow";
    else return @"sampler2D";
}

- (NSString*)shadow2DTexture:(NSString*)texture vec3:(NSString*)vec3 {
    if([EGGlobal.settings shadowType] == EGShadowType.shadow2d) return [NSString stringWithFormat:@"%@(%@, %@)", [self shadow2DEXT], texture, vec3];
    else return [NSString stringWithFormat:@"(%@(%@, %@.xy).x < %@.z ? 0.0 : 1.0)", [self texture2D], texture, vec3, vec3];
}

- (NSString*)blendMode:(EGBlendMode*)mode a:(NSString*)a b:(NSString*)b {
    return mode.blend(a, b);
}

- (NSString*)shadow2DEXT {
    if([self version] == 100) return @"shadow2DEXT";
    else return @"texture";
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


@implementation EGFontShader
static EGFontShader* _EGFontShader_instance;
static ODClassType* _EGFontShader_type;
@synthesize uvSlot = _uvSlot;
@synthesize positionSlot = _positionSlot;
@synthesize colorUniform = _colorUniform;
@synthesize shiftSlot = _shiftSlot;

+ (instancetype)fontShader {
    return [[EGFontShader alloc] init];
}

- (instancetype)init {
    self = [super initWithProgram:[[EGFontShaderBuilder fontShaderBuilder] program]];
    if(self) {
        _uvSlot = [self attributeForName:@"vertexUV"];
        _positionSlot = [self attributeForName:@"position"];
        _colorUniform = [self uniformVec4Name:@"color"];
        _shiftSlot = [self uniformVec2Name:@"shift"];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGFontShader class]) {
        _EGFontShader_type = [ODClassType classTypeWithCls:[EGFontShader class]];
        _EGFontShader_instance = [EGFontShader fontShader];
    }
}

- (void)loadAttributesVbDesc:(EGVertexBufferDesc*)vbDesc {
    [_positionSlot setFromBufferWithStride:((NSUInteger)([vbDesc stride])) valuesCount:2 valuesType:GL_FLOAT shift:((NSUInteger)(vbDesc.position))];
    [_uvSlot setFromBufferWithStride:((NSUInteger)([vbDesc stride])) valuesCount:2 valuesType:GL_FLOAT shift:((NSUInteger)(vbDesc.uv))];
}

- (void)loadUniformsParam:(EGFontShaderParam*)param {
    [EGGlobal.context bindTextureTexture:param.texture];
    [_colorUniform applyVec4:param.color];
    [_shiftSlot applyVec2:geVec4Xy(([[EGGlobal.matrix p] mulVec4:geVec4ApplyVec2ZW(param.shift, 0.0, 0.0)]))];
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


@implementation EGFontSymbolDesc
static ODClassType* _EGFontSymbolDesc_type;
@synthesize width = _width;
@synthesize offset = _offset;
@synthesize size = _size;
@synthesize textureRect = _textureRect;
@synthesize isNewLine = _isNewLine;

+ (instancetype)fontSymbolDescWithWidth:(float)width offset:(GEVec2)offset size:(GEVec2)size textureRect:(GERect)textureRect isNewLine:(BOOL)isNewLine {
    return [[EGFontSymbolDesc alloc] initWithWidth:width offset:offset size:size textureRect:textureRect isNewLine:isNewLine];
}

- (instancetype)initWithWidth:(float)width offset:(GEVec2)offset size:(GEVec2)size textureRect:(GERect)textureRect isNewLine:(BOOL)isNewLine {
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
    if(self == [EGFontSymbolDesc class]) _EGFontSymbolDesc_type = [ODClassType classTypeWithCls:[EGFontSymbolDesc class]];
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



