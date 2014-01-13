#import "objd.h"
#import <StoreKit/StoreKit.h>
#import "EGInApp.h"

@class EGInApp;

@interface EGInApp : NSObject
- (ODClassType*)type;

+ (void)loadProductsIds:(id <CNSeq>)ids callback:(void (^)(id <CNSeq>))callback onError:(void (^)(NSString *))error;

+ (void)getFromCacheOrLoadProduct:(NSString *)id callback:(void (^)(EGInAppProduct *))callback onError:(void (^)(NSString *))error;
+ (ODClassType*)type;
@end


@interface EGInAppProductPlat : EGInAppProduct
@property(nonatomic, strong) SKProduct *product;

- (instancetype)initWithProduct:(SKProduct *)product;

+ (instancetype)platWithProduct:(SKProduct *)product;

@end


@interface EGInAppTransactionPlat : EGInAppTransaction
- (instancetype)initWithTransaction:(SKPaymentTransaction *)transaction;

+ (instancetype)platWithTransaction:(SKPaymentTransaction *)transaction;

@end
