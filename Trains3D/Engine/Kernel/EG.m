#import "EG.h"

#import "EGDirector.h"
#import "EGContext.h"
#import "EGTexture.h"
@implementation EG

+ (id)g {
    return [[EG alloc] init];
}

- (id)init {
    self = [super init];
    
    return self;
}

+ (EGDirector*)director {
    return [EGDirector current];
}

+ (EGContext*)context {
    return [EGDirector current].context;
}

+ (EGTexture*)textureForFile:(NSString*)file {
    return [[EG context] textureForFile:file];
}

+ (EGMutableMatrix*)projectionMatrix {
    return [EG context].projectionMatrix;
}

+ (EGMutableMatrix*)viewMatrix {
    return [EG context].viewMatrix;
}

+ (EGMutableMatrix*)modelMatrix {
    return [EG context].modelMatrix;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
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


