#import "objd.h"
#import "ODType.h"
@class CNPArray;
@class CNPArrayIterator;
#import "CNTypes.h"

typedef struct CNVoidRefArray CNVoidRefArray;

struct CNVoidRefArray {
    NSUInteger length;
    VoidRef bytes;
};
static inline CNVoidRefArray CNVoidRefArrayMake(NSUInteger length, VoidRef bytes) {
    return (CNVoidRefArray){length, bytes};
}
static inline BOOL CNVoidRefArrayEq(CNVoidRefArray s1, CNVoidRefArray s2) {
    return s1.length == s2.length && s1.bytes == s2.bytes;
}
static inline NSUInteger CNVoidRefArrayHash(CNVoidRefArray self) {
    return (NSUInteger) self.bytes;
}
static inline NSString* CNVoidRefArrayDescription(CNVoidRefArray self) {
    NSMutableString* description = [NSMutableString stringWithString:@"<CNVoidRefArray: "];
    [description appendFormat:@"length=%li", self.length];
    [description appendFormat:@", bytes=%p", self.bytes];
    [description appendString:@">"];
    return description;
}
CNVoidRefArray cnVoidRefArrayApplyLength(NSUInteger length);
CNVoidRefArray cnVoidRefArrayApplyTpCount(ODPType* tp, NSUInteger count);
#define cnVoidRefArrayWriteTpItem(p_self, p_tp, p_item) ({\
    *(p_tp*)p_self.bytes = p_item;\
    (CNVoidRefArray){p_self.length, p_self.bytes + sizeof(p_tp)};\
})
static inline CNVoidRefArray cnVoidRefArrayWriteUInt4(const CNVoidRefArray self, unsigned int uInt4) {
    *(unsigned int*)self.bytes = uInt4;
    return (CNVoidRefArray){self.length, ((unsigned int*)self.bytes) + 1};
}
static inline void cnVoidRefArrayFree(CNVoidRefArray self) {
    free(self.bytes);
}

ODPType* cnVoidRefArrayType();
@interface CNVoidRefArrayWrap : NSObject
@property (readonly, nonatomic) CNVoidRefArray value;

+ (id)wrapWithValue:(CNVoidRefArray)value;
- (id)initWithValue:(CNVoidRefArray)value;
@end



