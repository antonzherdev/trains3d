#import <Foundation/Foundation.h>

@interface EGTexture : NSObject
@property (readonly, nonatomic) GLuint id;
@property (readonly, nonatomic) CGSize size;

+ (id)textureWithId:(GLuint)id size:(CGSize)size;
- (id)initWithId:(GLuint)id size:(CGSize)size;
+ (EGTexture*)loadFromFile:(NSString*)file;
@end


