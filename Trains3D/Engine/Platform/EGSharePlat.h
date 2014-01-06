#import "objd.h"
@class EGShareContent;

@class EGShareDialog;
@class EGShareChannel;

@interface EGShareDialog : NSObject
@property (nonatomic, readonly) EGShareContent* content;
@property (nonatomic, readonly) void(^completionHandler)(EGShareChannel*);

+ (id)shareDialogWithContent:(EGShareContent *)content shareHandler:(void (^)(EGShareChannel *))shareHandler cancelHandler:(void (^)())cancelHandler;

- (id)initWithContent:(EGShareContent *)content shareHandler:(void (^)(EGShareChannel *))shareHandler cancelHandler:(void (^)())cancelHandler;
- (ODClassType*)type;
- (void)display;
+ (ODClassType*)type;

- (void)displayFacebook;

+ (BOOL)isSupported;

- (void)displayTwitter;
@end


