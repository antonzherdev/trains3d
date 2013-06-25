#import "EGMap.h"

@implementation EGMap

+ (id)map {
    return [[EGMap alloc] init];
}

- (id)init {
    self = [super init];
    
    return self;
}

+ (void)drawLayoutWithSize:(EGMapSize)size {
    glBegin(GL_LINES);
    {
        for(int x = -1; x < size.width; x++) {
            glVertex3d(0.5 + x, -0.5, 0.0);
            glVertex3d(0.5 + x, -0.5 + size.height, 0.0);
        }
        for(int y = -1; y < size.height; y++) {
            glVertex3d(-0.5, 0.5 + y, 0.0);
            glVertex3d(-0.5 + size.width, 0.5 + y, 0.0);
        }
    }
    glEnd();
}

@end


