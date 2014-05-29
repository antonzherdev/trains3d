#import "objd.h"
@class CNSignal;

@class EGInAppProduct;
@class EGInAppTransaction;
@class EGInAppTransactionState;

typedef enum EGInAppTransactionStateR {
    EGInAppTransactionState_Nil = 0,
    EGInAppTransactionState_purchasing = 1,
    EGInAppTransactionState_purchased = 2,
    EGInAppTransactionState_failed = 3,
    EGInAppTransactionState_restored = 4
} EGInAppTransactionStateR;
@interface EGInAppTransactionState : CNEnum
+ (NSArray*)values;
@end
static EGInAppTransactionState* EGInAppTransactionState_Values[4];
static EGInAppTransactionState* EGInAppTransactionState_purchasing_Desc;
static EGInAppTransactionState* EGInAppTransactionState_purchased_Desc;
static EGInAppTransactionState* EGInAppTransactionState_failed_Desc;
static EGInAppTransactionState* EGInAppTransactionState_restored_Desc;


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
- (CNClassType*)type;
- (void)buy;
- (void)buyQuantity:(NSUInteger)quantity;
- (NSString*)description;
+ (CNClassType*)type;
@end


@interface EGInAppTransaction : NSObject {
@protected
    NSString* _productId;
    NSUInteger _quantity;
    EGInAppTransactionStateR _state;
    NSString* _error;
}
@property (nonatomic, readonly) NSString* productId;
@property (nonatomic, readonly) NSUInteger quantity;
@property (nonatomic, readonly) EGInAppTransactionStateR state;
@property (nonatomic, readonly) NSString* error;

+ (instancetype)inAppTransactionWithProductId:(NSString*)productId quantity:(NSUInteger)quantity state:(EGInAppTransactionStateR)state error:(NSString*)error;
- (instancetype)initWithProductId:(NSString*)productId quantity:(NSUInteger)quantity state:(EGInAppTransactionStateR)state error:(NSString*)error;
- (CNClassType*)type;
- (void)finish;
- (NSString*)description;
+ (CNSignal*)changed;
+ (CNSignal*)finished;
+ (CNClassType*)type;
@end


