#import "TRNotification.h"

@implementation TRNotifications{
    CNQueue* _queue;
}
static ODClassType* _TRNotifications_type;

+ (id)notifications {
    return [[TRNotifications alloc] init];
}

- (id)init {
    self = [super init];
    if(self) _queue = [CNQueue apply];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _TRNotifications_type = [ODClassType classTypeWithCls:[TRNotifications class]];
}

- (void)notifyNotification:(NSString*)notification {
    _queue = [_queue enqueueItem:notification];
}

- (BOOL)isEmpty {
    return [_queue isEmpty];
}

- (id)take {
    CNTuple* p = [_queue dequeue];
    _queue = ((CNQueue*)(p.b));
    return p.a;
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

