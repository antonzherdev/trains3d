#import "TRLevelBackgroundView.h"

#import "EG.h"
#import "EGTexture.h"
#import "TRLevel.h"
#import "EGMapIso.h"
@implementation TRLevelBackgroundView

+ (id)levelBackgroundView {
    return [[TRLevelBackgroundView alloc] init];
}

- (id)init {
    self = [super init];
    
    return self;
}

- (void)drawLevel:(TRLevel*)level {
    [egTexture(@"Grass.png") with:^void() {
        [level.map drawPlane];
    }];
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end


