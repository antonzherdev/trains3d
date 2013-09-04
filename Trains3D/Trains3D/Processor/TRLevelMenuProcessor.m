#import "TRLevelMenuProcessor.h"

#import "TRLevel.h"
#import "TRRailroad.h"
@implementation TRLevelMenuProcessor{
    TRLevel* _level;
}
static ODClassType* _TRLevelMenuProcessor_type;
@synthesize level = _level;

+ (id)levelMenuProcessorWithLevel:(TRLevel*)level {
    return [[TRLevelMenuProcessor alloc] initWithLevel:level];
}

- (id)initWithLevel:(TRLevel*)level {
    self = [super init];
    if(self) _level = level;
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _TRLevelMenuProcessor_type = [ODClassType classTypeWithCls:[TRLevelMenuProcessor class]];
}

- (BOOL)processEvent:(EGEvent*)event {
    return [event leftMouseProcessor:self];
}

- (BOOL)mouseUpEvent:(EGEvent*)event {
    if([[_level.railroad damagesPoints] isEmpty]) return NO;
    if([[_level repairer] isDefined]) return NO;
    EGVec2 p = [event location];
    if(p.y > 0.1) return NO;
    NSUInteger cityNumber = ((NSUInteger)(p.x / 0.1));
    if(cityNumber >= [[_level cities] count]) return NO;
    [_level runRepairerFromCity:((TRCity*)([[_level cities] applyIndex:cityNumber]))];
    return YES;
}

- (BOOL)mouseDownEvent:(EGEvent*)event {
    return NO;
}

- (BOOL)mouseDragEvent:(EGEvent*)event {
    return NO;
}

- (ODClassType*)type {
    return [TRLevelMenuProcessor type];
}

+ (ODClassType*)type {
    return _TRLevelMenuProcessor_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    TRLevelMenuProcessor* o = ((TRLevelMenuProcessor*)(other));
    return [self.level isEqual:o.level];
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.level hash];
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"level=%@", self.level];
    [description appendString:@">"];
    return description;
}

@end


