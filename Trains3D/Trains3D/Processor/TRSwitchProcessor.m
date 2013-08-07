#import "TRSwitchProcessor.h"

#import "EGRectIndex.h"
#import "TRRailroad.h"
#import "TRLevel.h"
@implementation TRSwitchProcessor{
    TRLevel* _level;
    EGRectIndex* _index;
    id _downed;
}
@synthesize level = _level;

+ (id)switchProcessorWithLevel:(TRLevel*)level {
    return [[TRSwitchProcessor alloc] initWithLevel:level];
}

- (id)initWithLevel:(TRLevel*)level {
    self = [super init];
    if(self) {
        _level = level;
        _index = [EGRectIndex rectIndexWithRects:(@[tuple(val(EGRectMake(-0.1, 0.2, 0.3, 0.2)), tuple([TRRailConnector top], @NO)), tuple(val(EGRectMake(-0.1, 0.2, -0.5, 0.2)), tuple([TRRailConnector bottom], @NO)), tuple(val(EGRectMake(-0.5, 0.2, -0.1, 0.2)), tuple([TRRailConnector left], @NO)), tuple(val(EGRectMake(0.3, 0.2, -0.1, 0.2)), tuple([TRRailConnector right], @NO)), tuple(val(EGRectMake(0.15, 0.1, 0.4, 0.1)), tuple([TRRailConnector top], @YES)), tuple(val(EGRectMake(-0.25, 0.1, -0.5, 0.1)), tuple([TRRailConnector bottom], @YES)), tuple(val(EGRectMake(-0.5, 0.1, 0.15, 0.1)), tuple([TRRailConnector left], @YES)), tuple(val(EGRectMake(0.4, 0.1, -0.25, 0.1)), tuple([TRRailConnector right], @YES))])];
        _downed = [CNOption none];
    }
    
    return self;
}

- (BOOL)processEvent:(EGEvent*)event {
    return [event leftMouseProcessor:self];
}

- (BOOL)mouseDownEvent:(EGEvent*)event {
    EGPoint location = [event location];
    EGPointI tile = egPointIApply(location);
    EGPoint relPoint = egPointSub(location, egPointApply(tile));
    _downed = [[_index objectForPoint:relPoint] flatMap:^id(CNTuple* v) {
        id content = [_level.railroad contentInTile:tile connector:((TRRailConnector*)v.a)];
        if(unumb(v.b)) return [content asKindOfClass:[TRLight class]];
        else return [content asKindOfClass:[TRSwitch class]];
    }];
    return [_downed isDefined];
}

- (BOOL)mouseDragEvent:(EGEvent*)event {
    return [_downed isDefined];
}

- (BOOL)mouseUpEvent:(EGEvent*)event {
    if([_downed isDefined]) {
        [[((TRRailroadConnectorContent*)[_downed get]) asKindOfClass:[TRSwitch class]] forEach:^void(TRSwitch* _) {
            [_level tryTurnTheSwitch:_];
        }];
        [[((TRRailroadConnectorContent*)[_downed get]) asKindOfClass:[TRLight class]] forEach:^void(TRLight* _) {
            [_ turn];
        }];
        return YES;
    } else {
        return NO;
    }
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end


