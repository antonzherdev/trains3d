#import "objd.h"
#import <StoreKit/StoreKit.h>

@class EGInApp;

@interface EGInApp : NSObject
- (ODClassType*)type;
+ (void)loadProductsIds:(id<CNSeq>)ids callback:(void(^)(id<CNSeq>))callback;
+ (ODClassType*)type;
@end


