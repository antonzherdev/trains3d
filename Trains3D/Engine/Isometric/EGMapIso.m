#import "EGMapIso.h"

#import "EGGL.h"
#import "EGMap.h"
#import "CNChain.h"
#import "CNRange.h"
@implementation EGMapSso{
    EGSizeI _size;
    EGRectI _limits;
    NSArray* _fullTiles;
    NSArray* _partialTiles;
    NSArray* _allTiles;
}
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
        _limits = egRectINewXY((1 - _size.height) / 2 - 1, (2 * _size.width + _size.height - 3) / 2 + 1, (1 - _size.width) / 2 - 1, (_size.width + 2 * _size.height - 3) / 2 + 1);
        _fullTiles = [[[self allPosibleTiles] filter:^BOOL(id _) {
            return [self isFullTile:uval(EGPointI, _)];
        }] toArray];
        _partialTiles = [[[self allPosibleTiles] filter:^BOOL(id _) {
            return [self isPartialTile:uval(EGPointI, _)];
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

- (void)drawLayout {
    glPushMatrix();
    egRotate(45, 0, 0, 1);
    glBegin(GL_LINES);
    double left = -ISO;
    double top = ISO * _size.height;
    double bottom = ISO * -_size.width;
    double right = ISO * (_size.width + _size.height - 1);
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
    [_fullTiles forEach:^void(id tile) {
        EGPointI p = uval(EGPointI, tile);
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

- (void)drawPlane {
    glBegin(GL_QUADS);
    double l = _limits.x - 1.5;
    double r = egRectIX2(_limits) + 1.5;
    double t = _limits.y - 1.5;
    double b = egRectIY2(_limits) + 1.5;
    NSInteger w = _limits.width + 3;
    NSInteger h = _limits.height + 3;
    egTexCoord2(0.0, 0.0);
    egVertex3(l, b, 0);
    egTexCoord2(w, 0.0);
    egVertex3(r, b, 0);
    egTexCoord2(w, h);
    egVertex3(r, t, 0);
    egTexCoord2(0.0, h);
    egVertex3(l, t, 0);
    glEnd();
    glPopMatrix();
}

- (CNChain*)allPosibleTiles {
    return [[[[CNRange rangeWithStart:_limits.x end:egRectIX2(_limits) step:1] chain] mul:[CNRange rangeWithStart:_limits.y end:egRectIY2(_limits) step:1]] map:^id(CNTuple* _) {
        return val(EGPointIMake(unumi(_.a), unumi(_.b)));
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
    return egRectINewXY([self tileCutAxisLess:0 more:tile.x + tile.y], [self tileCutAxisLess:tile.x + tile.y more:_size.width + _size.height - 2], [self tileCutAxisLess:tile.y - tile.x more:_size.height - 1], [self tileCutAxisLess:-_size.width + 1 more:tile.y - tile.x]);
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGMapSso* o = ((EGMapSso*)other);
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


