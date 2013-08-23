#import "EGMapIso.h"

#import "EGGL.h"
#import "EGMap.h"
#import "CNChain.h"
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

- (void)drawLayout {
    glPushMatrix();
    egRotate(((CGFloat)(45)), ((CGFloat)(0)), ((CGFloat)(0)), ((CGFloat)(1)));
    glBegin(GL_LINES);
    CGFloat left = -_ISO;
    CGFloat top = _ISO * _size.height;
    CGFloat bottom = _ISO * -_size.width;
    CGFloat right = _ISO * (_size.width + _size.height - 1);
    egNormal3(((CGFloat)(0)), ((CGFloat)(0)), ((CGFloat)(1)));
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
        EGPointI p = uwrap(EGPointI, tile);
        egNormal3(((CGFloat)(0)), ((CGFloat)(0)), ((CGFloat)(1)));
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
    CGFloat l = _limits.x - 1.5;
    CGFloat r = egRectIX2(_limits) + 1.5;
    CGFloat t = _limits.y - 1.5;
    CGFloat b = egRectIY2(_limits) + 1.5;
    NSInteger w = _limits.width + 3;
    NSInteger h = _limits.height + 3;
    egNormal3(((CGFloat)(0)), ((CGFloat)(0)), ((CGFloat)(1)));
    egTexCoord2(0.0, 0.0);
    egVertex3(l, b, ((CGFloat)(0)));
    egTexCoord2(((CGFloat)(w)), 0.0);
    egVertex3(r, b, ((CGFloat)(0)));
    egTexCoord2(((CGFloat)(w)), ((CGFloat)(h)));
    egVertex3(r, t, ((CGFloat)(0)));
    egTexCoord2(0.0, ((CGFloat)(h)));
    egVertex3(l, t, ((CGFloat)(0)));
    glEnd();
    glPopMatrix();
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


