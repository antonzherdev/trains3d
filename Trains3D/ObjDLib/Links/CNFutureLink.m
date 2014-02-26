#import "objd.h"
#import "CNFutureLink.h"

#import "CNFuture.h"
#import "CNAtomic.h"
#import "CNYield.h"
#import "CNTry.h"
#import "ODType.h"
@implementation CNFutureLink{
    CNPromise* __promise;
    BOOL __stopped;
    NSLock* __lock;
    CNAtomicInt* __counter;
    BOOL __ended;
}
static ODClassType* _CNFutureLink_type;

+ (instancetype)futureLink {
    return [[CNFutureLink alloc] init];
}

- (instancetype)init {
    self = [super init];
    if(self) {
        __promise = [CNPromise apply];
        __stopped = NO;
        __lock = [NSLock lock];
        __counter = [CNAtomicInt atomicInt];
        __ended = NO;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [CNFutureLink class]) _CNFutureLink_type = [ODClassType classTypeWithCls:[CNFutureLink class]];
}

- (CNFuture*)future {
    return __promise;
}

- (CNYield*)buildYield:(CNYield*)yield {
    return [CNYield decorateBase:yield yield:^NSInteger(CNFuture* fut) {
        if(!(__stopped)) {
            [__counter incrementAndGet];
            [((CNFuture*)(fut)) onCompleteF:^void(CNTry* tr) {
                if(!(__stopped)) {
                    [__lock lock];
                    if([tr isFailure]) {
                        __stopped = YES;
                        [__promise failureReason:tr];
                    } else {
                        if(!(__stopped)) {
                            if([yield yieldItem:[tr get]] != 0) {
                                __stopped = YES;
                                [__promise successValue:nil];
                                [yield endYieldWithResult:1];
                            } else {
                                if([__counter decrementAndGet] == 0 && __ended) {
                                    [__promise successValue:nil];
                                    [yield endYieldWithResult:0];
                                }
                            }
                        }
                    }
                    [__lock unlock];
                }
            }];
        }
        if(__stopped) return 1;
        else return 0;
    } end:^NSInteger(NSInteger res) {
        NSInteger ret = res;
        [__lock lock];
        __ended = YES;
        if(!([__promise isCompleted]) && [__counter intValue] == 0) {
            [__promise successValue:nil];
            if([yield endYieldWithResult:res] != 0) ret = 1;
        }
        [__lock unlock];
        return ret;
    }];
}

- (ODClassType*)type {
    return [CNFutureLink type];
}

+ (ODClassType*)type {
    return _CNFutureLink_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    return YES;
}

- (NSUInteger)hash {
    return 0;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendString:@">"];
    return description;
}

@end


