#import "ATActor.h"

#import "ATMailbox.h"
#import "ATTypedActorWrap.h"
@implementation ATActors
static ODClassType* _ATActors_type;

+ (void)initialize {
    [super initialize];
    if(self == [ATActors class]) _ATActors_type = [ODClassType classTypeWithCls:[ATActors class]];
}

+ (id)typedActor:(id)actor {
    return ((id)([ATTypedActorWrap typedActorWrapWithActor:actor mailbox:[ATMailbox mailbox]]));
}

- (ODClassType*)type {
    return [ATActors type];
}

+ (ODClassType*)type {
    return _ATActors_type;
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


