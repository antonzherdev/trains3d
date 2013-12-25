#import "TRSwitchProcessor.h"

#import "TRLevel.h"
#import "EGContext.h"
#import "TRRailroad.h"
#import "GEMat4.h"
#import "TRRailPoint.h"
#import "EGDirector.h"
@implementation TRSwitchProcessor{
    TRLevel* _level;
}
static CNNotificationHandle* _TRSwitchProcessor_strangeClickNotification;
static ODClassType* _TRSwitchProcessor_type;
@synthesize level = _level;

+ (id)switchProcessorWithLevel:(TRLevel*)level {
    return [[TRSwitchProcessor alloc] initWithLevel:level];
}

- (id)initWithLevel:(TRLevel*)level {
    self = [super init];
    if(self) _level = level;
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _TRSwitchProcessor_type = [ODClassType classTypeWithCls:[TRSwitchProcessor class]];
    _TRSwitchProcessor_strangeClickNotification = [CNNotificationHandle notificationHandleWithName:@"strangeClickNotification"];
}

- (BOOL)processEvent:(id<EGEvent>)event {
    GEVec2 vps = geVec2MulF(geVec2DivVec2(GEVec2Make(80.0, 80.0), [event viewport].size), EGGlobal.context.scale);
    GEVec2 loc = [event locationInViewport];
    id<CNSeq> closest = [[[[[[[[[[[[_level.railroad switches] chain] map:^TRSwitchProcessorItem*(TRSwitch* aSwitch) {
        GEMat4* rotate = [[GEMat4 identity] rotateAngle:((float)(((TRSwitch*)(aSwitch)).connector.angle)) x:0.0 y:0.0 z:1.0];
        GEMat4* moveToTile = [[GEMat4 identity] translateX:((float)(((TRSwitch*)(aSwitch)).tile.x)) y:((float)(((TRSwitch*)(aSwitch)).tile.y)) z:0.0];
        GEMat4* m = [moveToTile mulMatrix:rotate];
        GEVec2 p = GEVec2Make(-0.6, -0.2);
        GEVec2i nextTile = [((TRSwitch*)(aSwitch)).connector nextTile:((TRSwitch*)(aSwitch)).tile];
        TRRailConnector* osc = [((TRSwitch*)(aSwitch)).connector otherSideConnector];
        id city = [_level cityForTile:nextTile];
        return [[TRSwitchProcessorItem applyContent:aSwitch rect:GERectMake(p, GEVec2Make(0.4, 0.4))] mulMat4:m];
    }] append:[[[_level.railroad lights] chain] map:^TRSwitchProcessorItem*(TRRailLight* light) {
        CGFloat sz = 0.2;
        CGFloat sy = 0.2;
        GEMat4* stand = [[GEMat4 identity] rotateAngle:90.0 x:0.0 y:1.0 z:0.0];
        GEVec3 sh = [((TRRailLight*)(light)) shift];
        GEMat4* moveToPlace = [[GEMat4 identity] translateX:sh.z y:sh.x z:sh.y + sz / 2];
        GEMat4* rotateToConnector = [[GEMat4 identity] rotateAngle:((float)(((TRRailLight*)(light)).connector.angle)) x:0.0 y:0.0 z:1.0];
        GEMat4* moveToTile = [[GEMat4 identity] translateX:((float)(((TRRailLight*)(light)).tile.x)) y:((float)(((TRRailLight*)(light)).tile.y)) z:0.0];
        GEMat4* m = [[[moveToTile mulMatrix:rotateToConnector] mulMatrix:moveToPlace] mulMatrix:stand];
        return [[TRSwitchProcessorItem applyContent:light rect:geRectApplyXYWidthHeight(((float)(-sz / 2)), ((float)(-sy / 2)), ((float)(sz)), ((float)(sy)))] mulMat4:m];
    }]] map:^TRSwitchProcessorItem*(TRSwitchProcessorItem* item) {
        return [((TRSwitchProcessorItem*)(item)) mulMat4:[[event matrixModel] wcp]];
    }] map:^TRSwitchProcessorItem*(TRSwitchProcessorItem* item) {
        return [((TRSwitchProcessorItem*)(item)) expandVec2:vps];
    }] filter:^BOOL(TRSwitchProcessorItem* item) {
        return [((TRSwitchProcessorItem*)(item)) containsVec2:loc];
    }] sortBy] ascBy:^id(TRSwitchProcessorItem* item) {
        return numf4([((TRSwitchProcessorItem*)(item)) distanceVec2:loc]);
    }] endSort] topNumbers:2] toArray];
    id downed = (([closest count] == 2) ? ^id() {
        TRSwitchProcessorItem* a = [closest applyIndex:0];
        TRSwitchProcessorItem* b = [closest applyIndex:1];
        float delta = float4Abs([a distanceVec2:loc] - [b distanceVec2:loc]);
        if(delta < 0.01) {
            [_TRSwitchProcessor_strangeClickNotification postData:event];
            return [CNOption none];
        } else {
            return [CNOption someValue:a];
        }
    }() : [closest headOpt]);
    if([downed isDefined]) {
        [[ODObject asKindOfClass:[TRSwitch class] object:((TRSwitchProcessorItem*)([downed get])).content] forEach:^void(TRSwitch* _) {
            [_level tryTurnTheSwitch:_];
        }];
        [[ODObject asKindOfClass:[TRRailLight class] object:((TRSwitchProcessorItem*)([downed get])).content] forEach:^void(TRRailLight* _) {
            [((TRRailLight*)(_)) turn];
        }];
        return YES;
    } else {
        return NO;
    }
}

- (EGRecognizers*)recognizers {
    return [EGRecognizers applyRecognizer:[EGRecognizer applyTp:[EGTap apply] on:^BOOL(id<EGEvent> _) {
        return [self processEvent:_];
    }]];
}

- (BOOL)isProcessorActive {
    return !([[EGDirector current] isPaused]);
}

- (ODClassType*)type {
    return [TRSwitchProcessor type];
}

+ (CNNotificationHandle*)strangeClickNotification {
    return _TRSwitchProcessor_strangeClickNotification;
}

+ (ODClassType*)type {
    return _TRSwitchProcessor_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    TRSwitchProcessor* o = ((TRSwitchProcessor*)(other));
    return [self.level isEqual:o.level];
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.level hash];
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"level=%@", self.level];
    [description appendString:@">"];
    return description;
}

@end


@implementation TRSwitchProcessorItem{
    TRRailroadConnectorContent* _content;
    GEVec3 _p0;
    GEVec3 _p1;
    GEVec3 _p2;
    GEVec3 _p3;
}
static ODClassType* _TRSwitchProcessorItem_type;
@synthesize content = _content;
@synthesize p0 = _p0;
@synthesize p1 = _p1;
@synthesize p2 = _p2;
@synthesize p3 = _p3;

+ (id)switchProcessorItemWithContent:(TRRailroadConnectorContent*)content p0:(GEVec3)p0 p1:(GEVec3)p1 p2:(GEVec3)p2 p3:(GEVec3)p3 {
    return [[TRSwitchProcessorItem alloc] initWithContent:content p0:p0 p1:p1 p2:p2 p3:p3];
}

- (id)initWithContent:(TRRailroadConnectorContent*)content p0:(GEVec3)p0 p1:(GEVec3)p1 p2:(GEVec3)p2 p3:(GEVec3)p3 {
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
    _TRSwitchProcessorItem_type = [ODClassType classTypeWithCls:[TRSwitchProcessorItem class]];
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
    return [TRSwitchProcessorItem switchProcessorItemWithContent:_content p0:geVec3ApplyVec2Z(geVec2AddVec2(geVec3Xy(_p0), geVec2MulVec2(geVec2DivVec2(geVec2SubVec2(geVec3Xy(_p0), mid), len), vec2)), _p0.z) p1:geVec3ApplyVec2Z(geVec2AddVec2(geVec3Xy(_p1), geVec2MulVec2(geVec2DivVec2(geVec2SubVec2(geVec3Xy(_p1), mid), len), vec2)), _p1.z) p2:geVec3ApplyVec2Z(geVec2AddVec2(geVec3Xy(_p2), geVec2MulVec2(geVec2DivVec2(geVec2SubVec2(geVec3Xy(_p2), mid), len), vec2)), _p2.z) p3:geVec3ApplyVec2Z(geVec2AddVec2(geVec3Xy(_p3), geVec2MulVec2(geVec2DivVec2(geVec2SubVec2(geVec3Xy(_p3), mid), len), vec2)), _p3.z)];
}

- (BOOL)containsVec2:(GEVec2)vec2 {
    return geQuadContainsVec2([self quad], vec2);
}

- (float)distanceVec2:(GEVec2)vec2 {
    return geVec2Length(geVec2SubVec2(geQuadCenter([self quad]), vec2));
}

- (ODClassType*)type {
    return [TRSwitchProcessorItem type];
}

+ (ODClassType*)type {
    return _TRSwitchProcessorItem_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    TRSwitchProcessorItem* o = ((TRSwitchProcessorItem*)(other));
    return [self.content isEqual:o.content] && GEVec3Eq(self.p0, o.p0) && GEVec3Eq(self.p1, o.p1) && GEVec3Eq(self.p2, o.p2) && GEVec3Eq(self.p3, o.p3);
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.content hash];
    hash = hash * 31 + GEVec3Hash(self.p0);
    hash = hash * 31 + GEVec3Hash(self.p1);
    hash = hash * 31 + GEVec3Hash(self.p2);
    hash = hash * 31 + GEVec3Hash(self.p3);
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"content=%@", self.content];
    [description appendFormat:@", p0=%@", GEVec3Description(self.p0)];
    [description appendFormat:@", p1=%@", GEVec3Description(self.p1)];
    [description appendFormat:@", p2=%@", GEVec3Description(self.p2)];
    [description appendFormat:@", p3=%@", GEVec3Description(self.p3)];
    [description appendString:@">"];
    return description;
}

@end


