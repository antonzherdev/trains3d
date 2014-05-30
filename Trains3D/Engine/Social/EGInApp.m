#import "EGInApp.h"

#import "CNObserver.h"
@implementation EGInAppProduct
static CNClassType* _EGInAppProduct_type;
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
    if(self == [EGInAppProduct class]) _EGInAppProduct_type = [CNClassType classTypeWithCls:[EGInAppProduct class]];
}

- (void)buy {
    [self buyQuantity:1];
}

- (void)buyQuantity:(NSUInteger)quantity {
    @throw @"Method buy is abstract";
}

- (NSString*)description {
    return [NSString stringWithFormat:@"InAppProduct(%@, %@, %@)", _id, _name, _price];
}

- (CNClassType*)type {
    return [EGInAppProduct type];
}

+ (CNClassType*)type {
    return _EGInAppProduct_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation EGInAppTransaction
static CNSignal* _EGInAppTransaction_changed;
static CNSignal* _EGInAppTransaction_finished;
static CNClassType* _EGInAppTransaction_type;
@synthesize productId = _productId;
@synthesize quantity = _quantity;
@synthesize state = _state;
@synthesize error = _error;

+ (instancetype)inAppTransactionWithProductId:(NSString*)productId quantity:(NSUInteger)quantity state:(EGInAppTransactionStateR)state error:(NSString*)error {
    return [[EGInAppTransaction alloc] initWithProductId:productId quantity:quantity state:state error:error];
}

- (instancetype)initWithProductId:(NSString*)productId quantity:(NSUInteger)quantity state:(EGInAppTransactionStateR)state error:(NSString*)error {
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
        _EGInAppTransaction_type = [CNClassType classTypeWithCls:[EGInAppTransaction class]];
        _EGInAppTransaction_changed = [CNSignal signal];
        _EGInAppTransaction_finished = [CNSignal signal];
    }
}

- (void)finish {
    [_EGInAppTransaction_finished postData:self];
}

- (NSString*)description {
    return [NSString stringWithFormat:@"InAppTransaction(%@, %lu, %@, %@)", _productId, (unsigned long)_quantity, [EGInAppTransactionState value:_state], _error];
}

- (CNClassType*)type {
    return [EGInAppTransaction type];
}

+ (CNSignal*)changed {
    return _EGInAppTransaction_changed;
}

+ (CNSignal*)finished {
    return _EGInAppTransaction_finished;
}

+ (CNClassType*)type {
    return _EGInAppTransaction_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

EGInAppTransactionState* EGInAppTransactionState_Values[5];
EGInAppTransactionState* EGInAppTransactionState_purchasing_Desc;
EGInAppTransactionState* EGInAppTransactionState_purchased_Desc;
EGInAppTransactionState* EGInAppTransactionState_failed_Desc;
EGInAppTransactionState* EGInAppTransactionState_restored_Desc;
@implementation EGInAppTransactionState

+ (instancetype)inAppTransactionStateWithOrdinal:(NSUInteger)ordinal name:(NSString*)name {
    return [[EGInAppTransactionState alloc] initWithOrdinal:ordinal name:name];
}

- (instancetype)initWithOrdinal:(NSUInteger)ordinal name:(NSString*)name {
    self = [super initWithOrdinal:ordinal name:name];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    EGInAppTransactionState_purchasing_Desc = [EGInAppTransactionState inAppTransactionStateWithOrdinal:0 name:@"purchasing"];
    EGInAppTransactionState_purchased_Desc = [EGInAppTransactionState inAppTransactionStateWithOrdinal:1 name:@"purchased"];
    EGInAppTransactionState_failed_Desc = [EGInAppTransactionState inAppTransactionStateWithOrdinal:2 name:@"failed"];
    EGInAppTransactionState_restored_Desc = [EGInAppTransactionState inAppTransactionStateWithOrdinal:3 name:@"restored"];
    EGInAppTransactionState_Values[0] = nil;
    EGInAppTransactionState_Values[1] = EGInAppTransactionState_purchasing_Desc;
    EGInAppTransactionState_Values[2] = EGInAppTransactionState_purchased_Desc;
    EGInAppTransactionState_Values[3] = EGInAppTransactionState_failed_Desc;
    EGInAppTransactionState_Values[4] = EGInAppTransactionState_restored_Desc;
}

+ (NSArray*)values {
    return (@[EGInAppTransactionState_purchasing_Desc, EGInAppTransactionState_purchased_Desc, EGInAppTransactionState_failed_Desc, EGInAppTransactionState_restored_Desc]);
}

+ (EGInAppTransactionState*)value:(EGInAppTransactionStateR)r {
    return EGInAppTransactionState_Values[r];
}

@end

