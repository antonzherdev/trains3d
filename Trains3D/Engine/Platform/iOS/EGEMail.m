#import "EGEMail.h"

@implementation EGEMail
static EGEMail* _EGEMail_instance;
static ODClassType* _EGEMail_type;

+ (id)mail {
    return [[EGEMail alloc] init];
}

- (id)init {
    self = [super init];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGEMail_type = [ODClassType classTypeWithCls:[EGEMail class]];
    _EGEMail_instance = [EGEMail mail];
}

- (void)showInterfaceTo:(NSString*)to {
    MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
    controller.mailComposeDelegate = self;
    [controller setToRecipients:@[to]];
    if (controller) {
        [[[[[UIApplication sharedApplication] delegate] window] rootViewController] presentViewController:controller animated:YES completion:nil];
    }
}

- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError*)error;
{
    if (result == MFMailComposeResultSent) {
        NSLog(@"It's away!");
    }
    [[[[[UIApplication sharedApplication] delegate] window] rootViewController] dismissViewControllerAnimated:YES completion:^{

    }];
}

- (ODClassType*)type {
    return [EGEMail type];
}

+ (EGEMail*)instance {
    return _EGEMail_instance;
}

+ (ODClassType*)type {
    return _EGEMail_type;
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


