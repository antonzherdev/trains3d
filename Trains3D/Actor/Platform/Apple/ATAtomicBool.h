#import "objd.h"

@class ATAtomicBool;

@interface ATAtomicBool : NSObject
+ (id)atomicBool;
- (id)init;
- (ODClassType*)type;
- (BOOL)boolValue;
- (void)setNewValue:(BOOL)newValue;
- (BOOL)getAndSetNewValue:(BOOL)newValue;
- (BOOL)compareAndSetOldValue:(BOOL)oldValue newValue:(BOOL)newValue;
+ (ODClassType*)type;
@end


