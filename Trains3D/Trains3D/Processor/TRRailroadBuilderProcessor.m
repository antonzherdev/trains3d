#import "TRRailroadBuilderProcessor.h"

#import "TRRailroad.h"
#import "EGTwoFingerTouchToMouse.h"
#import "EGContext.h"
#import "EGDirector.h"
#import "TRRailPoint.h"
@implementation TRRailroadBuilderProcessor{
    TRRailroadBuilder* _builder;
    TRRailroadBuilderMouseProcessor* _mouseProcessor;
    EGTwoFingerTouchToMouse* _touchProcessor;
}
static ODClassType* _TRRailroadBuilderProcessor_type;
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

+ (void)initialize {
    [super initialize];
    _TRRailroadBuilderProcessor_type = [ODClassType classTypeWithCls:[TRRailroadBuilderProcessor class]];
}

- (BOOL)processEvent:(EGEvent*)event {
    return [event leftMouseProcessor:_mouseProcessor] || [event touchProcessor:_touchProcessor];
}

- (BOOL)isProcessorActive {
    return !([[EGGlobal director] isPaused]);
}

- (ODClassType*)type {
    return [TRRailroadBuilderProcessor type];
}

+ (ODClassType*)type {
    return _TRRailroadBuilderProcessor_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    TRRailroadBuilderProcessor* o = ((TRRailroadBuilderProcessor*)(other));
    return [self.builder isEqual:o.builder];
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.builder hash];
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"builder=%@", self.builder];
    [description appendString:@">"];
    return description;
}

@end


NSString* TRRailCorrectionDescription(TRRailCorrection self) {
    NSMutableString* description = [NSMutableString stringWithString:@"<TRRailCorrection: "];
    [description appendFormat:@"tile=%@", GEVec2iDescription(self.tile)];
    [description appendFormat:@", start=%@", GEVec2iDescription(self.start)];
    [description appendFormat:@", end=%@", GEVec2iDescription(self.end)];
    [description appendString:@">"];
    return description;
}
ODPType* trRailCorrectionType() {
    static ODPType* _ret = nil;
    if(_ret == nil) _ret = [ODPType typeWithCls:[TRRailCorrectionWrap class] name:@"TRRailCorrection" size:sizeof(TRRailCorrection) wrap:^id(void* data, NSUInteger i) {
        return wrap(TRRailCorrection, ((TRRailCorrection*)(data))[i]);
    }];
    return _ret;
}
@implementation TRRailCorrectionWrap{
    TRRailCorrection _value;
}
@synthesize value = _value;

+ (id)wrapWithValue:(TRRailCorrection)value {
    return [[TRRailCorrectionWrap alloc] initWithValue:value];
}

- (id)initWithValue:(TRRailCorrection)value {
    self = [super init];
    if(self) _value = value;
    return self;
}

- (NSString*)description {
    return TRRailCorrectionDescription(_value);
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    TRRailCorrectionWrap* o = ((TRRailCorrectionWrap*)(other));
    return TRRailCorrectionEq(_value, o.value);
}

- (NSUInteger)hash {
    return TRRailCorrectionHash(_value);
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end



@implementation TRRailroadBuilderMouseProcessor{
    TRRailroadBuilder* _builder;
    id _startedPoint;
}
static ODClassType* _TRRailroadBuilderMouseProcessor_type;
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

+ (void)initialize {
    [super initialize];
    _TRRailroadBuilderMouseProcessor_type = [ODClassType classTypeWithCls:[TRRailroadBuilderMouseProcessor class]];
}

- (BOOL)mouseDownEvent:(EGEvent*)event {
    _startedPoint = [CNOption applyValue:wrap(GEVec2, [event location])];
    return YES;
}

- (BOOL)mouseDragEvent:(EGEvent*)event {
    return unumb([[_startedPoint mapF:^id(id sp) {
        GEVec2 deltaVector = geVec2SubVec2([event location], uwrap(GEVec2, sp));
        if(geVec2LengthSquare(deltaVector) > 0.25) {
            GEVec2i spTile = geVec2iApplyVec2(uwrap(GEVec2, sp));
            GEVec2i start = [self normPoint:geVec2SubVec2(uwrap(GEVec2, sp), geVec2ApplyVec2i(spTile))];
            GEVec2i end = geVec2iAddVec2i(start, [self normPoint:geVec2SetLength(deltaVector, 0.7)]);
            [_builder tryBuildRail:[self convertRail:[self correctRail:TRRailCorrectionMake(spTile, start, end)]]];
        } else {
            [_builder clear];
        }
        return @YES;
    }] getOrValue:@NO]);
}

- (BOOL)mouseUpEvent:(EGEvent*)event {
    return unumb([[_startedPoint mapF:^id(id point) {
        [_builder fix];
        _startedPoint = [CNOption none];
        return @YES;
    }] getOrValue:@NO]);
}

- (GEVec2i)normPoint:(GEVec2)point {
    return GEVec2iMake([self nX:((CGFloat)(point.x))], [self nX:((CGFloat)(point.y))]);
}

- (NSInteger)nX:(CGFloat)x {
    return floatRound(x * 2);
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
                        return [self correctRail:TRRailCorrectionMake(rail.tile, geVec2iNegate(rail.end), rail.end)];
                    } else {
                        if(rail.end.x == 0 && rail.end.y == 0) {
                            return [self correctRail:TRRailCorrectionMake(rail.tile, rail.start, geVec2iNegate(rail.start))];
                        } else {
                            if(rail.start.x > rail.end.x) {
                                return [self correctRail:TRRailCorrectionMake(rail.tile, rail.end, rail.start)];
                            } else {
                                if(rail.start.x == rail.end.x && rail.start.y > rail.end.y) {
                                    return [self correctRail:TRRailCorrectionMake(rail.tile, rail.end, rail.start)];
                                } else {
                                    if(eqf(fabs(((CGFloat)(rail.start.x))), 1) && eqf(fabs(((CGFloat)(rail.start.y))), 1) && rail.start.x != rail.end.x) {
                                        return [self correctRail:TRRailCorrectionMake(rail.tile, GEVec2iMake(rail.start.x, 0), rail.end)];
                                    } else {
                                        if(eqf(fabs(((CGFloat)(rail.start.x))), 1) && eqf(fabs(((CGFloat)(rail.start.y))), 1)) {
                                            return [self correctRail:TRRailCorrectionMake(rail.tile, GEVec2iMake(0, rail.start.y), rail.end)];
                                        } else {
                                            if(eqf(fabs(((CGFloat)(rail.end.x))), 1) && eqf(fabs(((CGFloat)(rail.end.y))), 1) && rail.start.x != rail.end.x) {
                                                return [self correctRail:TRRailCorrectionMake(rail.tile, rail.start, GEVec2iMake(rail.end.x, 0))];
                                            } else {
                                                if(eqf(fabs(((CGFloat)(rail.end.x))), 1) && eqf(fabs(((CGFloat)(rail.end.y))), 1)) return [self correctRail:TRRailCorrectionMake(rail.tile, rail.start, GEVec2iMake(0, rail.end.y))];
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
    return [self correctRail:TRRailCorrectionMake(GEVec2iMake(rail.tile.x + x, rail.tile.y + y), GEVec2iMake(rail.start.x - 2 * x, rail.start.y - 2 * y), GEVec2iMake(rail.end.x - 2 * x, rail.end.y - 2 * y))];
}

- (TRRail*)convertRail:(TRRailCorrection)rail {
    return [TRRail railWithTile:rail.tile form:[TRRailForm formForConnector1:[TRRailConnector connectorForX:rail.start.x y:rail.start.y] connector2:[TRRailConnector connectorForX:rail.end.x y:rail.end.y]]];
}

- (ODClassType*)type {
    return [TRRailroadBuilderMouseProcessor type];
}

+ (ODClassType*)type {
    return _TRRailroadBuilderMouseProcessor_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    TRRailroadBuilderMouseProcessor* o = ((TRRailroadBuilderMouseProcessor*)(other));
    return [self.builder isEqual:o.builder];
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.builder hash];
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"builder=%@", self.builder];
    [description appendString:@">"];
    return description;
}

@end


