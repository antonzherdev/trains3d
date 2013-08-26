#import "objd.h"
#import "CNTypes.h"
@class EG;
#import "EGGL.h"
#import "EGShader.h"
#import "EGTypes.h"
@class EGContext;
@class EGMutableMatrix;

@class EGStandardShader;
@class EGSimpleColorShader;

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
+ (EGSimpleColorShader*)instance;
@end


