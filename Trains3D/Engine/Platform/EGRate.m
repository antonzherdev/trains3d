#import "EGRate.h"

@implementation EGRate {
    BOOL _rateRequest;
}
static EGRate* _EGRate_instance;
static ODClassType* _EGRate_type;

+ (id)rate {
    return [[EGRate alloc] init];
}

- (id)init {
    self = [super init];
    _rateRequest = NO;
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGRate_type = [ODClassType classTypeWithCls:[EGRate class]];
    _EGRate_instance = [EGRate rate];

//    [iRate sharedInstance].previewMode = YES;
    [iRate sharedInstance].promptAtLaunch = NO;
    [iRate sharedInstance].delegate = _EGRate_instance;
//    [[iRate sharedInstance] setRatedThisVersion:NO];
}

- (BOOL)iRateShouldPromptForRating
{
    //don't show prompt, just open app store
    [[iRate sharedInstance] openRatingsPageInAppStore];
    return NO;
}

- (BOOL)isRated {
    return [[iRate sharedInstance] ratedAnyVersion];
}

- (BOOL)isRatedThisVersion {
    return [[iRate sharedInstance] ratedThisVersion];
}

- (void)showRate {
    [[iRate sharedInstance] promptIfNetworkAvailable];
    _rateRequest = YES;
    [[iRate sharedInstance] setRatedThisVersion:YES];
}

- (void)iRateCouldNotConnectToAppStore:(NSError *)error
{
    if(_rateRequest) {
        NSString *err = [NSString stringWithFormat:@"%@", [error localizedDescription] ];
#if TARGET_OS_IPHONE
        UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                             message:err
                                                            delegate:nil
                                                   cancelButtonTitle:@"OK"
                                                   otherButtonTitles:nil];
        [errorAlert show];
#else
        NSAlert *alert = [[NSAlert alloc] init];
        [alert setMessageText:err];
        [alert runModal];
#endif
        [[iRate sharedInstance] setRatedThisVersion:NO];
    }
}

- (ODClassType*)type {
    return [EGRate type];
}

+ (EGRate*)instance {
    return _EGRate_instance;
}

+ (ODClassType*)type {
    return _EGRate_type;
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


