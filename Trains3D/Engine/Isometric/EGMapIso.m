#import "EGMapIso.h"

@implementation EGMapSso
static CGFloat _EGMapSso_ISO = 0.70710678118655;
static ODClassType* _EGMapSso_type;
@synthesize size = _size;
@synthesize limits = _limits;
@synthesize fullTiles = _fullTiles;
@synthesize partialTiles = _partialTiles;
@synthesize allTiles = _allTiles;

+ (instancetype)mapSsoWithSize:(GEVec2i)size {
    return [[EGMapSso alloc] initWithSize:size];
}

- (instancetype)initWithSize:(GEVec2i)size {
    self = [super init];
    __weak EGMapSso* _weakSelf = self;
    if(self) {
        _size = size;
        _limits = geVec2iRectToVec2i((GEVec2iMake((1 - _size.y) / 2 - 1, (1 - _size.x) / 2 - 1)), (GEVec2iMake((2 * _size.x + _size.y - 3) / 2 + 1, (_size.x + 2 * _size.y - 3) / 2 + 1)));
        _fullTiles = [[[self allPosibleTiles] filter:^BOOL(id _) {
            EGMapSso* _self = _weakSelf;
            return [_self isFullTile:uwrap(GEVec2i, _)];
        }] toArray];
        _partialTiles = [[[self allPosibleTiles] filter:^BOOL(id _) {
            EGMapSso* _self = _weakSelf;
            return [_self isPartialTile:uwrap(GEVec2i, _)];
        }] toArray];
        _allTiles = [_fullTiles addSeq:_partialTiles];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGMapSso class]) _EGMapSso_type = [ODClassType classTypeWithCls:[EGMapSso class]];
}

- (BOOL)isFullTile:(GEVec2i)tile {
    return tile.y + tile.x >= 0 && tile.y - tile.x <= _size.y - 1 && tile.y + tile.x <= _size.x + _size.y - 2 && tile.y - tile.x >= -_size.x + 1;
}

- (BOOL)isPartialTile:(GEVec2i)tile {
    return tile.y + tile.x >= -1 && tile.y - tile.x <= _size.y && tile.y + tile.x <= _size.x + _size.y - 1 && tile.y - tile.x >= -_size.x && (tile.y + tile.x == -1 || tile.y - tile.x == _size.y || tile.y + tile.x == _size.x + _size.y - 1 || tile.y - tile.x == -_size.x);
}

- (BOOL)isLeftTile:(GEVec2i)tile {
    return tile.y + tile.x == -1;
}

- (BOOL)isTopTile:(GEVec2i)tile {
    return tile.y - tile.x == _size.y;
}

- (BOOL)isRightTile:(GEVec2i)tile {
    return tile.y + tile.x == _size.x + _size.y - 1;
}

- (BOOL)isBottomTile:(GEVec2i)tile {
    return tile.y - tile.x == -_size.x;
}

- (BOOL)isVisibleTile:(GEVec2i)tile {
    return tile.y + tile.x >= -1 && tile.y - tile.x <= _size.y && tile.y + tile.x <= _size.x + _size.y - 1 && tile.y - tile.x >= -_size.x;
}

- (BOOL)isVisibleVec2:(GEVec2)vec2 {
    return vec2.y + vec2.x >= -1 && vec2.y - vec2.x <= _size.y && vec2.y + vec2.x <= _size.x + _size.y - 1 && vec2.y - vec2.x >= -_size.x;
}

- (GEVec2)distanceToMapVec2:(GEVec2)vec2 {
    return GEVec2Make(((vec2.y + vec2.x < -1) ? vec2.y + vec2.x + 1 : ((vec2.y + vec2.x > _size.x + _size.y - 1) ? (vec2.y + vec2.x - _size.x) - _size.y + 1 : 0.0)), ((vec2.y - vec2.x > _size.y) ? (vec2.y - vec2.x) - _size.y : ((vec2.y - vec2.x < -_size.x) ? vec2.y - vec2.x + _size.x : 0.0)));
}

- (CNChain*)allPosibleTiles {
    return [[[[CNRange rangeWithStart:geRectIX(_limits) end:geRectIX2(_limits) step:1] chain] mul:[CNRange rangeWithStart:geRectIY(_limits) end:geRectIY2(_limits) step:1]] map:^id(CNTuple* _) {
        return wrap(GEVec2i, (GEVec2iMake(unumi(((CNTuple*)(_)).a), unumi(((CNTuple*)(_)).b))));
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
    [description appendFormat:@"x=%ld", (long)self.x];
    [description appendFormat:@", y=%ld", (long)self.y];
    [description appendFormat:@", x2=%ld", (long)self.x2];
    [description appendFormat:@", y2=%ld", (long)self.y2];
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



