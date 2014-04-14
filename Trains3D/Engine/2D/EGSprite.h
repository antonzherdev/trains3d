#import "objd.h"
#import "EGBillboard.h"
#import "GEVec.h"
@class EGVertexBufferDesc;
@class ATReact;
@class EGMutableVertexBuffer;
@class EGVBO;
@class EGVertexArray;
@class ATReactFlag;
@class EGColorSource;
@class EGGlobal;
@class EGContext;
@class ATSignal;
@class EGTexture;
@class EGDirector;
@class EGEmptyIndexSource;
@class EGMesh;
@class EGBillboardShaderSystem;
@class EGCullFace;
@class EGMatrixStack;
@class EGMMatrixModel;
@class GEMat4;
@protocol EGEvent;
@class EGRecognizer;
@class EGTap;

@class EGSprite;

@interface EGSprite : NSObject {
@protected
    ATReact* _visible;
    ATReact* _material;
    ATReact* _position;
    ATReact* _rect;
    EGMutableVertexBuffer* _vb;
    EGVertexArray* _vao;
    ATReactFlag* __changed;
    ATReactFlag* __materialChanged;
    ATSignal* _tap;
}
@property (nonatomic, readonly) ATReact* visible;
@property (nonatomic, readonly) ATReact* material;
@property (nonatomic, readonly) ATReact* position;
@property (nonatomic, readonly) ATReact* rect;
@property (nonatomic, readonly) ATSignal* tap;

+ (instancetype)spriteWithVisible:(ATReact*)visible material:(ATReact*)material position:(ATReact*)position rect:(ATReact*)rect;
- (instancetype)initWithVisible:(ATReact*)visible material:(ATReact*)material position:(ATReact*)position rect:(ATReact*)rect;
- (ODClassType*)type;
+ (EGSprite*)applyVisible:(ATReact*)visible material:(ATReact*)material position:(ATReact*)position anchor:(GEVec2)anchor;
+ (EGSprite*)applyMaterial:(ATReact*)material position:(ATReact*)position anchor:(GEVec2)anchor;
+ (ATReact*)rectReactMaterial:(ATReact*)material anchor:(GEVec2)anchor;
- (void)draw;
- (GERect)rectInViewport;
- (BOOL)containsViewportVec2:(GEVec2)vec2;
- (BOOL)tapEvent:(id<EGEvent>)event;
- (EGRecognizer*)recognizer;
+ (EGSprite*)applyVisible:(ATReact*)visible material:(ATReact*)material position:(ATReact*)position;
+ (EGSprite*)applyMaterial:(ATReact*)material position:(ATReact*)position rect:(ATReact*)rect;
+ (EGSprite*)applyMaterial:(ATReact*)material position:(ATReact*)position;
+ (EGVertexBufferDesc*)vbDesc;
+ (ODClassType*)type;
@end


