#import <GLUT/glut.h>
#import "EGStat.h"

@implementation EGStat{
    CGFloat _accumDelta;
    NSInteger _framesCount;
    CGFloat _frameRate;
}

+ (id)stat {
    return [[EGStat alloc] init];
}

- (id)init {
    self = [super init];
    if(self) {
        _accumDelta = 0.0;
        _framesCount = 0;
        _frameRate = 0.0;
    }
    
    return self;
}

- (void)draw {
    glPushAttrib(GL_VIEWPORT_BIT);
    glViewport(0, 0, 100, 100);

    glMatrixMode(GL_PROJECTION);
    glPushMatrix();
    glLoadIdentity();

    glMatrixMode(GL_MODELVIEW);
    glPushMatrix();
    glLoadIdentity();
    NSString *string = [[NSString alloc] initWithFormat:@"%.1f", _frameRate];
    
    glColor3f(1.0, 1.0, 1.0);
    glRasterPos2f(-0.99, -0.99);
    int len, i;
    len = (int)[string length];
    char const *s = [string UTF8String];
    for (i = 0; i < len; i++) {
        glutBitmapCharacter(GLUT_BITMAP_HELVETICA_18, s[i]);
    }

    glMatrixMode(GL_PROJECTION);
    glPopMatrix();

    glMatrixMode(GL_MODELVIEW);
    glPopMatrix();

    glPopAttrib();
}

- (void)tickWithDelta:(CGFloat)delta {
    _accumDelta += delta;
    _framesCount++;
    if(_accumDelta > 0.1) {
        _frameRate = _framesCount / _accumDelta;
    }
}

@end


