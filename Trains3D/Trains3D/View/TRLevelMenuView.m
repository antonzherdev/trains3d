#import "TRLevelMenuView.h"

#import "EGCamera2D.h"
#import "TRLevel.h"
@implementation TRLevelMenuView{
    TRLevel* _level;
    id<EGCamera> _camera;
}
@synthesize level = _level;
@synthesize camera = _camera;

+ (id)levelMenuViewWithLevel:(TRLevel*)level {
    return [[TRLevelMenuView alloc] initWithLevel:level];
}

- (id)initWithLevel:(TRLevel*)level {
    self = [super init];
    if(self) {
        _level = level;
        _camera = [EGCamera2D camera2DWithSize:EGSizeMake(2, 1)];
    }
    
    return self;
}

- (void)drawView {
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end


