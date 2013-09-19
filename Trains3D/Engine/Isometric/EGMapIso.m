#import "EGMapIso.h"

#import "EGMesh.h"
#import "EGCameraIso.h"
#import "GEMat4.h"
#import "EGMaterial.h"
#import "GL.h"
@implementation EGMapSso{
    GEVec2i _size;
    GERecti _limits;
    id<CNSeq> _fullTiles;
    id<CNSeq> _partialTiles;
    id<CNSeq> _allTiles;
}
static CGFloat _EGMapSso_ISO = 0.70710676908493;
static ODClassType* _EGMapSso_type;
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
        _limits = geVec2iRectToVec2i(GEVec2iMake((1 - _size.y) / 2 - 1, (1 - _size.x) / 2 - 1), GEVec2iMake((2 * _size.x + _size.y - 3) / 2 + 1, (_size.x + 2 * _size.y - 3) / 2 + 1));
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
    return [[[[CNRange rangeWithStart:geRectiX(_limits) end:geRectiX2(_limits) step:1] chain] mul:[CNRange rangeWithStart:geRectiY(_limits) end:geRectiY2(_limits) step:1]] map:^id(CNTuple* _) {
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

- (GERecti)cutRectForTile:(GEVec2i)tile {
    return geVec2iRectToVec2i(GEVec2iMake([self tileCutAxisLess:0 more:tile.x + tile.y], [self tileCutAxisLess:tile.y - tile.x more:_size.y - 1]), GEVec2iMake([self tileCutAxisLess:tile.x + tile.y more:_size.x + _size.y - 2], [self tileCutAxisLess:-_size.x + 1 more:tile.y - tile.x]));
}

- (ODClassType*)type {
    return [EGMapSso type];
}

+ (CGFloat)ISO {
    return _EGMapSso_ISO;
}

+ (ODClassType*)type {
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
    CNLazy* __lazy_axisVertexBuffer;
    EGMesh* _plane;
}
static ODClassType* _EGMapSsoView_type;
@synthesize map = _map;
@synthesize plane = _plane;

+ (id)mapSsoViewWithMap:(EGMapSso*)map {
    return [[EGMapSsoView alloc] initWithMap:map];
}

- (id)initWithMap:(EGMapSso*)map {
    self = [super init];
    if(self) {
        _map = map;
        __lazy_axisVertexBuffer = [CNLazy lazyWithF:^EGVertexBuffer*() {
            return ^EGVertexBuffer*() {
                GEMat4* mi = [EGCameraIso.m inverse];
                return [[EGVertexBuffer vec4] setData:[ arrs(GEVec4, 4) {[mi mulVec4:GEVec4Make(0.0, 0.0, 0.0, 1.0)], [mi mulVec4:GEVec4Make(1.0, 0.0, 0.0, 1.0)], [mi mulVec4:GEVec4Make(0.0, 1.0, 0.0, 1.0)], [mi mulVec4:GEVec4Make(0.0, 0.0, 1.0, 1.0)]}]];
            }();
        }];
        _plane = [self createPlane];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGMapSsoView_type = [ODClassType classTypeWithCls:[EGMapSsoView class]];
}

- (EGVertexBuffer*)axisVertexBuffer {
    return [__lazy_axisVertexBuffer get];
}

- (void)drawLayout {
    [[EGColorSource applyColor:GEVec4Make(1.0, 0.0, 0.0, 1.0)] drawVb:[self axisVertexBuffer] index:[ arrui4(2) {0, 1}] mode:GL_LINES];
    [[EGColorSource applyColor:GEVec4Make(0.0, 1.0, 0.0, 1.0)] drawVb:[self axisVertexBuffer] index:[ arrui4(2) {0, 2}] mode:GL_LINES];
    [[EGColorSource applyColor:GEVec4Make(0.0, 0.0, 1.0, 1.0)] drawVb:[self axisVertexBuffer] index:[ arrui4(2) {0, 3}] mode:GL_LINES];
}

- (EGMesh*)createPlane {
    GERecti limits = _map.limits;
    CGFloat l = geRectiX(limits) - 2.5;
    CGFloat r = geRectiX2(limits) + 0.5;
    CGFloat t = geRectiY(limits) - 2.5;
    CGFloat b = geRectiY2(limits) + 0.5;
    NSInteger w = geRectiWidth(limits) + 3;
    NSInteger h = geRectiHeight(limits) + 3;
    return [EGMesh applyVertexData:[ arrs(EGMeshData, 32) {0, 0, 0, 1, 0, l, 0, b, w, 0, 0, 1, 0, r, 0, b, w, h, 0, 1, 0, r, 0, t, 0, h, 0, 1, 0, l, 0, t}] indexData:[ arrui4(6) {0, 1, 2, 2, 3, 0}]];
}

- (void)drawPlaneWithMaterial:(EGMaterial*)material {
    glDisable(GL_CULL_FACE);
    [material drawMesh:_plane];
    glEnable(GL_CULL_FACE);
}

- (ODClassType*)type {
    return [EGMapSsoView type];
}

+ (ODClassType*)type {
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


