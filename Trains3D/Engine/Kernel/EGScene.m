#import "EGScene.h"

#import "EGProcessor.h"
#import "EGLayer.h"
@implementation EGScene{
    id<EGController> _controller;
    id<CNSeq> _layers;
}
static ODClassType* _EGScene_type;
@synthesize controller = _controller;
@synthesize layers = _layers;

+ (id)sceneWithController:(id<EGController>)controller layers:(id<CNSeq>)layers {
    return [[EGScene alloc] initWithController:controller layers:layers];
}

- (id)initWithController:(id<EGController>)controller layers:(id<CNSeq>)layers {
    self = [super init];
    if(self) {
        _controller = controller;
        _layers = layers;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGScene_type = [ODClassType classTypeWithCls:[EGScene class]];
}

- (void)drawWithViewSize:(EGVec2)viewSize {
    [_layers forEach:^void(EGLayer* _) {
        [_ drawWithViewSize:viewSize];
    }];
}

- (BOOL)processEvent:(EGEvent*)event {
    return unumb([[[_layers chain] reverse] fold:^id(id r, EGLayer* layer) {
        return numb(unumb(r) || [layer processEvent:event]);
    } withStart:@NO]);
}

- (void)updateWithDelta:(CGFloat)delta {
    [_controller updateWithDelta:delta];
    [_layers forEach:^void(EGLayer* _) {
        [_ updateWithDelta:delta];
    }];
}

- (ODClassType*)type {
    return [EGScene type];
}

+ (ODClassType*)type {
    return _EGScene_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGScene* o = ((EGScene*)(other));
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


