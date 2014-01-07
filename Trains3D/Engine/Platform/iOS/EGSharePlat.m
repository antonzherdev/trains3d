#import "EGSharePlat.h"

#import "EGShare.h"
#import <Social/Social.h>

@interface EGShareDialog(iOS)<UIActivityItemSource>
@end

@implementation EGShareDialog{
    EGShareContent* _content;
    void(^_shareHandler)(EGShareChannel*);
    void(^_cancelHandler)();
}
static ODClassType* _EGShareDialog_type;


+ (id)shareDialogWithContent:(EGShareContent *)content shareHandler:(void (^)(EGShareChannel *))shareHandler cancelHandler:(void (^)())cancelHandler {
    return [[EGShareDialog alloc] initWithContent:content shareHandler:shareHandler cancelHandler:cancelHandler];
}

- (id)initWithContent:(EGShareContent *)content shareHandler:(void (^)(EGShareChannel *))shareHandler cancelHandler:(void (^)())cancelHandler {
    self = [super init];
    if(self) {
        _content = content;
        _shareHandler = shareHandler;
        _cancelHandler = cancelHandler;
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
    [vc setCompletionHandler:^(NSString *activityType, BOOL completed) {
        if(completed) {
            _shareHandler([self channelForActivityType:activityType]);
        } else {
            _cancelHandler();
        }
    }];
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

- (void)displayFacebook {
    [self displayService:SLServiceTypeFacebook channel:[EGShareChannel facebook]];
}

- (void)displayService:(NSString *)type channel:(EGShareChannel *)channel {
//    if([SLComposeViewController isAvailableForServiceType:type]) //check if Facebook Account is linked
//    {
        SLComposeViewController*controller = [[SLComposeViewController alloc] init]; //initiate the Social Controller
        controller = [SLComposeViewController composeViewControllerForServiceType:type]; //Tell him with what social plattform to use it, e.g. facebook or twitter
        [controller setInitialText:[_content textChannel:channel]]; //the message you want to post
        id img = [_content imageChannel:channel];
        if([img isDefined]) {
            [controller addImage:[UIImage imageNamed:[img get]]];
        }

        [controller setCompletionHandler:^(SLComposeViewControllerResult result) {
            if(result == SLComposeViewControllerResultDone) {
                _shareHandler(channel);
            } else {
                _cancelHandler();
            }
        }];
        [[[[[UIApplication sharedApplication] delegate] window] rootViewController] presentViewController:controller animated:YES completion:nil];
//    }
}

- (void)displayTwitter {
    [self displayService:SLServiceTypeTwitter channel:[EGShareChannel twitter]];
}

@end

