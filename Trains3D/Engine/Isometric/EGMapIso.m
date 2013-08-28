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
static CGFloat _ISO = 0.70710676908493;
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
            return [self isFullTile:uwrap(EGPointI, _)];
        }] toArray];
        _partialTiles = [[[self allPosibleTiles] filter:^BOOL(id _) {
            return [self isPartialTile:uwrap(EGPointI, _)];
        }] toArray];
        _allTiles = [_fullTiles arrayByAddingObject:_partialTiles];
    }
    
    return self;
}

- (BOOL)isFullTile:(EGPointI)tile {
    return tile.y + tile.x >= 0 && tile.y - tile.x <= _size.height - 1 && tile.y + tile.x <= _size.width + _size.height - 2 && tile.y - tile.x >= -_size.width + 1;
}

- (BOOL)isPartialTile:(EGPointI)tile {
    return tile.y + tile.x >= -1 && tile.y - tile.x <= _size.height && tile.y + tile.x <= _size.width + _size.height - 1 && tile.y - tile.x >= -_size.width && (tile.y + tile.x == -1 || tile.y - tile.x == _size.height || tile.y + tile.x == _size.width + _size.height - 1 || tile.y - tile.x == -_size.width);
}

- (CNChain*)allPosibleTiles {
    return [[[[CNRange rangeWithStart:_limits.x end:egRectIX2(_limits) step:1] chain] mul:[CNRange rangeWithStart:_limits.y end:egRectIY2(_limits) step:1]] map:^id(CNTuple* _) {
        return wrap(EGPointI, EGPointIMake(unumi(_.a), unumi(_.b)));
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

- (EGRectI)cutRectForTile:(EGPointI)tile {
    return egRectINewXY(((CGFloat)([self tileCutAxisLess:0 more:tile.x + tile.y])), ((CGFloat)([self tileCutAxisLess:tile.x + tile.y more:_size.width + _size.height - 2])), ((CGFloat)([self tileCutAxisLess:tile.y - tile.x more:_size.height - 1])), ((CGFloat)([self tileCutAxisLess:-_size.width + 1 more:tile.y - tile.x])));
}

+ (CGFloat)ISO {
    return _ISO;
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
    EGMeshModel* _plane;
}
@synthesize map = _map;
@synthesize plane = _plane;

+ (id)mapSsoViewWithMap:(EGMapSso*)map {
    return [[EGMapSsoView alloc] initWithMap:map];
}

- (id)initWithMap:(EGMapSso*)map {
    self = [super init];
    if(self) {
        _map = map;
        _plane = [EGMeshModel meshModelWithMeshes:(@[tuple([self createPlane], ((EGMaterial2*)([EGMaterial2 applyTexture:[EGTexture textureWithFile:@"Grass.png"]])))])];
    }
    
    return self;
}

- (void)drawLayout {
    glPushMatrix();
    egRotate(45.0, 0.0, 0.0, 1.0);
    glBegin(GL_LINES);
    CGFloat ISO = EGMapSso.ISO;
    EGSizeI size = _map.size;
    CGFloat left = -ISO;
    CGFloat top = ISO * size.height;
    CGFloat bottom = ISO * -size.width;
    CGFloat right = ISO * (size.width + size.height - 1);
    egNormal3(0.0, 0.0, 1.0);
    egVertex3(left, top, 0.0);
    egVertex3(left, bottom, 0.0);
    egVertex3(left, bottom, 0.0);
    egVertex3(right, bottom, 0.0);
    egVertex3(right, bottom, 0.0);
    egVertex3(right, top, 0.0);
    egVertex3(right, top, 0.0);
    egVertex3(left, top, 0.0);
    glEnd();
    glPopMatrix();
    egColor3(1.0, 1.0, 1.0);
    glBegin(GL_LINES);
    [_map.fullTiles forEach:^void(id tile) {
        EGPointI p = uwrap(EGPointI, tile);
        egNormal3(0.0, 0.0, 1.0);
        egVertex3(p.x - 0.5, p.y - 0.5, 0.0);
        egVertex3(p.x + 0.5, p.y - 0.5, 0.0);
        egVertex3(p.x + 0.5, p.y - 0.5, 0.0);
        egVertex3(p.x + 0.5, p.y + 0.5, 0.0);
        egVertex3(p.x + 0.5, p.y + 0.5, 0.0);
        egVertex3(p.x - 0.5, p.y + 0.5, 0.0);
        egVertex3(p.x - 0.5, p.y + 0.5, 0.0);
        egVertex3(p.x - 0.5, p.y - 0.5, 0.0);
    }];
    glEnd();
    egMapDrawAxis();
}

- (EGMesh*)createPlane {
    EGRectI limits = _map.limits;
    CGFloat l = limits.x - 1.5;
    CGFloat r = egRectIX2(limits) + 1.5;
    CGFloat t = limits.y - 1.5;
    CGFloat b = egRectIY2(limits) + 1.5;
    NSInteger w = limits.width + 3;
    NSInteger h = limits.height + 3;
    return [EGMesh applyVertexData:[ arrf4(32) {0, 0, 0, 0, 1, l, b, 0, w, 0, 0, 0, 1, r, b, 0, w, h, 0, 0, 1, r, t, 0, 0, h, 0, 0, 1, l, t, 0}] index:[ arruc(6) {0, 1, 2, 2, 3, 0}]];
}

- (void)drawPlane {
    [_plane draw];
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


