#import "EGShare.h"

#import "EGSharePlat.h"
@implementation EGShareChannel
static EGShareChannel* _EGShareChannel_facebook;
static EGShareChannel* _EGShareChannel_twitter;
static EGShareChannel* _EGShareChannel_email;
static EGShareChannel* _EGShareChannel_message;
static NSArray* _EGShareChannel_values;

+ (instancetype)shareChannelWithOrdinal:(NSUInteger)ordinal name:(NSString*)name {
    return [[EGShareChannel alloc] initWithOrdinal:ordinal name:name];
}

- (instancetype)initWithOrdinal:(NSUInteger)ordinal name:(NSString*)name {
    self = [super initWithOrdinal:ordinal name:name];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGShareChannel_facebook = [EGShareChannel shareChannelWithOrdinal:0 name:@"facebook"];
    _EGShareChannel_twitter = [EGShareChannel shareChannelWithOrdinal:1 name:@"twitter"];
    _EGShareChannel_email = [EGShareChannel shareChannelWithOrdinal:2 name:@"email"];
    _EGShareChannel_message = [EGShareChannel shareChannelWithOrdinal:3 name:@"message"];
    _EGShareChannel_values = (@[_EGShareChannel_facebook, _EGShareChannel_twitter, _EGShareChannel_email, _EGShareChannel_message]);
}

+ (EGShareChannel*)facebook {
    return _EGShareChannel_facebook;
}

+ (EGShareChannel*)twitter {
    return _EGShareChannel_twitter;
}

+ (EGShareChannel*)email {
    return _EGShareChannel_email;
}

+ (EGShareChannel*)message {
    return _EGShareChannel_message;
}

+ (NSArray*)values {
    return _EGShareChannel_values;
}

@end


@implementation EGShareItem{
    NSString* _text;
    id _subject;
}
static ODClassType* _EGShareItem_type;
@synthesize text = _text;
@synthesize subject = _subject;

+ (instancetype)shareItemWithText:(NSString*)text subject:(id)subject {
    return [[EGShareItem alloc] initWithText:text subject:subject];
}

- (instancetype)initWithText:(NSString*)text subject:(id)subject {
    self = [super init];
    if(self) {
        _text = text;
        _subject = subject;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGShareItem class]) _EGShareItem_type = [ODClassType classTypeWithCls:[EGShareItem class]];
}

+ (EGShareItem*)applyText:(NSString*)text {
    return [EGShareItem shareItemWithText:text subject:[CNOption none]];
}

- (ODClassType*)type {
    return [EGShareItem type];
}

+ (ODClassType*)type {
    return _EGShareItem_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGShareItem* o = ((EGShareItem*)(other));
    return [self.text isEqual:o.text] && [self.subject isEqual:o.subject];
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.text hash];
    hash = hash * 31 + [self.subject hash];
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"text=%@", self.text];
    [description appendFormat:@", subject=%@", self.subject];
    [description appendString:@">"];
    return description;
}

@end


@implementation EGShareContent{
    NSString* _text;
    id _image;
    id<CNImMap> _items;
}
static ODClassType* _EGShareContent_type;
@synthesize text = _text;
@synthesize image = _image;
@synthesize items = _items;

+ (instancetype)shareContentWithText:(NSString*)text image:(id)image items:(id<CNImMap>)items {
    return [[EGShareContent alloc] initWithText:text image:image items:items];
}

- (instancetype)initWithText:(NSString*)text image:(id)image items:(id<CNImMap>)items {
    self = [super init];
    if(self) {
        _text = text;
        _image = image;
        _items = items;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGShareContent class]) _EGShareContent_type = [ODClassType classTypeWithCls:[EGShareContent class]];
}

+ (EGShareContent*)applyText:(NSString*)text image:(id)image {
    return [EGShareContent shareContentWithText:text image:image items:(@{})];
}

- (EGShareContent*)addChannel:(EGShareChannel*)channel text:(NSString*)text {
    return [self addChannel:channel text:text subject:[CNOption none]];
}

- (EGShareContent*)addChannel:(EGShareChannel*)channel text:(NSString*)text subject:(id)subject {
    return [EGShareContent shareContentWithText:_text image:_image items:[_items addItem:tuple(channel, [EGShareItem shareItemWithText:text subject:subject])]];
}

- (EGShareContent*)twitterText:(NSString*)text {
    return [self addChannel:EGShareChannel.twitter text:text];
}

- (EGShareContent*)facebookText:(NSString*)text {
    return [self addChannel:EGShareChannel.facebook text:text];
}

- (EGShareContent*)emailText:(NSString*)text subject:(NSString*)subject {
    return [self addChannel:EGShareChannel.email text:text subject:[CNOption applyValue:subject]];
}

- (EGShareContent*)messageText:(NSString*)text {
    return [self addChannel:EGShareChannel.message text:text];
}

- (NSString*)textChannel:(EGShareChannel*)channel {
    return [[[_items optKey:channel] mapF:^NSString*(EGShareItem* _) {
        return ((EGShareItem*)(_)).text;
    }] getOrValue:_text];
}

- (id)subjectChannel:(EGShareChannel*)channel {
    return [[_items optKey:channel] flatMapF:^id(EGShareItem* _) {
        return ((EGShareItem*)(_)).subject;
    }];
}

- (id)imageChannel:(EGShareChannel*)channel {
    return _image;
}

- (EGShareDialog*)dialog {
    return [EGShareDialog shareDialogWithContent:self shareHandler:^void(EGShareChannel* _) {
    } cancelHandler:^void() {
    }];
}

- (EGShareDialog*)dialogShareHandler:(void(^)(EGShareChannel*))shareHandler cancelHandler:(void(^)())cancelHandler {
    return [EGShareDialog shareDialogWithContent:self shareHandler:shareHandler cancelHandler:cancelHandler];
}

- (ODClassType*)type {
    return [EGShareContent type];
}

+ (ODClassType*)type {
    return _EGShareContent_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGShareContent* o = ((EGShareContent*)(other));
    return [self.text isEqual:o.text] && [self.image isEqual:o.image] && [self.items isEqual:o.items];
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.text hash];
    hash = hash * 31 + [self.image hash];
    hash = hash * 31 + [self.items hash];
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"text=%@", self.text];
    [description appendFormat:@", image=%@", self.image];
    [description appendFormat:@", items=%@", self.items];
    [description appendString:@">"];
    return description;
}

@end


