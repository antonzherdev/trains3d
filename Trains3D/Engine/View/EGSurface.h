#import "objd.h"
#import "EGGL.h"
@class EGTexture;

@class EGSurface;

@interface EGSurface : NSObject
@property (nonatomic, readonly) NSUInteger width;
@property (nonatomic, readonly) NSUInteger height;

+ (id)surfaceWithWidth:(NSUInteger)width height:(NSUInteger)height;
- (id)initWithWidth:(NSUInteger)width height:(NSUInteger)height;
- (ODClassType*)type;
- (void)init;
- (void)dealloc;
- (void)applyDraw:(void(^)())draw;
- (void)bind;
- (void)unbind;
- (void)draw;
+ (ODClassType*)type;
@end


