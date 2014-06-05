#import "PGMapIso.h"
#import "TRLevel.h"
#import "TRCity.h"
#import "TRLevelFactory.h"
#import "TSTestCase.h"
#import "CNFuture.h"
#import "CNChain.h"

#define CHECK_ANGLE(xx, yy, a1, a2) if(x == xx && y == yy) {assertTrue(angle == a1 || angle == a2);}

@interface TRLevelSpec : TSTestCase
@end

@implementation  TRLevelSpec
-(void)testTwoCityGeneration {
//       it(@"should generare two cities in a time of starting.\n"
//                "These cities should be generated on an edge of the map.\n"
//                "These cities should be generated in different tiles.\n"
//                "These cities should have a correct angle.", ^{
    [self repeatTimes:100 f:^{
        PGVec2i mapSize = PGVec2iMake(1, 3);
        TRLevel* level = [TRLevelFactory levelWithMapSize:mapSize];
        [[level create2Cities] getResultAwait:1.0];
        NSArray * c = (NSArray *) [[level cities] getResultAwait:1.0];
        assertEquals(numui(c.count), @2);

        //This cities should be generated on an edge of the map.
        [[[level cities] getResultAwait:1.0]  forEach:^(TRCityState *x) {
            PGVec2i tile = x.city.tile;
            assertTrue([level.map isPartialTile:tile]);
        }];

        //This cities should be generated in different tiles.
        NSSet *tilesSet = [[[[[level cities] getResultAwait:1.0] chain] mapF:^id(TRCityState *x) {
            return wrap(PGVec2i, x.city.tile);
        }] toSet];
        assertEquals(numui(tilesSet.count), @2);

        //These cities should have a correct angle
        [[[level cities] getResultAwait:1.0] forEach:^(TRCityState* xx) {
            TRCity* city = xx.city;
            NSInteger x = city.tile.x;
            NSInteger y = city.tile.y;
            NSInteger angle = [TRCityAngle value:city.angle].angle;

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
    }];
}
- (void) testCreateThirdCity {
    PGVec2i mapSize = PGVec2iMake(1, 3);
    TRLevel* level = [TRLevelFactory levelWithMapSize:mapSize];
    [level create2Cities];
    [[level createNewCity] waitResultPeriod:1.0];
}
@end