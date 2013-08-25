#import <Foundation/Foundation.h>
#import "CNSeq.h"
#import "CNCollection.h"
#import "CNTypes.h"
@class CNOption;
@class CNChain;

@class CNPArray;
@class CNPArrayIterator;

@interface CNPArray : NSObject<CNSeq>
@property (nonatomic, readonly) NSUInteger stride;
@property (nonatomic, readonly) id(^wrap)(VoidRef, NSUInteger);
@property (nonatomic, readonly) NSUInteger count;
@property (nonatomic, readonly) NSUInteger length;
@property (nonatomic, readonly) VoidRef bytes;
@property (nonatomic, readonly) BOOL copied;

+ (id)arrayWithStride:(NSUInteger)stride wrap:(id(^)(VoidRef, NSUInteger))wrap count:(NSUInteger)count length:(NSUInteger)length bytes:(VoidRef)bytes copied:(BOOL)copied;
- (id)initWithStride:(NSUInteger)stride wrap:(id(^)(VoidRef, NSUInteger))wrap count:(NSUInteger)count length:(NSUInteger)length bytes:(VoidRef)bytes copied:(BOOL)copied;
+ (CNPArray*)applyStride:(NSUInteger)stride wrap:(id(^)(VoidRef, NSUInteger))wrap count:(NSUInteger)count copyBytes:(VoidRef)copyBytes;
- (id<CNIterator>)iterator;
- (id)applyIndex:(NSUInteger)index;
- (void)dealloc;
@end


@interface CNPArrayIterator : NSObject<CNIterator>
@property (nonatomic, readonly) CNPArray* array;

+ (id)arrayIteratorWithArray:(CNPArray*)array;
- (id)initWithArray:(CNPArray*)array;
- (BOOL)hasNext;
- (id)next;
@end


