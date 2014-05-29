#import "EGFont.h"

#import "EGVertex.h"
#import "CNObserver.h"
#import "EGTexture.h"
#import "EGDirector.h"
#import "EGContext.h"
#import "CNReact.h"
#import "EGMatrixModel.h"
#import "GEMat4.h"
#import "CNChain.h"
#import "EGVertexArray.h"
#import "EGIndex.h"
#import "EGFontShader.h"
#import "GL.h"
EGTextAlignment egTextAlignmentApplyXY(float x, float y) {
    return EGTextAlignmentMake(x, y, NO, (GEVec2Make(0.0, 0.0)));
}
EGTextAlignment egTextAlignmentApplyXYShift(float x, float y, GEVec2 shift) {
    return EGTextAlignmentMake(x, y, NO, shift);
}
EGTextAlignment egTextAlignmentBaselineX(float x) {
    return EGTextAlignmentMake(x, 0.0, YES, (GEVec2Make(0.0, 0.0)));
}
NSString* egTextAlignmentDescription(EGTextAlignment self) {
    return [NSString stringWithFormat:@"TextAlignment(%f, %f, %d, %@)", self.x, self.y, self.baseline, geVec2Description(self.shift)];
}
BOOL egTextAlignmentIsEqualTo(EGTextAlignment self, EGTextAlignment to) {
    return eqf4(self.x, to.x) && eqf4(self.y, to.y) && self.baseline == to.baseline && geVec2IsEqualTo(self.shift, to.shift);
}
NSUInteger egTextAlignmentHash(EGTextAlignment self) {
    NSUInteger hash = 0;
    hash = hash * 31 + float4Hash(self.x);
    hash = hash * 31 + float4Hash(self.y);
    hash = hash * 31 + self.baseline;
    hash = hash * 31 + geVec2Hash(self.shift);
    return hash;
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
CNPType* egTextAlignmentType() {
    static CNPType* _ret = nil;
    if(_ret == nil) _ret = [CNPType typeWithCls:[EGTextAlignmentWrap class] name:@"EGTextAlignment" size:sizeof(EGTextAlignment) wrap:^id(void* data, NSUInteger i) {
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

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end


@implementation EGFont
static EGFontSymbolDesc* _EGFont_newLineDesc;
static EGFontSymbolDesc* _EGFont_zeroDesc;
static EGVertexBufferDesc* _EGFont_vbDesc;
static CNClassType* _EGFont_type;
@synthesize symbolsChanged = _symbolsChanged;

+ (instancetype)font {
    return [[EGFont alloc] init];
}

- (instancetype)init {
    self = [super init];
    if(self) _symbolsChanged = [CNSignal signal];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGFont class]) {
        _EGFont_type = [CNClassType classTypeWithCls:[EGFont class]];
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
        NSArray* symbolsArr = [[[text chain] mapOptF:^EGFontSymbolDesc*(id s) {
            if(unumi(s) == 10) {
                newLines++;
                return _EGFont_newLineDesc;
            } else {
                return [self symbolOptSmb:unums(s)];
            }
        }] toArray];
        if([self resymbolHasGL:hasGL]) symbolsArr = [[[text chain] mapOptF:^EGFontSymbolDesc*(id s) {
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
    unsigned int* indexes = cnPointerApplyTpCount(cnuInt4Type(), symbolsCount * 6);
    GEVec2 vpSize = geVec2iDivF4([EGGlobal.context viewport].size, 2.0);
    __block EGFontPrintData* vp = vertexes;
    __block unsigned int* ip = indexes;
    __block unsigned int n = 0;
    CNMArray* linesWidth = [CNMArray array];
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
        EGCullFace* __tmp__il__1self = EGGlobal.context.cullFace;
        {
            unsigned int __il__1oldValue = [__tmp__il__1self disable];
            [vao drawParam:[EGFontShaderParam fontShaderParamWithTexture:[self texture] color:color shift:GEVec2Make(0.0, 0.0)]];
            if(__il__1oldValue != GL_NONE) [__tmp__il__1self setValue:__il__1oldValue];
        }
    }
}

- (EGFont*)beReadyForText:(NSString*)text {
    [[text chain] forEach:^void(id s) {
        [self symbolOptSmb:unums(s)];
    }];
    return self;
}

- (NSString*)description {
    return @"Font";
}

- (CNClassType*)type {
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

+ (CNClassType*)type {
    return _EGFont_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation EGFontSymbolDesc
static CNClassType* _EGFontSymbolDesc_type;
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
    if(self == [EGFontSymbolDesc class]) _EGFontSymbolDesc_type = [CNClassType classTypeWithCls:[EGFontSymbolDesc class]];
}

- (NSString*)description {
    return [NSString stringWithFormat:@"FontSymbolDesc(%f, %@, %@, %@, %d)", _width, geVec2Description(_offset), geVec2Description(_size), geRectDescription(_textureRect), _isNewLine];
}

- (BOOL)isEqual:(id)to {
    if(self == to) return YES;
    if(to == nil || !([to isKindOfClass:[EGFontSymbolDesc class]])) return NO;
    EGFontSymbolDesc* o = ((EGFontSymbolDesc*)(to));
    return eqf4(_width, o.width) && geVec2IsEqualTo(_offset, o.offset) && geVec2IsEqualTo(_size, o.size) && geRectIsEqualTo(_textureRect, o.textureRect) && _isNewLine == o.isNewLine;
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + float4Hash(_width);
    hash = hash * 31 + geVec2Hash(_offset);
    hash = hash * 31 + geVec2Hash(_size);
    hash = hash * 31 + geRectHash(_textureRect);
    hash = hash * 31 + _isNewLine;
    return hash;
}

- (CNClassType*)type {
    return [EGFontSymbolDesc type];
}

+ (CNClassType*)type {
    return _EGFontSymbolDesc_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

NSString* egFontPrintDataDescription(EGFontPrintData self) {
    return [NSString stringWithFormat:@"FontPrintData(%@, %@)", geVec2Description(self.position), geVec2Description(self.uv)];
}
BOOL egFontPrintDataIsEqualTo(EGFontPrintData self, EGFontPrintData to) {
    return geVec2IsEqualTo(self.position, to.position) && geVec2IsEqualTo(self.uv, to.uv);
}
NSUInteger egFontPrintDataHash(EGFontPrintData self) {
    NSUInteger hash = 0;
    hash = hash * 31 + geVec2Hash(self.position);
    hash = hash * 31 + geVec2Hash(self.uv);
    return hash;
}
CNPType* egFontPrintDataType() {
    static CNPType* _ret = nil;
    if(_ret == nil) _ret = [CNPType typeWithCls:[EGFontPrintDataWrap class] name:@"EGFontPrintData" size:sizeof(EGFontPrintData) wrap:^id(void* data, NSUInteger i) {
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

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end


