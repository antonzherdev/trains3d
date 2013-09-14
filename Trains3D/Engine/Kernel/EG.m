#import "EG.h"

#import "EGDirector.h"
#import "EGTexture.h"
#import "EGTypes.h"
#import "GEMatrix.h"
@implementation EG
static EGContext* _EG_context;
static EGMatrixStack* _EG_matrix;
static ODClassType* _EG_type;

+ (id)g {
    return [[EG alloc] init];
}

- (id)init {
    self = [super init];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EG_type = [ODClassType classTypeWithCls:[EG class]];
    _EG_context = [EGContext context];
    _EG_matrix = _EG_context.matrixStack;
}

+ (EGDirector*)director {
    return _EG_context.director;
}

+ (EGFileTexture*)textureForFile:(NSString*)file {
    return [_EG_context textureForFile:file];
}

- (ODClassType*)type {
    return [EG type];
}

+ (EGContext*)context {
    return _EG_context;
}

+ (EGMatrixStack*)matrix {
    return _EG_matrix;
}

+ (ODClassType*)type {
    return _EG_type;
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


@implementation EGContext{
    NSMutableDictionary* _textureCache;
    EGDirector* _director;
    EGEnvironment* _environment;
    EGMatrixStack* _matrixStack;
}
static ODClassType* _EGContext_type;
@synthesize director = _director;
@synthesize environment = _environment;
@synthesize matrixStack = _matrixStack;

+ (id)context {
    return [[EGContext alloc] init];
}

- (id)init {
    self = [super init];
    if(self) {
        _textureCache = [NSMutableDictionary mutableDictionary];
        _environment = EGEnvironment.aDefault;
        _matrixStack = [EGMatrixStack matrixStack];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGContext_type = [ODClassType classTypeWithCls:[EGContext class]];
}

- (EGFileTexture*)textureForFile:(NSString*)file {
    return ((EGFileTexture*)([_textureCache objectForKey:file orUpdateWith:^EGFileTexture*() {
        return [EGFileTexture fileTextureWithFile:file];
    }]));
}

- (ODClassType*)type {
    return [EGContext type];
}

+ (ODClassType*)type {
    return _EGContext_type;
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


@implementation EGMatrixStack{
    CNList* _stack;
    EGMatrixModel* _value;
}
static ODClassType* _EGMatrixStack_type;
@synthesize value = _value;

+ (id)matrixStack {
    return [[EGMatrixStack alloc] init];
}

- (id)init {
    self = [super init];
    if(self) {
        _stack = [CNList apply];
        _value = EGMatrixModel.identity;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGMatrixStack_type = [ODClassType classTypeWithCls:[EGMatrixStack class]];
}

- (void)clear {
    _value = EGMatrixModel.identity;
    _stack = [CNList apply];
}

- (void)push {
    _stack = [CNList applyItem:_value tail:_stack];
}

- (void)pop {
    _value = ((EGMatrixModel*)([[_stack head] get]));
    _stack = [_stack tail];
}

- (void)applyModify:(EGMatrixModel*(^)(EGMatrixModel*))modify f:(void(^)())f {
    [self push];
    _value = modify(_value);
    ((void(^)())(f))();
    [self pop];
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

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendString:@">"];
    return description;
}

@end


@implementation EGMatrixModel{
    GEMatrix* _m;
    GEMatrix* _w;
    GEMatrix* _c;
    GEMatrix* _p;
    CNLazy* __mw;
    CNLazy* __mwc;
    CNLazy* __mwcp;
    CNLazy* __cp;
    CNLazy* __wcp;
    CNLazy* __wc;
}
static EGMatrixModel* _EGMatrixModel_identity;
static ODClassType* _EGMatrixModel_type;
@synthesize m = _m;
@synthesize w = _w;
@synthesize c = _c;
@synthesize p = _p;
@synthesize _mw = __mw;
@synthesize _mwc = __mwc;
@synthesize _mwcp = __mwcp;
@synthesize _cp = __cp;
@synthesize _wcp = __wcp;
@synthesize _wc = __wc;

+ (id)matrixModelWithM:(GEMatrix*)m w:(GEMatrix*)w c:(GEMatrix*)c p:(GEMatrix*)p _mw:(CNLazy*)_mw _mwc:(CNLazy*)_mwc _mwcp:(CNLazy*)_mwcp _cp:(CNLazy*)_cp _wcp:(CNLazy*)_wcp _wc:(CNLazy*)_wc {
    return [[EGMatrixModel alloc] initWithM:m w:w c:c p:p _mw:_mw _mwc:_mwc _mwcp:_mwcp _cp:_cp _wcp:_wcp _wc:_wc];
}

- (id)initWithM:(GEMatrix*)m w:(GEMatrix*)w c:(GEMatrix*)c p:(GEMatrix*)p _mw:(CNLazy*)_mw _mwc:(CNLazy*)_mwc _mwcp:(CNLazy*)_mwcp _cp:(CNLazy*)_cp _wcp:(CNLazy*)_wcp _wc:(CNLazy*)_wc {
    self = [super init];
    if(self) {
        _m = m;
        _w = w;
        _c = c;
        _p = p;
        __mw = _mw;
        __mwc = _mwc;
        __mwcp = _mwcp;
        __cp = _cp;
        __wcp = _wcp;
        __wc = _wc;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGMatrixModel_type = [ODClassType classTypeWithCls:[EGMatrixModel class]];
    _EGMatrixModel_identity = [EGMatrixModel applyM:[GEMatrix identity] w:[GEMatrix identity] c:[GEMatrix identity] p:[GEMatrix identity]];
}

+ (EGMatrixModel*)applyM:(GEMatrix*)m w:(GEMatrix*)w c:(GEMatrix*)c p:(GEMatrix*)p {
    CNLazy* _mw = [CNLazy lazyWithF:^GEMatrix*() {
        return [w mulMatrix:m];
    }];
    CNLazy* _mwc = [CNLazy lazyWithF:^GEMatrix*() {
        return [c mulMatrix:((GEMatrix*)([_mw get]))];
    }];
    CNLazy* _cp = [CNLazy lazyWithF:^GEMatrix*() {
        return [p mulMatrix:c];
    }];
    CNLazy* _mwcp = [CNLazy lazyWithF:^GEMatrix*() {
        return [((GEMatrix*)([_cp get])) mulMatrix:((GEMatrix*)([_mw get]))];
    }];
    CNLazy* _wc = [CNLazy lazyWithF:^GEMatrix*() {
        return [c mulMatrix:w];
    }];
    CNLazy* _wcp = [CNLazy lazyWithF:^GEMatrix*() {
        return [p mulMatrix:((GEMatrix*)([_wc get]))];
    }];
    return [EGMatrixModel matrixModelWithM:m w:w c:c p:p _mw:_mw _mwc:_mwc _mwcp:_mwcp _cp:_cp _wcp:_wcp _wc:_wc];
}

- (GEMatrix*)mw {
    return ((GEMatrix*)([__mw get]));
}

- (GEMatrix*)mwc {
    return ((GEMatrix*)([__mwc get]));
}

- (GEMatrix*)mwcp {
    return ((GEMatrix*)([__mwcp get]));
}

- (GEMatrix*)cp {
    return ((GEMatrix*)([__cp get]));
}

- (GEMatrix*)wcp {
    return ((GEMatrix*)([__wcp get]));
}

- (GEMatrix*)wc {
    return ((GEMatrix*)([__wc get]));
}

- (EGMatrixModel*)modifyM:(GEMatrix*(^)(GEMatrix*))m {
    GEMatrix* mm = m(_m);
    CNLazy* _mw = [CNLazy lazyWithF:^GEMatrix*() {
        return [_w mulMatrix:mm];
    }];
    CNLazy* _mwc = [CNLazy lazyWithF:^GEMatrix*() {
        return [_c mulMatrix:((GEMatrix*)([_mw get]))];
    }];
    CNLazy* _mwcp = [CNLazy lazyWithF:^GEMatrix*() {
        return [((GEMatrix*)([__cp get])) mulMatrix:((GEMatrix*)([_mw get]))];
    }];
    return [EGMatrixModel matrixModelWithM:mm w:_w c:_c p:_p _mw:_mw _mwc:_mwc _mwcp:_mwcp _cp:__cp _wcp:__wcp _wc:__wc];
}

- (EGMatrixModel*)modifyW:(GEMatrix*(^)(GEMatrix*))w {
    GEMatrix* ww = w(_w);
    CNLazy* _mw = [CNLazy lazyWithF:^GEMatrix*() {
        return [ww mulMatrix:_m];
    }];
    CNLazy* _mwc = [CNLazy lazyWithF:^GEMatrix*() {
        return [_c mulMatrix:((GEMatrix*)([_mw get]))];
    }];
    CNLazy* _mwcp = [CNLazy lazyWithF:^GEMatrix*() {
        return [((GEMatrix*)([__cp get])) mulMatrix:((GEMatrix*)([_mw get]))];
    }];
    CNLazy* _wc = [CNLazy lazyWithF:^GEMatrix*() {
        return [_c mulMatrix:ww];
    }];
    CNLazy* _wcp = [CNLazy lazyWithF:^GEMatrix*() {
        return [_p mulMatrix:((GEMatrix*)([_wc get]))];
    }];
    return [EGMatrixModel matrixModelWithM:_m w:ww c:_c p:_p _mw:_mw _mwc:_mwc _mwcp:_mwcp _cp:__cp _wcp:_wcp _wc:_wc];
}

- (EGMatrixModel*)modifyC:(GEMatrix*(^)(GEMatrix*))c {
    GEMatrix* cc = c(_c);
    CNLazy* _mwc = [CNLazy lazyWithF:^GEMatrix*() {
        return [cc mulMatrix:((GEMatrix*)([__mw get]))];
    }];
    CNLazy* _cp = [CNLazy lazyWithF:^GEMatrix*() {
        return [_p mulMatrix:cc];
    }];
    CNLazy* _mwcp = [CNLazy lazyWithF:^GEMatrix*() {
        return [((GEMatrix*)([_cp get])) mulMatrix:((GEMatrix*)([__mw get]))];
    }];
    CNLazy* _wc = [CNLazy lazyWithF:^GEMatrix*() {
        return [cc mulMatrix:_w];
    }];
    CNLazy* _wcp = [CNLazy lazyWithF:^GEMatrix*() {
        return [_p mulMatrix:((GEMatrix*)([_wc get]))];
    }];
    return [EGMatrixModel matrixModelWithM:_m w:_w c:cc p:_p _mw:__mw _mwc:_mwc _mwcp:_mwcp _cp:_cp _wcp:_wcp _wc:_wc];
}

- (EGMatrixModel*)modifyP:(GEMatrix*(^)(GEMatrix*))p {
    GEMatrix* pp = p(_p);
    CNLazy* _cp = [CNLazy lazyWithF:^GEMatrix*() {
        return [pp mulMatrix:_c];
    }];
    CNLazy* _mwcp = [CNLazy lazyWithF:^GEMatrix*() {
        return [((GEMatrix*)([_cp get])) mulMatrix:((GEMatrix*)([__mw get]))];
    }];
    CNLazy* _wcp = [CNLazy lazyWithF:^GEMatrix*() {
        return [pp mulMatrix:((GEMatrix*)([__wc get]))];
    }];
    return [EGMatrixModel matrixModelWithM:_m w:_w c:_c p:pp _mw:__mw _mwc:__mwc _mwcp:_mwcp _cp:_cp _wcp:_wcp _wc:__wc];
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
    EGMatrixModel* o = ((EGMatrixModel*)(other));
    return [self.m isEqual:o.m] && [self.w isEqual:o.w] && [self.c isEqual:o.c] && [self.p isEqual:o.p] && [self._mw isEqual:o._mw] && [self._mwc isEqual:o._mwc] && [self._mwcp isEqual:o._mwcp] && [self._cp isEqual:o._cp] && [self._wcp isEqual:o._wcp] && [self._wc isEqual:o._wc];
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.m hash];
    hash = hash * 31 + [self.w hash];
    hash = hash * 31 + [self.c hash];
    hash = hash * 31 + [self.p hash];
    hash = hash * 31 + [self._mw hash];
    hash = hash * 31 + [self._mwc hash];
    hash = hash * 31 + [self._mwcp hash];
    hash = hash * 31 + [self._cp hash];
    hash = hash * 31 + [self._wcp hash];
    hash = hash * 31 + [self._wc hash];
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"m=%@", self.m];
    [description appendFormat:@", w=%@", self.w];
    [description appendFormat:@", c=%@", self.c];
    [description appendFormat:@", p=%@", self.p];
    [description appendFormat:@", _mw=%@", self._mw];
    [description appendFormat:@", _mwc=%@", self._mwc];
    [description appendFormat:@", _mwcp=%@", self._mwcp];
    [description appendFormat:@", _cp=%@", self._cp];
    [description appendFormat:@", _wcp=%@", self._wcp];
    [description appendFormat:@", _wc=%@", self._wc];
    [description appendString:@">"];
    return description;
}

@end


