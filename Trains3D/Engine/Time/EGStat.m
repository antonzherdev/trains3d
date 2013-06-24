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
}

- (void)tickWithDelta:(CGFloat)delta {
    _accumDelta += delta;
    _framesCount++;
    if(_accumDelta > 0.1) {
        _frameRate = _framesCount / _accumDelta;
    }
}

@end


