#import "objd.h"
@class EGShareContent;

@class EGShareDialog;
@class EGShareChannel;

@interface EGShareDialog : NSObject
@property (nonatomic, readonly) EGShareContent* content;
@property (nonatomic, readonly) void(^completionHandler)(EGShareChannel*);

+ (id)shareDialogWithContent:(EGShareContent*)content completionHandler:(void(^)(EGShareChannel*))completionHandler;
- (id)initWithContent:(EGShareContent*)content completionHandler:(void(^)(EGShareChannel*))completionHandler;
- (ODClassType*)type;
- (void)display;
+ (ODClassType*)type;

+ (BOOL)isSupported;
@end


