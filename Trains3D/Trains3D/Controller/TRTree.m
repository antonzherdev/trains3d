#import "TRTree.h"

#import "EGMapIso.h"
@implementation TRTreesRules{
    CGFloat _thickness;
}
static ODClassType* _TRTreesRules_type;
@synthesize thickness = _thickness;

+ (id)treesRulesWithThickness:(CGFloat)thickness {
    return [[TRTreesRules alloc] initWithThickness:thickness];
}

- (id)initWithThickness:(CGFloat)thickness {
    self = [super init];
    if(self) _thickness = thickness;
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _TRTreesRules_type = [ODClassType classTypeWithCls:[TRTreesRules class]];
}

- (ODClassType*)type {
    return [TRTreesRules type];
}

+ (ODClassType*)type {
    return _TRTreesRules_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    TRTreesRules* o = ((TRTreesRules*)(other));
    return eqf(self.thickness, o.thickness);
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + floatHash(self.thickness);
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"thickness=%f", self.thickness];
    [description appendString:@">"];
    return description;
}

@end


@implementation TRTrees{
    EGMapSso* _map;
    TRTreesRules* _rules;
    id<CNSeq> _trees;
}
static ODClassType* _TRTrees_type;
@synthesize map = _map;
@synthesize rules = _rules;
@synthesize trees = _trees;

+ (id)treesWithMap:(EGMapSso*)map rules:(TRTreesRules*)rules {
    return [[TRTrees alloc] initWithMap:map rules:rules];
}

- (id)initWithMap:(EGMapSso*)map rules:(TRTreesRules*)rules {
    self = [super init];
    __weak TRTrees* _weakSelf = self;
    if(self) {
        _map = map;
        _rules = rules;
        _trees = [[[[intRange(((NSInteger)(_rules.thickness * [_map.allTiles count]))) chain] map:^TRTree*(id _) {
            GEVec2i tile = uwrap(GEVec2i, [[_weakSelf.map.allTiles randomItem] get]);
            GEVec2 pos = GEVec2Make(((float)(randomFloatGap(-0.5, 0.5))), ((float)(randomFloatGap(-0.5, 0.5))));
            return [TRTree treeWithPosition:geVec2AddVec2(pos, geVec2ApplyVec2i(tile))];
        }] sort] toArray];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _TRTrees_type = [ODClassType classTypeWithCls:[TRTrees class]];
}

- (ODClassType*)type {
    return [TRTrees type];
}

+ (ODClassType*)type {
    return _TRTrees_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    TRTrees* o = ((TRTrees*)(other));
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
    GEVec2 _position;
}
static ODClassType* _TRTree_type;
@synthesize position = _position;

+ (id)treeWithPosition:(GEVec2)position {
    return [[TRTree alloc] initWithPosition:position];
}

- (id)initWithPosition:(GEVec2)position {
    self = [super init];
    if(self) _position = position;
    
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
    return GEVec2Eq(self.position, o.position);
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + GEVec2Hash(self.position);
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"position=%@", GEVec2Description(self.position)];
    [description appendString:@">"];
    return description;
}

@end


