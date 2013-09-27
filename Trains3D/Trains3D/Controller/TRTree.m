#import "TRTree.h"

#import "EGMapIso.h"
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
    id<CNSeq> __trees;
}
static ODClassType* _TRForest_type;
@synthesize map = _map;
@synthesize rules = _rules;

+ (id)forestWithMap:(EGMapSso*)map rules:(TRForestRules*)rules {
    return [[TRForest alloc] initWithMap:map rules:rules];
}

- (id)initWithMap:(EGMapSso*)map rules:(TRForestRules*)rules {
    self = [super init];
    __weak TRForest* _weakSelf = self;
    if(self) {
        _map = map;
        _rules = rules;
        __trees = [[[[intRange(((NSInteger)(_rules.thickness * [_map.allTiles count]))) chain] map:^TRTree*(id _) {
            GEVec2i tile = uwrap(GEVec2i, [[_weakSelf.map.allTiles randomItem] get]);
            GEVec2 pos = GEVec2Make(((float)(randomFloatGap(-0.5, 0.5))), ((float)(randomFloatGap(-0.5, 0.5))));
            return [TRTree treeWithTreeType:((TRTreeType*)([[_weakSelf.rules.types randomItem] get])) position:geVec2AddVec2(pos, geVec2ApplyVec2i(tile)) size:GEVec2Make(((float)(randomFloatGap(0.8, 1.2))), ((float)(randomFloatGap(0.8, 1.2))))];
        }] sort] toArray];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _TRForest_type = [ODClassType classTypeWithCls:[TRForest class]];
}

- (id<CNSeq>)trees {
    return __trees;
}

- (void)cutDownTile:(GEVec2i)tile {
    __trees = [[[__trees chain] filter:^BOOL(TRTree* _) {
        return !(GEVec2iEq(geVec2iApplyVec2(_.position), tile));
    }] toArray];
}

- (void)cutDownForRail:(TRRail*)rail {
    GEVec2 s = geVec2iDivF([rail.form.start vec], 2.0);
    GEVec2 e = geVec2iDivF([rail.form.end vec], 2.0);
    GEVec2 ds = ((eqf4(s.x, 0)) ? GEVec2Make(0.0, 0.2) : GEVec2Make(0.2, 0.0));
    GEVec2 de = ((eqf4(e.x, 0)) ? GEVec2Make(0.0, 0.2) : GEVec2Make(0.2, 0.0));
    geQuadApplyP0P1P2P3(geVec2SubVec2(s, ds), geVec2AddVec2(s, ds), geVec2SubVec2(e, de), geVec2AddVec2(e, de));
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
    return [self.map isEqual:o.map] && [self.rules isEqual:o.rules];
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.map hash];
    hash = hash * 31 + [self.rules hash];
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"map=%@", self.map];
    [description appendFormat:@", rules=%@", self.rules];
    [description appendString:@">"];
    return description;
}

@end


@implementation TRTree{
    TRTreeType* _treeType;
    GEVec2 _position;
    GEVec2 _size;
}
static ODClassType* _TRTree_type;
@synthesize treeType = _treeType;
@synthesize position = _position;
@synthesize size = _size;

+ (id)treeWithTreeType:(TRTreeType*)treeType position:(GEVec2)position size:(GEVec2)size {
    return [[TRTree alloc] initWithTreeType:treeType position:position size:size];
}

- (id)initWithTreeType:(TRTreeType*)treeType position:(GEVec2)position size:(GEVec2)size {
    self = [super init];
    if(self) {
        _treeType = treeType;
        _position = position;
        _size = size;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _TRTree_type = [ODClassType classTypeWithCls:[TRTree class]];
}

- (NSInteger)compareTo:(TRTree*)to {
    return -float4CompareTo(_position.y - _position.x, to.position.y - to.position.x);
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


@implementation TRTreeType
static TRTreeType* _TRTreeType_pine;
static TRTreeType* _TRTreeType_tree1;
static TRTreeType* _TRTreeType_tree2;
static TRTreeType* _TRTreeType_tree3;
static TRTreeType* _TRTreeType_yellow;
static NSArray* _TRTreeType_values;

+ (id)treeTypeWithOrdinal:(NSUInteger)ordinal name:(NSString*)name {
    return [[TRTreeType alloc] initWithOrdinal:ordinal name:name];
}

- (id)initWithOrdinal:(NSUInteger)ordinal name:(NSString*)name {
    self = [super initWithOrdinal:ordinal name:name];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _TRTreeType_pine = [TRTreeType treeTypeWithOrdinal:0 name:@"pine"];
    _TRTreeType_tree1 = [TRTreeType treeTypeWithOrdinal:1 name:@"tree1"];
    _TRTreeType_tree2 = [TRTreeType treeTypeWithOrdinal:2 name:@"tree2"];
    _TRTreeType_tree3 = [TRTreeType treeTypeWithOrdinal:3 name:@"tree3"];
    _TRTreeType_yellow = [TRTreeType treeTypeWithOrdinal:4 name:@"yellow"];
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

