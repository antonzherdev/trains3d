#import "Kiwi.h"
#import "EGMap.h"
#import "EGMapIso.h"
#import "EGCameraIso.h"

SPEC_BEGIN(EGCameraIsoSpec)
    describe(@"Isometric camera", ^{
        describe(@"Should translate view points into map point", ^{
            describe(@"For map size 2x3 and view size 100x90", ^{
                EGMapSize ms = EGMapSizeMake(2, 3);
                EGCameraIso *camera = [EGCameraIso cameraIsoWithTilesOnScreen:ms center:CGPointMake(0, 0)];
                CGSize viewSize = CGSizeMake(100, 90);
                it(@"(0, 20) -> (0.5, -1.5)", ^{
                    CGPoint p = [camera translateViewPoint:CGPointMake(0, 20) withViewSize:viewSize];
                    [[theValue(p.x) should] equal:0.5 withDelta:0.00001];
                    [[theValue(p.y) should] equal:-1.5 withDelta:0.00001];
                });
                it(@"(100, 70) -> (0.5, 3.5)", ^{
                    CGPoint p = [camera translateViewPoint:CGPointMake(100, 70) withViewSize:viewSize];
                    [[theValue(p.x) should] equal:0.5 withDelta:0.00001];
                    [[theValue(p.y) should] equal:3.5 withDelta:0.00001];
                });
                it(@"(100, 50) -> (1.5, 2.5)", ^{
                    CGPoint p = [camera translateViewPoint:CGPointMake(100, 50) withViewSize:viewSize];
                    [[theValue(p.x) should] equal:1.5 withDelta:0.00001];
                    [[theValue(p.y) should] equal:2.5 withDelta:0.00001];
                });
                it(@"(60, 70) -> (-0.5, 2.5)", ^{
                    CGPoint p = [camera translateViewPoint:CGPointMake(60, 70) withViewSize:viewSize];
                    [[theValue(p.x) should] equal:-0.5 withDelta:0.00001];
                    [[theValue(p.y) should] equal:2.5 withDelta:0.00001];
                });
            });
            describe(@"For map size 5x3 and view size 160x100", ^{
                EGMapSize ms = EGMapSizeMake(5, 3);
                EGCameraIso *camera = [EGCameraIso cameraIsoWithTilesOnScreen:ms center:CGPointMake(0, 0)];
                CGSize viewSize = CGSizeMake(160, 100);
                it(@"(0, 10) -> (2, -3)", ^{
                    CGPoint p = [camera translateViewPoint:CGPointMake(0, 10) withViewSize:viewSize];
                    [[theValue(p.x) should] equal:2 withDelta:0.00001];
                    [[theValue(p.y) should] equal:-3 withDelta:0.00001];
                });
            });
        });
    });
SPEC_END