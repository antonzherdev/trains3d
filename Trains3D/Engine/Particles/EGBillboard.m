#import "EGBillboard.h"

NSString* egBillboardBufferDataDescription(EGBillboardBufferData self) {
    return [NSString stringWithFormat:@"BillboardBufferData(%@, %@, %@, %@)", geVec3Description(self.position), geVec2Description(self.model), geVec4Description(self.color), geVec2Description(self.uv)];
}
BOOL egBillboardBufferDataIsEqualTo(EGBillboardBufferData self, EGBillboardBufferData to) {
    return geVec3IsEqualTo(self.position, to.position) && geVec2IsEqualTo(self.model, to.model) && geVec4IsEqualTo(self.color, to.color) && geVec2IsEqualTo(self.uv, to.uv);
}
NSUInteger egBillboardBufferDataHash(EGBillboardBufferData self) {
    NSUInteger hash = 0;
    hash = hash * 31 + geVec3Hash(self.position);
    hash = hash * 31 + geVec2Hash(self.model);
    hash = hash * 31 + geVec4Hash(self.color);
    hash = hash * 31 + geVec2Hash(self.uv);
    return hash;
}
CNPType* egBillboardBufferDataType() {
    static CNPType* _ret = nil;
    if(_ret == nil) _ret = [CNPType typeWithCls:[EGBillboardBufferDataWrap class] name:@"EGBillboardBufferData" size:sizeof(EGBillboardBufferData) wrap:^id(void* data, NSUInteger i) {
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

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end


EGBillboardBufferData* egBillboardParticleWriteToArray(EGBillboardParticle self, EGBillboardBufferData* array) {
    EGBillboardBufferData* pp = array;
    pp->position = self.position;
    pp->model = self.model.p0;
    pp->color = self.color;
    pp->uv = self.uv.p0;
    pp++;
    pp->position = self.position;
    pp->model = self.model.p1;
    pp->color = self.color;
    pp->uv = self.uv.p1;
    pp++;
    pp->position = self.position;
    pp->model = self.model.p2;
    pp->color = self.color;
    pp->uv = self.uv.p2;
    pp++;
    pp->position = self.position;
    pp->model = self.model.p3;
    pp->color = self.color;
    pp->uv = self.uv.p3;
    return pp + 1;
}
NSString* egBillboardParticleDescription(EGBillboardParticle self) {
    return [NSString stringWithFormat:@"BillboardParticle(%@, %@, %@, %@)", geVec3Description(self.position), geQuadDescription(self.uv), geQuadDescription(self.model), geVec4Description(self.color)];
}
BOOL egBillboardParticleIsEqualTo(EGBillboardParticle self, EGBillboardParticle to) {
    return geVec3IsEqualTo(self.position, to.position) && geQuadIsEqualTo(self.uv, to.uv) && geQuadIsEqualTo(self.model, to.model) && geVec4IsEqualTo(self.color, to.color);
}
NSUInteger egBillboardParticleHash(EGBillboardParticle self) {
    NSUInteger hash = 0;
    hash = hash * 31 + geVec3Hash(self.position);
    hash = hash * 31 + geQuadHash(self.uv);
    hash = hash * 31 + geQuadHash(self.model);
    hash = hash * 31 + geVec4Hash(self.color);
    return hash;
}
CNPType* egBillboardParticleType() {
    static CNPType* _ret = nil;
    if(_ret == nil) _ret = [CNPType typeWithCls:[EGBillboardParticleWrap class] name:@"EGBillboardParticle" size:sizeof(EGBillboardParticle) wrap:^id(void* data, NSUInteger i) {
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

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end


@implementation EGBillboardParticleSystem_impl

+ (instancetype)billboardParticleSystem_impl {
    return [[EGBillboardParticleSystem_impl alloc] init];
}

- (instancetype)init {
    self = [super init];
    
    return self;
}

- (NSUInteger)indexCount {
    return 6;
}

- (unsigned int*)createIndexArray {
    unsigned int* indexPointer = cnPointerApplyBytesCount(4, [self indexCount] * [self maxCount]);
    unsigned int* ia = indexPointer;
    NSInteger i = 0;
    unsigned int j = 0;
    while(i < [self maxCount]) {
        *(ia + 0) = j;
        *(ia + 1) = j + 1;
        *(ia + 2) = j + 2;
        *(ia + 3) = j + 2;
        *(ia + 4) = j;
        *(ia + 5) = j + 3;
        ia += 6;
        i++;
        j += 4;
    }
    return indexPointer;
}

- (unsigned int)vertexCount {
    return 4;
}

- (unsigned int)maxCount {
    @throw @"Method maxCount is abstract";
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

