#import "EGText.h"

#import "ATReact.h"
#import "EGContext.h"
#import "EGFont.h"
#import "ATObserver.h"
#import "EGVertexArray.h"
#import "EGFontShader.h"
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
        __changed = [ATReactFlag reactFlagWithInitial:YES reacts:(@[((ATReact*)(_font)), ((ATReact*)(_text)), ((ATReact*)(_position)), ((ATReact*)(_alignment)), ((ATReact*)(_shadow)), ((ATReact*)(EGGlobal.context.viewSize))])];
        _fontObserver = [_font mapF:^ATObserver*(EGFont* newFont) {
            return [((EGFont*)(newFont)).symbolsChanged observeF:^void(id _) {
                EGText* _self = _weakSelf;
                if(_self != nil) [_self->__changed set];
            }];
        }];
        __lazy_sizeInPoints = [CNLazy lazyWithF:^ATReact*() {
            EGText* _self = _weakSelf;
            if(_self != nil) return [ATReact asyncQueue:CNDispatchQueue.mainThread a:_self->_font b:_self->_text f:^id(EGFont* f, NSString* t) {
                return wrap(GEVec2, [((EGFont*)(f)) measureInPointsText:t]);
            }];
            else return nil;
        }];
        __lazy_sizeInP = [CNLazy lazyWithF:^ATReact*() {
            EGText* _self = _weakSelf;
            if(_self != nil) return [ATReact asyncQueue:CNDispatchQueue.mainThread a:[_self sizeInPoints] b:EGGlobal.context.scaledViewSize f:^id(id s, id vs) {
                return wrap(GEVec2, (geVec2DivVec2((geVec2MulF4((uwrap(GEVec2, s)), 2.0)), (uwrap(GEVec2, vs)))));
            }];
            else return nil;
        }];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGText class]) _EGText_type = [ODClassType classTypeWithCls:[EGText class]];
}

- (ATReact*)sizeInPoints {
    return [__lazy_sizeInPoints get];
}

- (ATReact*)sizeInP {
    return [__lazy_sizeInP get];
}

- (void)draw {
    if(!(unumb([_visible value]))) return ;
    if(unumb([__changed value])) {
        __vao = [((EGFont*)([_font value])) vaoText:[_text value] at:uwrap(GEVec3, [_position value]) alignment:uwrap(EGTextAlignment, [_alignment value])];
        [__changed clear];
    }
    {
        EGTextShadow* sh = [_shadow value];
        if(sh != nil) [((EGSimpleVertexArray*)(__vao)) drawParam:[EGFontShaderParam fontShaderParamWithTexture:[((EGFont*)([_font value])) texture] color:geVec4MulK(sh.color, (uwrap(GEVec4, [_color value]).w)) shift:sh.shift]];
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

+ (EGText*)applyVisible:(ATReact*)visible font:(ATReact*)font text:(ATReact*)text position:(ATReact*)position alignment:(ATReact*)alignment color:(ATReact*)color {
    return [EGText textWithVisible:visible font:font text:text position:position alignment:alignment color:color shadow:[ATReact applyValue:nil]];
}

+ (EGText*)applyFont:(ATReact*)font text:(ATReact*)text position:(ATReact*)position alignment:(ATReact*)alignment color:(ATReact*)color shadow:(ATReact*)shadow {
    return [EGText textWithVisible:[ATReact applyValue:@YES] font:font text:text position:position alignment:alignment color:color shadow:shadow];
}

+ (EGText*)applyFont:(ATReact*)font text:(ATReact*)text position:(ATReact*)position alignment:(ATReact*)alignment color:(ATReact*)color {
    return [EGText textWithVisible:[ATReact applyValue:@YES] font:font text:text position:position alignment:alignment color:color shadow:[ATReact applyValue:nil]];
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


