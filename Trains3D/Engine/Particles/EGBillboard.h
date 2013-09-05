#import "objd.h"
@class EG;
@class EGContext;
@class EGMatrixStack;
@class EGMatrixModel;
#import "EGGL.h"
#import "EGVec.h"
@class EGColorSource;
@class EGColorSourceColor;
@class EGColorSourceTexture;
@class EGMaterial;
@class EGSimpleMaterial;
@class EGStandardMaterial;
@class EGShaderProgram;
@class EGShader;
@class EGShaderAttribute;
@class EGShaderUniform;
@protocol EGShaderSystem;
@class EGMatrix;

@class EGBillboard;
@class EGBillboardShader;

@interface EGBillboard : NSObject
+ (id)billboard;
- (id)init;
- (ODClassType*)type;
+ (void)drawWithSize:(EGVec2)size;
+ (ODClassType*)type;
@end


@interface EGBillboardShader : NSObject
@property (nonatomic, readonly) EGShaderProgram* program;
@property (nonatomic, readonly) BOOL texture;
@property (nonatomic, readonly) EGShaderAttribute* positionSlot;
@property (nonatomic, readonly) EGShaderAttribute* modelSlot;
@property (nonatomic, readonly) id uvSlot;
@property (nonatomic, readonly) EGShaderUniform* wcUniform;
@property (nonatomic, readonly) EGShaderUniform* pUniform;

+ (id)billboardShaderWithProgram:(EGShaderProgram*)program texture:(BOOL)texture;
- (id)initWithProgram:(EGShaderProgram*)program texture:(BOOL)texture;
- (ODClassType*)type;
+ (NSString*)vertexTextWithTexture:(BOOL)texture parameters:(NSString*)parameters code:(NSString*)code;
+ (NSString*)fragmentTextWithTexture:(BOOL)texture parameters:(NSString*)parameters code:(NSString*)code;
- (void)load;
- (void)applyDraw:(void(^)())draw;
+ (ODClassType*)type;
@end


