#import "objd.h"

@class EGInAppProduct;
@class EGInAppTransaction;
@class EGInAppTransactionState;

@interface EGInAppProduct : NSObject {
@protected
    NSString* _id;
    NSString* _name;
    NSString* _price;
}
@property (nonatomic, readonly) NSString* id;
@property (nonatomic, readonly) NSString* name;
@property (nonatomic, readonly) NSString* price;

+ (instancetype)inAppProductWithId:(NSString*)id name:(NSString*)name price:(NSString*)price;
- (instancetype)initWithId:(NSString*)id name:(NSString*)name price:(NSString*)price;
- (ODClassType*)type;
- (void)buy;
- (void)buyQuantity:(NSUInteger)quantity;
+ (ODClassType*)type;
@end


@interface EGInAppTransaction : NSObject {
@protected
    NSString* _productId;
    NSUInteger _quantity;
    EGInAppTransactionState* _state;
    NSString* _error;
}
@property (nonatomic, readonly) NSString* productId;
@property (nonatomic, readonly) NSUInteger quantity;
@property (nonatomic, readonly) EGInAppTransactionState* state;
@property (nonatomic, readonly) NSString* error;

+ (instancetype)inAppTransactionWithProductId:(NSString*)productId quantity:(NSUInteger)quantity state:(EGInAppTransactionState*)state error:(NSString*)error;
- (instancetype)initWithProductId:(NSString*)productId quantity:(NSUInteger)quantity state:(EGInAppTransactionState*)state error:(NSString*)error;
- (ODClassType*)type;
- (void)finish;
+ (CNNotificationHandle*)changeNotification;
+ (CNNotificationHandle*)finishNotification;
+ (ODClassType*)type;
@end


@interface EGInAppTransactionState : ODEnum
+ (EGInAppTransactionState*)purchasing;
+ (EGInAppTransactionState*)purchased;
+ (EGInAppTransactionState*)failed;
+ (EGInAppTransactionState*)restored;
+ (NSArray*)values;
@end


