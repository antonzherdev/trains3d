#import "CNCollection.h"

#import "CNChain.h"
@implementation CNCollection

+ (id)collection {
    return [[CNCollection alloc] init];
}

- (id)init {
    self = [super init];
    
    return self;
}

- (NSUInteger)count {
    @throw @"Method count is abstract";
}

- (id<CNIterator>)iterator {
    @throw @"Method iterator is abstract";
}

- (CNChain*)chain {
    return [CNChain chainWithCollection:self];
}

- (void)forEach:(cnP)p {
    id <CNIterator> i = [self iterator];
    while(true) {
        id n = [i next];
        if([n isEmpty]) break;
        p(n);
    }
}


- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    CNCollection* o = ((CNCollection*)other);
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

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(id __unsafe_unretained [])buffer count:(NSUInteger)len {
    NSUInteger count = 0;
    // This is the initialization condition, so we'll do one-time setup here.
    // Ensure that you never set state->state back to 0, or use another method to detect initialization
    // (such as using one of the values of state->extra).
    if(state->state == 0)
    {
        // We are not tracking mutations, so we'll set state->mutationsPtr to point into one of our extra values,
        // since these values are not otherwise used by the protocol.
        // If your class was mutable, you may choose to use an internal variable that is updated when the class is mutated.
        // state->mutationsPtr MUST NOT be NULL.
        state->mutationsPtr = &state->extra[0];
    }
    // Now we provide items, which we track with state->state, and determine if we have finished iterating.
    NSUInteger idx = 0;
    id <CNIterator> i = [self iterator];
    while(idx < state->state) {
        if([[i next] isEmpty])
            return 0;
        idx++;
    }

    // Set state->itemsPtr to the provided buffer.
    // Alternate implementations may set state->itemsPtr to an internal C array of objects.
    // state->itemsPtr MUST NOT be NULL.
    state->itemsPtr = buffer;
    // Fill in the stack array, either until we've provided all items from the list
    // or until we've provided as many items as the stack based buffer will hold.
    while(count < len)
    {
        // For this sample, we generate the contents on the fly.
        // A real implementation would likely just be copying objects from internal storage.
        id next = [i next];
        if([next isEmpty]) break;
        buffer[count] = next;
        state->state++;
        count++;
    }
    return count;

}


@end


