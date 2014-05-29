#import "EGCollisionBody.h"

#import "GEMat4.h"

#include "btBulletCollisionCommon.h"
#include "btBox2dShape.h"

NSUInteger geVec2Hash(GEVec2 self) {
    NSUInteger hash = 0;
    hash = hash * 31 + float4Hash(self.x);
    hash = hash * 31 + float4Hash(self.y);
    return hash;
}
BOOL geVec2IsEqualTo(GEVec2 self, GEVec2 to) {
    return eqf4(self.x, to.x) && eqf4(self.y, to.y);
}
BOOL geVec3IsEqualTo(GEVec3 self, GEVec3 to) {
    return eqf4(self.x, to.x) && eqf4(self.y, to.y) && eqf4(self.z, to.z);
}
NSUInteger geVec3Hash(GEVec3 self) {
    NSUInteger hash = 0;
    hash = hash * 31 + float4Hash(self.x);
    hash = hash * 31 + float4Hash(self.y);
    hash = hash * 31 + float4Hash(self.z);
    return hash;
}


@implementation EGCollisionBody{
    id _data;
    id<EGCollisionShape> _shape;
    BOOL _isKinematic;
    GEMat4 * __matrix;
    btCollisionObject* _obj;
}
@synthesize shape = _shape;
@synthesize isKinematic = _isKinematic;
@synthesize data = _data;
static CNClassType* _EGCollisionBody_type;

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
        __matrix = [GEMat4 identity];
        _obj = new btCollisionObject;
        _obj->setUserPointer((__bridge void *)self);
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
    _EGCollisionBody_type = [CNClassType classTypeWithCls:[EGCollisionBody class]];
}

- (GEMat4 *)matrix {
    return __matrix;
}

- (void)setMatrix:(GEMat4 *)matrix {
    __matrix = matrix;
    _obj->getWorldTransform().setFromOpenGLMatrix(__matrix.array);
}

- (void)translateX:(float)x y:(float)y z:(float)z {
    [self setMatrix:[__matrix translateX:x y:y z:z]];
}

- (void)rotateAngle:(float)angle x:(float)x y:(float)y z:(float)z {
    [self setMatrix:[__matrix rotateAngle:angle x:x y:y z:z]];
}


- (CNClassType*)type {
    return [EGCollisionBody type];
}

+ (CNClassType*)type {
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
    GEVec3 _size;
    btBoxShape* _box;
}
static CNClassType* _EGCollisionBox_type;
@synthesize size = _size;


+ (id)collisionBoxWithSize:(GEVec3)size {
    return [[EGCollisionBox alloc] initWithSize:size];
}

- (id)initWithSize:(GEVec3)size {
    self = [super init];
    if(self) {
        _size = size;
        _box = new btBoxShape(btVector3(size.x/2, size.y/2, size.z/2));
    }

    return self;
}

+ (EGCollisionBox*)applyX:(float)x y:(float)y z:(float)z {
    return [EGCollisionBox collisionBoxWithSize:GEVec3Make(x, y, z)];
}

- (VoidRef)shape {
    return _box;
}

- (void)dealloc {
    delete _box;
}

+ (void)initialize {
    [super initialize];
    _EGCollisionBox_type = [CNClassType classTypeWithCls:[EGCollisionBox class]];
}

- (CNClassType*)type {
    return [EGCollisionBox type];
}

+ (CNClassType*)type {
    return _EGCollisionBox_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGCollisionBox* o = ((EGCollisionBox*)(other));
    return geVec3IsEqualTo(self.size, o.size);
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + geVec3Hash(self.size);
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"size=<%f, %f, %f>", self.size.x, self.size.y, self.size.z];
    [description appendString:@">"];
    return description;
}

@end

@implementation EGCollisionBox2d{
    GEVec2 _size;
    btBox2dShape* _box;
}
static CNClassType* _EGCollisionBox2d_type;
@synthesize size = _size;


+ (id)collisionBox2dWithSize:(GEVec2)size {
    return [[EGCollisionBox2d alloc] initWithSize:size];
}

- (id)initWithSize:(GEVec2)size {
    self = [super init];
    if(self) {
        _size = size;
        _box = new btBox2dShape(btVector3(size.x/2, size.y/2, 0));
    }

    return self;
}

+ (EGCollisionBox2d*)applyX:(float)x y:(float)y{
    return [EGCollisionBox2d collisionBox2dWithSize:GEVec2Make(x, y)];
}

- (VoidRef)shape {
    return _box;
}

- (void)dealloc {
    delete _box;
}

+ (void)initialize {
    [super initialize];
    _EGCollisionBox2d_type = [CNClassType classTypeWithCls:[EGCollisionBox2d class]];
}

- (CNClassType*)type {
    return [EGCollisionBox type];
}

+ (CNClassType*)type {
    return _EGCollisionBox2d_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGCollisionBox2d* o = ((EGCollisionBox2d*)(other));
    return geVec2IsEqualTo(self.size, o.size);
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + geVec2Hash(self.size);
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"size=<%f, %f>", self.size.x, self.size.y];
    [description appendString:@">"];
    return description;
}

@end


@implementation EGCollisionPlane{
    GEVec3 _normal;
    float _distance;
    btStaticPlaneShape* _plane;
}
static CNClassType* _EGCollisionPlane_type;
@synthesize normal = _normal;
@synthesize distance = _distance;

+ (id)collisionPlaneWithNormal:(GEVec3)normal distance:(float)distance {
    return [[EGCollisionPlane alloc] initWithNormal:normal distance:distance];
}

- (id)initWithNormal:(GEVec3)normal distance:(float)distance {
    self = [super init];
    if(self) {
        _normal = normal;
        _distance = distance;
        _plane = new btStaticPlaneShape(btVector3(normal.x, normal.y, normal.z), distance);
    }

    return self;
}

- (void)dealloc {
    delete _plane;
}

+ (void)initialize {
    [super initialize];
    _EGCollisionPlane_type = [CNClassType classTypeWithCls:[EGCollisionPlane class]];
}

- (VoidRef)shape {
    return _plane;
}

- (CNClassType*)type {
    return [EGCollisionPlane type];
}

+ (CNClassType*)type {
    return _EGCollisionPlane_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGCollisionPlane* o = ((EGCollisionPlane*)(other));
    return geVec3IsEqualTo(self.normal, o.normal) && eqf4(self.distance, o.distance);
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + geVec3Hash(self.normal);
    hash = hash * 31 + float4Hash(self.distance);
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"normal=<%f, %f, %f>", self.normal.x, self.normal.y, self.normal.z];
    [description appendFormat:@", distance=%f", self.distance];
    [description appendString:@">"];
    return description;
}

@end

