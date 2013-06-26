#import "TRLevelView.h"
#import "EGTexture.h"
#import "EGCamera.h"

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
    EGMapSize mapSize = EGMapSizeMake(4, 4);
    glClearColor(0.0, 0.0, 0.0, 1.0);

    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    egCameraIsoFocus(viewSize, mapSize, CGPointMake(0, 0));

    glColor3d(1.0, 1.0, 1.0);
    glTexEnvf(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_DECAL);

    if(_t == nil) _t = [EGTexture loadFromFile:@"Grass.png"];
    [_t bind];
    glEnable( GL_TEXTURE_2D );
    egMapSsoDrawPlane(mapSize);
    glDisable(GL_TEXTURE_2D);

    glColor3d(1.0, 1.0, 1.0);
    egMapSsoDrawLayout(mapSize);
}

@end


