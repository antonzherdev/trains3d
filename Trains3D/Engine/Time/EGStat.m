#import <GLUT/glut.h>
#import "EGStat.h"
#import "EGText.h"

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
    
    glColor4f(1.0, 1.0, 1.0, 1.0);
    egTextGlutDraw(string, GLUT_BITMAP_HELVETICA_18, EGVec2Make(-0.99, -0.99));

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
        _accumDelta = 0;
        _framesCount = 0;
    }
}

@end


