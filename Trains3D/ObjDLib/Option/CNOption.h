#import "objdcore.h"
#import "CNSeq.h"
#import "ODObject.h"
#import "CNCollection.h"
@class ODClassType;
@protocol CNSet;
@class CNHashSetBuilder;
@class CNChain;
@class CNDispatchQueue;

@class CNOption;
@class CNNone;
@class CNSome;
@class CNSomeIterator;

@interface CNOption : NSObject<CNSeq>
+ (instancetype)option;
- (instancetype)init;
- (ODClassType*)type;
+ (id)none;
+ (id)applyValue:(id)value;
+ (id)someValue:(id)value;
- (id)get;
- (id)getOrElseF:(id(^)())f;
- (id)getOrValue:(id)value;
- (id)getOrNil;
- (id)mapF:(id(^)(id))f;
- (id)flatMapF:(id(^)(id))f;
- (id)filterF:(BOOL(^)(id))f;
- (BOOL)isEmpty;
- (BOOL)isDefined;
- (void)forEach:(void(^)(id))each;
- (BOOL)tryEach:(void(^)(id))each;
- (id<CNIterator>)iterator;
+ (ODClassType*)type;
@end


@interface CNNone : CNOption
+ (instancetype)none;
- (instancetype)init;
- (ODClassType*)type;
- (NSUInteger)count;
- (id)get;
- (id)getOrElseF:(id(^)())f;
- (id)getOrValue:(id)value;
- (id)getOrNil;
- (void)forEach:(void(^)(id))each;
- (id)mapF:(id(^)(id))f;
- (id)flatMapF:(id(^)(id))f;
- (id)filterF:(BOOL(^)(id))f;
- (BOOL)isEmpty;
- (BOOL)isDefined;
- (id<CNIterator>)iterator;
- (BOOL)goOn:(BOOL(^)(id))on;
- (BOOL)tryEach:(void(^)(id))each;
- (BOOL)containsItem:(id)item;
+ (ODClassType*)type;
@end


@interface CNSome : CNOption
@property (nonatomic, readonly) id value;

+ (instancetype)someWithValue:(id)value;
- (instancetype)initWithValue:(id)value;
- (ODClassType*)type;
- (NSUInteger)count;
- (id)get;
- (id)getOrElseF:(id(^)())f;
- (id)getOrNil;
- (id)getOrValue:(id)value;
- (id)mapF:(id(^)(id))f;
- (id)flatMapF:(id(^)(id))f;
- (id)filterF:(BOOL(^)(id))f;
- (BOOL)isEmpty;
- (BOOL)isDefined;
- (id<CNIterator>)iterator;
- (void)forEach:(void(^)(id))each;
- (BOOL)tryEach:(void(^)(id))each;
- (BOOL)goOn:(BOOL(^)(id))on;
- (BOOL)containsItem:(id)item;
+ (ODClassType*)type;
@end


@interface CNSomeIterator : NSObject<CNIterator>
@property (nonatomic, readonly) id value;
@property (nonatomic) BOOL hasNext;

+ (instancetype)someIteratorWithValue:(id)value;
- (instancetype)initWithValue:(id)value;
- (ODClassType*)type;
- (id)next;
+ (ODClassType*)type;
@end


