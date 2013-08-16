#import "EGScene.h"

#import "EGProcessor.h"
#import "EGLayer.h"
@implementation EGScene{
    id<EGController> _controller;
    id<CNList> _layers;
}
@synthesize controller = _controller;
@synthesize layers = _layers;

+ (id)sceneWithController:(id<EGController>)controller layers:(id<CNList>)layers {
    return [[EGScene alloc] initWithController:controller layers:layers];
}

- (id)initWithController:(id<EGController>)controller layers:(id<CNList>)layers {
    self = [super init];
    if(self) {
        _controller = controller;
        _layers = layers;
    }
    
    return self;
}

- (void)drawWithViewSize:(EGSize)viewSize {
    [_layers forEach:^void(EGLayer* _) {
        [_ drawWithViewSize:viewSize];
    }];
}

- (BOOL)processEvent:(EGEvent*)event {
    return unumb([[[_layers chain] reverse] fold:^id(id r, EGLayer* layer) {
        return numb(unumb(r) || [layer processEvent:event]);
    } withStart:@NO]);
}

- (void)updateWithDelta:(double)delta {
    [_controller updateWithDelta:delta];
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGScene* o = ((EGScene*)other);
    return [self.controller isEqual:o.controller] && [self.layers isEqual:o.layers];
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.controller hash];
    hash = hash * 31 + [self.layers hash];
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"controller=%@", self.controller];
    [description appendFormat:@", layers=%@", self.layers];
    [description appendString:@">"];
    return description;
}

@end


