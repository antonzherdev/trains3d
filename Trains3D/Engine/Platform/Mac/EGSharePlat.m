#import "EGSharePlat.h"

#import "EGShare.h"
@implementation EGShareDialog{
    EGShareContent* _content;
    void(^_completionHandler)(EGShareChannel*);
}
static ODClassType* _EGShareDialog_type;
@synthesize content = _content;
@synthesize completionHandler = _completionHandler;

+ (id)shareDialogWithContent:(EGShareContent*)content completionHandler:(void(^)(EGShareChannel*))completionHandler {
    return [[EGShareDialog alloc] initWithContent:content completionHandler:completionHandler];
}

- (id)initWithContent:(EGShareContent*)content completionHandler:(void(^)(EGShareChannel*))completionHandler {
    self = [super init];
    if(self) {
        _content = content;
        _completionHandler = completionHandler;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGShareDialog_type = [ODClassType classTypeWithCls:[EGShareDialog class]];
}

- (void)display {
    @throw @"Method display is abstract";
}

- (ODClassType*)type {
    return [EGShareDialog type];
}

+ (ODClassType*)type {
    return _EGShareDialog_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

+ (BOOL)isSupported {
    return NO;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGShareDialog* o = ((EGShareDialog*)(other));
    return [self.content isEqual:o.content] && [self.completionHandler isEqual:o.completionHandler];
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.content hash];
    hash = hash * 31 + [self.completionHandler hash];
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"content=%@", self.content];
    [description appendString:@">"];
    return description;
}

@end


