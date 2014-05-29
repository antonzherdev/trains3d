#import "objd.h"
#import "EGBillboard.h"
#import "GEVec.h"
@class EGVertexBufferDesc;
@class CNReact;
@class EGMutableVertexBuffer;
@class EGVBO;
@class EGVertexArray;
@class CNReactFlag;
@class EGColorSource;
@class EGGlobal;
@class EGContext;
@class CNSignal;
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
    CNReact* _visible;
    CNReact* _material;
    CNReact* _position;
    CNReact* _rect;
    EGMutableVertexBuffer* _vb;
    EGVertexArray* _vao;
    CNReactFlag* __changed;
    CNReactFlag* __materialChanged;
    CNSignal* _tap;
}
@property (nonatomic, readonly) CNReact* visible;
@property (nonatomic, readonly) CNReact* material;
@property (nonatomic, readonly) CNReact* position;
@property (nonatomic, readonly) CNReact* rect;
@property (nonatomic, readonly) CNSignal* tap;

+ (instancetype)spriteWithVisible:(CNReact*)visible material:(CNReact*)material position:(CNReact*)position rect:(CNReact*)rect;
- (instancetype)initWithVisible:(CNReact*)visible material:(CNReact*)material position:(CNReact*)position rect:(CNReact*)rect;
- (CNClassType*)type;
+ (EGSprite*)applyVisible:(CNReact*)visible material:(CNReact*)material position:(CNReact*)position anchor:(GEVec2)anchor;
+ (EGSprite*)applyMaterial:(CNReact*)material position:(CNReact*)position anchor:(GEVec2)anchor;
+ (CNReact*)rectReactMaterial:(CNReact*)material anchor:(GEVec2)anchor;
- (void)draw;
- (GERect)rectInViewport;
- (BOOL)containsViewportVec2:(GEVec2)vec2;
- (BOOL)tapEvent:(id<EGEvent>)event;
- (EGRecognizer*)recognizer;
+ (EGSprite*)applyVisible:(CNReact*)visible material:(CNReact*)material position:(CNReact*)position;
+ (EGSprite*)applyMaterial:(CNReact*)material position:(CNReact*)position rect:(CNReact*)rect;
+ (EGSprite*)applyMaterial:(CNReact*)material position:(CNReact*)position;
- (NSString*)description;
+ (EGVertexBufferDesc*)vbDesc;
+ (CNClassType*)type;
@end


