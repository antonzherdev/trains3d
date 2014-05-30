#import "TRSwitchProcessor.h"

#import "CNObserver.h"
#import "TRLevel.h"
#import "CNFuture.h"
#import "TRRailroad.h"
#import "EGDirector.h"
#import "GEMat4.h"
#import "EGMapIso.h"
#import "CNChain.h"
#import "EGMatrixModel.h"
#import "CNSortBuilder.h"
#import "EGPlatformPlat.h"
#import "EGPlatform.h"
#import "CNReact.h"
@implementation TRSwitchProcessor
static CNSignal* _TRSwitchProcessor_strangeClick;
static CNClassType* _TRSwitchProcessor_type;
@synthesize level = _level;

+ (instancetype)switchProcessorWithLevel:(TRLevel*)level {
    return [[TRSwitchProcessor alloc] initWithLevel:level];
}

- (instancetype)initWithLevel:(TRLevel*)level {
    self = [super init];
    if(self) _level = level;
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [TRSwitchProcessor class]) {
        _TRSwitchProcessor_type = [CNClassType classTypeWithCls:[TRSwitchProcessor class]];
        _TRSwitchProcessor_strangeClick = [CNSignal signal];
    }
}

- (BOOL)processEvent:(id<EGEvent>)event {
    [self doProcessEvent:event];
    return NO;
}

- (CNFuture*)doProcessEvent:(id<EGEvent>)event {
    return [self lockAndOnSuccessFuture:[_level.railroad state] f:^id(TRRailroadState* rrState) {
        GEVec2 vps = geVec2MulF4((geVec2DivVec2((GEVec2Make(80.0, 80.0)), [event viewport].size)), ((float)([[EGDirector current] scale])));
        GEVec2 loc = [event locationInViewport];
        NSArray* closest = [[[[[[[[[[[[((TRRailroadState*)(rrState)) switches] chain] mapF:^TRSwitchProcessorItem*(TRSwitchState* aSwitch) {
            GEMat4* rotate = [[GEMat4 identity] rotateAngle:((float)([TRRailConnector value:[((TRSwitchState*)(aSwitch)) connector]].angle)) x:0.0 y:0.0 z:1.0];
            GEMat4* moveToTile = [[GEMat4 identity] translateX:((float)([((TRSwitchState*)(aSwitch)) tile].x)) y:((float)([((TRSwitchState*)(aSwitch)) tile].y)) z:0.0];
            GEMat4* m = [moveToTile mulMatrix:rotate];
            GEVec2 p = GEVec2Make(-0.6, -0.2);
            GEVec2i nextTile = [[TRRailConnector value:[((TRSwitchState*)(aSwitch)) connector]] nextTile:[((TRSwitchState*)(aSwitch)) tile]];
            TRRailConnectorR osc = [[TRRailConnector value:[((TRSwitchState*)(aSwitch)) connector]] otherSideConnector];
            TRCity* city = [_level cityForTile:nextTile];
            if(city != nil && [_level.map isBottomTile:nextTile]) {
                if([TRCityAngle value:((TRCity*)(city)).angle].form == TRRailForm_bottomTop) p = geVec2AddVec2(p, (GEVec2Make(0.1, -0.1)));
                else p = geVec2AddVec2(p, (GEVec2Make(0.1, 0.1)));
            } else {
                if([[((TRRailroadState*)(rrState)) contentInTile:nextTile connector:osc] isKindOfClass:[TRSwitch class]]) p = geVec2AddVec2(p, (GEVec2Make(0.2, 0.0)));
            }
            return [[TRSwitchProcessorItem applyContent:aSwitch rect:GERectMake(p, (GEVec2Make(0.4, 0.4)))] mulMat4:m];
        }] appendCollection:[[[((TRRailroadState*)(rrState)) lights] chain] mapF:^TRSwitchProcessorItem*(TRRailLightState* light) {
            CGFloat sz = 0.2;
            CGFloat sy = 0.2;
            GEMat4* stand = [[GEMat4 identity] rotateAngle:90.0 x:0.0 y:1.0 z:0.0];
            GEVec3 sh = [((TRRailLightState*)(light)) shift];
            GEMat4* moveToPlace = [[GEMat4 identity] translateX:sh.z y:sh.x z:sh.y + sz / 2];
            GEMat4* rotateToConnector = [[GEMat4 identity] rotateAngle:((float)([TRRailConnector value:[((TRRailLightState*)(light)) connector]].angle)) x:0.0 y:0.0 z:1.0];
            GEMat4* moveToTile = [[GEMat4 identity] translateX:((float)([((TRRailLightState*)(light)) tile].x)) y:((float)([((TRRailLightState*)(light)) tile].y)) z:0.0];
            GEMat4* m = [[[moveToTile mulMatrix:rotateToConnector] mulMatrix:moveToPlace] mulMatrix:stand];
            return [[TRSwitchProcessorItem applyContent:light rect:geRectApplyXYWidthHeight(((float)(-sz / 2)), ((float)(-sy / 2)), ((float)(sz)), ((float)(sy)))] mulMat4:m];
        }]] mapF:^TRSwitchProcessorItem*(TRSwitchProcessorItem* item) {
            return [((TRSwitchProcessorItem*)(item)) mulMat4:[[event matrixModel] wcp]];
        }] mapF:^TRSwitchProcessorItem*(TRSwitchProcessorItem* item) {
            return [((TRSwitchProcessorItem*)(item)) expandVec2:vps];
        }] filterWhen:^BOOL(TRSwitchProcessorItem* item) {
            return [((TRSwitchProcessorItem*)(item)) containsVec2:loc];
        }] sortBy] ascBy:^id(TRSwitchProcessorItem* item) {
            return numf4([((TRSwitchProcessorItem*)(item)) distanceVec2:loc]);
        }] endSort] topNumbers:2] toArray];
        TRSwitchProcessorItem* downed;
        if([closest count] == 2) {
            TRSwitchProcessorItem* a = ((TRSwitchProcessorItem*)(nonnil([closest applyIndex:0])));
            TRSwitchProcessorItem* b = ((TRSwitchProcessorItem*)(nonnil([closest applyIndex:1])));
            float delta = float4Abs([a distanceVec2:loc] - [b distanceVec2:loc]);
            if(delta < 0.008 && !(egPlatform().isComputer)) {
                [_TRSwitchProcessor_strangeClick postData:event];
                downed = nil;
            } else {
                downed = a;
            }
        } else {
            downed = [closest head];
        }
        {
            TRSwitchProcessorItem* d = downed;
            if(d != nil) {
                {
                    TRSwitchState* _ = [CNObject asKindOfClass:[TRSwitchState class] object:((TRSwitchProcessorItem*)(d)).content];
                    if(_ != nil) [_level tryTurnASwitch:((TRSwitchState*)(_)).aSwitch];
                }
                {
                    TRRailLightState* _ = [CNObject asKindOfClass:[TRRailLightState class] object:((TRSwitchProcessorItem*)(d)).content];
                    if(_ != nil) [_level.railroad turnLight:((TRRailLightState*)(_)).light];
                }
            }
        }
        return nil;
    }];
}

- (EGRecognizers*)recognizers {
    return [EGRecognizers applyRecognizer:[EGRecognizer applyTp:[EGTap apply] on:^BOOL(id<EGEvent> _) {
        return [self processEvent:_];
    }]];
}

- (NSString*)description {
    return [NSString stringWithFormat:@"SwitchProcessor(%@)", _level];
}

- (BOOL)isProcessorActive {
    return !(unumb([[EGDirector current].isPaused value]));
}

- (CNClassType*)type {
    return [TRSwitchProcessor type];
}

+ (CNSignal*)strangeClick {
    return _TRSwitchProcessor_strangeClick;
}

+ (CNClassType*)type {
    return _TRSwitchProcessor_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation TRSwitchProcessorItem
static CNClassType* _TRSwitchProcessorItem_type;
@synthesize content = _content;
@synthesize p0 = _p0;
@synthesize p1 = _p1;
@synthesize p2 = _p2;
@synthesize p3 = _p3;

+ (instancetype)switchProcessorItemWithContent:(TRRailroadConnectorContent*)content p0:(GEVec3)p0 p1:(GEVec3)p1 p2:(GEVec3)p2 p3:(GEVec3)p3 {
    return [[TRSwitchProcessorItem alloc] initWithContent:content p0:p0 p1:p1 p2:p2 p3:p3];
}

- (instancetype)initWithContent:(TRRailroadConnectorContent*)content p0:(GEVec3)p0 p1:(GEVec3)p1 p2:(GEVec3)p2 p3:(GEVec3)p3 {
    self = [super init];
    if(self) {
        _content = content;
        _p0 = p0;
        _p1 = p1;
        _p2 = p2;
        _p3 = p3;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [TRSwitchProcessorItem class]) _TRSwitchProcessorItem_type = [CNClassType classTypeWithCls:[TRSwitchProcessorItem class]];
}

+ (TRSwitchProcessorItem*)applyContent:(TRRailroadConnectorContent*)content rect:(GERect)rect {
    return [TRSwitchProcessorItem switchProcessorItemWithContent:content p0:geVec3ApplyVec2(rect.p) p1:geVec3ApplyVec2(geRectPw(rect)) p2:geVec3ApplyVec2(geRectPhw(rect)) p3:geVec3ApplyVec2(geRectPh(rect))];
}

- (GEQuad)quad {
    return GEQuadMake(geVec3Xy(_p0), geVec3Xy(_p1), geVec3Xy(_p2), geVec3Xy(_p3));
}

- (TRSwitchProcessorItem*)mulMat4:(GEMat4*)mat4 {
    return [TRSwitchProcessorItem switchProcessorItemWithContent:_content p0:[mat4 mulVec3:_p0] p1:[mat4 mulVec3:_p1] p2:[mat4 mulVec3:_p2] p3:[mat4 mulVec3:_p3]];
}

- (GERect)boundingRect {
    return geQuadBoundingRect([self quad]);
}

- (TRSwitchProcessorItem*)expandVec2:(GEVec2)vec2 {
    GERect r = [self boundingRect];
    GEVec2 len = r.size;
    GEVec2 mid = geRectCenter(r);
    return [TRSwitchProcessorItem switchProcessorItemWithContent:_content p0:geVec3ApplyVec2Z((geVec2AddVec2(geVec3Xy(_p0), (geVec2MulVec2((geVec2DivVec2((geVec2SubVec2(geVec3Xy(_p0), mid)), len)), vec2)))), _p0.z) p1:geVec3ApplyVec2Z((geVec2AddVec2(geVec3Xy(_p1), (geVec2MulVec2((geVec2DivVec2((geVec2SubVec2(geVec3Xy(_p1), mid)), len)), vec2)))), _p1.z) p2:geVec3ApplyVec2Z((geVec2AddVec2(geVec3Xy(_p2), (geVec2MulVec2((geVec2DivVec2((geVec2SubVec2(geVec3Xy(_p2), mid)), len)), vec2)))), _p2.z) p3:geVec3ApplyVec2Z((geVec2AddVec2(geVec3Xy(_p3), (geVec2MulVec2((geVec2DivVec2((geVec2SubVec2(geVec3Xy(_p3), mid)), len)), vec2)))), _p3.z)];
}

- (BOOL)containsVec2:(GEVec2)vec2 {
    return geQuadContainsVec2([self quad], vec2);
}

- (float)distanceVec2:(GEVec2)vec2 {
    return geVec2Length((geVec2SubVec2(geQuadCenter([self quad]), vec2)));
}

- (NSString*)description {
    return [NSString stringWithFormat:@"SwitchProcessorItem(%@, %@, %@, %@, %@)", _content, geVec3Description(_p0), geVec3Description(_p1), geVec3Description(_p2), geVec3Description(_p3)];
}

- (CNClassType*)type {
    return [TRSwitchProcessorItem type];
}

+ (CNClassType*)type {
    return _TRSwitchProcessorItem_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

