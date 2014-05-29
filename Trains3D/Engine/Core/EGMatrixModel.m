#import "EGMatrixModel.h"

#import "GEMat4.h"
@implementation EGMatrixStack
static CNClassType* _EGMatrixStack_type;

+ (instancetype)matrixStack {
    return [[EGMatrixStack alloc] init];
}

- (instancetype)init {
    self = [super init];
    if(self) {
        _stack = [CNImList apply];
        __value = [EGMMatrixModel matrixModel];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGMatrixStack class]) _EGMatrixStack_type = [CNClassType classTypeWithCls:[EGMatrixStack class]];
}

- (EGMMatrixModel*)value {
    return __value;
}

- (void)setValue:(EGMatrixModel*)value {
    [__value setMatrixModel:value];
}

- (void)clear {
    [__value clear];
    _stack = [CNImList apply];
}

- (void)push {
    _stack = [CNImList applyItem:[__value immutable] tail:_stack];
}

- (void)pop {
    [__value setMatrixModel:((EGImMatrixModel*)(nonnil([_stack head])))];
    _stack = [_stack tail];
}

- (void)applyModify:(void(^)(EGMMatrixModel*))modify f:(void(^)())f {
    [self push];
    modify([self value]);
    f();
    [self pop];
}

- (void)identityF:(void(^)())f {
    [self push];
    [[self value] clear];
    f();
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

- (NSString*)description {
    return @"MatrixStack";
}

- (CNClassType*)type {
    return [EGMatrixStack type];
}

+ (CNClassType*)type {
    return _EGMatrixStack_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation EGMatrixModel
static EGMatrixModel* _EGMatrixModel_identity;
static CNClassType* _EGMatrixModel_type;

+ (instancetype)matrixModel {
    return [[EGMatrixModel alloc] init];
}

- (instancetype)init {
    self = [super init];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGMatrixModel class]) {
        _EGMatrixModel_type = [CNClassType classTypeWithCls:[EGMatrixModel class]];
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

- (NSString*)description {
    return @"MatrixModel";
}

- (CNClassType*)type {
    return [EGMatrixModel type];
}

+ (EGMatrixModel*)identity {
    return _EGMatrixModel_identity;
}

+ (CNClassType*)type {
    return _EGMatrixModel_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation EGImMatrixModel
static CNClassType* _EGImMatrixModel_type;
@synthesize m = _m;
@synthesize w = _w;
@synthesize c = _c;
@synthesize p = _p;

+ (instancetype)imMatrixModelWithM:(GEMat4*)m w:(GEMat4*)w c:(GEMat4*)c p:(GEMat4*)p {
    return [[EGImMatrixModel alloc] initWithM:m w:w c:c p:p];
}

- (instancetype)initWithM:(GEMat4*)m w:(GEMat4*)w c:(GEMat4*)c p:(GEMat4*)p {
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
    if(self == [EGImMatrixModel class]) _EGImMatrixModel_type = [CNClassType classTypeWithCls:[EGImMatrixModel class]];
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

- (NSString*)description {
    return [NSString stringWithFormat:@"ImMatrixModel(%@, %@, %@, %@)", _m, _w, _c, _p];
}

- (CNClassType*)type {
    return [EGImMatrixModel type];
}

+ (CNClassType*)type {
    return _EGImMatrixModel_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation EGMMatrixModel
static CNClassType* _EGMMatrixModel_type;
@synthesize _m = __m;
@synthesize _w = __w;
@synthesize _c = __c;
@synthesize _p = __p;

+ (instancetype)matrixModel {
    return [[EGMMatrixModel alloc] init];
}

- (instancetype)init {
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
    if(self == [EGMMatrixModel class]) _EGMMatrixModel_type = [CNClassType classTypeWithCls:[EGMMatrixModel class]];
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
    return ((GEMat4*)(nonnil(__mw)));
}

- (GEMat4*)mwc {
    if(__mwc == nil) __mwc = [__c mulMatrix:[self mw]];
    return ((GEMat4*)(nonnil(__mwc)));
}

- (GEMat4*)mwcp {
    if(__mwcp == nil) __mwcp = [__p mulMatrix:[self mwc]];
    return ((GEMat4*)(nonnil(__mwcp)));
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

- (NSString*)description {
    return @"MMatrixModel";
}

- (CNClassType*)type {
    return [EGMMatrixModel type];
}

+ (CNClassType*)type {
    return _EGMMatrixModel_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

