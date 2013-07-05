#import "TRRailroadBuilderProcessor.h"

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

- (id)mouseDragEvent:(EGEvent*)event {
    return [[_startedPoint map:^id(id sp_) {
        CGPoint sp = uval(CGPoint, sp_);
        CGPoint deltaVector = egpSub([event location], sp);
        if(egpLengthSQ(deltaVector) > 0.25) {
            EGIPoint spTile = egpRound(sp);
            EGIPoint start = [self normPoint:egpSub(sp, egipFloat(spTile))];
            EGIPoint end = egipAdd(start, [self normPoint:egpSetLength(deltaVector, 0.7)]);
            [_builder tryBuildRail:[self correctRail:[TRRail railWithTile:spTile start:start end:end]]];
        }
        return @YES;
    }] getOr:@NO];
}

- (id)mouseUpEvent:(EGEvent*)event {
    return [[_startedPoint map:^id(id point_) {
        CGPoint point = uval(CGPoint, point_);
        [_builder fix];
        _startedPoint = [CNOption none];
        return @YES;
    }] getOr:@NO];
}

- (EGIPoint)normPoint:(CGPoint)point {
    return EGIPointMake([self nX:point.x], [self nX:point.y]);
}

- (NSInteger)nX:(CGFloat)x {
    return round(x * 2);
}

- (TRRail*)correctRail:(TRRail*)rail {
    if(rail.end.x > 1) return [self moveRail:rail x:1 y:0];
    else if(rail.end.x < -1) return [self moveRail:rail x:-1 y:0];
    else if(rail.end.y > 1) return [self moveRail:rail x:0 y:1];
    else if(rail.end.y < -1) return [self moveRail:rail x:0 y:-1];
    else if(rail.start.x == 0 && rail.start.y == 0) return [self correctRail:[TRRail railWithTile:rail.tile start:egipNeg(rail.end) end:rail.end]];
    else if(rail.end.x == 0 && rail.end.y == 0) return [self correctRail:[TRRail railWithTile:rail.tile start:rail.start end:egipNeg(rail.start)]];
    else return rail;
}

- (TRRail*)moveRail:(TRRail*)rail x:(NSInteger)x y:(NSInteger)y {
    return [self correctRail:[TRRail railWithTile:egip(rail.tile.x + x, rail.tile.y + y) start:egip(rail.start.x - 2 * x, rail.start.y - 2 * y) end:egip(rail.end.x - 2 * x, rail.end.y - 2 * y)]];
}

@end


