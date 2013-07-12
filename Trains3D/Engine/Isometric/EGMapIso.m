#import "EGMapIso.h"

#import "EGGL.h"
#import "EGMap.h"
@implementation EGMapSso{
    EGISize _size;
    EGIRect _limits;
    NSArray* _fullTiles;
    NSArray* _partialTiles;
}
@synthesize size = _size;
@synthesize limits = _limits;
@synthesize fullTiles = _fullTiles;
@synthesize partialTiles = _partialTiles;

+ (id)mapSsoWithSize:(EGISize)size {
    return [[EGMapSso alloc] initWithSize:size];
}

- (id)initWithSize:(EGISize)size {
    self = [super init];
    if(self) {
        _size = size;
        _limits = EGIRectMake((1 - _size.height) / 2 - 1, (1 - _size.width) / 2 - 1, (2 * _size.width + _size.height - 3) / 2 + 1, (_size.width + 2 * _size.height - 3) / 2 + 1);
        _fullTiles = [[[self allPosibleTiles] filter:^BOOL(id _) {
            return [self isFullTile:uval(EGIPoint, _)];
        }] array];
        _partialTiles = [[[self allPosibleTiles] filter:^BOOL(id _) {
            return [self isPartialTile:uval(EGIPoint, _)];
        }] array];
    }
    
    return self;
}

- (BOOL)isFullTile:(EGIPoint)tile {
    return tile.y + tile.x >= 0 && tile.y - tile.x <= _size.height - 1 && tile.y + tile.x <= _size.width + _size.height - 2 && tile.y - tile.x >= -_size.width + 1;
}

- (BOOL)isPartialTile:(EGIPoint)tile {
    return tile.y + tile.x >= -1 && tile.y - tile.x <= _size.height && tile.y + tile.x <= _size.width + _size.height - 1 && tile.y - tile.x >= -_size.width && (tile.y + tile.x == -1 || tile.y - tile.x == _size.height || tile.y + tile.x == _size.width + _size.height - 1 || tile.y - tile.x == -_size.width);
}

- (void)drawLayout {
    glPushMatrix();
    egRotate(45, 0, 0, 1);
    glBegin(GL_LINES);
    CGFloat left = -ISO;
    CGFloat top = ISO * _size.height;
    CGFloat bottom = ISO * -_size.width;
    CGFloat right = ISO * _size.width + _size.height - 1;
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
        EGIPoint p = uval(EGIPoint, tile);
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
    CGFloat l = _limits.left - 1.5;
    CGFloat r = _limits.right + 1.5;
    CGFloat t = _limits.top - 1.5;
    CGFloat b = _limits.bottom + 1.5;
    NSInteger w = _limits.right - _limits.left + 3;
    NSInteger h = _limits.bottom - _limits.top + 3;
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
    return [[[CNChain chainWithStart:_limits.left end:_limits.right step:1] mul:[CNChain chainWithStart:_limits.top end:_limits.bottom step:1]] map:^id(CNTuple* _) {
        return val(EGIPointMake(unumi(_.a), unumi(_.b)));
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

- (EGIRect)cutRectForTile:(EGIPoint)tile {
    return EGIRectMake([self tileCutAxisLess:0 more:tile.x + tile.y], [self tileCutAxisLess:tile.y - tile.x more:_size.height - 1], [self tileCutAxisLess:tile.x + tile.y more:_size.width + _size.height - 2], [self tileCutAxisLess:-_size.width + 1 more:tile.y - tile.x]);
}

@end


