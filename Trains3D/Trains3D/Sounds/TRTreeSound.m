#import "TRTreeSound.h"

#import "SDSound.h"
#import "TRTree.h"
@implementation TRTreeSound{
    TRForest* _forest;
}
static ODClassType* _TRTreeSound_type;
@synthesize forest = _forest;

+ (id)treeSoundWithForest:(TRForest*)forest {
    return [[TRTreeSound alloc] initWithForest:forest];
}

- (id)initWithForest:(TRForest*)forest {
    self = [super initWithSound:[SDSound applyFile:@"Rustle.wav"]];
    if(self) _forest = forest;
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _TRTreeSound_type = [ODClassType classTypeWithCls:[TRTreeSound class]];
}

- (void)updateWithDelta:(CGFloat)delta {
}

- (ODClassType*)type {
    return [TRTreeSound type];
}

+ (ODClassType*)type {
    return _TRTreeSound_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    TRTreeSound* o = ((TRTreeSound*)(other));
    return [self.forest isEqual:o.forest];
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.forest hash];
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"forest=%@", self.forest];
    [description appendString:@">"];
    return description;
}

@end


