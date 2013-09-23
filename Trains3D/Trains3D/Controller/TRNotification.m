#import "TRNotification.h"

@implementation TRNotifications{
    List#C.class _list;
}
static ODClassType* _TRNotifications_type;

+ (id)notifications {
    return [[TRNotifications alloc] init];
}

- (id)init {
    self = [super init];
    if(self) _list = CNList;
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _TRNotifications_type = [ODClassType classTypeWithCls:[TRNotifications class]];
}

- (ODClassType*)type {
    return [TRNotifications type];
}

+ (ODClassType*)type {
    return _TRNotifications_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendString:@">"];
    return description;
}

@end


