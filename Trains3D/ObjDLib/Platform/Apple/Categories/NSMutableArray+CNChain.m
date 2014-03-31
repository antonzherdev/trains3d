#import "NSMutableArray+CNChain.h"
#import "NSArray+CNChain.h"
#import "CNEnumerator.h"

#define NILL_ST(_object) (_object == nil) ? _NULL : _object
#define UNILL_ST(_object) (_object == _NULL) ? nil : _object

static NSNull* _NULL;

@implementation NSMutableArray (CNChain)
+ (NSMutableArray *)mutableArray {
    return [NSMutableArray array];
}

- (void)appendItem:(id)object {
    [self addObject:NILL_ST(object)];
}

+ (void)initialize {
    [super initialize];
    _NULL = [NSNull null];
}


+ (NSMutableArray *)applyCapacity:(NSUInteger)size {
    return [NSMutableArray arrayWithCapacity:size];
}

- (BOOL)removeItem:(id)object {
    NSUInteger oldCount = self.count;
    [self removeObject:NILL_ST(object)];
    return oldCount > self.count;
}

- (void)mutableFilterBy:(BOOL(^)(id))by {
    NSMutableIndexSet* indexSet = [NSMutableIndexSet indexSet];
    NSUInteger i = 0;
    for(id item in self) {
        if(!by(UNILL_ST(item))) {
            [indexSet addIndex:i];
        }
        i++;
    }
    [self removeObjectsAtIndexes:indexSet];
}


- (void)clear {
    [self removeAllObjects];
}

- (BOOL)removeIndex:(NSUInteger)index1 {
    NSUInteger oldCount = self.count;
    [self removeObjectAtIndex:index1];
    return oldCount > self.count;
}

- (void)insertIndex:(NSUInteger)index1 item:(id)item {
    [self insertObject:item atIndex:index1];
}


- (void)setIndex:(NSUInteger)index1 item:(id)item {
    [self setObject:NILL_ST(item) atIndexedSubscript:index1];
}

- (NSArray*)im {
    return self;
}

- (NSArray*)imCopy {
    return [NSArray arrayWithArray:self];
}


- (id <CNMIterator>)mutableIterator {
    return [CNMEnumerator enumeratorWithEnumerator:[self objectEnumerator]];
}
@end