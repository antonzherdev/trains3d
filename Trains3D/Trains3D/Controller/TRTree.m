#import "TRTree.h"

#import "EGMapIso.h"
#import "TRWeather.h"
#import "TRRailroad.h"
#import "TRRailPoint.h"
@implementation TRForestRules{
    id<CNSeq> _types;
    CGFloat _thickness;
}
static ODClassType* _TRForestRules_type;
@synthesize types = _types;
@synthesize thickness = _thickness;

+ (id)forestRulesWithTypes:(id<CNSeq>)types thickness:(CGFloat)thickness {
    return [[TRForestRules alloc] initWithTypes:types thickness:thickness];
}

- (id)initWithTypes:(id<CNSeq>)types thickness:(CGFloat)thickness {
    self = [super init];
    if(self) {
        _types = types;
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
    return [self.types isEqual:o.types] && eqf(self.thickness, o.thickness);
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.types hash];
    hash = hash * 31 + floatHash(self.thickness);
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"types=%@", self.types];
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
            return [TRTree treeWithTreeType:[[_weakSelf.rules.types randomItem] get] position:geVec2AddVec2(pos, geVec2ApplyVec2i(tile)) size:GEVec2Make(((float)(odFloatRndMinMax(0.9, 1.1))), ((float)(odFloatRndMinMax(0.9, 1.1))))];
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
    GEVec2 pos = geVec2AddVec2(geVec2iMulF([aSwitch.connector vec], 0.4), geVec2ApplyVec2i(aSwitch.tile));
    float xx = pos.x + pos.y;
    float yy = pos.y - pos.x;
    __trees = [[[__trees chain] filter:^BOOL(TRTree* tree) {
        float ty = ((TRTree*)(tree)).position.y - ((TRTree*)(tree)).position.x;
        if(yy - 1.2 <= ty && ty <= yy) {
            float tx = ((TRTree*)(tree)).position.x + ((TRTree*)(tree)).position.y;
            if(xx - 0.3 < tx && tx < xx + 0.3) return NO;
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
        _z = float4Round((_position.y - _position.x) * 500);
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


@implementation TRTreeType{
    CGFloat _width;
    CGFloat _height;
}
static TRTreeType* _TRTreeType_pine;
static TRTreeType* _TRTreeType_tree1;
static TRTreeType* _TRTreeType_tree2;
static TRTreeType* _TRTreeType_tree3;
static TRTreeType* _TRTreeType_yellow;
static NSArray* _TRTreeType_values;
@synthesize width = _width;
@synthesize height = _height;

+ (id)treeTypeWithOrdinal:(NSUInteger)ordinal name:(NSString*)name width:(CGFloat)width height:(CGFloat)height {
    return [[TRTreeType alloc] initWithOrdinal:ordinal name:name width:width height:height];
}

- (id)initWithOrdinal:(NSUInteger)ordinal name:(NSString*)name width:(CGFloat)width height:(CGFloat)height {
    self = [super initWithOrdinal:ordinal name:name];
    if(self) {
        _width = width;
        _height = height;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _TRTreeType_pine = [TRTreeType treeTypeWithOrdinal:0 name:@"pine" width:184.0 / 512 height:1.0];
    _TRTreeType_tree1 = [TRTreeType treeTypeWithOrdinal:1 name:@"tree1" width:1.0 height:1.0];
    _TRTreeType_tree2 = [TRTreeType treeTypeWithOrdinal:2 name:@"tree2" width:1.0 height:1.0];
    _TRTreeType_tree3 = [TRTreeType treeTypeWithOrdinal:3 name:@"tree3" width:1.0 height:1.0];
    _TRTreeType_yellow = [TRTreeType treeTypeWithOrdinal:4 name:@"yellow" width:1.0 height:1.0];
    _TRTreeType_values = (@[_TRTreeType_pine, _TRTreeType_tree1, _TRTreeType_tree2, _TRTreeType_tree3, _TRTreeType_yellow]);
}

+ (TRTreeType*)pine {
    return _TRTreeType_pine;
}

+ (TRTreeType*)tree1 {
    return _TRTreeType_tree1;
}

+ (TRTreeType*)tree2 {
    return _TRTreeType_tree2;
}

+ (TRTreeType*)tree3 {
    return _TRTreeType_tree3;
}

+ (TRTreeType*)yellow {
    return _TRTreeType_yellow;
}

+ (NSArray*)values {
    return _TRTreeType_values;
}

@end


