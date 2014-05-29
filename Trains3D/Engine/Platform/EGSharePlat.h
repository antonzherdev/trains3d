#import "objd.h"
#import "EGShare.h"

@class EGShareContent;

@class EGShareDialog;
@class EGShareChannel;

@interface EGShareDialog : NSObject
@property (nonatomic, readonly) EGShareContent* content;
@property (nonatomic, readonly) void(^completionHandler)(EGShareChannelR);

+ (id)shareDialogWithContent:(EGShareContent*)content shareHandler:(void (^)(EGShareChannelR))shareHandler cancelHandler:(void (^)())cancelHandler;

- (id)initWithContent:(EGShareContent *)content shareHandler:(void (^)(EGShareChannelR))shareHandler cancelHandler:(void (^)())cancelHandler;
- (CNClassType*)type;
- (void)display;
+ (CNClassType*)type;

- (void)displayFacebook;

+ (BOOL)isSupported;

- (void)displayTwitter;
@end


