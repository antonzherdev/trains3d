#import "objdcore.h"
#import "ODType.h"
#import "CNSeq.h"
#import "CNCollection.h"
#import "CNTypes.h"
@class CNOption;
@class CNChain;

@class CNPArray;
@class CNPArrayIterator;
@class CNMutablePArray;

@interface CNPArray : NSObject<CNSeq>
@property (nonatomic, readonly) NSUInteger stride;
@property (nonatomic, readonly) id(^wrap)(VoidRef, NSUInteger);
@property (nonatomic, readonly) NSUInteger count;
@property (nonatomic, readonly) NSUInteger length;
@property (nonatomic, readonly) VoidRef bytes;
@property (nonatomic, readonly) BOOL copied;

+ (id)arrayWithStride:(NSUInteger)stride wrap:(id(^)(VoidRef, NSUInteger))wrap count:(NSUInteger)count length:(NSUInteger)length bytes:(VoidRef)bytes copied:(BOOL)copied;
- (id)initWithStride:(NSUInteger)stride wrap:(id(^)(VoidRef, NSUInteger))wrap count:(NSUInteger)count length:(NSUInteger)length bytes:(VoidRef)bytes copied:(BOOL)copied;
- (ODClassType*)type;
+ (CNPArray*)applyStride:(NSUInteger)stride wrap:(id(^)(VoidRef, NSUInteger))wrap count:(NSUInteger)count copyBytes:(VoidRef)copyBytes;
- (id<CNIterator>)iterator;
- (id)applyIndex:(NSUInteger)index;
- (void)dealloc;
+ (ODClassType*)type;
@end


@interface CNPArrayIterator : NSObject<CNIterator>
@property (nonatomic, readonly) CNPArray* array;

+ (id)arrayIteratorWithArray:(CNPArray*)array;
- (id)initWithArray:(CNPArray*)array;
- (ODClassType*)type;
- (BOOL)hasNext;
- (id)next;
+ (ODClassType*)type;
@end


@interface CNMutablePArray : CNPArray
+ (id)mutablePArrayWithStride:(NSUInteger)stride wrap:(id(^)(VoidRef, NSUInteger))wrap count:(NSUInteger)count length:(NSUInteger)length bytes:(VoidRef)bytes;
- (id)initWithStride:(NSUInteger)stride wrap:(id(^)(VoidRef, NSUInteger))wrap count:(NSUInteger)count length:(NSUInteger)length bytes:(VoidRef)bytes;
- (ODClassType*)type;
+ (CNMutablePArray*)applyTp:(ODPType*)tp count:(NSUInteger)count;
- (void)writeItem:(VoidRef)item;
- (void)writeItem:(VoidRef)item times:(NSUInteger)times;
- (void)writeItems:(CNPArray*)items;
+ (ODClassType*)type;
@end


