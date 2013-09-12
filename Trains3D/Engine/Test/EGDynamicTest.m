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
    EGVec3 v = [body velocity];
    [self assertEqualsA:wrap(EGVec3, v) b:wrap(EGVec3, EGVec3Make(0.0, 0.0, 0.0))];
    [intRange(30) forEach:^void(id _) {
        [world updateWithDelta:1.0 / 30.0];
    }];
    m = [body matrix];
    [self assertTrueValue:float4Between([m array][13], -5.1, -4.99)];
    v = [body velocity];
    [self assertTrueValue:eqf4(v.x, 0)];
    [self assertTrueValue:float4Between(v.y, -10.01, -9.99)];
    [self assertTrueValue:eqf4(v.z, 0)];
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


