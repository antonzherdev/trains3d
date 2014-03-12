#import "objdcore.h"
#import "ODObject.h"
@class ODClassType;

@class CNLazy;
@class CNCache;
@class CNWeak;

@interface CNLazy : NSObject {
@private
    id(^_f)();
    id __value;
    BOOL __calculated;
}
@property (nonatomic, readonly) id(^f)();

+ (instancetype)lazyWithF:(id(^)())f;
- (instancetype)initWithF:(id(^)())f;
- (ODClassType*)type;
- (BOOL)isCalculated;
- (id)get;
+ (ODClassType*)type;
@end


@interface CNCache : NSObject {
@private
    id(^_f)(id);
    id __lastX;
    id __lastF;
}
@property (nonatomic, readonly) id(^f)(id);

+ (instancetype)cacheWithF:(id(^)(id))f;
- (instancetype)initWithF:(id(^)(id))f;
- (ODClassType*)type;
- (id)applyX:(id)x;
+ (ODClassType*)type;
@end


@interface CNWeak : NSObject {
@private
    __weak id _get;
}
@property (nonatomic, readonly, weak) id get;

+ (instancetype)weakWithGet:(id)get;
- (instancetype)initWithGet:(id)get;
- (ODClassType*)type;
+ (ODClassType*)type;
@end


