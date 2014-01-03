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
    UIImage *image = nil;
    if([_content.image isDefined]) image = [UIImage imageNamed:[_content.image get]];
    UIActivityViewController * vc = [[UIActivityViewController alloc] initWithActivityItems:image == nil ? @[self] : @[self, image]
                                                                      applicationActivities:nil];
    vc.excludedActivityTypes = @[UIActivityTypePrint, UIActivityTypeCopyToPasteboard,
            UIActivityTypeAssignToContact, UIActivityTypeSaveToCameraRoll, UIActivityTypePostToWeibo,
            UIActivityTypeSaveToCameraRoll,
            @"com.apple.UIKit.activity.AirDrop",
            @"com.apple.UIKit.activity.AddToReadingList",
            @"com.apple.UIKit.activity.AddToReadingList",
            @"com.apple.UIKit.activity.PostToFlickr",
            @"com.apple.UIKit.activity.PostToVimeo",
            @"com.apple.UIKit.activity.PostToTencentWeibo",
    ];
    [[[[[UIApplication sharedApplication] delegate] window] rootViewController] presentViewController:vc animated:YES completion:nil];
}

+ (BOOL)isSupported {
    return YES;
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

- (id)activityViewControllerPlaceholderItem:(UIActivityViewController *)activityViewController {
    return _content.text;
}

- (id)activityViewController:(UIActivityViewController *)activityViewController itemForActivityType:(NSString *)activityType {
    return [_content textChannel:[self channelForActivityType:activityType]];
}

- (UIImage *)activityViewController:(UIActivityViewController *)activityViewController thumbnailImageForActivityType:(NSString *)activityType suggestedSize:(CGSize)size {
    return nil;
}

- (NSString *)activityViewController:(UIActivityViewController *)activityViewController subjectForActivityType:(NSString *)activityType {
    return  [[_content subjectChannel:[self channelForActivityType:activityType]] getOrNil];
}

- (NSString *)activityViewController:(UIActivityViewController *)activityViewController dataTypeIdentifierForActivityType:(NSString *)activityType {
    return nil;
}


- (EGShareChannel *)channelForActivityType:(NSString *)type {
    if([type isEqualToString:UIActivityTypePostToTwitter]) return [EGShareChannel twitter];
    if([type isEqualToString:UIActivityTypePostToFacebook]) return [EGShareChannel facebook];
    if([type isEqualToString:UIActivityTypeMail]) return [EGShareChannel email];
    if([type isEqualToString:UIActivityTypeMessage]) return [EGShareChannel message];
    return nil;
}


@end


