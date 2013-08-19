#import <Foundation/Foundation.h>

@interface EGTexture : NSObject
@property (readonly, nonatomic) NSString * file;
@property (readonly, nonatomic) CGSize size;

- (id)initWithFile:(NSString *)file;
+ (id)textureWithFile:(NSString *)file;
- (void)bind;
- (void)draw:(void (^)())f;
@end


