#import "Kiwi.h"
#import "EGMap.h"

#define p(x, y) val(EGMapPointMake(x, y))

SPEC_BEGIN(EGMapSpec)
    describe(@"Square isometric(Sso)", ^{
        describe(@"should determine full and partial tiles. ", ^{
            describe(@"For map size 2x3", ^{
                EGMapSize s = EGMapSizeMake(2, 3);
                it(@"the tile 0:2 should be full", ^{
                    [[theValue(egMapSsoIsFullTile(s, 0, 2)) should] beTrue];
                });
                it(@"the tile 1:0 should be full", ^{
                    [[theValue(egMapSsoIsFullTile(s, 1, 0)) should] beTrue];
                });
                it(@"the tile -1:1 should be full", ^{
                    [[theValue(egMapSsoIsFullTile(s, -1, 1)) should] beTrue];
                });
                it(@"the tile -1:0 should not be full", ^{
                    [[theValue(egMapSsoIsFullTile(s, -1, 0)) should] beFalse];
                });
                it(@"the list of full tiles should be [(-1,1), (0,0), (0,1), (0,2), (1,0), (1,1), (1,2), (2,1)]", ^{
                    NSArray *r = egMapSsoFullTiles(s);
                    [[r should] equal:@[
                            p(-1, 1),
                            p(0, 0), p(0, 1), p(0, 2),
                            p(1, 0), p(1, 1), p(1, 2),
                            p(2, 1)
                    ]];
                });
            });
        });
    });
SPEC_END