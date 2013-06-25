#import "TRLevelView.h"
#import "EGTexture.h"
#import "EGCamera.h"
#import "EGMap.h"

@implementation TRLevelView{
    EGTexture * _t;
}
+ (id)levelView {
    return [[TRLevelView alloc] init];
}

- (id)init {
    self = [super init];
    
    return self;
}

- (void)drawController:(id)controller viewSize:(CGSize)viewSize {
    glClearColor(0.0, 0.0, 0.0, 1.0);

    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    [EGCamera isometricFocusWithViewSize:viewSize tilesOnScreen:CGSizeMake(3, 3) center:CGPointMake(0, 0)];

    glColor3d(1.0, 1.0, 1.0);
    glTexEnvf(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_DECAL);

    if(_t == nil) _t = [EGTexture loadFromFile:@"Grass.png"];
    [_t bind];
    glEnable( GL_TEXTURE_2D );
    glBegin(GL_QUADS);
    {
        glTexCoord2d(0.0, 0.0); glVertex3f(-0.5, -0.5, 0);
        glTexCoord2d(1.0, 0.0); glVertex3f(-0.5, 2.5, 0);
        glTexCoord2d(1.0, 1.0); glVertex3f(2.5, 2.5, 0);
        glTexCoord2d(0.0, 1.0); glVertex3f(2.5, -0.5, 0);
    }
    glEnd();
    glDisable(GL_TEXTURE_2D);


    glColor3d(1.0, 1.0, 1.0);
    [EGSquareIsoMap drawLayoutWithSize:EGMapSizeMake(3, 3)];
}

@end


