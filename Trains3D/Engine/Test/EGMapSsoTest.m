#import "EGMapSsoTest.h"

#import "EGMapIso.h"
#import "CNChain.h"
@implementation EGMapSsoTest
static CNClassType* _EGMapSsoTest_type;

+ (instancetype)mapSsoTest {
    return [[EGMapSsoTest alloc] init];
}

- (instancetype)init {
    self = [super init];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGMapSsoTest class]) _EGMapSsoTest_type = [CNClassType classTypeWithCls:[EGMapSsoTest class]];
}

- (void)testFullPartialTile {
    EGMapSso* map = [EGMapSso mapSsoWithSize:GEVec2iMake(2, 3)];
    assertTrue(([map isFullTile:GEVec2iMake(0, 2)]));
    assertTrue(([map isFullTile:GEVec2iMake(1, 0)]));
    assertTrue(([map isFullTile:GEVec2iMake(-1, 1)]));
    assertFalse(([map isFullTile:GEVec2iMake(-1, 0)]));
    assertTrue(([map isPartialTile:GEVec2iMake(-1, 0)]));
    assertFalse(([map isFullTile:GEVec2iMake(-2, 1)]));
    assertTrue(([map isPartialTile:GEVec2iMake(-2, 1)]));
    assertFalse(([map isFullTile:GEVec2iMake(-3, 1)]));
    assertFalse(([map isPartialTile:GEVec2iMake(-3, 1)]));
}

- (void)testFullTiles {
    EGMapSso* map = [EGMapSso mapSsoWithSize:GEVec2iMake(2, 3)];
    id<CNSet> exp = [[(@[tuple(@-1, @1), tuple(@0, @0), tuple(@0, @1), tuple(@0, @2), tuple(@1, @0), tuple(@1, @1), tuple(@1, @2), tuple(@2, @1)]) chain] toSet];
    id<CNSet> tiles = [[[map.fullTiles chain] mapF:^CNTuple*(id v) {
        return tuple((numi((uwrap(GEVec2i, v).x))), (numi((uwrap(GEVec2i, v).y))));
    }] toSet];
    assertEquals(exp, tiles);
}

- (void)testPartialTiles {
    EGMapSso* map = [EGMapSso mapSsoWithSize:GEVec2iMake(2, 3)];
    id<CNSet> exp = [[(@[tuple(@-2, @1), tuple(@-1, @0), tuple(@-1, @2), tuple(@0, @-1), tuple(@0, @3), tuple(@1, @-1), tuple(@1, @3), tuple(@2, @0), tuple(@2, @2), tuple(@3, @1)]) chain] toSet];
    id<CNSet> tiles = [[[map.partialTiles chain] mapF:^CNTuple*(id v) {
        return tuple((numi((uwrap(GEVec2i, v).x))), (numi((uwrap(GEVec2i, v).y))));
    }] toSet];
    assertEquals(exp, tiles);
}

- (NSString*)description {
    return @"MapSsoTest";
}

- (CNClassType*)type {
    return [EGMapSsoTest type];
}

+ (CNClassType*)type {
    return _EGMapSsoTest_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

