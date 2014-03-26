#import "TRTree.h"

#import "EGMapIso.h"
#import "TRWeather.h"
#import "TRRailroad.h"
#import "TRRailPoint.h"
#import "EGCollisionBody.h"
#import "EGDynamicWorld.h"
#import "GEMat4.h"
#import "EGPlatformPlat.h"
#import "EGPlatform.h"
@implementation TRForestRules
static ODClassType* _TRForestRules_type;
@synthesize forestType = _forestType;
@synthesize thickness = _thickness;

+ (instancetype)forestRulesWithForestType:(TRForestType*)forestType thickness:(CGFloat)thickness {
    return [[TRForestRules alloc] initWithForestType:forestType thickness:thickness];
}

- (instancetype)initWithForestType:(TRForestType*)forestType thickness:(CGFloat)thickness {
    self = [super init];
    if(self) {
        _forestType = forestType;
        _thickness = thickness;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [TRForestRules class]) _TRForestRules_type = [ODClassType classTypeWithCls:[TRForestRules class]];
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

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"forestType=%@", self.forestType];
    [description appendFormat:@", thickness=%f", self.thickness];
    [description appendString:@">"];
    return description;
}

@end


@implementation TRForest
static CNNotificationHandle* _TRForest_cutDownNotification;
static ODClassType* _TRForest_type;
@synthesize map = _map;
@synthesize rules = _rules;
@synthesize weather = _weather;

+ (instancetype)forestWithMap:(EGMapSso*)map rules:(TRForestRules*)rules weather:(TRWeather*)weather {
    return [[TRForest alloc] initWithMap:map rules:rules weather:weather];
}

- (instancetype)initWithMap:(EGMapSso*)map rules:(TRForestRules*)rules weather:(TRWeather*)weather {
    self = [super init];
    if(self) {
        _map = map;
        _rules = rules;
        _weather = weather;
        __treesCount = [__trees count];
        if([self class] == [TRForest class]) [self _init];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [TRForest class]) {
        _TRForest_type = [ODClassType classTypeWithCls:[TRForest class]];
        _TRForest_cutDownNotification = [CNNotificationHandle notificationHandleWithName:@"cutDownNotification"];
    }
}

- (void)_init {
    [self fill];
}

- (void)fill {
    __trees = [[[intRange(((NSInteger)(_rules.thickness * [_map.allTiles count] * 1.1))) chain] map:^TRTree*(id _) {
        GEVec2i tile = uwrap(GEVec2i, [[_map.allTiles randomItem] get]);
        GEVec2 pos = GEVec2Make((((float)(odFloatRndMinMax(-0.5, 0.5)))), (((float)(odFloatRndMinMax(-0.5, 0.5)))));
        return [TRTree treeWithTreeType:[[_rules.forestType.treeTypes randomItem] get] position:geVec2AddVec2(pos, geVec2ApplyVec2i(tile)) size:GEVec2Make((((float)(odFloatRndMinMax(0.9, 1.1)))), (((float)(odFloatRndMinMax(0.9, 1.1)))))];
    }] toTreeSet];
}

- (CNFuture*)trees {
    return [self promptF:^id<CNImIterable>() {
        return __trees;
    }];
}

- (NSUInteger)treesCount {
    return __treesCount;
}

- (CNFuture*)cutDownTile:(GEVec2i)tile {
    return [self futureF:^id() {
        [self _cutDownRect:geRectSubVec2((GERectMake(geVec2ApplyVec2i(tile), (GEVec2Make(1.4, 1.4)))), (GEVec2Make(0.7, 0.7)))];
        return nil;
    }];
}

- (CNFuture*)cutDownForRail:(TRRail*)rail {
    return [self futureF:^id() {
        GEVec2 s = geVec2iDivF4([rail.form.start vec], 2.0);
        GEVec2 e = geVec2iDivF4([rail.form.end vec], 2.0);
        GEVec2 ds = ((eqf4(s.x, 0)) ? GEVec2Make(0.3, 0.0) : GEVec2Make(0.0, 0.3));
        GEVec2 de = ((eqf4(e.x, 0)) ? GEVec2Make(0.3, 0.0) : GEVec2Make(0.0, 0.3));
        [self _cutDownRect:geRectAddVec2((geQuadBoundingRect((GEQuadMake((geVec2SubVec2(s, ds)), (geVec2AddVec2(s, ds)), (geVec2SubVec2(e, de)), (geVec2AddVec2(e, de)))))), geVec2ApplyVec2i(rail.tile))];
        return nil;
    }];
}

- (CNFuture*)cutDownForASwitch:(TRSwitch*)aSwitch {
    return [self futureF:^id() {
        [self _cutDownPos:geVec2ApplyVec2i((geVec2iAddVec2i((geVec2iMulI([aSwitch.connector vec], ((NSInteger)(0.4)))), aSwitch.tile))) xLength:0.5 yLength:2.5];
        return nil;
    }];
}

- (CNFuture*)cutDownForLight:(TRRailLight*)light {
    return [self futureF:^id() {
        [self _cutDownPos:geVec2ApplyVec2i((geVec2iAddVec2i((geVec2iMulI([light.connector vec], ((NSInteger)(0.45)))), light.tile))) xLength:0.3 yLength:2.5];
        return nil;
    }];
}

- (void)_cutDownPos:(GEVec2)pos xLength:(CGFloat)xLength yLength:(CGFloat)yLength {
    float xx = pos.x + pos.y;
    float yy = pos.y - pos.x;
    __trees = [[[__trees chain] filter:^BOOL(TRTree* tree) {
        float ty = ((TRTree*)(tree)).position.y - ((TRTree*)(tree)).position.x;
        if(yy - yLength <= ty && ty <= yy) {
            float tx = ((TRTree*)(tree)).position.x + ((TRTree*)(tree)).position.y;
            if(xx - xLength < tx && tx < xx + xLength) {
                [_TRForest_cutDownNotification postSender:self data:tree];
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

- (void)_cutDownRect:(GERect)rect {
    __trees = [[[__trees chain] filter:^BOOL(TRTree* tree) {
        if(geRectContainsVec2(rect, ((TRTree*)(tree)).position)) {
            [_TRForest_cutDownNotification postSender:self data:tree];
            return NO;
        } else {
            return YES;
        }
    }] toArray];
    __treesCount = [__trees count];
}

- (CNFuture*)updateWithDelta:(CGFloat)delta {
    return [self futureF:^id() {
        [__trees forEach:^void(TRTree* _) {
            [((TRTree*)(_)) updateWithWind:[_weather wind] delta:delta];
        }];
        return nil;
    }];
}

- (ODClassType*)type {
    return [TRForest type];
}

+ (CNNotificationHandle*)cutDownNotification {
    return _TRForest_cutDownNotification;
}

+ (ODClassType*)type {
    return _TRForest_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
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


@implementation TRTree
static ODClassType* _TRTree_type;
@synthesize treeType = _treeType;
@synthesize position = _position;
@synthesize size = _size;
@synthesize z = _z;
@synthesize rigidity = _rigidity;
@synthesize rustle = _rustle;
@synthesize body = _body;

+ (instancetype)treeWithTreeType:(TRTreeType*)treeType position:(GEVec2)position size:(GEVec2)size {
    return [[TRTree alloc] initWithTreeType:treeType position:position size:size];
}

- (instancetype)initWithTreeType:(TRTreeType*)treeType position:(GEVec2)position size:(GEVec2)size {
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
        _body = ((_treeType.collisions) ? ^id() {
            EGRigidBody* b = [EGRigidBody staticalData:nil shape:[EGCollisionBox applyX:0.01 y:0.01 z:_size.y]];
            b.matrix = [[GEMat4 identity] translateX:_position.x y:_position.y z:0.0];
            return [CNOption applyValue:b];
        }() : [CNOption none]);
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [TRTree class]) _TRTree_type = [ODClassType classTypeWithCls:[TRTree class]];
}

- (NSInteger)compareTo:(TRTree*)to {
    return -intCompareTo(_z, to.z);
}

- (GEVec2)incline {
    return __incline;
}

- (void)updateWithWind:(GEVec2)wind delta:(CGFloat)delta {
    GEVec2 mw = geVec2MulF4((geVec2MulF4(wind, 0.3)), ((float)(_rigidity)));
    float mws = float4Abs(mw.x) + float4Abs(mw.y);
    if(__rustleUp) {
        _rustle += delta * mws * 7;
        if(_rustle > mws) __rustleUp = NO;
    } else {
        _rustle -= delta * mws * 7;
        if(_rustle < -mws) __rustleUp = YES;
    }
    if(__inclineUp) {
        __incline = geVec2MulF4(__incline, ((float)(1.0 - delta)));
        if(float4Abs(__incline.x) + float4Abs(__incline.y) < mws * 0.8) __inclineUp = NO;
    } else {
        __incline = geVec2AddVec2(__incline, (geVec2MulF4(wind, ((float)(delta)))));
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
    id<CNImSeq> _treeTypes;
}
static TRForestType* _TRForestType_Pine;
static TRForestType* _TRForestType_Leaf;
static TRForestType* _TRForestType_SnowPine;
static TRForestType* _TRForestType_Palm;
static NSArray* _TRForestType_values;
@synthesize treeTypes = _treeTypes;

+ (instancetype)forestTypeWithOrdinal:(NSUInteger)ordinal name:(NSString*)name treeTypes:(id<CNImSeq>)treeTypes {
    return [[TRForestType alloc] initWithOrdinal:ordinal name:name treeTypes:treeTypes];
}

- (instancetype)initWithOrdinal:(NSUInteger)ordinal name:(NSString*)name treeTypes:(id<CNImSeq>)treeTypes {
    self = [super initWithOrdinal:ordinal name:name];
    if(self) _treeTypes = treeTypes;
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _TRForestType_Pine = [TRForestType forestTypeWithOrdinal:0 name:@"Pine" treeTypes:(@[TRTreeType.Pine])];
    _TRForestType_Leaf = [TRForestType forestTypeWithOrdinal:1 name:@"Leaf" treeTypes:(@[TRTreeType.Leaf, TRTreeType.WeakLeaf])];
    _TRForestType_SnowPine = [TRForestType forestTypeWithOrdinal:2 name:@"SnowPine" treeTypes:(@[TRTreeType.SnowPine])];
    _TRForestType_Palm = [TRForestType forestTypeWithOrdinal:3 name:@"Palm" treeTypes:(@[TRTreeType.Palm])];
    _TRForestType_values = (@[_TRForestType_Pine, _TRForestType_Leaf, _TRForestType_SnowPine, _TRForestType_Palm]);
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

+ (TRForestType*)Palm {
    return _TRForestType_Palm;
}

+ (NSArray*)values {
    return _TRForestType_values;
}

@end


@implementation TRTreeType{
    GERect _uv;
    CGFloat _scale;
    CGFloat _rustleStrength;
    BOOL _collisions;
    GEQuad _uvQuad;
    GEVec2 _size;
}
static TRTreeType* _TRTreeType_Pine;
static TRTreeType* _TRTreeType_SnowPine;
static TRTreeType* _TRTreeType_Leaf;
static TRTreeType* _TRTreeType_WeakLeaf;
static TRTreeType* _TRTreeType_Palm;
static NSArray* _TRTreeType_values;
@synthesize uv = _uv;
@synthesize scale = _scale;
@synthesize rustleStrength = _rustleStrength;
@synthesize collisions = _collisions;
@synthesize uvQuad = _uvQuad;
@synthesize size = _size;

+ (instancetype)treeTypeWithOrdinal:(NSUInteger)ordinal name:(NSString*)name uv:(GERect)uv scale:(CGFloat)scale rustleStrength:(CGFloat)rustleStrength collisions:(BOOL)collisions {
    return [[TRTreeType alloc] initWithOrdinal:ordinal name:name uv:uv scale:scale rustleStrength:rustleStrength collisions:collisions];
}

- (instancetype)initWithOrdinal:(NSUInteger)ordinal name:(NSString*)name uv:(GERect)uv scale:(CGFloat)scale rustleStrength:(CGFloat)rustleStrength collisions:(BOOL)collisions {
    self = [super initWithOrdinal:ordinal name:name];
    if(self) {
        _uv = uv;
        _scale = scale;
        _rustleStrength = rustleStrength;
        _collisions = collisions;
        _uvQuad = geRectUpsideDownStripQuad(_uv);
        _size = geVec2MulF4((GEVec2Make(geRectWidth(_uv), 0.5)), ((float)(_scale)));
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _TRTreeType_Pine = [TRTreeType treeTypeWithOrdinal:0 name:@"Pine" uv:geRectApplyXYWidthHeight(0.0, 0.0, ((float)(184.0 / 512)), (([egPlatform() isIOS]) ? 0.5 : ((float)(1.0)))) scale:1.0 rustleStrength:1.0 collisions:YES];
    _TRTreeType_SnowPine = [TRTreeType treeTypeWithOrdinal:1 name:@"SnowPine" uv:geRectApplyXYWidthHeight(0.0, 0.0, ((float)(184.0 / 512)), (([egPlatform() isIOS]) ? 0.5 : ((float)(1.0)))) scale:1.0 rustleStrength:1.0 collisions:YES];
    _TRTreeType_Leaf = [TRTreeType treeTypeWithOrdinal:2 name:@"Leaf" uv:geRectApplyXYWidthHeight(0.0, 0.0, ((float)(197.0 / 512)), 0.5) scale:1.6 rustleStrength:0.8 collisions:YES];
    _TRTreeType_WeakLeaf = [TRTreeType treeTypeWithOrdinal:3 name:@"WeakLeaf" uv:geRectApplyXYWidthHeight(0.0, 0.5, ((float)(115.0 / 512)), 0.5) scale:0.6 rustleStrength:1.5 collisions:NO];
    _TRTreeType_Palm = [TRTreeType treeTypeWithOrdinal:4 name:@"Palm" uv:geRectApplyXYWidthHeight(0.0, 0.0, ((float)(2115.0 / 5500)), (([egPlatform() isIOS]) ? 0.5 : ((float)(1.0)))) scale:1.5 rustleStrength:1.0 collisions:YES];
    _TRTreeType_values = (@[_TRTreeType_Pine, _TRTreeType_SnowPine, _TRTreeType_Leaf, _TRTreeType_WeakLeaf, _TRTreeType_Palm]);
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

+ (TRTreeType*)Palm {
    return _TRTreeType_Palm;
}

+ (NSArray*)values {
    return _TRTreeType_values;
}

@end


