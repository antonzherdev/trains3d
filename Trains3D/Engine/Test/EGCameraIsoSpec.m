#import "Kiwi.h"
#import "EGMap.h"
#import "EGMapIso.h"
#import "EGCameraIso.h"

SPEC_BEGIN(EGCameraIsoSpec)
    describe(@"Isometric camera", ^{
        describe(@"Should translate view points into map point", ^{
            describe(@"For map size 2x3 and view size 100x90", ^{
                EGSizeI ms = EGSizeIMake(2, 3);
                EGCameraIso *camera = [EGCameraIso cameraIsoWithTilesOnScreen:ms center:EGPointMake(0, 0)];
                EGSize viewSize = EGSizeMake(100, 90);
                it(@"(0, 20) -> (0.5, -1.5)", ^{
                    EGPoint p = [camera translateViewPoint:EGPointMake(0, 20) withViewSize:viewSize];
                    [[theValue(p.x) should] equal:0.5 withDelta:0.00001];
                    [[theValue(p.y) should] equal:-1.5 withDelta:0.00001];
                });
                it(@"(100, 70) -> (0.5, 3.5)", ^{
                    EGPoint p = [camera translateViewPoint:EGPointMake(100, 70) withViewSize:viewSize];
                    [[theValue(p.x) should] equal:0.5 withDelta:0.00001];
                    [[theValue(p.y) should] equal:3.5 withDelta:0.00001];
                });
                it(@"(100, 50) -> (1.5, 2.5)", ^{
                    EGPoint p = [camera translateViewPoint:EGPointMake(100, 50) withViewSize:viewSize];
                    [[theValue(p.x) should] equal:1.5 withDelta:0.00001];
                    [[theValue(p.y) should] equal:2.5 withDelta:0.00001];
                });
                it(@"(60, 70) -> (-0.5, 2.5)", ^{
                    EGPoint p = [camera translateViewPoint:EGPointMake(60, 70) withViewSize:viewSize];
                    [[theValue(p.x) should] equal:-0.5 withDelta:0.00001];
                    [[theValue(p.y) should] equal:2.5 withDelta:0.00001];
                });
            });
            describe(@"For map size 5x3 and view size 160x100", ^{
                EGSizeI ms = EGSizeIMake(5, 3);
                EGCameraIso *camera = [EGCameraIso cameraIsoWithTilesOnScreen:ms center:EGPointMake(0, 0)];
                EGSize viewSize = EGSizeMake(160, 100);
                it(@"(0, 10) -> (2, -3)", ^{
                    EGPoint p = [camera translateViewPoint:EGPointMake(0, 10) withViewSize:viewSize];
                    [[theValue(p.x) should] equal:2 withDelta:0.00001];
                    [[theValue(p.y) should] equal:-3 withDelta:0.00001];
                });
            });
        });
    });
SPEC_END