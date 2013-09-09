#import "objd.h"
#import "EGGL.h"
@class EGTexture;
@class EGVertexBuffer;
@class EGIndexBuffer;
@class EGShaderProgram;
@class EGShaderAttribute;

@class EGSurface;
@class EGSurfaceShader;

@interface EGSurface : NSObject
@property (nonatomic, readonly) NSUInteger width;
@property (nonatomic, readonly) NSUInteger height;
@property (nonatomic, readonly) EGTexture* texture;

+ (id)surfaceWithWidth:(NSUInteger)width height:(NSUInteger)height;
- (id)initWithWidth:(NSUInteger)width height:(NSUInteger)height;
- (ODClassType*)type;
- (EGSurface*)init;
- (void)dealloc;
- (void)applyDraw:(void(^)())draw;
- (void)bind;
- (void)unbind;
- (void)drawFullScreen;
+ (ODClassType*)type;
@end


@interface EGSurfaceShader : NSObject
@property (nonatomic, readonly) EGShaderProgram* program;
@property (nonatomic, readonly) EGShaderAttribute* positionSlot;

+ (id)surfaceShader;
- (id)init;
- (ODClassType*)type;
- (void)applyDraw:(void(^)())draw;
+ (NSString*)vertex;
+ (NSString*)fragment;
+ (ODClassType*)type;
@end


