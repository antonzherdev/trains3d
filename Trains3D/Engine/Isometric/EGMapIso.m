#import "EGMapIso.h"

#import "CNChain.h"
#import "CNRange.h"
#import "CNData.h"
#import "EG.h"
#import "EGMap.h"
#import "EGMesh.h"
#import "EGMaterial.h"
#import "EGTexture.h"
#import "EGBuffer.h"
#import "EGShader.h"
#import "EGContext.h"
@implementation EGMapSso{
    EGSizeI _size;
    EGRectI _limits;
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

+ (id)mapSsoWithSize:(EGSizeI)size {
    return [[EGMapSso alloc] initWithSize:size];
}

- (id)initWithSize:(EGSizeI)size {
    self = [super init];
    if(self) {
        _size = size;
        _limits = egRectINewXY(((CGFloat)((1 - _size.height) / 2 - 1)), ((CGFloat)((2 * _size.width + _size.height - 3) / 2 + 1)), ((CGFloat)((1 - _size.width) / 2 - 1)), ((CGFloat)((_size.width + 2 * _size.height - 3) / 2 + 1)));
        _fullTiles = [[[self allPosibleTiles] filter:^BOOL(id _) {
            return [self isFullTile:uwrap(EGVec2I, _)];
        }] toArray];
        _partialTiles = [[[self allPosibleTiles] filter:^BOOL(id _) {
            return [self isPartialTile:uwrap(EGVec2I, _)];
        }] toArray];
        _allTiles = [_fullTiles arrayByAddingObject:_partialTiles];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGMapSso_type = [ODClassType classTypeWithCls:[EGMapSso class]];
}

- (BOOL)isFullTile:(EGVec2I)tile {
    return tile.y + tile.x >= 0 && tile.y - tile.x <= _size.height - 1 && tile.y + tile.x <= _size.width + _size.height - 2 && tile.y - tile.x >= -_size.width + 1;
}

- (BOOL)isPartialTile:(EGVec2I)tile {
    return tile.y + tile.x >= -1 && tile.y - tile.x <= _size.height && tile.y + tile.x <= _size.width + _size.height - 1 && tile.y - tile.x >= -_size.width && (tile.y + tile.x == -1 || tile.y - tile.x == _size.height || tile.y + tile.x == _size.width + _size.height - 1 || tile.y - tile.x == -_size.width);
}

- (CNChain*)allPosibleTiles {
    return [[[[CNRange rangeWithStart:_limits.x end:egRectIX2(_limits) step:1] chain] mul:[CNRange rangeWithStart:_limits.y end:egRectIY2(_limits) step:1]] map:^id(CNTuple* _) {
        return wrap(EGVec2I, EGVec2IMake(unumi(_.a), unumi(_.b)));
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

- (EGRectI)cutRectForTile:(EGVec2I)tile {
    return egRectINewXY(((CGFloat)([self tileCutAxisLess:0 more:tile.x + tile.y])), ((CGFloat)([self tileCutAxisLess:tile.x + tile.y more:_size.width + _size.height - 2])), ((CGFloat)([self tileCutAxisLess:tile.y - tile.x more:_size.height - 1])), ((CGFloat)([self tileCutAxisLess:-_size.width + 1 more:tile.y - tile.x])));
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
    return EGSizeIEq(self.size, o.size);
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + EGSizeIHash(self.size);
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"size=%@", EGSizeIDescription(self.size)];
    [description appendString:@">"];
    return description;
}

@end


@implementation EGMapSsoView{
    EGMapSso* _map;
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
    EGRectI limits = _map.limits;
    CGFloat l = limits.x - 2.5;
    CGFloat r = egRectIX2(limits) + 0.5;
    CGFloat t = limits.y - 2.5;
    CGFloat b = egRectIY2(limits) + 0.5;
    NSInteger w = limits.width + 3;
    NSInteger h = limits.height + 3;
    return [EGMesh applyVertexData:[ arrf4(32) {0, 0, 0, 1, 0, l, 0, b, w, 0, 0, 1, 0, r, 0, b, w, h, 0, 1, 0, r, 0, t, 0, h, 0, 1, 0, l, 0, t}] index:[ arrui4(6) {0, 1, 2, 2, 3, 0}]];
}

- (void)drawPlaneWithMaterial:(EGMaterial*)material {
    glDisable(GL_CULL_FACE);
    [_plane drawWithMaterial:material];
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


