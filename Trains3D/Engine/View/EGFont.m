#import "EGFont.h"

#import "EGVertex.h"
#import "ATObserver.h"
#import "EGTexture.h"
#import "EGDirector.h"
#import "EGContext.h"
#import "ATReact.h"
#import "EGMatrixModel.h"
#import "GEMat4.h"
#import "EGVertexArray.h"
#import "EGIndex.h"
#import "EGFontShader.h"
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
static EGFontSymbolDesc* _EGFont_newLineDesc;
static EGFontSymbolDesc* _EGFont_zeroDesc;
static EGVertexBufferDesc* _EGFont_vbDesc;
static ODClassType* _EGFont_type;
@synthesize symbolsChanged = _symbolsChanged;

+ (instancetype)font {
    return [[EGFont alloc] init];
}

- (instancetype)init {
    self = [super init];
    if(self) _symbolsChanged = [ATSignal signal];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGFont class]) {
        _EGFont_type = [ODClassType classTypeWithCls:[EGFont class]];
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

- (GEVec2)measureInPointsText:(NSString*)text {
    CNTuple* pair = [self buildSymbolArrayHasGL:NO text:text];
    NSArray* symbolsArr = pair.a;
    NSInteger newLines = unumi(pair.b);
    __block NSInteger fullWidth = 0;
    __block NSInteger lineWidth = 0;
    for(EGFontSymbolDesc* s in symbolsArr) {
        if(((EGFontSymbolDesc*)(s)).isNewLine) {
            if(lineWidth > fullWidth) fullWidth = lineWidth;
            lineWidth = 0;
        } else {
            lineWidth += ((NSInteger)(((EGFontSymbolDesc*)(s)).width));
        }
    }
    if(lineWidth > fullWidth) fullWidth = lineWidth;
    return geVec2DivF4((GEVec2Make(((float)(fullWidth)), ((float)([self height])) * (newLines + 1))), ((float)([[EGDirector current] scale])));
}

- (EGFontSymbolDesc*)symbolOptSmb:(unichar)smb {
    @throw @"Method symbolOpt is abstract";
}

- (GEVec2)measurePText:(NSString*)text {
    return geVec2DivVec2((geVec2MulF4([self measureInPointsText:text], 2.0)), (uwrap(GEVec2, [EGGlobal.context.scaledViewSize value])));
}

- (GEVec2)measureCText:(NSString*)text {
    return geVec4Xy(([[EGGlobal.matrix p] divBySelfVec4:geVec4ApplyVec2ZW([self measurePText:text], 0.0, 0.0)]));
}

- (BOOL)resymbolHasGL:(BOOL)hasGL {
    return NO;
}

- (CNTuple*)buildSymbolArrayHasGL:(BOOL)hasGL text:(NSString*)text {
    @synchronized(self) {
        __block NSInteger newLines = 0;
        NSArray* symbolsArr = [[[text chain] mapOpt:^EGFontSymbolDesc*(id s) {
            if(unumi(s) == 10) {
                newLines++;
                return _EGFont_newLineDesc;
            } else {
                return [self symbolOptSmb:unums(s)];
            }
        }] toArray];
        if([self resymbolHasGL:hasGL]) symbolsArr = [[[text chain] mapOpt:^EGFontSymbolDesc*(id s) {
            if(unumi(s) == 10) return _EGFont_newLineDesc;
            else return [self symbolOptSmb:unums(s)];
        }] toArray];
        return tuple(symbolsArr, numi(newLines));
    }
}

- (EGSimpleVertexArray*)vaoText:(NSString*)text at:(GEVec3)at alignment:(EGTextAlignment)alignment {
    GEVec2 pos = geVec2AddVec2((geVec4Xy(([[EGGlobal.matrix wcp] mulVec4:geVec4ApplyVec3W(at, 1.0)]))), (geVec2MulF4((geVec2DivVec2(alignment.shift, (uwrap(GEVec2, [EGGlobal.context.scaledViewSize value])))), 2.0)));
    CNTuple* pair = [self buildSymbolArrayHasGL:YES text:text];
    NSArray* symbolsArr = pair.a;
    NSInteger newLines = unumi(pair.b);
    NSUInteger symbolsCount = [symbolsArr count] - newLines;
    EGFontPrintData* vertexes = cnPointerApplyTpCount(egFontPrintDataType(), symbolsCount * 4);
    unsigned int* indexes = cnPointerApplyTpCount(oduInt4Type(), symbolsCount * 6);
    GEVec2 vpSize = geVec2iDivF4([EGGlobal.context viewport].size, 2.0);
    __block EGFontPrintData* vp = vertexes;
    __block unsigned int* ip = indexes;
    __block unsigned int n = 0;
    NSMutableArray* linesWidth = [NSMutableArray mutableArray];
    id<CNIterator> linesWidthIterator;
    __block float x = pos.x;
    if(!(eqf4(alignment.x, -1))) {
        __block NSInteger lineWidth = 0;
        for(EGFontSymbolDesc* s in symbolsArr) {
            if(((EGFontSymbolDesc*)(s)).isNewLine) {
                [linesWidth appendItem:numi(lineWidth)];
                lineWidth = 0;
            } else {
                lineWidth += ((NSInteger)(((EGFontSymbolDesc*)(s)).width));
            }
        }
        [linesWidth appendItem:numi(lineWidth)];
        linesWidthIterator = [linesWidth iterator];
        x = pos.x - unumi([((id<CNIterator>)(nonnil(linesWidthIterator))) next]) / vpSize.x * (alignment.x / 2 + 0.5);
    }
    float hh = ((float)([self height])) / vpSize.y;
    __block float y = ((alignment.baseline) ? pos.y + ((float)([self size])) / vpSize.y : pos.y - hh * (newLines + 1) * (alignment.y / 2 - 0.5));
    for(EGFontSymbolDesc* s in symbolsArr) {
        if(((EGFontSymbolDesc*)(s)).isNewLine) {
            x = ((eqf4(alignment.x, -1)) ? pos.x : pos.x - unumi([((id<CNIterator>)(nonnil(linesWidthIterator))) next]) / vpSize.x * (alignment.x / 2 + 0.5));
            y -= hh;
        } else {
            GEVec2 size = geVec2DivVec2(((EGFontSymbolDesc*)(s)).size, vpSize);
            GERect tr = ((EGFontSymbolDesc*)(s)).textureRect;
            GEVec2 v0 = GEVec2Make(x + ((EGFontSymbolDesc*)(s)).offset.x / vpSize.x, y - ((EGFontSymbolDesc*)(s)).offset.y / vpSize.y);
            vp->position = v0;
            vp->uv = tr.p;
            vp++;
            vp->position = GEVec2Make(v0.x, v0.y - size.y);
            vp->uv = geRectPh(tr);
            vp++;
            vp->position = GEVec2Make(v0.x + size.x, v0.y - size.y);
            vp->uv = geRectPhw(tr);
            vp++;
            vp->position = GEVec2Make(v0.x + size.x, v0.y);
            vp->uv = geRectPw(tr);
            vp++;
            *(ip + 0) = n;
            *(ip + 1) = n + 1;
            *(ip + 2) = n + 2;
            *(ip + 3) = n + 2;
            *(ip + 4) = n + 3;
            *(ip + 5) = n;
            ip += 6;
            x += ((EGFontSymbolDesc*)(s)).width / vpSize.x;
            n += 4;
        }
    }
    id<EGVertexBuffer> vb = [EGVBO applyDesc:_EGFont_vbDesc array:vertexes count:((unsigned int)(symbolsCount * 4))];
    EGImmutableIndexBuffer* ib = [EGIBO applyPointer:indexes count:((unsigned int)(symbolsCount * 6))];
    cnPointerFree(vertexes);
    cnPointerFree(indexes);
    return [EGFontShader.instance vaoVbo:vb ibo:ib];
}

- (void)drawText:(NSString*)text at:(GEVec3)at alignment:(EGTextAlignment)alignment color:(GEVec4)color {
    EGSimpleVertexArray* vao = [self vaoText:text at:at alignment:alignment];
    {
        EGCullFace* __tmp_1self = EGGlobal.context.cullFace;
        {
            unsigned int __inline__1_oldValue = [__tmp_1self disable];
            [vao drawParam:[EGFontShaderParam fontShaderParamWithTexture:[self texture] color:color shift:GEVec2Make(0.0, 0.0)]];
            if(__inline__1_oldValue != GL_NONE) [__tmp_1self setValue:__inline__1_oldValue];
        }
    }
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



