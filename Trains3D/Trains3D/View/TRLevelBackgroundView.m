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

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    TRLevelBackgroundView* o = ((TRLevelBackgroundView*)other);
    return YES;
}

- (NSUInteger)hash {
    return 0;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendString:@">"];
    return description;
}

@end


