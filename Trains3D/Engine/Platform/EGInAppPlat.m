#import "EGInAppPlat.h"

@class EGInAppProductRequestDelegate;

static NSArray* _curDelegates;
static NSMutableDictionary* _EGInApp_products;

@interface EGInAppProductRequestDelegate : NSObject<SKProductsRequestDelegate>
- (instancetype)initWithCallback:(void (^)(id <CNSeq>))callback onError:(void (^)(NSString *))error;

+ (instancetype)delegateWithCallback:(void (^)(id <CNSeq>))callback onError:(void (^)(NSString *))error;

@end

@implementation EGInAppProductRequestDelegate {
    void(^_callback)(id<CNSeq>);
    void(^_onError)(NSString*);
}
- (instancetype)initWithCallback:(void (^)(id <CNSeq>))callback onError:(void (^)(NSString *))error {
    self = [super init];
    if (self) {
        _callback = callback;
        _onError = error;
    }

    return self;
}

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
//    NSLog(@"In-app purchases prices did receive response");
    for(NSString* id in response.invalidProductIdentifiers) {
        NSLog(@"Invalid in-app id: %@", id);
    }
    NSArray *products = [[[response.products chain] map:^EGInAppProduct *(SKProduct *x) {
        return [EGInAppProductPlat platWithProduct:x];
    }] toArray];
    [products forEach:^(EGInAppProductPlat* x) {
        [_EGInApp_products setObject:x forKey:x.id];
    }];
    _callback(products);
}

- (void)requestDidFinish:(SKRequest *)request {
//    NSLog(@"In-app purchases prices finished");
    @synchronized (_curDelegates) {
        _curDelegates = [_curDelegates arrayByRemovingObject:self];
    }
}

- (void)request:(SKRequest *)request didFailWithError:(NSError *)error {
    NSLog(@"Error in request in-app purchases prices: %@", error);
    _onError(error.localizedDescription);
    @synchronized (_curDelegates) {
        _curDelegates = [_curDelegates arrayByRemovingObject:self];
    }
}


+ (instancetype)delegateWithCallback:(void (^)(id <CNSeq>))callback onError:(void (^)(NSString *))error {
    return [[self alloc] initWithCallback:callback onError:error];
}

@end


@interface EGInAppObserver : NSObject <SKPaymentTransactionObserver>
@end

@implementation EGInAppObserver
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions {
    for(SKPaymentTransaction * transaction in transactions) {
        [[EGInAppTransaction changeNotification] postSender:[EGInAppTransactionPlat platWithTransaction:transaction]];
    }
}
@end


@implementation EGInApp
static ODClassType* _EGInApp_type;
static EGInAppObserver* _EGInApp_observer;


+ (void)load {
    [super load];
    _EGInApp_observer = [[EGInAppObserver alloc] init];
    [[SKPaymentQueue defaultQueue] addTransactionObserver:_EGInApp_observer];
}


+ (void)initialize {
    [super initialize];
    _curDelegates = [NSArray array];
    _EGInApp_type = [ODClassType classTypeWithCls:[EGInApp class]];
    _EGInApp_products = [NSMutableDictionary mutableDictionary];
}

+ (void)getFromCacheOrLoadProduct:(NSString *)idd callback:(void (^)(EGInAppProduct *))callback onError:(void (^)(NSString *))error {
    EGInAppProduct* product = [_EGInApp_products objectForKey:idd];
    if(product != nil) {
        callback(product);
    } else {
        NSArray *ids = @[idd];
        [EGInApp loadProductsIds:ids
                        callback:^void(id <CNSeq> products) {
                            id o = [products head];
                            if(o != nil) callback(o);
                        }
                        onError:error];
    }
}

+ (void)loadProductsIds:(id <CNSeq>)ids callback:(void (^)(id <CNSeq>))callback onError:(void (^)(NSString *))error {
    SKProductsRequest *productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:[ids convertWithBuilder:[CNHashSetBuilder hashSetBuilder]]];
    EGInAppProductRequestDelegate *del = [EGInAppProductRequestDelegate delegateWithCallback:callback onError:error];
    @synchronized (_curDelegates) {
        _curDelegates = [_curDelegates arrayByAddingObject:del];
    }
    productsRequest.delegate = del;
    [productsRequest start];
}

- (ODClassType*)type {
    return [EGInApp type];
}

+ (ODClassType*)type {
    return _EGInApp_type;
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


@implementation EGInAppProductPlat {
    SKProduct* _product;
}
- (instancetype)initWithProduct:(SKProduct *)x {
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
    [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [numberFormatter setLocale:x.priceLocale];
    NSString *formattedString = [numberFormatter stringFromNumber:x.price];
    self = [super initWithId:x.productIdentifier name:x.localizedTitle price:formattedString];
    if (self) {
        _product = x;
    }

    return self;
}

+ (instancetype)platWithProduct:(SKProduct *)product {
    return [[self alloc] initWithProduct:product];
}

- (void)buyQuantity:(NSUInteger)quantity {
    SKMutablePayment *payment = [SKMutablePayment paymentWithProduct:_product];
    payment.quantity = quantity;
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

@end

@implementation EGInAppTransactionPlat {
    SKPaymentTransaction * _transaction;
}
- (instancetype)initWithTransaction:(SKPaymentTransaction *)transaction {
    EGInAppTransactionState *state;
    if(transaction.transactionState == SKPaymentTransactionStateFailed) {
        NSLog(@"In-App: %@: Error in transaction %@", transaction.payment.productIdentifier, transaction.error);
        state = [EGInAppTransactionState failed];
    } else if(transaction.transactionState == SKPaymentTransactionStatePurchasing) {
        NSLog(@"In-App: %@: purchasing", transaction.payment.productIdentifier);
        state = [EGInAppTransactionState purchasing];
    } else if(transaction.transactionState == SKPaymentTransactionStatePurchased) {
        NSLog(@"In-App: %@: purchased", transaction.payment.productIdentifier);
        state = [EGInAppTransactionState purchased];
    } else if(transaction.transactionState == SKPaymentTransactionStateRestored) {
        NSLog(@"In-App: %@: restored", transaction.payment.productIdentifier);
        state = [EGInAppTransactionState restored];
    } else {
        NSLog(@"In-App: %@: unknown state %li", transaction.payment.productIdentifier, (long)transaction.transactionState);
    }
    self = [super initWithProductId:transaction.payment.productIdentifier
                           quantity:(NSUInteger)transaction.payment.quantity
                              state:state
                              error:transaction.error.localizedDescription
    ];
    if (self) {
        _transaction = transaction;
    }

    return self;
}

+ (instancetype)platWithTransaction:(SKPaymentTransaction *)transaction {
    return [[self alloc] initWithTransaction:transaction];
}


- (void)finish {
    [[SKPaymentQueue defaultQueue] finishTransaction:_transaction];
    [super finish];
}

@end