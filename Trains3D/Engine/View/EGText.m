#import <GLUT/glut.h>
#import "EGText.h"

@implementation EGText

+ (id)text {
    return [[EGText alloc] init];
}

- (id)init {
    self = [super init];
    
    return self;
}

+ (void)glutDrawText:(NSString*)text font:(void*)font position:(CGPoint)position {
    glRasterPos2f(-0.99, -0.99);
    int len, i;
    len = (int)[text length];
    char const *s = [text UTF8String];
    for (i = 0; i < len; i++) {
        glutBitmapCharacter(font, s[i]);
    }

}

@end


