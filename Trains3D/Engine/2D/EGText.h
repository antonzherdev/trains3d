#import "objd.h"
#import "GEVec.h"
@class ATReact;
@class ATReactFlag;
@class EGGlobal;
@class EGContext;
@class EGFont;
@class ATSignal;
@class EGSimpleVertexArray;
@class EGFontShaderParam;

@class EGText;
@class EGTextShadow;

@interface EGText : NSObject {
@protected
    ATReact* _visible;
    ATReact* _font;
    ATReact* _text;
    ATReact* _position;
    ATReact* _alignment;
    ATReact* _color;
    ATReact* _shadow;
    ATReactFlag* __changed;
    ATReact* _fontObserver;
    EGSimpleVertexArray* __vao;
    ATReact* _isEmpty;
    CNLazy* __lazy_sizeInPoints;
    CNLazy* __lazy_sizeInP;
}
@property (nonatomic, readonly) ATReact* visible;
@property (nonatomic, readonly) ATReact* font;
@property (nonatomic, readonly) ATReact* text;
@property (nonatomic, readonly) ATReact* position;
@property (nonatomic, readonly) ATReact* alignment;
@property (nonatomic, readonly) ATReact* color;
@property (nonatomic, readonly) ATReact* shadow;

+ (instancetype)textWithVisible:(ATReact*)visible font:(ATReact*)font text:(ATReact*)text position:(ATReact*)position alignment:(ATReact*)alignment color:(ATReact*)color shadow:(ATReact*)shadow;
- (instancetype)initWithVisible:(ATReact*)visible font:(ATReact*)font text:(ATReact*)text position:(ATReact*)position alignment:(ATReact*)alignment color:(ATReact*)color shadow:(ATReact*)shadow;
- (ODClassType*)type;
- (ATReact*)sizeInPoints;
- (ATReact*)sizeInP;
- (void)draw;
- (GEVec2)measureInPoints;
- (GEVec2)measureP;
- (GEVec2)measureC;
+ (EGText*)applyVisible:(ATReact*)visible font:(ATReact*)font text:(ATReact*)text position:(ATReact*)position alignment:(ATReact*)alignment color:(ATReact*)color;
+ (EGText*)applyFont:(ATReact*)font text:(ATReact*)text position:(ATReact*)position alignment:(ATReact*)alignment color:(ATReact*)color shadow:(ATReact*)shadow;
+ (EGText*)applyFont:(ATReact*)font text:(ATReact*)text position:(ATReact*)position alignment:(ATReact*)alignment color:(ATReact*)color;
+ (ODClassType*)type;
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
- (ODClassType*)type;
+ (ODClassType*)type;
@end


