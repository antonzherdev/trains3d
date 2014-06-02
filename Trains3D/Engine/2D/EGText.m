#import "EGText.h"

#import "CNReact.h"
#import "EGContext.h"
#import "EGFont.h"
#import "CNObserver.h"
#import "EGVertexArray.h"
#import "CNDispatchQueue.h"
#import "EGFontShader.h"
@implementation EGText
static CNClassType* _EGText_type;
@synthesize visible = _visible;
@synthesize font = _font;
@synthesize text = _text;
@synthesize position = _position;
@synthesize alignment = _alignment;
@synthesize color = _color;
@synthesize shadow = _shadow;

+ (instancetype)textWithVisible:(CNReact*)visible font:(CNReact*)font text:(CNReact*)text position:(CNReact*)position alignment:(CNReact*)alignment color:(CNReact*)color shadow:(CNReact*)shadow {
    return [[EGText alloc] initWithVisible:visible font:font text:text position:position alignment:alignment color:color shadow:shadow];
}

- (instancetype)initWithVisible:(CNReact*)visible font:(CNReact*)font text:(CNReact*)text position:(CNReact*)position alignment:(CNReact*)alignment color:(CNReact*)color shadow:(CNReact*)shadow {
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
        __changed = [CNReactFlag reactFlagWithInitial:YES reacts:(@[((CNReact*)(font)), ((CNReact*)(text)), ((CNReact*)(position)), ((CNReact*)(alignment)), ((CNReact*)(shadow)), ((CNReact*)(EGGlobal.context.viewSize))])];
        _fontObserver = [font mapF:^CNObserver*(EGFont* newFont) {
            return [((EGFont*)(newFont)).symbolsChanged observeF:^void(id _) {
                EGText* _self = _weakSelf;
                if(_self != nil) [_self->__changed set];
            }];
        }];
        _isEmpty = [text mapF:^id(NSString* _) {
            return numb([_ isEmpty]);
        }];
        __lazy_sizeInPoints = [CNLazy lazyWithF:^CNReact*() {
            return [CNReact asyncQueue:CNDispatchQueue.mainThread a:font b:text f:^id(EGFont* f, NSString* t) {
                return wrap(GEVec2, [((EGFont*)(f)) measureInPointsText:t]);
            }];
        }];
        __lazy_sizeInP = [CNLazy lazyWithF:^CNReact*() {
            EGText* _self = _weakSelf;
            if(_self != nil) return [CNReact asyncQueue:CNDispatchQueue.mainThread a:[_self sizeInPoints] b:EGGlobal.context.scaledViewSize f:^id(id s, id vs) {
                return wrap(GEVec2, (geVec2DivVec2((geVec2MulI((uwrap(GEVec2, s)), 2)), (uwrap(GEVec2, vs)))));
            }];
            else return nil;
        }];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGText class]) _EGText_type = [CNClassType classTypeWithCls:[EGText class]];
}

- (CNReact*)sizeInPoints {
    return [__lazy_sizeInPoints get];
}

- (CNReact*)sizeInP {
    return [__lazy_sizeInP get];
}

- (void)draw {
    if(!(unumb([_visible value])) || unumb([_isEmpty value])) return ;
    if(unumb([__changed value])) {
        __vao = [((EGFont*)([_font value])) vaoText:[_text value] at:uwrap(GEVec3, [_position value]) alignment:uwrap(EGTextAlignment, [_alignment value])];
        [__changed clear];
    }
    {
        EGTextShadow* sh = [_shadow value];
        if(sh != nil) [((EGSimpleVertexArray*)(__vao)) drawParam:[EGFontShaderParam fontShaderParamWithTexture:[((EGFont*)([_font value])) texture] color:geVec4MulK(((EGTextShadow*)(sh)).color, (uwrap(GEVec4, [_color value]).w)) shift:((EGTextShadow*)(sh)).shift]];
    }
    [((EGSimpleVertexArray*)(__vao)) drawParam:[EGFontShaderParam fontShaderParamWithTexture:[((EGFont*)([_font value])) texture] color:uwrap(GEVec4, [_color value]) shift:GEVec2Make(0.0, 0.0)]];
}

- (GEVec2)measureInPoints {
    return [((EGFont*)([_font value])) measureInPointsText:[_text value]];
}

- (GEVec2)measureP {
    return [((EGFont*)([_font value])) measurePText:[_text value]];
}

- (GEVec2)measureC {
    return [((EGFont*)([_font value])) measureCText:[_text value]];
}

+ (EGText*)applyVisible:(CNReact*)visible font:(CNReact*)font text:(CNReact*)text position:(CNReact*)position alignment:(CNReact*)alignment color:(CNReact*)color {
    return [EGText textWithVisible:visible font:font text:text position:position alignment:alignment color:color shadow:[CNReact applyValue:nil]];
}

+ (EGText*)applyFont:(CNReact*)font text:(CNReact*)text position:(CNReact*)position alignment:(CNReact*)alignment color:(CNReact*)color shadow:(CNReact*)shadow {
    return [EGText textWithVisible:[CNReact applyValue:@YES] font:font text:text position:position alignment:alignment color:color shadow:shadow];
}

+ (EGText*)applyFont:(CNReact*)font text:(CNReact*)text position:(CNReact*)position alignment:(CNReact*)alignment color:(CNReact*)color {
    return [EGText textWithVisible:[CNReact applyValue:@YES] font:font text:text position:position alignment:alignment color:color shadow:[CNReact applyValue:nil]];
}

- (NSString*)description {
    return [NSString stringWithFormat:@"Text(%@, %@, %@, %@, %@, %@, %@)", _visible, _font, _text, _position, _alignment, _color, _shadow];
}

- (CNClassType*)type {
    return [EGText type];
}

+ (CNClassType*)type {
    return _EGText_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation EGTextShadow
static CNClassType* _EGTextShadow_type;
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
    if(self == [EGTextShadow class]) _EGTextShadow_type = [CNClassType classTypeWithCls:[EGTextShadow class]];
}

- (NSString*)description {
    return [NSString stringWithFormat:@"TextShadow(%@, %@)", geVec4Description(_color), geVec2Description(_shift)];
}

- (BOOL)isEqual:(id)to {
    if(self == to) return YES;
    if(to == nil || !([to isKindOfClass:[EGTextShadow class]])) return NO;
    EGTextShadow* o = ((EGTextShadow*)(to));
    return geVec4IsEqualTo(_color, o.color) && geVec2IsEqualTo(_shift, o.shift);
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + geVec4Hash(_color);
    hash = hash * 31 + geVec2Hash(_shift);
    return hash;
}

- (CNClassType*)type {
    return [EGTextShadow type];
}

+ (CNClassType*)type {
    return _EGTextShadow_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

