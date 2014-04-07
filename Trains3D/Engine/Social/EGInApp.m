#import "EGInApp.h"

@implementation EGInAppProduct
static ODClassType* _EGInAppProduct_type;
@synthesize id = _id;
@synthesize name = _name;
@synthesize price = _price;

+ (instancetype)inAppProductWithId:(NSString*)id name:(NSString*)name price:(NSString*)price {
    return [[EGInAppProduct alloc] initWithId:id name:name price:price];
}

- (instancetype)initWithId:(NSString*)id name:(NSString*)name price:(NSString*)price {
    self = [super init];
    if(self) {
        _id = id;
        _name = name;
        _price = price;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGInAppProduct class]) _EGInAppProduct_type = [ODClassType classTypeWithCls:[EGInAppProduct class]];
}

- (void)buy {
    [self buyQuantity:1];
}

- (void)buyQuantity:(NSUInteger)quantity {
    @throw @"Method buy is abstract";
}

- (ODClassType*)type {
    return [EGInAppProduct type];
}

+ (ODClassType*)type {
    return _EGInAppProduct_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"id=%@", self.id];
    [description appendFormat:@", name=%@", self.name];
    [description appendFormat:@", price=%@", self.price];
    [description appendString:@">"];
    return description;
}

@end


@implementation EGInAppTransaction
static CNNotificationHandle* _EGInAppTransaction_changeNotification;
static CNNotificationHandle* _EGInAppTransaction_finishNotification;
static ODClassType* _EGInAppTransaction_type;
@synthesize productId = _productId;
@synthesize quantity = _quantity;
@synthesize state = _state;
@synthesize error = _error;

+ (instancetype)inAppTransactionWithProductId:(NSString*)productId quantity:(NSUInteger)quantity state:(EGInAppTransactionState*)state error:(NSString*)error {
    return [[EGInAppTransaction alloc] initWithProductId:productId quantity:quantity state:state error:error];
}

- (instancetype)initWithProductId:(NSString*)productId quantity:(NSUInteger)quantity state:(EGInAppTransactionState*)state error:(NSString*)error {
    self = [super init];
    if(self) {
        _productId = productId;
        _quantity = quantity;
        _state = state;
        _error = error;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGInAppTransaction class]) {
        _EGInAppTransaction_type = [ODClassType classTypeWithCls:[EGInAppTransaction class]];
        _EGInAppTransaction_changeNotification = [CNNotificationHandle notificationHandleWithName:@"InAppTransaction.changeNotification"];
        _EGInAppTransaction_finishNotification = [CNNotificationHandle notificationHandleWithName:@"InAppTransaction.finishNotification"];
    }
}

- (void)finish {
    [_EGInAppTransaction_finishNotification postSender:self];
}

- (ODClassType*)type {
    return [EGInAppTransaction type];
}

+ (CNNotificationHandle*)changeNotification {
    return _EGInAppTransaction_changeNotification;
}

+ (CNNotificationHandle*)finishNotification {
    return _EGInAppTransaction_finishNotification;
}

+ (ODClassType*)type {
    return _EGInAppTransaction_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"productId=%@", self.productId];
    [description appendFormat:@", quantity=%lu", (unsigned long)self.quantity];
    [description appendFormat:@", state=%@", self.state];
    [description appendFormat:@", error=%@", self.error];
    [description appendString:@">"];
    return description;
}

@end


@implementation EGInAppTransactionState
static EGInAppTransactionState* _EGInAppTransactionState_purchasing;
static EGInAppTransactionState* _EGInAppTransactionState_purchased;
static EGInAppTransactionState* _EGInAppTransactionState_failed;
static EGInAppTransactionState* _EGInAppTransactionState_restored;
static NSArray* _EGInAppTransactionState_values;

+ (instancetype)inAppTransactionStateWithOrdinal:(NSUInteger)ordinal name:(NSString*)name {
    return [[EGInAppTransactionState alloc] initWithOrdinal:ordinal name:name];
}

- (instancetype)initWithOrdinal:(NSUInteger)ordinal name:(NSString*)name {
    self = [super initWithOrdinal:ordinal name:name];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGInAppTransactionState_purchasing = [EGInAppTransactionState inAppTransactionStateWithOrdinal:0 name:@"purchasing"];
    _EGInAppTransactionState_purchased = [EGInAppTransactionState inAppTransactionStateWithOrdinal:1 name:@"purchased"];
    _EGInAppTransactionState_failed = [EGInAppTransactionState inAppTransactionStateWithOrdinal:2 name:@"failed"];
    _EGInAppTransactionState_restored = [EGInAppTransactionState inAppTransactionStateWithOrdinal:3 name:@"restored"];
    _EGInAppTransactionState_values = (@[_EGInAppTransactionState_purchasing, _EGInAppTransactionState_purchased, _EGInAppTransactionState_failed, _EGInAppTransactionState_restored]);
}

+ (EGInAppTransactionState*)purchasing {
    return _EGInAppTransactionState_purchasing;
}

+ (EGInAppTransactionState*)purchased {
    return _EGInAppTransactionState_purchased;
}

+ (EGInAppTransactionState*)failed {
    return _EGInAppTransactionState_failed;
}

+ (EGInAppTransactionState*)restored {
    return _EGInAppTransactionState_restored;
}

+ (NSArray*)values {
    return _EGInAppTransactionState_values;
}

@end


