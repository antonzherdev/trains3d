#import "objd.h"
#import "GEVec.h"
@class CNReact;
@class CNReactFlag;
@class EGGlobal;
@class EGContext;
@class EGFont;
@class CNSignal;
@class EGSimpleVertexArray;
@class CNDispatchQueue;
@class EGFontShaderParam;

@class EGText;
@class EGTextShadow;

@interface EGText : NSObject {
@protected
    CNReact* _visible;
    CNReact* _font;
    CNReact* _text;
    CNReact* _position;
    CNReact* _alignment;
    CNReact* _color;
    CNReact* _shadow;
    CNReactFlag* __changed;
    CNReact* _fontObserver;
    EGSimpleVertexArray* __vao;
    CNReact* _isEmpty;
    CNLazy* __lazy_sizeInPoints;
    CNLazy* __lazy_sizeInP;
}
@property (nonatomic, readonly) CNReact* visible;
@property (nonatomic, readonly) CNReact* font;
@property (nonatomic, readonly) CNReact* text;
@property (nonatomic, readonly) CNReact* position;
@property (nonatomic, readonly) CNReact* alignment;
@property (nonatomic, readonly) CNReact* color;
@property (nonatomic, readonly) CNReact* shadow;

+ (instancetype)textWithVisible:(CNReact*)visible font:(CNReact*)font text:(CNReact*)text position:(CNReact*)position alignment:(CNReact*)alignment color:(CNReact*)color shadow:(CNReact*)shadow;
- (instancetype)initWithVisible:(CNReact*)visible font:(CNReact*)font text:(CNReact*)text position:(CNReact*)position alignment:(CNReact*)alignment color:(CNReact*)color shadow:(CNReact*)shadow;
- (CNClassType*)type;
- (CNReact*)sizeInPoints;
- (CNReact*)sizeInP;
- (void)draw;
- (GEVec2)measureInPoints;
- (GEVec2)measureP;
- (GEVec2)measureC;
+ (EGText*)applyVisible:(CNReact*)visible font:(CNReact*)font text:(CNReact*)text position:(CNReact*)position alignment:(CNReact*)alignment color:(CNReact*)color;
+ (EGText*)applyFont:(CNReact*)font text:(CNReact*)text position:(CNReact*)position alignment:(CNReact*)alignment color:(CNReact*)color shadow:(CNReact*)shadow;
+ (EGText*)applyFont:(CNReact*)font text:(CNReact*)text position:(CNReact*)position alignment:(CNReact*)alignment color:(CNReact*)color;
- (NSString*)description;
+ (CNClassType*)type;
@end


@interface EGTextShadow : NSObject {
@protected
    GEVec4 _color;
    GEVec2 _shift;
}
@property (nonatomic, readonly) GEVec4 color;
@property (nonatomic, readonly) GEVec2 shift;

+ (instancetype)textShadowWithColor:(GEVec4)color shift:(GEVec2)shift;
- (instancetype)initWithColor:(GEVec4)color shift:(GEVec2)shift;
- (CNClassType*)type;
- (NSString*)description;
- (BOOL)isEqual:(id)to;
- (NSUInteger)hash;
+ (CNClassType*)type;
@end


