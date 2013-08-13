#import "Kiwi.h"
#import "EGMapIso.h"
#import "TRLevel.h"
#import "TRCity.h"
#import "TRLevelFactory.h"

#define CHECK_ANGLE(xx, yy, a1, a2) if(x == xx && y == yy) [[theValue(angle == a1 || angle == a2) should] beTrue];

SPEC_BEGIN(TRLevelSpec)
    describe(@"TRLevel", ^{
        EGSizeI mapSize = EGSizeIMake(1, 3);
        it(@"should generare two cities in a time of starting.\n"
                "These cities should be generated on an edge of the map.\n"
                "These cities should be generated in different tiles.\n"
                "These cities should have a correct angle.", ^{

            for(int i = 0; i < 500; i++) {
                @autoreleasepool {
                    TRLevel* level = [TRLevelFactory levelWithMapSize:mapSize];
                    [[[level cities] should] haveCountOf:2];

                    //This cities should be generated on an edge of the map.
                    [[level cities] forEach:^(TRCity* x) {
                        EGPointI tile = x.tile;
                        BOOL isPartial = [level.map isPartialTile:tile];
                        [[theValue(isPartial) should] beTrue];
                    }];

                    //This cities should be generated in different tiles.
                    NSSet *tilesSet = [[[level cities] map:^id(TRCity *x) {
                        return val(x.tile);
                    }] toSet];
                    [[tilesSet should] haveCountOf:2];

                    //These cities should have a correct angle
                    [[level cities] forEach:^(TRCity* city) {
                        NSInteger x = city.tile.x;
                        NSInteger y = city.tile.y;
                        NSInteger angle = city.angle.angle;

                        CHECK_ANGLE(-2, 1, 0, -1)
                        else CHECK_ANGLE(-1, 0, 0, 270)
                        else CHECK_ANGLE(0, -1, 270, -1)
                        else CHECK_ANGLE(1, 0, 180, 270)
                        else CHECK_ANGLE(2, 1, 180, -1)
                        else CHECK_ANGLE(1, 2, 90, 180)
                        else CHECK_ANGLE(0, 3, 90, -1)
                        else CHECK_ANGLE(-1, 2, 0, 90)
                        else @throw [NSString stringWithFormat:@"Incorrect tile %i, %i", (int) x, (int) y];

                    }];
                }
            }
        });

        it(@".createNewCity should create third city on the first call", ^{
            TRLevel* level = [TRLevelFactory levelWithMapSize:mapSize];
            [level createNewCity];
        });
    });
SPEC_END