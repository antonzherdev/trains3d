#import "TRRailroadBuilderProcessor.h"

#import "EGProcessor.h"
#import "EGTwoFingerTouchToMouse.h"
#import "TRRailroad.h"
@implementation TRRailroadBuilderProcessor{
    TRRailroadBuilder* _builder;
    TRRailroadBuilderMouseProcessor* _mouseProcessor;
    EGTwoFingerTouchToMouse* _touchProcessor;
}
@synthesize builder = _builder;

+ (id)railroadBuilderProcessorWithBuilder:(TRRailroadBuilder*)builder {
    return [[TRRailroadBuilderProcessor alloc] initWithBuilder:builder];
}

- (id)initWithBuilder:(TRRailroadBuilder*)builder {
    self = [super init];
    if(self) {
        _builder = builder;
        _mouseProcessor = [TRRailroadBuilderMouseProcessor railroadBuilderMouseProcessorWithBuilder:_builder];
        _touchProcessor = [EGTwoFingerTouchToMouse twoFingerTouchToMouseWithProcessor:_mouseProcessor];
    }
    
    return self;
}

- (BOOL)processEvent:(EGEvent*)event {
    return [event leftMouseProcessor:_mouseProcessor] || [event touchProcessor:_touchProcessor];
}

@end


@implementation TRRailroadBuilderMouseProcessor{
    TRRailroadBuilder* _builder;
    id _startedPoint;
}
@synthesize builder = _builder;

+ (id)railroadBuilderMouseProcessorWithBuilder:(TRRailroadBuilder*)builder {
    return [[TRRailroadBuilderMouseProcessor alloc] initWithBuilder:builder];
}

- (id)initWithBuilder:(TRRailroadBuilder*)builder {
    self = [super init];
    if(self) {
        _builder = builder;
        _startedPoint = [CNOption none];
    }
    
    return self;
}

- (BOOL)mouseDownEvent:(EGEvent*)event {
    _startedPoint = [CNOption opt:val([event location])];
    return YES;
}

- (BOOL)mouseDragEvent:(EGEvent*)event {
    return unumb([[_startedPoint map:^id(id sp) {
        EGPoint deltaVector = egPointSub([event location], uval(EGPoint, sp));
        if(egPointLengthSquare(deltaVector) > 0.25) {
            EGPointI spTile = egPointIApply(uval(EGPoint, sp));
            EGPointI start = [self normPoint:egPointSub(uval(EGPoint, sp), egPointApply(spTile))];
            EGPointI end = egPointIAdd(start, [self normPoint:egPointSet(deltaVector, 0.7)]);
            [_builder tryBuildRail:[self convertRail:[self correctRail:TRRailCorrectionMake(spTile, start, end)]]];
        }
        return @YES;
    }] getOr:@NO]);
}

- (BOOL)mouseUpEvent:(EGEvent*)event {
    return unumb([[_startedPoint map:^id(id point) {
        [_builder fix];
        _startedPoint = [CNOption none];
        return @YES;
    }] getOr:@NO]);
}

- (EGPointI)normPoint:(EGPoint)point {
    return EGPointIMake([self nX:point.x], [self nX:point.y]);
}

- (NSInteger)nX:(double)x {
    return lround(x * 2);
}

- (TRRailCorrection)correctRail:(TRRailCorrection)rail {
    if(rail.end.x > 1) {
        return [self moveRail:rail x:1 y:0];
    } else {
        if(rail.end.x < -1) {
            return [self moveRail:rail x:-1 y:0];
        } else {
            if(rail.end.y > 1) {
                return [self moveRail:rail x:0 y:1];
            } else {
                if(rail.end.y < -1) {
                    return [self moveRail:rail x:0 y:-1];
                } else {
                    if(rail.start.x == 0 && rail.start.y == 0) {
                        return [self correctRail:TRRailCorrectionMake(rail.tile, egPointINegate(rail.end), rail.end)];
                    } else {
                        if(rail.end.x == 0 && rail.end.y == 0) {
                            return [self correctRail:TRRailCorrectionMake(rail.tile, rail.start, egPointINegate(rail.start))];
                        } else {
                            if(rail.start.x > rail.end.x) {
                                return [self correctRail:TRRailCorrectionMake(rail.tile, rail.end, rail.start)];
                            } else {
                                if(rail.start.x == rail.end.x && rail.start.y > rail.end.y) {
                                    return [self correctRail:TRRailCorrectionMake(rail.tile, rail.end, rail.start)];
                                } else {
                                    if(fabs(rail.start.x) == 1 && fabs(rail.start.y) == 1 && rail.start.x != rail.end.x) {
                                        return [self correctRail:TRRailCorrectionMake(rail.tile, EGPointIMake(rail.start.x, 0), rail.end)];
                                    } else {
                                        if(fabs(rail.start.x) == 1 && fabs(rail.start.y) == 1) {
                                            return [self correctRail:TRRailCorrectionMake(rail.tile, EGPointIMake(0, rail.start.y), rail.end)];
                                        } else {
                                            if(fabs(rail.end.x) == 1 && fabs(rail.end.y) == 1 && rail.start.x != rail.end.x) {
                                                return [self correctRail:TRRailCorrectionMake(rail.tile, rail.start, EGPointIMake(rail.end.x, 0))];
                                            } else {
                                                if(fabs(rail.end.x) == 1 && fabs(rail.end.y) == 1) return [self correctRail:TRRailCorrectionMake(rail.tile, rail.start, EGPointIMake(0, rail.end.y))];
                                                else return rail;
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

- (TRRailCorrection)moveRail:(TRRailCorrection)rail x:(NSInteger)x y:(NSInteger)y {
    return [self correctRail:TRRailCorrectionMake(EGPointIMake(rail.tile.x + x, rail.tile.y + y), EGPointIMake(rail.start.x - 2 * x, rail.start.y - 2 * y), EGPointIMake(rail.end.x - 2 * x, rail.end.y - 2 * y))];
}

- (TRRail*)convertRail:(TRRailCorrection)rail {
    return [TRRail railWithTile:rail.tile form:[TRRailForm formForConnector1:[TRRailConnector connectorForX:rail.start.x y:rail.start.y] connector2:[TRRailConnector connectorForX:rail.end.x y:rail.end.y]]];
}

@end


