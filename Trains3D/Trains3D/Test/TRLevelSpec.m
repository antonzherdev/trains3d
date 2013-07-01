#import "Kiwi.h"
#import "TRLevel.h"

SPEC_BEGIN(TRLevelSpec)
    describe(@"TRLevel", ^{
        EGMapSize mapSize = EGMapSizeMake(10, 7);
        it(@"should generare two cities in a time of starting.\n"
                "This cities should be generated on an edge of the map.\n"
                "This cities should be generated in different tiles.", ^{

            for(int i = 0; i < 500; i++) {
                @autoreleasepool {
                    TRLevel* level = [TRLevel levelWithMapSize:mapSize];
                    [[[level cities] should] haveCountOf:2];

                    //This cities should be generated on an edge of the map.
                    [[level cities] forEach:^(TRCity* x) {
                        EGMapPoint tile = x.tile;
                        BOOL isPartial = egMapSsoIsPartialTile(mapSize, tile.x, tile.y);
                        [[theValue(isPartial) should] beTrue];
                    }];

                    //This cities should be generated in different tiles.
                    NSSet *tilesSet = [[[level cities] map:^id(TRCity *x) {
                        return val(x.tile);
                    }] set];
                    [[tilesSet should] haveCountOf:2];
                }
            }
        });

        it(@".createNewCity should create third city on the first call", ^{
            TRLevel* level = [TRLevel levelWithMapSize:mapSize];
            [level createNewCity];
        });
    });
SPEC_END