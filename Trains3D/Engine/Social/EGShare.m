#import "EGShare.h"

#import "EGSharePlat.h"
EGShareChannel* EGShareChannel_Values[5];
EGShareChannel* EGShareChannel_facebook_Desc;
EGShareChannel* EGShareChannel_twitter_Desc;
EGShareChannel* EGShareChannel_email_Desc;
EGShareChannel* EGShareChannel_message_Desc;
@implementation EGShareChannel

+ (instancetype)shareChannelWithOrdinal:(NSUInteger)ordinal name:(NSString*)name {
    return [[EGShareChannel alloc] initWithOrdinal:ordinal name:name];
}

- (instancetype)initWithOrdinal:(NSUInteger)ordinal name:(NSString*)name {
    self = [super initWithOrdinal:ordinal name:name];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    EGShareChannel_facebook_Desc = [EGShareChannel shareChannelWithOrdinal:0 name:@"facebook"];
    EGShareChannel_twitter_Desc = [EGShareChannel shareChannelWithOrdinal:1 name:@"twitter"];
    EGShareChannel_email_Desc = [EGShareChannel shareChannelWithOrdinal:2 name:@"email"];
    EGShareChannel_message_Desc = [EGShareChannel shareChannelWithOrdinal:3 name:@"message"];
    EGShareChannel_Values[0] = nil;
    EGShareChannel_Values[1] = EGShareChannel_facebook_Desc;
    EGShareChannel_Values[2] = EGShareChannel_twitter_Desc;
    EGShareChannel_Values[3] = EGShareChannel_email_Desc;
    EGShareChannel_Values[4] = EGShareChannel_message_Desc;
}

+ (NSArray*)values {
    return (@[EGShareChannel_facebook_Desc, EGShareChannel_twitter_Desc, EGShareChannel_email_Desc, EGShareChannel_message_Desc]);
}

+ (EGShareChannel*)value:(EGShareChannelR)r {
    return EGShareChannel_Values[r];
}

@end

@implementation EGShareItem
static CNClassType* _EGShareItem_type;
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
    if(self == [EGShareItem class]) _EGShareItem_type = [CNClassType classTypeWithCls:[EGShareItem class]];
}

+ (EGShareItem*)applyText:(NSString*)text {
    return [EGShareItem shareItemWithText:text subject:nil];
}

- (NSString*)description {
    return [NSString stringWithFormat:@"ShareItem(%@, %@)", _text, _subject];
}

- (BOOL)isEqual:(id)to {
    if(self == to) return YES;
    if(to == nil || !([to isKindOfClass:[EGShareItem class]])) return NO;
    EGShareItem* o = ((EGShareItem*)(to));
    return [_text isEqual:o.text] && [_subject isEqual:o.subject];
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [_text hash];
    hash = hash * 31 + [_subject hash];
    return hash;
}

- (CNClassType*)type {
    return [EGShareItem type];
}

+ (CNClassType*)type {
    return _EGShareItem_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation EGShareContent
static CNClassType* _EGShareContent_type;
@synthesize text = _text;
@synthesize image = _image;
@synthesize items = _items;

+ (instancetype)shareContentWithText:(NSString*)text image:(NSString*)image items:(NSDictionary*)items {
    return [[EGShareContent alloc] initWithText:text image:image items:items];
}

- (instancetype)initWithText:(NSString*)text image:(NSString*)image items:(NSDictionary*)items {
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
    if(self == [EGShareContent class]) _EGShareContent_type = [CNClassType classTypeWithCls:[EGShareContent class]];
}

+ (EGShareContent*)applyText:(NSString*)text image:(NSString*)image {
    return [EGShareContent shareContentWithText:text image:image items:(@{})];
}

- (EGShareContent*)addChannel:(EGShareChannelR)channel text:(NSString*)text {
    return [self addChannel:channel text:text subject:nil];
}

- (EGShareContent*)addChannel:(EGShareChannelR)channel text:(NSString*)text subject:(NSString*)subject {
    return [EGShareContent shareContentWithText:_text image:_image items:[_items addItem:tuple([EGShareChannel value:channel], [EGShareItem shareItemWithText:text subject:subject])]];
}

- (EGShareContent*)twitterText:(NSString*)text {
    return [self addChannel:EGShareChannel_twitter text:text];
}

- (EGShareContent*)facebookText:(NSString*)text {
    return [self addChannel:EGShareChannel_facebook text:text];
}

- (EGShareContent*)emailText:(NSString*)text subject:(NSString*)subject {
    return [self addChannel:EGShareChannel_email text:text subject:subject];
}

- (EGShareContent*)messageText:(NSString*)text {
    return [self addChannel:EGShareChannel_message text:text];
}

- (NSString*)textChannel:(EGShareChannelR)channel {
    EGShareItem* __tmp = [_items applyKey:[EGShareChannel value:channel]];
    if(__tmp != nil) return ((EGShareItem*)([_items applyKey:[EGShareChannel value:channel]])).text;
    else return _text;
}

- (NSString*)subjectChannel:(EGShareChannelR)channel {
    return ((EGShareItem*)([_items applyKey:[EGShareChannel value:channel]])).subject;
}

- (NSString*)imageChannel:(EGShareChannelR)channel {
    return _image;
}

- (EGShareDialog*)dialog {
    return [EGShareDialog shareDialogWithContent:self shareHandler:^void(EGShareChannelR _) {
    } cancelHandler:^void() {
    }];
}

- (EGShareDialog*)dialogShareHandler:(void(^)(EGShareChannelR))shareHandler cancelHandler:(void(^)())cancelHandler {
    return [EGShareDialog shareDialogWithContent:self shareHandler:shareHandler cancelHandler:cancelHandler];
}

- (NSString*)description {
    return [NSString stringWithFormat:@"ShareContent(%@, %@, %@)", _text, _image, _items];
}

- (BOOL)isEqual:(id)to {
    if(self == to) return YES;
    if(to == nil || !([to isKindOfClass:[EGShareContent class]])) return NO;
    EGShareContent* o = ((EGShareContent*)(to));
    return [_text isEqual:o.text] && [_image isEqual:o.image] && [_items isEqual:o.items];
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [_text hash];
    hash = hash * 31 + [_image hash];
    hash = hash * 31 + [_items hash];
    return hash;
}

- (CNClassType*)type {
    return [EGShareContent type];
}

+ (CNClassType*)type {
    return _EGShareContent_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

