#import "TRLevelView.h"
#import "EGTexture.h"
#import "EGCamera.h"
#import "TRLevel.h"

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

- (void)drawController:(TRLevel*)controller viewSize:(CGSize)viewSize {
    EGMapSize mapSize = controller.mapSize;
    egCameraIsoFocus(viewSize, mapSize, CGPointMake(0, 0));

    if(_t == nil) _t = [EGTexture loadFromFile:@"Grass.png"];
    [_t bind];
    glEnable( GL_TEXTURE_2D );
    egMapSsoDrawPlane(mapSize);
    glDisable(GL_TEXTURE_2D);

    glColor3d(1.0, 1.0, 1.0);
    egMapSsoDrawLayout(mapSize);
}

@end


