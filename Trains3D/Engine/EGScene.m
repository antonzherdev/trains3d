#import "EGScene.h"
#import "EGTexture.h"

@implementation EGScene{
    EGCamera* _camera;
    CGSize _lastSize;
    EGTexture * _t;
    CGFloat _r;
}
@synthesize camera = _camera;

+ (id)scene {
    return [[EGScene alloc] init];
}

- (id)init {
    self = [super init];
    
    return self;
}

- (void)reshapeWithSize:(CGSize)size {
    _lastSize = size;
    [_camera reshapeWithSize:size];
}

- (void)draw {
    _r += 0.01; if(_r > 0.5) _r = 0.0;
    glClearColor(_r, 0.0, 0.0, 1.0);

    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    if(_t == nil) {
        _t = [EGTexture loadFromFile:@"Grass.png"];
    }
    [_camera startDraw];

    glColor3d(1.0, 1.0, 1.0);
    glTexEnvf(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_DECAL);
    [_t bind];
    glEnable( GL_TEXTURE_2D );
    glBegin(GL_QUADS);
        float w = 0.5;
        glTexCoord2d(0.0, 0.0); glVertex3f(w, 0, w);
        glTexCoord2d(1.0, 0.0); glVertex3f(-w, 0, w);
        glTexCoord2d(1.0, 1.0); glVertex3f(-w, 0, -w);
        glTexCoord2d(0.0, 1.0); glVertex3f(w, 0, -w);
    glEnd();
    glDisable(GL_TEXTURE_2D);


    glBegin(GL_LINES);

    glColor3d(1.0, 0.0, 0.0);
    float ww = 0.5;
    glVertex3d(-ww, 0.0, 0.0);
    glVertex3d(ww, 0.0, 0.0);

    glColor3d(0.0, 1.0, 0.0);
    glVertex3d(0.0, -ww, 0.0);
    glVertex3d(0.0, ww, 0.0);

    glColor3d(0.0, 0.0, 1.0);
    glVertex3d(0.0, 0.0, -ww);
    glVertex3d(0.0, 0.0, ww);

    glEnd();
}

- (void)setCamera:(EGCamera*)camera {
    _camera = camera;
    [camera reshapeWithSize:_lastSize];
}

@end


