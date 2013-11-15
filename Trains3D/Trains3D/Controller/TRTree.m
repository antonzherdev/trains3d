#import "TRTree.h"

#import "EGMapIso.h"
#import "TRWeather.h"
#import "TRRailroad.h"
#import "TRRailPoint.h"
@implementation TRForestRules{
    TRForestType* _forestType;
    CGFloat _thickness;
}
static ODClassType* _TRForestRules_type;
@synthesize forestType = _forestType;
@synthesize thickness = _thickness;

+ (id)forestRulesWithForestType:(TRForestType*)forestType thickness:(CGFloat)thickness {
    return [[TRForestRules alloc] initWithForestType:forestType thickness:thickness];
}

- (id)initWithForestType:(TRForestType*)forestType thickness:(CGFloat)thickness {
    self = [super init];
    if(self) {
        _forestType = forestType;
        _thickness = thickness;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _TRForestRules_type = [ODClassType classTypeWithCls:[TRForestRules class]];
}

- (ODClassType*)type {
    return [TRForestRules type];
}

+ (ODClassType*)type {
    return _TRForestRules_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    TRForestRules* o = ((TRForestRules*)(other));
    return self.forestType == o.forestType && eqf(self.thickness, o.thickness);
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.forestType ordinal];
    hash = hash * 31 + floatHash(self.thickness);
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"forestType=%@", self.forestType];
    [description appendFormat:@", thickness=%f", self.thickness];
    [description appendString:@">"];
    return description;
}

@end


@implementation TRForest{
    EGMapSso* _map;
    TRForestRules* _rules;
    TRWeather* _weather;
    id<CNIterable> __trees;
}
static ODClassType* _TRForest_type;
@synthesize map = _map;
@synthesize rules = _rules;
@synthesize weather = _weather;

+ (id)forestWithMap:(EGMapSso*)map rules:(TRForestRules*)rules weather:(TRWeather*)weather {
    return [[TRForest alloc] initWithMap:map rules:rules weather:weather];
}

- (id)initWithMap:(EGMapSso*)map rules:(TRForestRules*)rules weather:(TRWeather*)weather {
    self = [super init];
    __weak TRForest* _weakSelf = self;
    if(self) {
        _map = map;
        _rules = rules;
        _weather = weather;
        __trees = [[[intRange(((NSInteger)(_rules.thickness * [_map.allTiles count] * 1.1))) chain] map:^TRTree*(id _) {
            GEVec2i tile = uwrap(GEVec2i, [[_weakSelf.map.allTiles randomItem] get]);
            GEVec2 pos = GEVec2Make(((float)(odFloatRndMinMax(-0.5, 0.5))), ((float)(odFloatRndMinMax(-0.5, 0.5))));
            return [TRTree treeWithTreeType:[[_weakSelf.rules.forestType.treeTypes randomItem] get] position:geVec2AddVec2(pos, geVec2ApplyVec2i(tile)) size:GEVec2Make(((float)(odFloatRndMinMax(0.9, 1.1))), ((float)(odFloatRndMinMax(0.9, 1.1))))];
        }] toTreeSet];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _TRForest_type = [ODClassType classTypeWithCls:[TRForest class]];
}

- (id<CNIterable>)trees {
    return __trees;
}

- (void)cutDownTile:(GEVec2i)tile {
    [self cutDownRect:geRectSubVec2(GERectMake(geVec2ApplyVec2i(tile), GEVec2Make(1.4, 1.4)), GEVec2Make(0.7, 0.7))];
}

- (void)cutDownForRail:(TRRail*)rail {
    GEVec2 s = geVec2iDivF([rail.form.start vec], 2.0);
    GEVec2 e = geVec2iDivF([rail.form.end vec], 2.0);
    GEVec2 ds = ((eqf4(s.x, 0)) ? GEVec2Make(0.3, 0.0) : GEVec2Make(0.0, 0.3));
    GEVec2 de = ((eqf4(e.x, 0)) ? GEVec2Make(0.3, 0.0) : GEVec2Make(0.0, 0.3));
    [self cutDownRect:geRectAddVec2(geQuadBoundingRect(geQuadApplyP0P1P2P3(geVec2SubVec2(s, ds), geVec2AddVec2(s, ds), geVec2SubVec2(e, de), geVec2AddVec2(e, de))), geVec2ApplyVec2i(rail.tile))];
}

- (void)cutDownForASwitch:(TRSwitch*)aSwitch {
    [self cutDownPos:geVec2AddVec2(geVec2iMulF([aSwitch.connector vec], 0.4), geVec2ApplyVec2i(aSwitch.tile)) xLength:0.5 yLength:2.5];
}

- (void)cutDownForLight:(TRRailLight*)light {
    [self cutDownPos:geVec2AddVec2(geVec2iMulF([light.connector vec], 0.45), geVec2ApplyVec2i(light.tile)) xLength:0.5 yLength:2.5];
}

- (void)cutDownPos:(GEVec2)pos xLength:(CGFloat)xLength yLength:(CGFloat)yLength {
    float xx = pos.x + pos.y;
    float yy = pos.y - pos.x;
    __trees = [[[__trees chain] filter:^BOOL(TRTree* tree) {
        float ty = ((TRTree*)(tree)).position.y - ((TRTree*)(tree)).position.x;
        if(yy - yLength <= ty && ty <= yy) {
            float tx = ((TRTree*)(tree)).position.x + ((TRTree*)(tree)).position.y;
            if(xx - xLength < tx && tx < xx + xLength) return NO;
            else return YES;
        } else {
            return YES;
        }
    }] toArray];
}

- (void)cutDownRect:(GERect)rect {
    __trees = [[[__trees chain] filter:^BOOL(TRTree* _) {
        return !(geRectContainsVec2(rect, ((TRTree*)(_)).position));
    }] toArray];
}

- (void)updateWithDelta:(CGFloat)delta {
    [__trees forEach:^void(TRTree* _) {
        [((TRTree*)(_)) updateWithWind:[_weather wind] delta:delta];
    }];
}

- (ODClassType*)type {
    return [TRForest type];
}

+ (ODClassType*)type {
    return _TRForest_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    TRForest* o = ((TRForest*)(other));
    return [self.map isEqual:o.map] && [self.rules isEqual:o.rules] && [self.weather isEqual:o.weather];
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.map hash];
    hash = hash * 31 + [self.rules hash];
    hash = hash * 31 + [self.weather hash];
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"map=%@", self.map];
    [description appendFormat:@", rules=%@", self.rules];
    [description appendFormat:@", weather=%@", self.weather];
    [description appendString:@">"];
    return description;
}

@end


@implementation TRTree{
    TRTreeType* _treeType;
    GEVec2 _position;
    GEVec2 _size;
    NSInteger _z;
    CGFloat _rigidity;
    BOOL __rustleUp;
    CGFloat _rustle;
    GEVec2 __incline;
    BOOL __inclineUp;
}
static ODClassType* _TRTree_type;
@synthesize treeType = _treeType;
@synthesize position = _position;
@synthesize size = _size;
@synthesize z = _z;
@synthesize rigidity = _rigidity;
@synthesize rustle = _rustle;

+ (id)treeWithTreeType:(TRTreeType*)treeType position:(GEVec2)position size:(GEVec2)size {
    return [[TRTree alloc] initWithTreeType:treeType position:position size:size];
}

- (id)initWithTreeType:(TRTreeType*)treeType position:(GEVec2)position size:(GEVec2)size {
    self = [super init];
    if(self) {
        _treeType = treeType;
        _position = position;
        _size = size;
        _z = float4Round((_position.y - _position.x) * 400);
        _rigidity = odFloatRndMinMax(0.5, 1.5);
        __rustleUp = YES;
        _rustle = 0.0;
        __incline = GEVec2Make(0.0, 0.0);
        __inclineUp = NO;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _TRTree_type = [ODClassType classTypeWithCls:[TRTree class]];
}

- (NSInteger)compareTo:(TRTree*)to {
    return -intCompareTo(_z, to.z);
}

- (GEVec2)incline {
    return __incline;
}

- (void)updateWithWind:(GEVec2)wind delta:(CGFloat)delta {
    GEVec2 mw = geVec2MulF(geVec2MulF(wind, 0.3), _rigidity);
    float mws = float4Abs(mw.x) + float4Abs(mw.y);
    if(__rustleUp) {
        _rustle += delta * mws * mws * 65;
        if(_rustle > mws) __rustleUp = NO;
    } else {
        _rustle -= delta * mws * mws * 65;
        if(_rustle < -mws) __rustleUp = YES;
    }
    if(__inclineUp) {
        __incline = geVec2MulF(__incline, 1.0 - delta);
        if(float4Abs(__incline.x) + float4Abs(__incline.y) < mws * 0.8) __inclineUp = NO;
    } else {
        __incline = geVec2AddVec2(__incline, geVec2MulF(wind, delta));
        if(float4Abs(__incline.x) + float4Abs(__incline.y) > mws) __inclineUp = YES;
    }
}

- (ODClassType*)type {
    return [TRTree type];
}

+ (ODClassType*)type {
    return _TRTree_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    TRTree* o = ((TRTree*)(other));
    return self.treeType == o.treeType && GEVec2Eq(self.position, o.position) && GEVec2Eq(self.size, o.size);
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.treeType ordinal];
    hash = hash * 31 + GEVec2Hash(self.position);
    hash = hash * 31 + GEVec2Hash(self.size);
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"treeType=%@", self.treeType];
    [description appendFormat:@", position=%@", GEVec2Description(self.position)];
    [description appendFormat:@", size=%@", GEVec2Description(self.size)];
    [description appendString:@">"];
    return description;
}

@end


@implementation TRForestType{
    id<CNSeq> _treeTypes;
}
static TRForestType* _TRForestType_Pine;
static TRForestType* _TRForestType_Leaf;
static TRForestType* _TRForestType_SnowPine;
static NSArray* _TRForestType_values;
@synthesize treeTypes = _treeTypes;

+ (id)forestTypeWithOrdinal:(NSUInteger)ordinal name:(NSString*)name treeTypes:(id<CNSeq>)treeTypes {
    return [[TRForestType alloc] initWithOrdinal:ordinal name:name treeTypes:treeTypes];
}

- (id)initWithOrdinal:(NSUInteger)ordinal name:(NSString*)name treeTypes:(id<CNSeq>)treeTypes {
    self = [super initWithOrdinal:ordinal name:name];
    if(self) _treeTypes = treeTypes;
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _TRForestType_Pine = [TRForestType forestTypeWithOrdinal:0 name:@"Pine" treeTypes:(@[TRTreeType.Pine])];
    _TRForestType_Leaf = [TRForestType forestTypeWithOrdinal:1 name:@"Leaf" treeTypes:(@[TRTreeType.Leaf, TRTreeType.WeakLeaf])];
    _TRForestType_SnowPine = [TRForestType forestTypeWithOrdinal:2 name:@"SnowPine" treeTypes:(@[TRTreeType.SnowPine])];
    _TRForestType_values = (@[_TRForestType_Pine, _TRForestType_Leaf, _TRForestType_SnowPine]);
}

+ (TRForestType*)Pine {
    return _TRForestType_Pine;
}

+ (TRForestType*)Leaf {
    return _TRForestType_Leaf;
}

+ (TRForestType*)SnowPine {
    return _TRForestType_SnowPine;
}

+ (NSArray*)values {
    return _TRForestType_values;
}

@end


@implementation TRTreeType{
    GERect _uv;
    CGFloat _scale;
    CGFloat _rustleStrength;
    GEQuad _uvQuad;
    GEVec2 _size;
}
static TRTreeType* _TRTreeType_Pine;
static TRTreeType* _TRTreeType_SnowPine;
static TRTreeType* _TRTreeType_Leaf;
static TRTreeType* _TRTreeType_WeakLeaf;
static NSArray* _TRTreeType_values;
@synthesize uv = _uv;
@synthesize scale = _scale;
@synthesize rustleStrength = _rustleStrength;
@synthesize uvQuad = _uvQuad;
@synthesize size = _size;

+ (id)treeTypeWithOrdinal:(NSUInteger)ordinal name:(NSString*)name uv:(GERect)uv scale:(CGFloat)scale rustleStrength:(CGFloat)rustleStrength {
    return [[TRTreeType alloc] initWithOrdinal:ordinal name:name uv:uv scale:scale rustleStrength:rustleStrength];
}

- (id)initWithOrdinal:(NSUInteger)ordinal name:(NSString*)name uv:(GERect)uv scale:(CGFloat)scale rustleStrength:(CGFloat)rustleStrength {
    self = [super initWithOrdinal:ordinal name:name];
    if(self) {
        _uv = uv;
        _scale = scale;
        _rustleStrength = rustleStrength;
        _uvQuad = geRectUpsideDownQuad(_uv);
        _size = geVec2MulF(GEVec2Make(geRectWidth(_uv), 0.5), _scale);
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _TRTreeType_Pine = [TRTreeType treeTypeWithOrdinal:0 name:@"Pine" uv:geRectApplyXYWidthHeight(0.0, 0.0, ((float)(184.0 / 512)), 1.0) scale:1.0 rustleStrength:1.0];
    _TRTreeType_SnowPine = [TRTreeType treeTypeWithOrdinal:1 name:@"SnowPine" uv:geRectApplyXYWidthHeight(0.0, 0.0, ((float)(184.0 / 512)), 1.0) scale:1.0 rustleStrength:1.0];
    _TRTreeType_Leaf = [TRTreeType treeTypeWithOrdinal:2 name:@"Leaf" uv:geRectApplyXYWidthHeight(0.0, 0.0, ((float)(197.0 / 512)), 0.5) scale:1.6 rustleStrength:1.0];
    _TRTreeType_WeakLeaf = [TRTreeType treeTypeWithOrdinal:3 name:@"WeakLeaf" uv:geRectApplyXYWidthHeight(0.0, 0.5, ((float)(115.0 / 512)), 0.5) scale:0.6 rustleStrength:2.0];
    _TRTreeType_values = (@[_TRTreeType_Pine, _TRTreeType_SnowPine, _TRTreeType_Leaf, _TRTreeType_WeakLeaf]);
}

+ (TRTreeType*)Pine {
    return _TRTreeType_Pine;
}

+ (TRTreeType*)SnowPine {
    return _TRTreeType_SnowPine;
}

+ (TRTreeType*)Leaf {
    return _TRTreeType_Leaf;
}

+ (TRTreeType*)WeakLeaf {
    return _TRTreeType_WeakLeaf;
}

+ (NSArray*)values {
    return _TRTreeType_values;
}

@end


