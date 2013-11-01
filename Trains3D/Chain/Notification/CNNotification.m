#import "objd.h"
#import "CNNotification.h"

#import "CNNotificationPlatform.h"
#import "ODType.h"
@implementation CNNotificationHandle{
    NSString* _name;
}
static ODClassType* _CNNotificationHandle_type;
@synthesize name = _name;

+ (id)notificationHandleWithName:(NSString*)name {
    return [[CNNotificationHandle alloc] initWithName:name];
}

- (id)initWithName:(NSString*)name {
    self = [super init];
    if(self) _name = name;
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _CNNotificationHandle_type = [ODClassType classTypeWithCls:[CNNotificationHandle class]];
}

- (void)postData:(id)data {
    [CNNotificationCenter.aDefault postName:_name data:data];
}

- (void)post {
    [CNNotificationCenter.aDefault postName:_name data:nil];
}

- (void)observeBy:(void(^)(id))by {
    [CNNotificationCenter.aDefault addObserverName:_name block:by];
}

- (ODClassType*)type {
    return [CNNotificationHandle type];
}

+ (ODClassType*)type {
    return _CNNotificationHandle_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    CNNotificationHandle* o = ((CNNotificationHandle*)(other));
    return [self.name isEqual:o.name];
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.name hash];
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"name=%@", self.name];
    [description appendString:@">"];
    return description;
}

@end


