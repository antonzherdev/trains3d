#import "Kiwi.h"
#import "TRLevel.h"
#import "TRRailPoint.h"

#define p(form, x) trRailPointPoint(TRRailPointMake(t0, [[TRRailForm form] ordinal], x, NO))
#define pb(form, x) trRailPointPoint(TRRailPointMake(t0, [[TRRailForm form] ordinal], x, YES))
#define chechPoints(p1, p2) [[theValue(EGPointEq(p1, p2)) should] beTrue]
#define egp(x, y) EGPointMake(x, y)

SPEC_BEGIN(TRRailPointSpec)
    describe(@"TRRailPoint", ^{
        describe(@"should translate itself to CGPoint", ^{
            EGPointI t0 = EGPointIMake(0, 0);
            CGFloat sin45_2 = sqrt(2.0)/4.0;
            CGFloat tl = [[TRRailForm leftTop] length];
            CGFloat tl2 = tl/2;

            it(@"for form leftRight", ^{
                chechPoints(p(leftRight, 0), egp(-0.5, 0));
                chechPoints(pb(leftRight, 0), egp(0.5, 0));
                chechPoints(p(leftRight, 0.5), egp(0, 0));
                chechPoints(p(leftRight, 1), egp(0.5, 0));
            });
            it(@"for form bottomTop", ^{
                chechPoints(p(bottomTop, 0), egp(0, -0.5));
                chechPoints(p(bottomTop, 0.5), egp(0, 0));
                chechPoints(p(bottomTop, 1), egp(0, 0.5));
            });

            it(@"for form leftTop", ^{
                chechPoints(p(leftTop, 0), egp(-0.5, 0));
                chechPoints(p(leftTop, tl2), egp(-0.5 + sin45_2, 0.5 - sin45_2));
                chechPoints(p(leftTop, tl), egp(0, 0.5));
            });

            it(@"for form leftBottom", ^{
                chechPoints(p(leftBottom, 0), egp(-0.5, 0));
                chechPoints(p(leftBottom, tl2), egp(-0.5 + sin45_2, -0.5 + sin45_2));
                chechPoints(p(leftBottom, tl), egp(0, -0.5));
            });

            it(@"for form bottomRight", ^{
                chechPoints(p(bottomRight, 0), egp(0, -0.5));
                chechPoints(p(bottomRight, tl2), egp(0.5 - sin45_2, -0.5 + sin45_2));
                chechPoints(p(bottomRight, tl), egp(0.5, 0));
            });
            it(@"for form topRight", ^{
                chechPoints(p(topRight, 0), egp(0, 0.5));
                chechPoints(p(topRight, tl2), egp(0.5 - sin45_2, 0.5 - sin45_2));
                chechPoints(p(topRight, tl), egp(0.5, 0));
            });
        });
    });
SPEC_END