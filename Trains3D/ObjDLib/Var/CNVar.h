#import "objdcore.h"
#import "ODObject.h"
@class CNAtomicObject;
@class ODClassType;

@class CNVar;

@interface CNVar : NSObject {
@private
    CNAtomicObject* __value;
    CNAtomicObject* __observers;
}
+ (instancetype)var;
- (instancetype)init;
- (ODClassType*)type;
+ (CNVar*)applyInitial:(id)initial;
- (void)setValue:(id)value;
- (void)updateF:(id(^)(id))f;
- (id)value;
- (void)onChangeF:(void(^)(id))f;
- (CNVar*)mapF:(id(^)(id))f;
+ (ODClassType*)type;
@end


