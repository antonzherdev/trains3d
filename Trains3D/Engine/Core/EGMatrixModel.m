#import "EGMatrixModel.h"

#import "GEMat4.h"
@implementation EGMatrixStack{
    CNList* _stack;
    EGMMatrixModel* __value;
}
static ODClassType* _EGMatrixStack_type;

+ (id)matrixStack {
    return [[EGMatrixStack alloc] init];
}

- (id)init {
    self = [super init];
    if(self) {
        _stack = [CNList apply];
        __value = [EGMMatrixModel matrixModel];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGMatrixStack class]) _EGMatrixStack_type = [ODClassType classTypeWithCls:[EGMatrixStack class]];
}

- (EGMMatrixModel*)value {
    return __value;
}

- (void)setValue:(EGMatrixModel*)value {
    [__value setMatrixModel:value];
}

- (void)clear {
    [__value clear];
    _stack = [CNList apply];
}

- (void)push {
    _stack = [CNList applyItem:[__value immutable] tail:_stack];
}

- (void)pop {
    [__value setMatrixModel:[_stack head]];
    _stack = [_stack tail];
}

- (void)applyModify:(void(^)(EGMMatrixModel*))modify f:(void(^)())f {
    [self push];
    modify(__value);
    ((void(^)())(f))();
    [self pop];
}

- (void)identityF:(void(^)())f {
    [self push];
    [__value clear];
    ((void(^)())(f))();
    [self pop];
}

- (GEMat4*)m {
    return [__value m];
}

- (GEMat4*)w {
    return [__value w];
}

- (GEMat4*)c {
    return [__value c];
}

- (GEMat4*)p {
    return [__value p];
}

- (GEMat4*)mw {
    return [__value mw];
}

- (GEMat4*)mwc {
    return [__value mwc];
}

- (GEMat4*)mwcp {
    return [__value mwcp];
}

- (GEMat4*)wc {
    return [__value wc];
}

- (GEMat4*)wcp {
    return [__value wcp];
}

- (GEMat4*)cp {
    return [__value cp];
}

- (ODClassType*)type {
    return [EGMatrixStack type];
}

+ (ODClassType*)type {
    return _EGMatrixStack_type;
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


@implementation EGMatrixModel
static EGMatrixModel* _EGMatrixModel_identity;
static ODClassType* _EGMatrixModel_type;

+ (id)matrixModel {
    return [[EGMatrixModel alloc] init];
}

- (id)init {
    self = [super init];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGMatrixModel class]) {
        _EGMatrixModel_type = [ODClassType classTypeWithCls:[EGMatrixModel class]];
        _EGMatrixModel_identity = [EGImMatrixModel imMatrixModelWithM:[GEMat4 identity] w:[GEMat4 identity] c:[GEMat4 identity] p:[GEMat4 identity]];
    }
}

- (GEMat4*)m {
    @throw @"Method m is abstract";
}

- (GEMat4*)w {
    @throw @"Method w is abstract";
}

- (GEMat4*)c {
    @throw @"Method c is abstract";
}

- (GEMat4*)p {
    @throw @"Method p is abstract";
}

- (GEMat4*)mw {
    return [[self w] mulMatrix:[self m]];
}

- (GEMat4*)mwc {
    return [[self c] mulMatrix:[[self w] mulMatrix:[self m]]];
}

- (GEMat4*)mwcp {
    return [[self p] mulMatrix:[[self c] mulMatrix:[[self w] mulMatrix:[self m]]]];
}

- (GEMat4*)cp {
    return [[self p] mulMatrix:[self c]];
}

- (GEMat4*)wcp {
    return [[self p] mulMatrix:[[self c] mulMatrix:[self w]]];
}

- (GEMat4*)wc {
    return [[self c] mulMatrix:[self w]];
}

- (EGMMatrixModel*)mutable {
    @throw @"Method mutable is abstract";
}

- (ODClassType*)type {
    return [EGMatrixModel type];
}

+ (EGMatrixModel*)identity {
    return _EGMatrixModel_identity;
}

+ (ODClassType*)type {
    return _EGMatrixModel_type;
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


@implementation EGImMatrixModel{
    GEMat4* _m;
    GEMat4* _w;
    GEMat4* _c;
    GEMat4* _p;
}
static ODClassType* _EGImMatrixModel_type;
@synthesize m = _m;
@synthesize w = _w;
@synthesize c = _c;
@synthesize p = _p;

+ (id)imMatrixModelWithM:(GEMat4*)m w:(GEMat4*)w c:(GEMat4*)c p:(GEMat4*)p {
    return [[EGImMatrixModel alloc] initWithM:m w:w c:c p:p];
}

- (id)initWithM:(GEMat4*)m w:(GEMat4*)w c:(GEMat4*)c p:(GEMat4*)p {
    self = [super init];
    if(self) {
        _m = m;
        _w = w;
        _c = c;
        _p = p;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGImMatrixModel class]) _EGImMatrixModel_type = [ODClassType classTypeWithCls:[EGImMatrixModel class]];
}

- (EGMMatrixModel*)mutable {
    return [EGMMatrixModel applyM:_m w:_w c:_c p:_p];
}

- (GEMat4*)mw {
    return [_w mulMatrix:_m];
}

- (GEMat4*)mwc {
    return [_c mulMatrix:[_w mulMatrix:_m]];
}

- (GEMat4*)mwcp {
    return [_p mulMatrix:[_c mulMatrix:[_w mulMatrix:_m]]];
}

- (GEMat4*)cp {
    return [_p mulMatrix:_c];
}

- (GEMat4*)wcp {
    return [_p mulMatrix:[_c mulMatrix:_w]];
}

- (GEMat4*)wc {
    return [_c mulMatrix:_w];
}

- (ODClassType*)type {
    return [EGImMatrixModel type];
}

+ (ODClassType*)type {
    return _EGImMatrixModel_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGImMatrixModel* o = ((EGImMatrixModel*)(other));
    return [self.m isEqual:o.m] && [self.w isEqual:o.w] && [self.c isEqual:o.c] && [self.p isEqual:o.p];
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.m hash];
    hash = hash * 31 + [self.w hash];
    hash = hash * 31 + [self.c hash];
    hash = hash * 31 + [self.p hash];
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"m=%@", self.m];
    [description appendFormat:@", w=%@", self.w];
    [description appendFormat:@", c=%@", self.c];
    [description appendFormat:@", p=%@", self.p];
    [description appendString:@">"];
    return description;
}

@end


@implementation EGMMatrixModel{
    GEMat4* __m;
    GEMat4* __w;
    GEMat4* __c;
    GEMat4* __p;
    GEMat4* __mw;
    GEMat4* __mwc;
    GEMat4* __mwcp;
}
static ODClassType* _EGMMatrixModel_type;
@synthesize _m = __m;
@synthesize _w = __w;
@synthesize _c = __c;
@synthesize _p = __p;

+ (id)matrixModel {
    return [[EGMMatrixModel alloc] init];
}

- (id)init {
    self = [super init];
    if(self) {
        __m = [GEMat4 identity];
        __w = [GEMat4 identity];
        __c = [GEMat4 identity];
        __p = [GEMat4 identity];
        __mw = nil;
        __mwc = nil;
        __mwcp = nil;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGMMatrixModel class]) _EGMMatrixModel_type = [ODClassType classTypeWithCls:[EGMMatrixModel class]];
}

- (GEMat4*)m {
    return __m;
}

- (GEMat4*)w {
    return __w;
}

- (GEMat4*)c {
    return __c;
}

- (GEMat4*)p {
    return __p;
}

- (GEMat4*)mw {
    if(__mw == nil) __mw = [__w mulMatrix:__m];
    return __mw;
}

- (GEMat4*)mwc {
    if(__mwc == nil) __mwc = [__c mulMatrix:[self mw]];
    return __mwc;
}

- (GEMat4*)mwcp {
    if(__mwcp == nil) __mwcp = [__p mulMatrix:[self mwc]];
    return __mwcp;
}

- (GEMat4*)cp {
    return [__p mulMatrix:__c];
}

- (GEMat4*)wcp {
    return [__p mulMatrix:[__c mulMatrix:__w]];
}

- (GEMat4*)wc {
    return [__c mulMatrix:__w];
}

- (EGMMatrixModel*)copy {
    return [EGMMatrixModel applyM:[self m] w:[self w] c:[self c] p:[self p]];
}

+ (EGMMatrixModel*)applyMatrixModel:(EGMatrixModel*)matrixModel {
    return [matrixModel mutable];
}

+ (EGMMatrixModel*)applyImMatrixModel:(EGImMatrixModel*)imMatrixModel {
    return [imMatrixModel mutable];
}

+ (EGMMatrixModel*)applyM:(GEMat4*)m w:(GEMat4*)w c:(GEMat4*)c p:(GEMat4*)p {
    EGMMatrixModel* mm = [EGMMatrixModel matrixModel];
    mm._m = m;
    mm._w = w;
    mm._c = c;
    mm._p = p;
    return mm;
}

- (EGMMatrixModel*)mutable {
    return self;
}

- (EGImMatrixModel*)immutable {
    return [EGImMatrixModel imMatrixModelWithM:[self m] w:[self w] c:[self c] p:[self p]];
}

- (EGMMatrixModel*)modifyM:(GEMat4*(^)(GEMat4*))m {
    __m = m(__m);
    __mw = nil;
    __mwc = nil;
    __mwcp = nil;
    return self;
}

- (EGMMatrixModel*)modifyW:(GEMat4*(^)(GEMat4*))w {
    __w = w(__w);
    __mw = nil;
    __mwc = nil;
    __mwcp = nil;
    return self;
}

- (EGMMatrixModel*)modifyC:(GEMat4*(^)(GEMat4*))c {
    __c = c(__c);
    __mwc = nil;
    __mwcp = nil;
    return self;
}

- (EGMMatrixModel*)modifyP:(GEMat4*(^)(GEMat4*))p {
    __p = p(__p);
    __mwcp = nil;
    return self;
}

- (void)clear {
    __m = [GEMat4 identity];
    __w = [GEMat4 identity];
    __c = [GEMat4 identity];
    __p = [GEMat4 identity];
    __mw = nil;
    __mwc = nil;
    __mwcp = nil;
}

- (void)setMatrixModel:(EGMatrixModel*)matrixModel {
    __m = [matrixModel m];
    __w = [matrixModel w];
    __c = [matrixModel c];
    __p = [matrixModel p];
    __mw = nil;
    __mwc = nil;
    __mwcp = nil;
}

- (ODClassType*)type {
    return [EGMMatrixModel type];
}

+ (ODClassType*)type {
    return _EGMMatrixModel_type;
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

