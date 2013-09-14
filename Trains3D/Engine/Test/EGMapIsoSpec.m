#import "Kiwi.h"
#import "EGMapIso.h"

#define p(x, y) tuple(numi(x), numi(y))
NSArray * pointToTuples(NSArray * arr) {
    return [[[arr chain] map:^id(id x) {
        GEVec2I p = uwrap(GEVec2I, x);
        return tuple(numi(p.x), numi(p.y));
    }] toArray];
}
SPEC_BEGIN(EGMapIsoSpec)
    describe(@"Square isometric(Sso)", ^{
        describe(@"should determine full and partial tiles. ", ^{
            describe(@"For map size 2x3", ^{
                EGMapSso* m = [EGMapSso mapSsoWithSize:GEVec2IMake(2, 3)];
                it(@"the tile 0:2 should be full", ^{
                    [[theValue([m isFullTile:GEVec2IMake(0, 2)]) should] beTrue];
                });
                it(@"the tile 1:0 should be full", ^{
                    [[theValue([m isFullTile:GEVec2IMake(1, 0)]) should] beTrue];
                });
                it(@"the tile -1:1 should be full", ^{
                    [[theValue([m isFullTile:GEVec2IMake(-1, 1)]) should] beTrue];
                });
                it(@"the tile -1:0 should not be full but should be partial", ^{
                    [[theValue([m isFullTile:GEVec2IMake(-1, 0)]) should] beFalse];
                    [[theValue([m isPartialTile:GEVec2IMake(-1, 0)]) should] beTrue];
                });
                it(@"the tile -2:1 should not be full but should be partial", ^{
                    [[theValue([m isFullTile:GEVec2IMake(-2, 1)]) should] beFalse];
                    [[theValue([m isPartialTile:GEVec2IMake(-2, 1)]) should] beTrue];
                });
                it(@"the tile -3:1 should not be full and should not be partial", ^{
                    [[theValue([m isFullTile:GEVec2IMake(-3, 1)]) should] beFalse];
                    [[theValue([m isPartialTile:GEVec2IMake(-3, 1)]) should] beFalse];
                });
                it(@"the list of full tiles should be [(-1,1), (0,0), (0,1), (0,2), (1,0), (1,1), (1,2), (2,1)]", ^{
                    NSArray *r = pointToTuples(m.fullTiles);
                    [[r should] equal:@[
                            p(-1, 1),
                            p(0, 0), p(0, 1), p(0, 2),
                            p(1, 0), p(1, 1), p(1, 2),
                            p(2, 1)
                    ]];
                });
                it(@"the list of patrial tiles should be [(-2,1), (-1,0), (-1,2), (0,-1), (0,3), (1,-1), (1,3), (2,0), (2,2), (3,1)]", ^{
                    NSArray *r = pointToTuples(m.partialTiles);
                    [[r should] equal:@[
                            p(-2, 1),
                            p(-1, 0), p(-1, 2),
                            p(0, -1), p(0, 3),
                            p(1, -1), p(1, 3),
                            p(2, 0), p(2, 2),
                            p(3, 1),
                    ]];
                });
            });
        });
    });
SPEC_END