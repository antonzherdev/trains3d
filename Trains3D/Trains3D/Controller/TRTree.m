#import "TRTree.h"

#import "PGPlatformPlat.h"
#import "PGPlatform.h"
#import "PGMapIso.h"
#import "TRWeather.h"
#import "CNObserver.h"
#import "CNFuture.h"
#import "CNChain.h"
#import "TRRailroad.h"
#import "PGDynamicWorld.h"
#import "PGCollisionBody.h"
#import "PGMat4.h"
TRTreeType* TRTreeType_Values[6];
TRTreeType* TRTreeType_Pine_Desc;
TRTreeType* TRTreeType_SnowPine_Desc;
TRTreeType* TRTreeType_Leaf_Desc;
TRTreeType* TRTreeType_WeakLeaf_Desc;
TRTreeType* TRTreeType_Palm_Desc;
@implementation TRTreeType{
    PGRect _uv;
    CGFloat _scale;
    CGFloat _rustleStrength;
    BOOL _collisions;
    PGQuad _uvQuad;
    PGVec2 _size;
}
@synthesize uv = _uv;
@synthesize scale = _scale;
@synthesize rustleStrength = _rustleStrength;
@synthesize collisions = _collisions;
@synthesize uvQuad = _uvQuad;
@synthesize size = _size;

+ (instancetype)treeTypeWithOrdinal:(NSUInteger)ordinal name:(NSString*)name uv:(PGRect)uv scale:(CGFloat)scale rustleStrength:(CGFloat)rustleStrength collisions:(BOOL)collisions {
    return [[TRTreeType alloc] initWithOrdinal:ordinal name:name uv:uv scale:scale rustleStrength:rustleStrength collisions:collisions];
}

- (instancetype)initWithOrdinal:(NSUInteger)ordinal name:(NSString*)name uv:(PGRect)uv scale:(CGFloat)scale rustleStrength:(CGFloat)rustleStrength collisions:(BOOL)collisions {
    self = [super initWithOrdinal:ordinal name:name];
    if(self) {
        _uv = uv;
        _scale = scale;
        _rustleStrength = rustleStrength;
        _collisions = collisions;
        _uvQuad = pgRectUpsideDownStripQuad(uv);
        _size = pgVec2MulF((PGVec2Make(pgRectWidth(uv), 0.5)), scale);
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    TRTreeType_Pine_Desc = [TRTreeType treeTypeWithOrdinal:0 name:@"Pine" uv:pgRectApplyXYWidthHeight(0.0, 0.0, ((float)(184.0 / 512)), (([egPlatform()->_os isIOS]) ? 0.5 : ((float)(1.0)))) scale:1.0 rustleStrength:1.0 collisions:YES];
    TRTreeType_SnowPine_Desc = [TRTreeType treeTypeWithOrdinal:1 name:@"SnowPine" uv:pgRectApplyXYWidthHeight(0.0, 0.0, ((float)(184.0 / 512)), (([egPlatform()->_os isIOS]) ? 0.5 : ((float)(1.0)))) scale:1.0 rustleStrength:1.0 collisions:YES];
    TRTreeType_Leaf_Desc = [TRTreeType treeTypeWithOrdinal:2 name:@"Leaf" uv:pgRectApplyXYWidthHeight(0.0, 0.0, ((float)(197.0 / 512)), 0.5) scale:1.6 rustleStrength:0.8 collisions:YES];
    TRTreeType_WeakLeaf_Desc = [TRTreeType treeTypeWithOrdinal:3 name:@"WeakLeaf" uv:pgRectApplyXYWidthHeight(0.0, 0.5, ((float)(115.0 / 512)), 0.5) scale:0.6 rustleStrength:1.5 collisions:NO];
    TRTreeType_Palm_Desc = [TRTreeType treeTypeWithOrdinal:4 name:@"Palm" uv:pgRectApplyXYWidthHeight(0.0, 0.0, ((float)(2115.0 / 5500)), (([egPlatform()->_os isIOS]) ? 0.5 : ((float)(1.0)))) scale:1.5 rustleStrength:1.0 collisions:YES];
    TRTreeType_Values[0] = nil;
    TRTreeType_Values[1] = TRTreeType_Pine_Desc;
    TRTreeType_Values[2] = TRTreeType_SnowPine_Desc;
    TRTreeType_Values[3] = TRTreeType_Leaf_Desc;
    TRTreeType_Values[4] = TRTreeType_WeakLeaf_Desc;
    TRTreeType_Values[5] = TRTreeType_Palm_Desc;
}

+ (NSArray*)values {
    return (@[TRTreeType_Pine_Desc, TRTreeType_SnowPine_Desc, TRTreeType_Leaf_Desc, TRTreeType_WeakLeaf_Desc, TRTreeType_Palm_Desc]);
}

+ (TRTreeType*)value:(TRTreeTypeR)r {
    return TRTreeType_Values[r];
}

@end

TRForestType* TRForestType_Values[5];
TRForestType* TRForestType_Pine_Desc;
TRForestType* TRForestType_Leaf_Desc;
TRForestType* TRForestType_SnowPine_Desc;
TRForestType* TRForestType_Palm_Desc;
@implementation TRForestType{
    NSArray* _treeTypes;
}
@synthesize treeTypes = _treeTypes;

+ (instancetype)forestTypeWithOrdinal:(NSUInteger)ordinal name:(NSString*)name treeTypes:(NSArray*)treeTypes {
    return [[TRForestType alloc] initWithOrdinal:ordinal name:name treeTypes:treeTypes];
}

- (instancetype)initWithOrdinal:(NSUInteger)ordinal name:(NSString*)name treeTypes:(NSArray*)treeTypes {
    self = [super initWithOrdinal:ordinal name:name];
    if(self) _treeTypes = treeTypes;
    
    return self;
}

+ (void)initialize {
    [super initialize];
    TRForestType_Pine_Desc = [TRForestType forestTypeWithOrdinal:0 name:@"Pine" treeTypes:(@[[TRTreeType value:TRTreeType_Pine]])];
    TRForestType_Leaf_Desc = [TRForestType forestTypeWithOrdinal:1 name:@"Leaf" treeTypes:(@[[TRTreeType value:TRTreeType_Leaf], [TRTreeType value:TRTreeType_WeakLeaf]])];
    TRForestType_SnowPine_Desc = [TRForestType forestTypeWithOrdinal:2 name:@"SnowPine" treeTypes:(@[[TRTreeType value:TRTreeType_SnowPine]])];
    TRForestType_Palm_Desc = [TRForestType forestTypeWithOrdinal:3 name:@"Palm" treeTypes:(@[[TRTreeType value:TRTreeType_Palm]])];
    TRForestType_Values[0] = nil;
    TRForestType_Values[1] = TRForestType_Pine_Desc;
    TRForestType_Values[2] = TRForestType_Leaf_Desc;
    TRForestType_Values[3] = TRForestType_SnowPine_Desc;
    TRForestType_Values[4] = TRForestType_Palm_Desc;
}

+ (NSArray*)values {
    return (@[TRForestType_Pine_Desc, TRForestType_Leaf_Desc, TRForestType_SnowPine_Desc, TRForestType_Palm_Desc]);
}

+ (TRForestType*)value:(TRForestTypeR)r {
    return TRForestType_Values[r];
}

@end

@implementation TRForestRules
static CNClassType* _TRForestRules_type;
@synthesize forestType = _forestType;
@synthesize thickness = _thickness;

+ (instancetype)forestRulesWithForestType:(TRForestTypeR)forestType thickness:(CGFloat)thickness {
    return [[TRForestRules alloc] initWithForestType:forestType thickness:thickness];
}

- (instancetype)initWithForestType:(TRForestTypeR)forestType thickness:(CGFloat)thickness {
    self = [super init];
    if(self) {
        _forestType = forestType;
        _thickness = thickness;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [TRForestRules class]) _TRForestRules_type = [CNClassType classTypeWithCls:[TRForestRules class]];
}

- (NSString*)description {
    return [NSString stringWithFormat:@"ForestRules(%@, %f)", [TRForestType value:_forestType], _thickness];
}

- (BOOL)isEqual:(id)to {
    if(self == to) return YES;
    if(to == nil || !([to isKindOfClass:[TRForestRules class]])) return NO;
    TRForestRules* o = ((TRForestRules*)(to));
    return _forestType == o->_forestType && eqf(_thickness, o->_thickness);
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [[TRForestType value:_forestType] hash];
    hash = hash * 31 + floatHash(_thickness);
    return hash;
}

- (CNClassType*)type {
    return [TRForestRules type];
}

+ (CNClassType*)type {
    return _TRForestRules_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation TRForest
static CNClassType* _TRForest_type;
@synthesize map = _map;
@synthesize rules = _rules;
@synthesize weather = _weather;
@synthesize stateWasRestored = _stateWasRestored;
@synthesize treeWasCutDown = _treeWasCutDown;

+ (instancetype)forestWithMap:(PGMapSso*)map rules:(TRForestRules*)rules weather:(TRWeather*)weather {
    return [[TRForest alloc] initWithMap:map rules:rules weather:weather];
}

- (instancetype)initWithMap:(PGMapSso*)map rules:(TRForestRules*)rules weather:(TRWeather*)weather {
    self = [super init];
    if(self) {
        _map = map;
        _rules = rules;
        _weather = weather;
        _stateWasRestored = [CNSignal signal];
        _treeWasCutDown = [CNSignal signal];
        if([self class] == [TRForest class]) [self _init];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [TRForest class]) _TRForest_type = [CNClassType classTypeWithCls:[TRForest class]];
}

- (CNFuture*)restoreTrees:(NSArray*)trees {
    return [self promptF:^id() {
        __trees = trees;
        __treesCount = [__trees count];
        [_stateWasRestored postData:trees];
        return nil;
    }];
}

- (void)_init {
    NSArray* tps = [TRForestType value:_rules->_forestType].treeTypes;
    TRTreeTypeR tp = ((TRTreeTypeR)([nonnil([[TRForestType value:_rules->_forestType].treeTypes head]) ordinal] + 1));
    NSUInteger typesCount = [tps count];
    __trees = [[[[intRange(((NSInteger)(_rules->_thickness * [_map->_allTiles count] * 1.1))) chain] mapF:^TRTree*(id _) {
        PGVec2i tile = uwrap(PGVec2i, nonnil([[_map->_allTiles chain] randomItem]));
        PGVec2 pos = PGVec2Make((((float)(cnFloatRndMinMax(-0.5, 0.5)))), (((float)(cnFloatRndMinMax(-0.5, 0.5)))));
        return [TRTree treeWithTreeType:((typesCount == 1) ? tp : ((TRTreeTypeR)([nonnil([tps applyIndex:cnuIntRndMax(typesCount - 1)]) ordinal] + 1))) position:pgVec2AddVec2(pos, pgVec2ApplyVec2i(tile)) size:PGVec2Make((((float)(cnFloatRndMinMax(0.9, 1.1)))), (((float)(cnFloatRndMinMax(0.9, 1.1)))))];
    }] sort] toArray];
    __treesCount = [__trees count];
}

- (CNFuture*)trees {
    return [self promptF:^NSArray*() {
        return __trees;
    }];
}

- (NSUInteger)treesCount {
    return __treesCount;
}

- (CNFuture*)cutDownTile:(PGVec2i)tile {
    return [self futureF:^id() {
        [self _cutDownRect:pgRectSubVec2((PGRectMake(pgVec2ApplyVec2i(tile), (PGVec2Make(1.4, 1.4)))), (PGVec2Make(0.7, 0.7)))];
        return nil;
    }];
}

- (CNFuture*)cutDownForRail:(TRRail*)rail {
    return [self futureF:^id() {
        PGVec2 s = pgVec2iDivF([[TRRailConnector value:[TRRailForm value:rail->_form].start] vec], 2.0);
        PGVec2 e = pgVec2iDivF([[TRRailConnector value:[TRRailForm value:rail->_form].end] vec], 2.0);
        PGVec2 ds = ((eqf4(s.x, 0)) ? PGVec2Make(0.3, 0.0) : PGVec2Make(0.0, 0.3));
        PGVec2 de = ((eqf4(e.x, 0)) ? PGVec2Make(0.3, 0.0) : PGVec2Make(0.0, 0.3));
        [self _cutDownRect:pgRectAddVec2((pgQuadBoundingRect((PGQuadMake((pgVec2SubVec2(s, ds)), (pgVec2AddVec2(s, ds)), (pgVec2SubVec2(e, de)), (pgVec2AddVec2(e, de)))))), pgVec2ApplyVec2i(rail->_tile))];
        return nil;
    }];
}

- (CNFuture*)cutDownForASwitch:(TRSwitch*)aSwitch {
    return [self futureF:^id() {
        [self _cutDownPos:pgVec2AddVec2((pgVec2iMulF([[TRRailConnector value:aSwitch->_connector] vec], 0.4)), pgVec2ApplyVec2i(aSwitch->_tile)) xLength:0.55 yLength:2.7];
        return nil;
    }];
}

- (CNFuture*)cutDownForLight:(TRRailLight*)light {
    return [self futureF:^id() {
        [self _cutDownPos:pgVec2AddVec2((pgVec2iMulF([[TRRailConnector value:light->_connector] vec], 0.45)), pgVec2ApplyVec2i(light->_tile)) xLength:0.3 yLength:2.5];
        return nil;
    }];
}

- (void)_cutDownPos:(PGVec2)pos xLength:(CGFloat)xLength yLength:(CGFloat)yLength {
    float xx = pos.x + pos.y;
    float yy = pos.y - pos.x;
    __trees = [[[__trees chain] filterWhen:^BOOL(TRTree* tree) {
        float ty = ((TRTree*)(tree))->_position.y - ((TRTree*)(tree))->_position.x;
        if(yy - yLength <= ty && ty <= yy) {
            float tx = ((TRTree*)(tree))->_position.x + ((TRTree*)(tree))->_position.y;
            if(xx - xLength < tx && tx < xx + xLength) {
                [_treeWasCutDown postData:tree];
                return NO;
            } else {
                return YES;
            }
        } else {
            return YES;
        }
    }] toArray];
    __treesCount = [__trees count];
}

- (void)_cutDownRect:(PGRect)rect {
    __trees = [[[__trees chain] filterWhen:^BOOL(TRTree* tree) {
        if(pgRectContainsVec2(rect, ((TRTree*)(tree))->_position)) {
            [_treeWasCutDown postData:tree];
            return NO;
        } else {
            return YES;
        }
    }] toArray];
    __treesCount = [__trees count];
}

- (CNFuture*)updateWithDelta:(CGFloat)delta {
    return [self futureF:^id() {
        for(TRTree* _ in __trees) {
            [((TRTree*)(_)) updateWithWind:[_weather wind] delta:delta];
        }
        return nil;
    }];
}

- (NSString*)description {
    return [NSString stringWithFormat:@"Forest(%@, %@, %@)", _map, _rules, _weather];
}

- (CNClassType*)type {
    return [TRForest type];
}

+ (CNClassType*)type {
    return _TRForest_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation TRTree
static CNClassType* _TRTree_type;
@synthesize treeType = _treeType;
@synthesize position = _position;
@synthesize size = _size;
@synthesize z = _z;
@synthesize rigidity = _rigidity;
@synthesize rustle = _rustle;
@synthesize body = _body;

+ (instancetype)treeWithTreeType:(TRTreeTypeR)treeType position:(PGVec2)position size:(PGVec2)size {
    return [[TRTree alloc] initWithTreeType:treeType position:position size:size];
}

- (instancetype)initWithTreeType:(TRTreeTypeR)treeType position:(PGVec2)position size:(PGVec2)size {
    self = [super init];
    if(self) {
        _treeType = treeType;
        _position = position;
        _size = size;
        _z = float4Round((position.y - position.x) * 400);
        _rigidity = cnFloatRndMinMax(0.5, 1.5);
        __rustleUp = YES;
        _rustle = 0.0;
        __incline = PGVec2Make(0.0, 0.0);
        __inclineUp = NO;
        _body = (([TRTreeType value:treeType].collisions) ? ({
            PGRigidBody* b = [PGRigidBody staticalData:nil shape:[PGCollisionBox applyX:0.01 y:0.01 z:size.y]];
            b.matrix = [[PGMat4 identity] translateX:position.x y:position.y z:0.0];
            b;
        }) : nil);
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [TRTree class]) _TRTree_type = [CNClassType classTypeWithCls:[TRTree class]];
}

- (NSInteger)compareTo:(TRTree*)to {
    return -intCompareTo(_z, ((TRTree*)(to))->_z);
}

- (PGVec2)incline {
    return __incline;
}

- (void)updateWithWind:(PGVec2)wind delta:(CGFloat)delta {
    PGVec2 mw = pgVec2MulF((pgVec2MulF(wind, 0.3)), _rigidity);
    float mws = float4Abs(mw.x) + float4Abs(mw.y);
    if(__rustleUp) {
        _rustle += delta * mws * 7;
        if(_rustle > mws) __rustleUp = NO;
    } else {
        _rustle -= delta * mws * 7;
        if(_rustle < -mws) __rustleUp = YES;
    }
    if(__inclineUp) {
        __incline = pgVec2MulF(__incline, 1.0 - delta);
        if(float4Abs(__incline.x) + float4Abs(__incline.y) < mws * 0.8) __inclineUp = NO;
    } else {
        __incline = pgVec2AddVec2(__incline, (pgVec2MulF(wind, delta)));
        if(float4Abs(__incline.x) + float4Abs(__incline.y) > mws) __inclineUp = YES;
    }
}

- (NSString*)description {
    return [NSString stringWithFormat:@"Tree(%@, %@, %@)", [TRTreeType value:_treeType], pgVec2Description(_position), pgVec2Description(_size)];
}

- (CNClassType*)type {
    return [TRTree type];
}

+ (CNClassType*)type {
    return _TRTree_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

