#import "objd.h"
#import "ATObserver.h"

@class ATReact;
@class ATImReact;
@class ATMReact;
@class ATVal;
@class ATVar;
@class ATSlot;
@class ATReactExpression;
@class ATMappedReact;
@class ATMappedReact2;
@class ATMappedReact3;
@class ATFlatMappedReact;
@class ATAsyncMappedReact;
@class ATAsyncMappedReact2;
@class ATAsyncMappedReact3;
@class ATReactFlag;

@interface ATReact : NSObject<ATObservable>
+ (instancetype)react;
- (instancetype)init;
- (ODClassType*)type;
+ (ATReact*)applyValue:(id)value;
+ (ATReact*)applyA:(ATReact*)a f:(id(^)(id))f;
+ (ATReact*)applyA:(ATReact*)a b:(ATReact*)b f:(id(^)(id, id))f;
+ (ATReact*)applyA:(ATReact*)a b:(ATReact*)b c:(ATReact*)c f:(id(^)(id, id, id))f;
+ (ATReact*)asyncQueue:(CNDispatchQueue*)queue a:(ATReact*)a f:(id(^)(id))f;
+ (ATReact*)asyncA:(ATReact*)a f:(id(^)(id))f;
+ (ATReact*)asyncQueue:(CNDispatchQueue*)queue a:(ATReact*)a b:(ATReact*)b f:(id(^)(id, id))f;
+ (ATReact*)asyncA:(ATReact*)a b:(ATReact*)b f:(id(^)(id, id))f;
+ (ATReact*)asyncQueue:(CNDispatchQueue*)queue a:(ATReact*)a b:(ATReact*)b c:(ATReact*)c f:(id(^)(id, id, id))f;
+ (ATReact*)asyncA:(ATReact*)a b:(ATReact*)b c:(ATReact*)c f:(id(^)(id, id, id))f;
- (void)attachObserver:(ATObserver*)observer;
- (void)detachObserver:(ATObserver*)observer;
- (id)value;
- (ATReact*)mapF:(id(^)(id))f;
- (ATReact*)flatMapF:(ATReact*(^)(id))f;
- (ATReact*)asyncMapQueue:(CNDispatchQueue*)queue f:(id(^)(id))f;
- (ATReact*)asyncMapF:(id(^)(id))f;
+ (ODClassType*)type;
@end


@interface ATImReact : ATReact
+ (instancetype)imReact;
- (instancetype)init;
- (ODClassType*)type;
- (void)attachObserver:(ATObserver*)observer;
- (void)detachObserver:(ATObserver*)observer;
+ (ODClassType*)type;
@end


@interface ATMReact : ATReact<ATObservableBase> {
@private
    CNAtomicObject* __value;
    CNAtomicObject* __observers;
}
@property (nonatomic, readonly) CNAtomicObject* _value;

+ (instancetype)react;
- (instancetype)init;
- (ODClassType*)type;
- (id)value;
- (void)_setValue:(id)value;
+ (ODClassType*)type;
@end


@interface ATVal : ATImReact {
@private
    id _value;
}
@property (nonatomic, readonly) id value;

+ (instancetype)valWithValue:(id)value;
- (instancetype)initWithValue:(id)value;
- (ODClassType*)type;
+ (ODClassType*)type;
@end


@interface ATVar : ATMReact
+ (instancetype)var;
- (instancetype)init;
- (ODClassType*)type;
+ (ATVar*)applyInitial:(id)initial;
- (void)setValue:(id)value;
- (void)updateF:(id(^)(id))f;
+ (ODClassType*)type;
@end


@interface ATSlot : ATMReact {
@private
    ATReact* __base;
    ATObserver* __observer;
}
+ (instancetype)slot;
- (instancetype)init;
- (ODClassType*)type;
+ (ATSlot*)applyInitial:(id)initial;
- (void)connectTo:(ATReact*)to;
- (void)setValue:(id)value;
+ (ODClassType*)type;
@end


@interface ATReactExpression : ATMReact
+ (instancetype)reactExpression;
- (instancetype)init;
- (ODClassType*)type;
- (void)_init;
- (void)recalc;
- (id)calc;
+ (ODClassType*)type;
@end


@interface ATMappedReact : ATReactExpression {
@private
    ATReact* _a;
    id(^_f)(id);
    ATObserver* _obsA;
}
@property (nonatomic, readonly) ATReact* a;
@property (nonatomic, readonly) id(^f)(id);

+ (instancetype)mappedReactWithA:(ATReact*)a f:(id(^)(id))f;
- (instancetype)initWithA:(ATReact*)a f:(id(^)(id))f;
- (ODClassType*)type;
- (id)calc;
+ (ODClassType*)type;
@end


@interface ATMappedReact2 : ATReactExpression {
@private
    ATReact* _a;
    ATReact* _b;
    id(^_f)(id, id);
    ATObserver* _obsA;
    ATObserver* _obsB;
}
@property (nonatomic, readonly) ATReact* a;
@property (nonatomic, readonly) ATReact* b;
@property (nonatomic, readonly) id(^f)(id, id);

+ (instancetype)mappedReact2WithA:(ATReact*)a b:(ATReact*)b f:(id(^)(id, id))f;
- (instancetype)initWithA:(ATReact*)a b:(ATReact*)b f:(id(^)(id, id))f;
- (ODClassType*)type;
- (id)calc;
+ (ODClassType*)type;
@end


@interface ATMappedReact3 : ATReactExpression {
@private
    ATReact* _a;
    ATReact* _b;
    ATReact* _c;
    id(^_f)(id, id, id);
    ATObserver* _obsA;
    ATObserver* _obsB;
    ATObserver* _obsC;
}
@property (nonatomic, readonly) ATReact* a;
@property (nonatomic, readonly) ATReact* b;
@property (nonatomic, readonly) ATReact* c;
@property (nonatomic, readonly) id(^f)(id, id, id);

+ (instancetype)mappedReact3WithA:(ATReact*)a b:(ATReact*)b c:(ATReact*)c f:(id(^)(id, id, id))f;
- (instancetype)initWithA:(ATReact*)a b:(ATReact*)b c:(ATReact*)c f:(id(^)(id, id, id))f;
- (ODClassType*)type;
- (id)calc;
+ (ODClassType*)type;
@end


@interface ATFlatMappedReact : ATReactExpression {
@private
    ATReact* _a;
    ATReact*(^_f)(id);
    ATObserver* _obsA;
}
@property (nonatomic, readonly) ATReact* a;
@property (nonatomic, readonly) ATReact*(^f)(id);

+ (instancetype)flatMappedReactWithA:(ATReact*)a f:(ATReact*(^)(id))f;
- (instancetype)initWithA:(ATReact*)a f:(ATReact*(^)(id))f;
- (ODClassType*)type;
- (id)calc;
+ (ODClassType*)type;
@end


@interface ATAsyncMappedReact : ATReactExpression {
@private
    CNDispatchQueue* _queue;
    ATReact* _a;
    id(^_f)(id);
    ATObserver* _obsA;
}
@property (nonatomic, readonly) CNDispatchQueue* queue;
@property (nonatomic, readonly) ATReact* a;
@property (nonatomic, readonly) id(^f)(id);

+ (instancetype)asyncMappedReactWithQueue:(CNDispatchQueue*)queue a:(ATReact*)a f:(id(^)(id))f;
- (instancetype)initWithQueue:(CNDispatchQueue*)queue a:(ATReact*)a f:(id(^)(id))f;
- (ODClassType*)type;
- (id)calc;
+ (ODClassType*)type;
@end


@interface ATAsyncMappedReact2 : ATReactExpression {
@private
    CNDispatchQueue* _queue;
    ATReact* _a;
    ATReact* _b;
    id(^_f)(id, id);
    ATObserver* _obsA;
    ATObserver* _obsB;
}
@property (nonatomic, readonly) CNDispatchQueue* queue;
@property (nonatomic, readonly) ATReact* a;
@property (nonatomic, readonly) ATReact* b;
@property (nonatomic, readonly) id(^f)(id, id);

+ (instancetype)asyncMappedReact2WithQueue:(CNDispatchQueue*)queue a:(ATReact*)a b:(ATReact*)b f:(id(^)(id, id))f;
- (instancetype)initWithQueue:(CNDispatchQueue*)queue a:(ATReact*)a b:(ATReact*)b f:(id(^)(id, id))f;
- (ODClassType*)type;
- (id)calc;
+ (ODClassType*)type;
@end


@interface ATAsyncMappedReact3 : ATReactExpression {
@private
    CNDispatchQueue* _queue;
    ATReact* _a;
    ATReact* _b;
    ATReact* _c;
    id(^_f)(id, id, id);
    ATObserver* _obsA;
    ATObserver* _obsB;
    ATObserver* _obsC;
}
@property (nonatomic, readonly) CNDispatchQueue* queue;
@property (nonatomic, readonly) ATReact* a;
@property (nonatomic, readonly) ATReact* b;
@property (nonatomic, readonly) ATReact* c;
@property (nonatomic, readonly) id(^f)(id, id, id);

+ (instancetype)asyncMappedReact3WithQueue:(CNDispatchQueue*)queue a:(ATReact*)a b:(ATReact*)b c:(ATReact*)c f:(id(^)(id, id, id))f;
- (instancetype)initWithQueue:(CNDispatchQueue*)queue a:(ATReact*)a b:(ATReact*)b c:(ATReact*)c f:(id(^)(id, id, id))f;
- (ODClassType*)type;
- (id)calc;
+ (ODClassType*)type;
@end


@interface ATReactFlag : ATMReact {
@private
    BOOL _initial;
    id<CNImSeq> _reacts;
    id<CNImSeq> _observers;
}
@property (nonatomic, readonly) BOOL initial;
@property (nonatomic, readonly) id<CNImSeq> reacts;

+ (instancetype)reactFlagWithInitial:(BOOL)initial reacts:(id<CNImSeq>)reacts;
- (instancetype)initWithInitial:(BOOL)initial reacts:(id<CNImSeq>)reacts;
- (ODClassType*)type;
- (void)_init;
- (void)set;
- (void)setValue:(BOOL)value;
- (void)clear;
- (void)processF:(void(^)())f;
+ (ODClassType*)type;
@end


