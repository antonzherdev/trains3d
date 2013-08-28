#import "objd.h"
#import "CNTypes.h"
@class EG;
#import "EGGL.h"
#import "EGShader.h"
#import "EGTypes.h"
@class EGContext;
@class EGMutableMatrix;
@class EGTexture;

@class EGStandardShader;
@class EGSimpleColorShader;
@class EGSimpleTextureShader;

@interface EGStandardShader : EGShader
+ (id)standardShaderWithProgram:(EGShaderProgram*)program;
- (id)initWithProgram:(EGShaderProgram*)program;
+ (NSInteger)STRIDE;
+ (NSInteger)POSITION_SHIFT;
@end


@interface EGSimpleColorShader : EGStandardShader
@property (nonatomic) EGColor color;
@property (nonatomic, readonly) EGShaderAttribute* positionSlot;
@property (nonatomic, readonly) EGShaderUniform* colorUniform;
@property (nonatomic, readonly) EGShaderUniform* mvpUniform;

+ (id)simpleColorShader;
- (id)init;
- (void)load;
+ (NSString*)vertexProgram;
+ (NSString*)fragmentProgram;
+ (EGSimpleColorShader*)instance;
@end


@interface EGSimpleTextureShader : EGStandardShader
@property (nonatomic, retain) EGTexture* texture;
@property (nonatomic, readonly) EGShaderAttribute* positionSlot;
@property (nonatomic, readonly) EGShaderUniform* colorUniform;
@property (nonatomic, readonly) EGShaderUniform* mvpUniform;

+ (id)simpleTextureShader;
- (id)init;
- (void)load;
+ (NSString*)vertexProgram1;
+ (NSString*)fragmentProgram1;
+ (EGSimpleTextureShader*)instance1;
@end


