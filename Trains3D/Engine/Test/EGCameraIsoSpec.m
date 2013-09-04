#import "Kiwi.h"
#import "EGMap.h"
#import "EGMapIso.h"
#import "EGCameraIso.h"

SPEC_BEGIN(EGCameraIsoSpec)
    describe(@"Isometric camera", ^{
        describe(@"Should translate view points into map point", ^{
            describe(@"For map size 2x3 and view size 100x90", ^{
                EGSizeI ms = EGSizeIMake(2, 3);
                EGCameraIso *camera = [EGCameraIso cameraIsoWithTilesOnScreen:ms center:EGVec2Make(0, 0)];
                EGSize viewSize = EGSizeMake(100, 90);
                it(@"(0, 20) -> (0.5, -1.5)", ^{
                    EGVec2 p = [camera translateWithViewSize:viewSize viewPoint:EGVec2Make(0, 20)];
                    [[theValue(p.x) should] equal:0.5 withDelta:0.00001];
                    [[theValue(p.y) should] equal:-1.5 withDelta:0.00001];
                });
                it(@"(100, 70) -> (0.5, 3.5)", ^{
                    EGVec2 p = [camera translateWithViewSize:viewSize viewPoint:EGVec2Make(100, 70)];
                    [[theValue(p.x) should] equal:0.5 withDelta:0.00001];
                    [[theValue(p.y) should] equal:3.5 withDelta:0.00001];
                });
                it(@"(100, 50) -> (1.5, 2.5)", ^{
                    EGVec2 p = [camera translateWithViewSize:viewSize viewPoint:EGVec2Make(100, 50)];
                    [[theValue(p.x) should] equal:1.5 withDelta:0.00001];
                    [[theValue(p.y) should] equal:2.5 withDelta:0.00001];
                });
                it(@"(60, 70) -> (-0.5, 2.5)", ^{
                    EGVec2 p = [camera translateWithViewSize:viewSize viewPoint:EGVec2Make(60, 70)];
                    [[theValue(p.x) should] equal:-0.5 withDelta:0.00001];
                    [[theValue(p.y) should] equal:2.5 withDelta:0.00001];
                });
            });
            describe(@"For map size 5x3 and view size 160x100", ^{
                EGSizeI ms = EGSizeIMake(5, 3);
                EGCameraIso *camera = [EGCameraIso cameraIsoWithTilesOnScreen:ms center:EGVec2Make(0, 0)];
                EGSize viewSize = EGSizeMake(160, 100);
                it(@"(0, 10) -> (2, -3)", ^{
                    EGVec2 p = [camera translateWithViewSize:viewSize viewPoint:EGVec2Make(0, 10)];
                    [[theValue(p.x) should] equal:2 withDelta:0.00001];
                    [[theValue(p.y) should] equal:-3 withDelta:0.00001];
                });
            });
        });
    });
SPEC_END