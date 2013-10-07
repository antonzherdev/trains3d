#import "EGMapIso.h"

#import "EGCameraIso.h"
#import "GEMat4.h"
#import "EGMaterial.h"
#import "GL.h"
@implementation EGMapSso{
    GEVec2i _size;
    GERectI _limits;
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
        _allTiles = [_fullTiles addSeq:_partialTiles];
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
    return [[[[CNRange rangeWithStart:geRectIX(_limits) end:geRectIX2(_limits) step:1] chain] mul:[CNRange rangeWithStart:geRectIY(_limits) end:geRectIY2(_limits) step:1]] map:^id(CNTuple* _) {
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

- (EGMapTileCutState)cutStateForTile:(GEVec2i)tile {
    return EGMapTileCutStateMake([self tileCutAxisLess:0 more:tile.x + tile.y], [self tileCutAxisLess:tile.y - tile.x more:_size.y - 1], [self tileCutAxisLess:tile.x + tile.y more:_size.x + _size.y - 2], [self tileCutAxisLess:-_size.x + 1 more:tile.y - tile.x]);
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


NSString* EGMapTileCutStateDescription(EGMapTileCutState self) {
    NSMutableString* description = [NSMutableString stringWithString:@"<EGMapTileCutState: "];
    [description appendFormat:@"x=%li", self.x];
    [description appendFormat:@", y=%li", self.y];
    [description appendFormat:@", x2=%li", self.x2];
    [description appendFormat:@", y2=%li", self.y2];
    [description appendString:@">"];
    return description;
}
ODPType* egMapTileCutStateType() {
    static ODPType* _ret = nil;
    if(_ret == nil) _ret = [ODPType typeWithCls:[EGMapTileCutStateWrap class] name:@"EGMapTileCutState" size:sizeof(EGMapTileCutState) wrap:^id(void* data, NSUInteger i) {
        return wrap(EGMapTileCutState, ((EGMapTileCutState*)(data))[i]);
    }];
    return _ret;
}
@implementation EGMapTileCutStateWrap{
    EGMapTileCutState _value;
}
@synthesize value = _value;

+ (id)wrapWithValue:(EGMapTileCutState)value {
    return [[EGMapTileCutStateWrap alloc] initWithValue:value];
}

- (id)initWithValue:(EGMapTileCutState)value {
    self = [super init];
    if(self) _value = value;
    return self;
}

- (NSString*)description {
    return EGMapTileCutStateDescription(_value);
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGMapTileCutStateWrap* o = ((EGMapTileCutStateWrap*)(other));
    return EGMapTileCutStateEq(_value, o.value);
}

- (NSUInteger)hash {
    return EGMapTileCutStateHash(_value);
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
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
        _plane = ^EGMesh*() {
            GERectI limits = _map.limits;
            CGFloat l = geRectIX(limits) - 2.5;
            CGFloat r = geRectIX2(limits) + 0.5;
            CGFloat t = geRectIY(limits) - 2.5;
            CGFloat b = geRectIY2(limits) + 0.5;
            NSInteger w = geRectIWidth(limits) + 3;
            NSInteger h = geRectIHeight(limits) + 3;
            return [EGMesh applyVertexData:[ arrs(EGMeshData, 4) {EGMeshDataMake(GEVec2Make(0.0, 0.0), GEVec3Make(0.0, 1.0, 0.0), GEVec3Make(((float)(l)), 0.0, ((float)(b)))), EGMeshDataMake(GEVec2Make(((float)(w)), 0.0), GEVec3Make(0.0, 1.0, 0.0), GEVec3Make(((float)(r)), 0.0, ((float)(b)))), EGMeshDataMake(GEVec2Make(((float)(w)), ((float)(h))), GEVec3Make(0.0, 1.0, 0.0), GEVec3Make(((float)(r)), 0.0, ((float)(t)))), EGMeshDataMake(GEVec2Make(0.0, ((float)(h))), GEVec3Make(0.0, 1.0, 0.0), GEVec3Make(((float)(l)), 0.0, ((float)(t))))}] indexData:[ arrui4(6) {0, 1, 2, 2, 3, 0}]];
        }();
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGMapSsoView_type = [ODClassType classTypeWithCls:[EGMapSsoView class]];
}

- (EGVertexBuffer*)axisVertexBuffer {
    return ((EGVertexBuffer*)([__lazy_axisVertexBuffer get]));
}

- (void)drawLayout {
    [[EGColorSource applyColor:GEVec4Make(1.0, 0.0, 0.0, 1.0)] drawVb:[self axisVertexBuffer] index:[ arrui4(2) {0, 1}] mode:((unsigned int)(GL_LINES))];
    [[EGColorSource applyColor:GEVec4Make(0.0, 1.0, 0.0, 1.0)] drawVb:[self axisVertexBuffer] index:[ arrui4(2) {0, 2}] mode:((unsigned int)(GL_LINES))];
    [[EGColorSource applyColor:GEVec4Make(0.0, 0.0, 1.0, 1.0)] drawVb:[self axisVertexBuffer] index:[ arrui4(2) {0, 3}] mode:((unsigned int)(GL_LINES))];
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


