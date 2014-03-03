#import "EGMapIso.h"
#import "TRLevel.h"
#import "TRCity.h"
#import "TRLevelFactory.h"
#import "TSTestCase.h"

#define CHECK_ANGLE(xx, yy, a1, a2) if(x == xx && y == yy) {assertTrue(angle == a1 || angle == a2);}

@interface TRLevelSpec : TSTestCase
@end

@implementation  TRLevelSpec
-(void)testTwoCityGeneration {
    GEVec2i mapSize = GEVec2iMake(1, 3);
//       it(@"should generare two cities in a time of starting.\n"
//                "These cities should be generated on an edge of the map.\n"
//                "These cities should be generated in different tiles.\n"
//                "These cities should have a correct angle.", ^{
    [self repeatTimes:500 f:^{
        TRLevel* level = [TRLevelFactory levelWithMapSize:mapSize];
        [level createNewCity];
        [level createNewCity];
        NSArray * c = (NSArray *) [level cities];
        assertEquals(numui(c.count), @2);

        //This cities should be generated on an edge of the map.
        [[level cities] forEach:^(TRCity* x) {
            GEVec2i tile = x.tile;
            assertTrue([level.map isPartialTile:tile]);
        }];

        //This cities should be generated in different tiles.
        NSSet *tilesSet = [[[[level cities] chain] map:^id(TRCity *x) {
            return wrap(GEVec2i, x.tile);
        }] toSet];
        assertEquals(numui(tilesSet.count), @2);

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
    }];
}
- (void) testCreateThirdCity {
    GEVec2i mapSize = GEVec2iMake(1, 3);
    TRLevel* level = [TRLevelFactory levelWithMapSize:mapSize];
    [level createNewCity];
}
@end