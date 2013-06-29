#import "TRLevelBackgroundView.h"

@implementation TRLevelBackgroundView{
    EGTexture* _texture;
}

+ (id)levelBackgroundView {
    return [[TRLevelBackgroundView alloc] init];
}

- (id)init {
    self = [super init];
    if(self) {
        _texture = [EGTexture textureWithFile:@"Grass.png"];
    }
    
    return self;
}

- (void)drawLevel:(TRLevel*)level {
    [_texture with:^void() {
        egMapSsoDrawPlane(level.mapSize);
    }];
}

@end


