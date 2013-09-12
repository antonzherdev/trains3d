#import "EGCollisionBody.h"

#import "EGMatrix.h"

#include "btBulletCollisionCommon.h"
#include "btBox2dShape.h"

@implementation EGCollisionBody{
    id _data;
    id<EGCollisionShape> _shape;
    BOOL _isKinematic;
    EGMatrix* __matrix;
    btCollisionObject* _obj;
}
@synthesize shape = _shape;
@synthesize isKinematic = _isKinematic;
@synthesize data = _data;
static ODClassType* _EGCollisionBody_type;

- (void*)obj {
    return _obj;
}

+ (id)collisionBodyWithData:(id)data shape:(id<EGCollisionShape>)shape isKinematic:(BOOL)isKinematic {
    return [[EGCollisionBody alloc] initWithData:data shape:shape isKinematic:isKinematic];
}

- (id)initWithData:(id)data shape:(id<EGCollisionShape>)shape isKinematic:(BOOL)isKinematic {
    self = [super init];
    if(self) {
        _data = data;
        _shape = shape;
        _isKinematic = isKinematic;
        _obj = nil;
        __matrix = [EGMatrix identity];
        _obj = new btCollisionObject;
        _obj->setUserPointer((__bridge void *)self);
        int f = _obj->getCollisionFlags();
        if(isKinematic) {
            _obj->setCollisionFlags( _obj->getCollisionFlags() | btCollisionObject::CF_KINEMATIC_OBJECT);
            _obj->setActivationState(DISABLE_DEACTIVATION);
        }
        _obj->setCollisionShape(static_cast<btCollisionShape*>(_shape.shape));
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGCollisionBody_type = [ODClassType classTypeWithCls:[EGCollisionBody class]];
}

- (EGMatrix*)matrix {
    return __matrix;
}

- (void)setMatrix:(EGMatrix*)matrix {
    __matrix = matrix;
    _obj->getWorldTransform().setFromOpenGLMatrix(__matrix.array);
}

- (void)translateX:(float)x y:(float)y z:(float)z {
    [self setMatrix:[__matrix translateX:x y:y z:z]];
}

- (void)rotateAngle:(float)angle x:(float)x y:(float)y z:(float)z {
    [self setMatrix:[__matrix rotateAngle:angle x:x y:y z:z]];
}


- (ODClassType*)type {
    return [EGCollisionBody type];
}

+ (ODClassType*)type {
    return _EGCollisionBody_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendString:@">"];
    return description;
}

- (void)dealloc {
    delete _obj;
}


@end


@implementation EGCollisionBox{
    EGVec3 _halfSize;
    btBoxShape* _box;
}
static ODClassType* _EGCollisionBox_type;
@synthesize halfSize = _halfSize;


+ (id)collisionBoxWithHalfSize:(EGVec3)halfSize {
    return [[EGCollisionBox alloc] initWithHalfSize:halfSize];
}

- (id)initWithHalfSize:(EGVec3)halfSize {
    self = [super init];
    if(self) {
        _halfSize = halfSize;
        _box = new btBoxShape(btVector3(halfSize.x, halfSize.y, halfSize.z));
    }

    return self;
}

+ (EGCollisionBox*)applyX:(float)x y:(float)y z:(float)z {
    return [EGCollisionBox collisionBoxWithHalfSize:EGVec3Make(x, y, z)];
}

- (VoidRef)shape {
    return _box;
}

- (void)dealloc {
    delete _box;
}

+ (void)initialize {
    [super initialize];
    _EGCollisionBox_type = [ODClassType classTypeWithCls:[EGCollisionBox class]];
}

- (ODClassType*)type {
    return [EGCollisionBox type];
}

+ (ODClassType*)type {
    return _EGCollisionBox_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGCollisionBox* o = ((EGCollisionBox*)(other));
    return EGVec3Eq(self.halfSize, o.halfSize);
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + EGVec3Hash(self.halfSize);
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"halfSize=%@", EGVec3Description(self.halfSize)];
    [description appendString:@">"];
    return description;
}

@end

@implementation EGCollisionBox2d{
    EGVec2 _halfSize;
    btBox2dShape* _box;
}
static ODClassType* _EGCollisionBox2d_type;
@synthesize halfSize = _halfSize;


+ (id)collisionBox2dWithHalfSize:(EGVec2)halfSize {
    return [[EGCollisionBox2d alloc] initWithHalfSize:halfSize];
}

- (id)initWithHalfSize:(EGVec2)halfSize {
    self = [super init];
    if(self) {
        _halfSize = halfSize;
        _box = new btBox2dShape(btVector3(halfSize.x, halfSize.y, 0));
    }

    return self;
}

+ (EGCollisionBox2d*)applyX:(float)x y:(float)y{
    return [EGCollisionBox2d collisionBox2dWithHalfSize:EGVec2Make(x, y)];
}

- (VoidRef)shape {
    return _box;
}

- (void)dealloc {
    delete _box;
}

+ (void)initialize {
    [super initialize];
    _EGCollisionBox2d_type = [ODClassType classTypeWithCls:[EGCollisionBox2d class]];
}

- (ODClassType*)type {
    return [EGCollisionBox type];
}

+ (ODClassType*)type {
    return _EGCollisionBox2d_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGCollisionBox2d* o = ((EGCollisionBox2d*)(other));
    return EGVec2Eq(self.halfSize, o.halfSize);
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + EGVec2Hash(self.halfSize);
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"halfSize=%@", EGVec2Description(self.halfSize)];
    [description appendString:@">"];
    return description;
}

@end

