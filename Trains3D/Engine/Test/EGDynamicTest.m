#import "EGDynamicTest.h"

#import "EGDynamicWorld.h"
#import "EGCollisionBody.h"
#import "EGMatrix.h"
@implementation EGDynamicTest
static ODClassType* _EGDynamicTest_type;

+ (id)dynamicTest {
    return [[EGDynamicTest alloc] init];
}

- (id)init {
    self = [super init];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGDynamicTest_type = [ODClassType classTypeWithCls:[EGDynamicTest class]];
}

- (void)testSimple {
    EGDynamicWorld* world = [EGDynamicWorld dynamicWorldWithGravity:EGVec3Make(0.0, -10.0, 0.0)];
    EGCollisionBox* shape = [EGCollisionBox collisionBoxWithHalfSize:EGVec3Make(0.5, 0.5, 0.5)];
    EGDynamicBody* body = [EGDynamicBody dynamicBodyWithData:@1 shape:shape isKinematic:YES mass:1.0];
    [world addBody:body];
    EGMatrix* m = [body matrix];
    [self assertTrueValue:eqf4([m array][13], 0)];
    [world updateWithDelta:1.0];
    m = [body matrix];
    [self assertTrueValue:float4Between([m array][13], -0.18056, -0.18055)];
}

- (ODClassType*)type {
    return [EGDynamicTest type];
}

+ (ODClassType*)type {
    return _EGDynamicTest_type;
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


