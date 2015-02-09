#import "PGEMail.h"


@class PGEFeedbackComposeViewController;

@protocol PGEFeedbackComposeViewControllerDelegate
- (void) feedbackComposeController:(PGEFeedbackComposeViewController*)controller sendText:(NSString*)text;
@end

@interface PGEFeedbackComposeViewController : UIViewController<UITextViewDelegate>
@property (weak) id<PGEFeedbackComposeViewControllerDelegate> feedbackDelegate;
@end

@implementation PGEFeedbackComposeViewController {
    UITextView* textView;
    UIBarButtonItem* sendButton;
}
- (instancetype)init {
    self = [super init];
    if (self) {
        textView = [[UITextView alloc] init];
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
            textView.contentInset = UIEdgeInsetsMake(0, 0, 400, 0);
        } else {
            textView.contentInset = UIEdgeInsetsMake(0, 0, 160, 0);
        }
    }

    return self;
}


- (void)loadView {
    [super loadView];
    self.view = textView;
    textView.font = [UIFont systemFontOfSize:17];
    textView.delegate = self;
    UIBarButtonItem* cancelButton = [[UIBarButtonItem alloc]
            initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                 target:self
                                 action:@selector(cancel:)];
    self.navigationItem.title = @"Mail the Developer";
    self.navigationItem.leftBarButtonItem = cancelButton;
    sendButton = [[UIBarButtonItem alloc]
            initWithTitle:@"Send"
                    style:UIBarButtonItemStyleDone target:self
                   action:@selector(send:)];
    sendButton.enabled = NO;
    self.navigationItem.rightBarButtonItem = sendButton;
}

- (void)viewWillAppear:(BOOL)animated {
    [textView becomeFirstResponder];
}

- (void)textViewDidChange:(UITextView *)textView1 {
    sendButton.enabled = ![textView.text isEmpty];
}



- (void)send:(id)sender {
    [self.feedbackDelegate feedbackComposeController:self sendText:[textView text]];
}

- (void)cancel:(id)sender {
    [[self navigationController] dismissViewControllerAnimated:YES completion:nil];
}


@end

@interface PGEMail () <PGEFeedbackComposeViewControllerDelegate>
@end

@implementation PGEMail {
    NSString* _to;
    NSString* _subject;
    NSString* _platform;
}
static PGEMail * _EGEMail_instance;
static CNClassType* _EGEMail_type;

+ (id)mail {
    return [[PGEMail alloc] init];
}

- (id)init {
    self = [super init];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGEMail_type = [CNClassType classTypeWithCls:[PGEMail class]];
    _EGEMail_instance = [PGEMail mail];
}

- (void)showInterfaceTo:(NSString *)to subject:(NSString *)subject text:(NSString *)text htmlText:(NSString *)htmlText platform:(NSString*) platform {
    if(![MFMailComposeViewController canSendMail]) {
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"Cannot send email" message:@"It is impossible to send email using this device" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
        return;
    }

    _to = to;
    _subject = subject;
    _platform = platform;

    PGEFeedbackComposeViewController *fb = [[PGEFeedbackComposeViewController alloc] init];
    fb.feedbackDelegate = self;
    UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:fb];
    nav.modalPresentationStyle = UIModalPresentationPageSheet;
    [[[[[UIApplication sharedApplication] delegate] window] rootViewController] presentViewController:nav animated:YES completion:nil];
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

- (CNClassType*)type {
    return [PGEMail type];
}

+ (PGEMail *)instance {
    return _EGEMail_instance;
}

+ (CNClassType*)type {
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

- (void)feedbackComposeController:(PGEFeedbackComposeViewController *)controller sendText:(NSString *)text {
    [[[[[UIApplication sharedApplication] delegate] window] rootViewController] dismissViewControllerAnimated:YES completion:^{
        MFMailComposeViewController* ctr = [[MFMailComposeViewController alloc] init];
        ctr.mailComposeDelegate = self;
        [ctr setToRecipients:@[_to]];
        [ctr setSubject:_subject];
        NSString *fullText = [NSString stringWithFormat:@"%@\n\n> %@", text, _platform];
        [ctr setMessageBody:fullText isHTML:NO];
        if (ctr) {
            [[[[[UIApplication sharedApplication] delegate] window] rootViewController] presentViewController:ctr animated:YES completion:nil];
        }
    }];
}


@end


