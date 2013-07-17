#import "TRSwitchProcessor.h"

#import "TRRailroad.h"
#import "TRLevel.h"
@implementation TRSwitchProcessor{
    TRLevel* _level;
    id _downedSwitch;
}
@synthesize level = _level;

+ (id)switchProcessorWithLevel:(TRLevel*)level {
    return [[TRSwitchProcessor alloc] initWithLevel:level];
}

- (id)initWithLevel:(TRLevel*)level {
    self = [super init];
    if(self) {
        _level = level;
        _downedSwitch = [CNOption none];
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
    _downedSwitch = [[self connectorForPoint:relPoint] flatMap:^id(TRRailConnector* _) {
        return [_level.railroad switchInTile:tile connector:_];
    }];
    return [_downedSwitch isDefined];
}

- (id)connectorForPoint:(EGPoint)point {
    if(-0.1 < point.x && point.x < 0.1) {
        if(point.y < -0.3) {
            return [TRRailConnector bottom];
        } else {
            if(0.3 < point.y) return [TRRailConnector top];
            else return nil;
        }
    } else {
        if(-0.1 < point.y && point.y < 0.1) {
            if(point.x < -0.3) {
                return [TRRailConnector left];
            } else {
                if(0.3 < point.x) return [TRRailConnector right];
                else return nil;
            }
        } else {
            return nil;
        }
    }
}

- (BOOL)mouseDragEvent:(EGEvent*)event {
    return [_downedSwitch isDefined];
}

- (BOOL)mouseUpEvent:(EGEvent*)event {
    if([_downedSwitch isDefined]) {
        [_level tryTurnTheSwitch:[_downedSwitch get]];
        return YES;
    } else {
        return NO;
    }
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end


