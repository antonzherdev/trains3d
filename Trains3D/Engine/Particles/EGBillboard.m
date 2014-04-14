#import "EGBillboard.h"

NSString* EGBillboardBufferDataDescription(EGBillboardBufferData self) {
    NSMutableString* description = [NSMutableString stringWithString:@"<EGBillboardBufferData: "];
    [description appendFormat:@"position=%@", GEVec3Description(self.position)];
    [description appendFormat:@", model=%@", GEVec2Description(self.model)];
    [description appendFormat:@", color=%@", GEVec4Description(self.color)];
    [description appendFormat:@", uv=%@", GEVec2Description(self.uv)];
    [description appendString:@">"];
    return description;
}
ODPType* egBillboardBufferDataType() {
    static ODPType* _ret = nil;
    if(_ret == nil) _ret = [ODPType typeWithCls:[EGBillboardBufferDataWrap class] name:@"EGBillboardBufferData" size:sizeof(EGBillboardBufferData) wrap:^id(void* data, NSUInteger i) {
        return wrap(EGBillboardBufferData, ((EGBillboardBufferData*)(data))[i]);
    }];
    return _ret;
}
@implementation EGBillboardBufferDataWrap{
    EGBillboardBufferData _value;
}
@synthesize value = _value;

+ (id)wrapWithValue:(EGBillboardBufferData)value {
    return [[EGBillboardBufferDataWrap alloc] initWithValue:value];
}

- (id)initWithValue:(EGBillboardBufferData)value {
    self = [super init];
    if(self) _value = value;
    return self;
}

- (NSString*)description {
    return EGBillboardBufferDataDescription(_value);
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGBillboardBufferDataWrap* o = ((EGBillboardBufferDataWrap*)(other));
    return EGBillboardBufferDataEq(_value, o.value);
}

- (NSUInteger)hash {
    return EGBillboardBufferDataHash(_value);
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end



@implementation EGBillboardParticleSystem
static ODClassType* _EGBillboardParticleSystem_type;

+ (instancetype)billboardParticleSystem {
    return [[EGBillboardParticleSystem alloc] init];
}

- (instancetype)init {
    self = [super init];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGBillboardParticleSystem class]) _EGBillboardParticleSystem_type = [ODClassType classTypeWithCls:[EGBillboardParticleSystem class]];
}

- (ODClassType*)type {
    return [EGBillboardParticleSystem type];
}

+ (ODClassType*)type {
    return _EGBillboardParticleSystem_type;
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


@implementation EGEmissiveBillboardParticleSystem
static ODClassType* _EGEmissiveBillboardParticleSystem_type;

+ (instancetype)emissiveBillboardParticleSystem {
    return [[EGEmissiveBillboardParticleSystem alloc] init];
}

- (instancetype)init {
    self = [super init];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGEmissiveBillboardParticleSystem class]) _EGEmissiveBillboardParticleSystem_type = [ODClassType classTypeWithCls:[EGEmissiveBillboardParticleSystem class]];
}

- (ODClassType*)type {
    return [EGEmissiveBillboardParticleSystem type];
}

+ (ODClassType*)type {
    return _EGEmissiveBillboardParticleSystem_type;
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


NSString* EGBillboardParticle2Description(EGBillboardParticle2 self) {
    NSMutableString* description = [NSMutableString stringWithString:@"<EGBillboardParticle2: "];
    [description appendFormat:@"position=%@", GEVec3Description(self.position)];
    [description appendFormat:@", uv=%@", GEQuadDescription(self.uv)];
    [description appendFormat:@", model=%@", GEQuadDescription(self.model)];
    [description appendFormat:@", color=%@", GEVec4Description(self.color)];
    [description appendString:@">"];
    return description;
}
ODPType* egBillboardParticle2Type() {
    static ODPType* _ret = nil;
    if(_ret == nil) _ret = [ODPType typeWithCls:[EGBillboardParticle2Wrap class] name:@"EGBillboardParticle2" size:sizeof(EGBillboardParticle2) wrap:^id(void* data, NSUInteger i) {
        return wrap(EGBillboardParticle2, ((EGBillboardParticle2*)(data))[i]);
    }];
    return _ret;
}
@implementation EGBillboardParticle2Wrap{
    EGBillboardParticle2 _value;
}
@synthesize value = _value;

+ (id)wrapWithValue:(EGBillboardParticle2)value {
    return [[EGBillboardParticle2Wrap alloc] initWithValue:value];
}

- (id)initWithValue:(EGBillboardParticle2)value {
    self = [super init];
    if(self) _value = value;
    return self;
}

- (NSString*)description {
    return EGBillboardParticle2Description(_value);
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGBillboardParticle2Wrap* o = ((EGBillboardParticle2Wrap*)(other));
    return EGBillboardParticle2Eq(_value, o.value);
}

- (NSUInteger)hash {
    return EGBillboardParticle2Hash(_value);
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end



