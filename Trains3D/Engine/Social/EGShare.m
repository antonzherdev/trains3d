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


@implementation EGShareItem
static ODClassType* _EGShareItem_type;
@synthesize text = _text;
@synthesize subject = _subject;

+ (instancetype)shareItemWithText:(NSString*)text subject:(NSString*)subject {
    return [[EGShareItem alloc] initWithText:text subject:subject];
}

- (instancetype)initWithText:(NSString*)text subject:(NSString*)subject {
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
    return [EGShareItem shareItemWithText:text subject:nil];
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

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"text=%@", self.text];
    [description appendFormat:@", subject=%@", self.subject];
    [description appendString:@">"];
    return description;
}

@end


@implementation EGShareContent
static ODClassType* _EGShareContent_type;
@synthesize text = _text;
@synthesize image = _image;
@synthesize items = _items;

+ (instancetype)shareContentWithText:(NSString*)text image:(NSString*)image items:(id<CNImMap>)items {
    return [[EGShareContent alloc] initWithText:text image:image items:items];
}

- (instancetype)initWithText:(NSString*)text image:(NSString*)image items:(id<CNImMap>)items {
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

+ (EGShareContent*)applyText:(NSString*)text image:(NSString*)image {
    return [EGShareContent shareContentWithText:text image:image items:(@{})];
}

- (EGShareContent*)addChannel:(EGShareChannel*)channel text:(NSString*)text {
    return [self addChannel:channel text:text subject:nil];
}

- (EGShareContent*)addChannel:(EGShareChannel*)channel text:(NSString*)text subject:(NSString*)subject {
    return [EGShareContent shareContentWithText:_text image:_image items:[_items addItem:tuple(channel, [EGShareItem shareItemWithText:text subject:subject])]];
}

- (EGShareContent*)twitterText:(NSString*)text {
    return [self addChannel:EGShareChannel.twitter text:text];
}

- (EGShareContent*)facebookText:(NSString*)text {
    return [self addChannel:EGShareChannel.facebook text:text];
}

- (EGShareContent*)emailText:(NSString*)text subject:(NSString*)subject {
    return [self addChannel:EGShareChannel.email text:text subject:subject];
}

- (EGShareContent*)messageText:(NSString*)text {
    return [self addChannel:EGShareChannel.message text:text];
}

- (NSString*)textChannel:(EGShareChannel*)channel {
    NSString* __tmp;
    {
        EGShareItem* _ = ((EGShareItem*)([_items optKey:channel]));
        if(_ != nil) __tmp = ((EGShareItem*)(_)).text;
        else __tmp = nil;
    }
    if(__tmp != nil) return ((NSString*)(__tmp));
    else return _text;
}

- (NSString*)subjectChannel:(EGShareChannel*)channel {
    EGShareItem* _ = ((EGShareItem*)([_items optKey:channel]));
    if(_ != nil) return ((EGShareItem*)(_)).subject;
    else return nil;
}

- (NSString*)imageChannel:(EGShareChannel*)channel {
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

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"text=%@", self.text];
    [description appendFormat:@", image=%@", self.image];
    [description appendFormat:@", items=%@", self.items];
    [description appendString:@">"];
    return description;
}

@end


