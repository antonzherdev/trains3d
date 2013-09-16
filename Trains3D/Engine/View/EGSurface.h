#import "objd.h"
#import "GEVec.h"
#import "GL.h"
@class EGTexture;
@class EGVertexBuffer;
@class EGIndexBuffer;
@class EGShaderProgram;
@class EGShaderAttribute;

@class EGSurface;
@class EGSurfaceShader;
@class EGFullScreenSurface;

@interface EGSurface : NSObject
@property (nonatomic, readonly) GEVec2i size;
@property (nonatomic, readonly) EGTexture* texture;

+ (id)surfaceWithSize:(GEVec2i)size;
- (id)initWithSize:(GEVec2i)size;
- (ODClassType*)type;
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


@interface EGFullScreenSurface : NSObject
+ (id)fullScreenSurface;
- (id)init;
- (ODClassType*)type;
- (void)bind;
- (void)applyDraw:(void(^)())draw;
- (void)unbind;
+ (ODClassType*)type;
@end


