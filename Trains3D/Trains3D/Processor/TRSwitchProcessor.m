#import "TRSwitchProcessor.h"

#import "EGProcessor.h"
#import "TRRailroad.h"
@implementation TRSwitchProcessor{
    TRRailroad* _railroad;
    TRSwitch* _downedSwitch;
}
@synthesize railroad = _railroad;

+ (id)switchProcessorWithRailroad:(TRRailroad*)railroad {
    return [[TRSwitchProcessor alloc] initWithRailroad:railroad];
}

- (id)initWithRailroad:(TRRailroad*)railroad {
    self = [super init];
    if(self) {
        _railroad = railroad;
        _downedSwitch = [CNOption none];
    }
    
    return self;
}

- (BOOL)processEvent:(EGEvent*)event {
    return [event leftMouseProcessor:self];
}

- (BOOL)mouseDownEvent:(EGEvent*)event {
    CGPoint location = [event location];
    EGIPoint tile = egpRound(location);
    CGPoint relPoint = egpSub(location, egipFloat(tile));
    _downedSwitch = [[self connectorForPoint:relPoint] flatMap:^id(TRRailConnector* _) {
        return [_railroad switchInTile:tile connector:_];
    }];
    return [_downedSwitch isDefined];
}

- (TRRailConnector*)connectorForPoint:(CGPoint)point {
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
        [[_downedSwitch get] turn];
        return YES;
    } else {
        return NO;
    }
}

@end


