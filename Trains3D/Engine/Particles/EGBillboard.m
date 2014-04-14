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



NSString* EGBillboardParticleDescription(EGBillboardParticle self) {
    NSMutableString* description = [NSMutableString stringWithString:@"<EGBillboardParticle: "];
    [description appendFormat:@"position=%@", GEVec3Description(self.position)];
    [description appendFormat:@", uv=%@", GEQuadDescription(self.uv)];
    [description appendFormat:@", model=%@", GEQuadDescription(self.model)];
    [description appendFormat:@", color=%@", GEVec4Description(self.color)];
    [description appendString:@">"];
    return description;
}
ODPType* egBillboardParticleType() {
    static ODPType* _ret = nil;
    if(_ret == nil) _ret = [ODPType typeWithCls:[EGBillboardParticleWrap class] name:@"EGBillboardParticle" size:sizeof(EGBillboardParticle) wrap:^id(void* data, NSUInteger i) {
        return wrap(EGBillboardParticle, ((EGBillboardParticle*)(data))[i]);
    }];
    return _ret;
}
@implementation EGBillboardParticleWrap{
    EGBillboardParticle _value;
}
@synthesize value = _value;

+ (id)wrapWithValue:(EGBillboardParticle)value {
    return [[EGBillboardParticleWrap alloc] initWithValue:value];
}

- (id)initWithValue:(EGBillboardParticle)value {
    self = [super init];
    if(self) _value = value;
    return self;
}

- (NSString*)description {
    return EGBillboardParticleDescription(_value);
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGBillboardParticleWrap* o = ((EGBillboardParticleWrap*)(other));
    return EGBillboardParticleEq(_value, o.value);
}

- (NSUInteger)hash {
    return EGBillboardParticleHash(_value);
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end



