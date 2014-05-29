#import "TRLevel.h"
#import "TSTestCase.h"

#define p(fform, xx) trRailPointApplyTileFormXBack(t0, TRRailForm_##fform, xx, NO).point
#define pb(fform, xx) trRailPointApplyTileFormXBack(t0, TRRailForm_##fform, xx, YES).point
#define chechPoints(p1, p2) assertTrue(geVec2IsEqualTo(p1, p2))
#define egp(x, y) GEVec2Make(x, y)

@interface TRRailPointSpec : TSTestCase
@end

@implementation TRRailPointSpec
-(void) testTranslationToRealPoint {
    GEVec2i t0 = GEVec2iMake(0, 0);
    CGFloat sin45_2 = sqrt(2.0)/4.0;
    CGFloat tl = [TRRailForm_leftTop_Desc length];
    CGFloat tl2 = tl/2;

//    it(@"for form leftRight", ^{
        chechPoints(p(leftRight, 0), egp(-0.5, 0));
        chechPoints(pb(leftRight, 0), egp(0.5, 0));
        chechPoints(p(leftRight, 0.5), egp(0, 0));
        chechPoints(p(leftRight, 1), egp(0.5, 0));
//    });
//    it(@"for form bottomTop", ^{
        chechPoints(p(bottomTop, 0), egp(0, -0.5));
        chechPoints(p(bottomTop, 0.5), egp(0, 0));
        chechPoints(p(bottomTop, 1), egp(0, 0.5));
//    });

//    it(@"for form leftTop", ^{
        chechPoints(p(leftTop, 0), egp(-0.5, 0));
        chechPoints(p(leftTop, tl2), egp(-0.5 + sin45_2, 0.5 - sin45_2));
        chechPoints(p(leftTop, tl), egp(0, 0.5));
//    });

//    it(@"for form leftBottom", ^{
        chechPoints(p(leftBottom, 0), egp(-0.5, 0));
        chechPoints(p(leftBottom, tl2), egp(-0.5 + sin45_2, -0.5 + sin45_2));
        chechPoints(p(leftBottom, tl), egp(0, -0.5));
//    });

//    it(@"for form bottomRight", ^{
        chechPoints(p(bottomRight, 0), egp(0, -0.5));
        chechPoints(p(bottomRight, tl2), egp(0.5 - sin45_2, -0.5 + sin45_2));
        chechPoints(p(bottomRight, tl), egp(0.5, 0));
//    });
//    it(@"for form topRight", ^{
        chechPoints(p(topRight, 0), egp(0, 0.5));
        chechPoints(p(topRight, tl2), egp(0.5 - sin45_2, 0.5 - sin45_2));
        chechPoints(p(topRight, tl), egp(0.5, 0));
//    });
}
@end