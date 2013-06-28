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
    if(self) {
        _t = [EGTexture textureWithFile:@"Grass.png"];
    }
    return self;
}

- (void)drawController:(TRLevel*)controller viewSize:(CGSize)viewSize {
    EGMapSize mapSize = controller.mapSize;
    egCameraIsoFocus(viewSize, mapSize, CGPointMake(0, 0));

    [_t with:^{
        egMapSsoDrawPlane(mapSize);
    }];
    glColor3f(1.0, 1.0, 1.0);
    egMapSsoDrawLayout(mapSize);
}

@end


