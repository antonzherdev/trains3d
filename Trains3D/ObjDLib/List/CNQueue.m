#import "objd.h"
#import "CNQueue.h"

#import "ODType.h"
#import "CNList.h"
#import "CNOption.h"
@implementation CNImQueue{
    CNList* _in;
    CNList* _out;
}
static CNImQueue* _CNImQueue_empty;
static ODClassType* _CNImQueue_type;
@synthesize in = _in;
@synthesize out = _out;

+ (id)imQueueWithIn:(CNList*)in out:(CNList*)out {
    return [[CNImQueue alloc] initWithIn:in out:out];
}

- (id)initWithIn:(CNList*)in out:(CNList*)out {
    self = [super init];
    if(self) {
        _in = in;
        _out = out;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [CNImQueue class]) {
        _CNImQueue_type = [ODClassType classTypeWithCls:[CNImQueue class]];
        _CNImQueue_empty = [CNImQueue imQueueWithIn:[CNList apply] out:[CNList apply]];
    }
}

+ (CNImQueue*)apply {
    return _CNImQueue_empty;
}

- (id<CNIterator>)iterator {
    return [CNQueueIterator queueIteratorWithIn:_in out:_out];
}

- (BOOL)isEmpty {
    return [_in isEmpty] && [_out isEmpty];
}

- (NSUInteger)count {
    return [_in count] + [_out count];
}

- (CNImQueue*)addItem:(id)item {
    if([self isEmpty]) return [CNImQueue imQueueWithIn:[CNList apply] out:[CNList applyItem:item]];
    else return [CNImQueue imQueueWithIn:[CNList applyItem:item tail:_in] out:_out];
}

- (CNImQueue*)enqueueItem:(id)item {
    if([self isEmpty]) return [CNImQueue imQueueWithIn:[CNList apply] out:[CNList applyItem:item]];
    else return [CNImQueue imQueueWithIn:[CNList applyItem:item tail:_in] out:_out];
}

- (CNTuple*)dequeue {
    if(!([_out isEmpty])) {
        return tuple([_out headOpt], [CNImQueue imQueueWithIn:_in out:[_out tail]]);
    } else {
        if([_in isEmpty]) {
            return tuple([CNOption none], self);
        } else {
            CNList* rev = [_in reverse];
            return tuple([rev headOpt], [CNImQueue imQueueWithIn:[CNList apply] out:[rev tail]]);
        }
    }
}

- (ODClassType*)type {
    return [CNImQueue type];
}

+ (ODClassType*)type {
    return _CNImQueue_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    CNImQueue* o = ((CNImQueue*)(other));
    return [self.in isEqual:o.in] && [self.out isEqual:o.out];
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.in hash];
    hash = hash * 31 + [self.out hash];
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"in=%@", self.in];
    [description appendFormat:@", out=%@", self.out];
    [description appendString:@">"];
    return description;
}

@end


@implementation CNQueueIterator{
    CNList* _in;
    CNList* _out;
    id<CNIterator> _i;
    BOOL _isIn;
}
static ODClassType* _CNQueueIterator_type;
@synthesize in = _in;
@synthesize out = _out;

+ (id)queueIteratorWithIn:(CNList*)in out:(CNList*)out {
    return [[CNQueueIterator alloc] initWithIn:in out:out];
}

- (id)initWithIn:(CNList*)in out:(CNList*)out {
    self = [super init];
    if(self) {
        _in = in;
        _out = out;
        _i = [_in iterator];
        _isIn = YES;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [CNQueueIterator class]) _CNQueueIterator_type = [ODClassType classTypeWithCls:[CNQueueIterator class]];
}

- (BOOL)hasNext {
    if([_i hasNext]) {
        return YES;
    } else {
        if(_isIn) {
            _isIn = NO;
            _i = [[_out reverse] iterator];
            return [_i hasNext];
        } else {
            return NO;
        }
    }
}

- (id)next {
    if(!([_i hasNext]) && _isIn) {
        _isIn = NO;
        _i = [[_out reverse] iterator];
    }
    return [_i next];
}

- (ODClassType*)type {
    return [CNQueueIterator type];
}

+ (ODClassType*)type {
    return _CNQueueIterator_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    CNQueueIterator* o = ((CNQueueIterator*)(other));
    return [self.in isEqual:o.in] && [self.out isEqual:o.out];
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.in hash];
    hash = hash * 31 + [self.out hash];
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"in=%@", self.in];
    [description appendFormat:@", out=%@", self.out];
    [description appendString:@">"];
    return description;
}

@end


@implementation CNMQueue{
    CNImQueue* __queue;
}
static ODClassType* _CNMQueue_type;

+ (id)queue {
    return [[CNMQueue alloc] init];
}

- (id)init {
    self = [super init];
    if(self) __queue = [CNImQueue apply];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [CNMQueue class]) _CNMQueue_type = [ODClassType classTypeWithCls:[CNMQueue class]];
}

- (void)enqueueItem:(id)item {
    __queue = [__queue addItem:item];
}

- (id)dequeue {
    CNTuple* p = [__queue dequeue];
    __queue = p.b;
    return p.a;
}

- (NSUInteger)count {
    return [__queue count];
}

- (ODClassType*)type {
    return [CNMQueue type];
}

+ (ODClassType*)type {
    return _CNMQueue_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendString:@">"];
    return description;
}

@end


