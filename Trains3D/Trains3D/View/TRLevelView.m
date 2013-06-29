#import "TRLevelView.h"

@implementation TRLevelView{
    TRLevelBackgroundView* _backgroundView;
}

+ (id)levelView {
    return [[TRLevelView alloc] init];
}

- (id)init {
    self = [super init];
    if(self) {
        _backgroundView = [TRLevelBackgroundView levelBackgroundView];
    }
    
    return self;
}

- (void)drawController:(TRLevel*)controller viewSize:(CGSize)viewSize {
    EGMapSize mapSize = controller.mapSize;
    egCameraIsoFocus(viewSize, mapSize, CGPointMake(0, 0));
    [_backgroundView drawLevel:controller];
    glColor3f(1.0, 1.0, 1.0);
    egMapSsoDrawLayout(mapSize);
}

@end


