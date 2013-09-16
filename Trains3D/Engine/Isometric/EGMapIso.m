#import "EGMapIso.h"

#import "EGGL.h"
#import "EGMaterial.h"
@implementation EGMapSso{
    GEVec2i _size;
    GERectI _limits;
    id<CNSeq> _fullTiles;
    id<CNSeq> _partialTiles;
    id<CNSeq> _allTiles;
}
static CGFloat _EGMapSso_ISO = 0.70710676908493;
static ODType* _EGMapSso_type;
@synthesize size = _size;
@synthesize limits = _limits;
@synthesize fullTiles = _fullTiles;
@synthesize partialTiles = _partialTiles;
@synthesize allTiles = _allTiles;

+ (id)mapSsoWithSize:(GEVec2i)size {
    return [[EGMapSso alloc] initWithSize:size];
}

- (id)initWithSize:(GEVec2i)size {
    self = [super init];
    __weak EGMapSso* _weakSelf = self;
    if(self) {
        _size = size;
        _limits = geRectINewXYXX2YY2(((CGFloat)((1 - _size.y) / 2 - 1)), ((CGFloat)((2 * _size.x + _size.y - 3) / 2 + 1)), ((CGFloat)((1 - _size.x) / 2 - 1)), ((CGFloat)((_size.x + 2 * _size.y - 3) / 2 + 1)));
        _fullTiles = [[[self allPosibleTiles] filter:^BOOL(id _) {
            return [_weakSelf isFullTile:uwrap(GEVec2i, _)];
        }] toArray];
        _partialTiles = [[[self allPosibleTiles] filter:^BOOL(id _) {
            return [_weakSelf isPartialTile:uwrap(GEVec2i, _)];
        }] toArray];
        _allTiles = [_fullTiles arrayByAddingItem:_partialTiles];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGMapSso_type = [ODClassType classTypeWithCls:[EGMapSso class]];
}

- (BOOL)isFullTile:(GEVec2i)tile {
    return tile.y + tile.x >= 0 && tile.y - tile.x <= _size.y - 1 && tile.y + tile.x <= _size.x + _size.y - 2 && tile.y - tile.x >= -_size.x + 1;
}

- (BOOL)isPartialTile:(GEVec2i)tile {
    return tile.y + tile.x >= -1 && tile.y - tile.x <= _size.y && tile.y + tile.x <= _size.x + _size.y - 1 && tile.y - tile.x >= -_size.x && (tile.y + tile.x == -1 || tile.y - tile.x == _size.y || tile.y + tile.x == _size.x + _size.y - 1 || tile.y - tile.x == -_size.x);
}

- (CNChain*)allPosibleTiles {
    return [[[[CNRange rangeWithStart:_limits.x end:geRectIX2(_limits) step:1] chain] mul:[CNRange rangeWithStart:_limits.y end:geRectIY2(_limits) step:1]] map:^id(CNTuple* _) {
        return wrap(GEVec2i, GEVec2iMake(unumi(_.a), unumi(_.b)));
    }];
}

- (NSInteger)tileCutAxisLess:(NSInteger)less more:(NSInteger)more {
    if(less == more) {
        return 1;
    } else {
        if(less < more) return 0;
        else return 2;
    }
}

- (GERectI)cutRectForTile:(GEVec2i)tile {
    return geRectINewXYXX2YY2(((CGFloat)([self tileCutAxisLess:0 more:tile.x + tile.y])), ((CGFloat)([self tileCutAxisLess:tile.x + tile.y more:_size.x + _size.y - 2])), ((CGFloat)([self tileCutAxisLess:tile.y - tile.x more:_size.y - 1])), ((CGFloat)([self tileCutAxisLess:-_size.x + 1 more:tile.y - tile.x])));
}

- (ODClassType*)type {
    return [EGMapSso type];
}

+ (CGFloat)ISO {
    return _EGMapSso_ISO;
}

+ (ODType*)type {
    return _EGMapSso_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGMapSso* o = ((EGMapSso*)(other));
    return GEVec2iEq(self.size, o.size);
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + GEVec2iHash(self.size);
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"size=%@", GEVec2iDescription(self.size)];
    [description appendString:@">"];
    return description;
}

@end


@implementation EGMapSsoView{
    EGMapSso* _map;
    EGMesh* _plane;
}
static ODType* _EGMapSsoView_type;
@synthesize map = _map;
@synthesize plane = _plane;

+ (id)mapSsoViewWithMap:(EGMapSso*)map {
    return [[EGMapSsoView alloc] initWithMap:map];
}

- (id)initWithMap:(EGMapSso*)map {
    self = [super init];
    if(self) {
        _map = map;
        _plane = [self createPlane];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGMapSsoView_type = [ODClassType classTypeWithCls:[EGMapSsoView class]];
}

- (void)drawLayout {
}

- (EGMesh*)createPlane {
    GERectI limits = _map.limits;
    CGFloat l = limits.x - 2.5;
    CGFloat r = geRectIX2(limits) + 0.5;
    CGFloat t = limits.y - 2.5;
    CGFloat b = geRectIY2(limits) + 0.5;
    NSInteger w = limits.width + 3;
    NSInteger h = limits.height + 3;
    return [EGMesh applyDataType:egMeshDataType() vertexData:[ arrs(EGMeshData, 32) {0, 0, 0, 1, 0, l, 0, b, w, 0, 0, 1, 0, r, 0, b, w, h, 0, 1, 0, r, 0, t, 0, h, 0, 1, 0, l, 0, t}] indexData:[ arrui4(6) {0, 1, 2, 2, 3, 0}]];
}

- (void)drawPlaneWithMaterial:(EGMaterial*)material {
    glDisable(GL_CULL_FACE);
    [material drawMesh:_plane];
    glEnable(GL_CULL_FACE);
}

- (ODClassType*)type {
    return [EGMapSsoView type];
}

+ (ODType*)type {
    return _EGMapSsoView_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGMapSsoView* o = ((EGMapSsoView*)(other));
    return [self.map isEqual:o.map];
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.map hash];
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"map=%@", self.map];
    [description appendString:@">"];
    return description;
}

@end


