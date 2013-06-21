#import "EGOpenGLView.h"


@implementation EGOpenGLView {

@private
    EGDirector *_director;
}

@synthesize director = _director;

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self doInit];
    }

    return self;
}

- (id)initWithFrame:(NSRect)frameRect pixelFormat:(NSOpenGLPixelFormat *)format {
    self = [super initWithFrame:frameRect pixelFormat:format];
    if (self) {
        [self doInit];
    }

    return self;
}

- (void)doInit {
    if(_director != nil) return;

    _director = [EGDirector director];
}

- (id)init {
    self = [super init];
    if (self) {
        [self doInit];
    }

    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self doInit];
}


- (void)reshape {
    [super reshape];

    NSRect rect = [self bounds];

    [_director reshapeWithSize:NSSizeToCGSize(rect.size)];
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
//    glClearColor(0.0, 0.0, 0.0, 1.0);
//    glClear(GL_COLOR_BUFFER_BIT);

    /*int tile_pixel_width_ = 64;
    int tile_world_size_ = 10;
    float zoomfactor = 1.0f;

    // Get the viewport resolution
    GLint viewport[4];
    glGetIntegerv( GL_VIEWPORT, viewport );

    // Set the projection matrix
    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
    float aspect=(float)viewport[3]/(float)viewport[2];
//    float screen_tiles=(float)viewport[2] / (float)tile_pixel_width_;
//    float ortho_width=screen_tiles*(float)tile_world_size_*1.414213562373f;
//    float ortho_height=ortho_width * aspect;
//    glOrtho(-ortho_width/2, ortho_width/2, -ortho_height/2, ortho_height/2, 0.0f, 1000.0f);
    double ow = 0.70710676908493;
    float oh = ow * aspect;
    glOrtho(-ow, ow, -oh, oh, 0.0f, 1000.0f);
    // Set the camera, pointed at (x_,z_), 30 degrees around X and 45 degrees around Z. 100 units (arbitrarily chosen, will probably need to be larger for a bigger map, to
    // Prevent far-plane clipping
    int x_ = 0;
    int z_ = 0;
    glMatrixMode(GL_MODELVIEW);
    glLoadIdentity();

    glTranslatef(0 ,0 ,-100);
    glRotatef(30, 1, 0, 0);
    glRotatef(-45.0f, 0, 1, 0);
    glTranslatef(-x_,0, -z_);

    glBegin(GL_QUADS);
    float w = 0.5;
    glVertex3f(w, 0, w);
    glVertex3f(-w, 0, w);
    glVertex3f(-w, 0, -w);
    glVertex3f(w, 0, -w);
    glEnd();





//    glPushMatrix();
//    glTranslated(0.5, 0.5, 0.5);
//    glColor3d(0.5, 0.5, 0.5);
//    glutWireCube(100);
//    glPopMatrix();

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

    glFlush();

    GLdouble projMatrix[16];
    GLdouble modelMatrix[16];
    glGetDoublev(GL_PROJECTION_MATRIX, projMatrix);
    glGetDoublev(GL_MODELVIEW_MATRIX, modelMatrix);
    modelMatrix[0] = 0;*/
    [_director draw];
    glFlush();
}


@end