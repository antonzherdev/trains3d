#import "objdcore.h"
#import "CNSeq.h"
#import "ODObject.h"
#import "CNCollection.h"
@class ODClassType;
@protocol CNSet;
@class CNHashSetBuilder;
@class CNChain;
@class CNDispatchQueue;

@class CNPArray;
@class CNPArrayIterator;

@interface CNPArray : NSObject<CNImSeq>
@property (nonatomic, readonly) NSUInteger stride;
@property (nonatomic, readonly) id(^wrap)(VoidRef, NSUInteger);
@property (nonatomic, readonly) NSUInteger count;
@property (nonatomic, readonly) NSUInteger length;
@property (nonatomic, readonly) VoidRef bytes;
@property (nonatomic, readonly) BOOL copied;

+ (instancetype)arrayWithStride:(NSUInteger)stride wrap:(id(^)(VoidRef, NSUInteger))wrap count:(NSUInteger)count length:(NSUInteger)length bytes:(VoidRef)bytes copied:(BOOL)copied;
- (instancetype)initWithStride:(NSUInteger)stride wrap:(id(^)(VoidRef, NSUInteger))wrap count:(NSUInteger)count length:(NSUInteger)length bytes:(VoidRef)bytes copied:(BOOL)copied;
- (ODClassType*)type;
+ (CNPArray*)applyStride:(NSUInteger)stride wrap:(id(^)(VoidRef, NSUInteger))wrap count:(NSUInteger)count copyBytes:(VoidRef)copyBytes;
- (id<CNIterator>)iterator;
- (id)applyIndex:(NSUInteger)index;
- (void)dealloc;
- (id)unsafeApplyIndex:(NSUInteger)index;
- (void)forRefEach:(void(^)(VoidRef))each;
+ (ODClassType*)type;
@end


@interface CNPArrayIterator : NSObject<CNIterator>
@property (nonatomic, readonly) CNPArray* array;

+ (instancetype)arrayIteratorWithArray:(CNPArray*)array;
- (instancetype)initWithArray:(CNPArray*)array;
- (ODClassType*)type;
- (BOOL)hasNext;
- (id)next;
+ (ODClassType*)type;
@end


