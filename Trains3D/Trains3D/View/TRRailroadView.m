#import "TRRailroadView.h"
#import "TR3DRail.h"
#import "TR3DRailTurn.h"
#import "TR3DSwitch.h"

#import "EGGL.h"
#import "EGModel.h"
#import "TRRailroad.h"
#import "TRRailPoint.h"
#import "EG.h"
#import "EGTexture.h"
#import "EGMaterial.h"
@implementation TRRailroadView{
    TRRailView* _railView;
    TRSwitchView* _switchView;
    TRLightView* _lightView;
    TRDamageView* _damageView;
}

+ (id)railroadView {
    return [[TRRailroadView alloc] init];
}

- (id)init {
    self = [super init];
    if(self) {
        _railView = [TRRailView railView];
        _switchView = [TRSwitchView switchView];
        _lightView = [TRLightView lightView];
        _damageView = [TRDamageView damageView];
    }
    
    return self;
}

- (void)drawRailroad:(TRRailroad*)railroad {
    [[railroad rails] forEach:^void(TRRail* _) {
        [_railView drawRail:_];
    }];
    [[railroad switches] forEach:^void(TRSwitch* _) {
        [_switchView drawTheSwitch:_];
    }];
    [[railroad lights] forEach:^void(TRLight* _) {
        [_lightView drawLight:_];
    }];
    [[railroad.builder rail] forEach:^void(TRRail* _) {
        [_railView drawRail:_];
    }];
    [[railroad damagesPoints] forEach:^void(TRRailPoint* _) {
        [_damageView drawPoint:_];
    }];
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    return YES;
}

- (NSUInteger)hash {
    return 0;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendString:@">"];
    return description;
}

@end


@implementation TRRailView

+ (id)railView {
    return [[TRRailView alloc] init];
}

- (id)init {
    self = [super init];
    
    return self;
}

- (void)drawRail:(TRRail*)rail {
    glPushMatrix();
    egTranslate(((CGFloat)(rail.tile.x)), ((CGFloat)(rail.tile.y)), 0.001);
    if(rail.form == TRRailForm.bottomTop || rail.form == TRRailForm.leftRight) {
        if(rail.form == TRRailForm.leftRight) egRotate(((CGFloat)(90)), ((CGFloat)(0)), ((CGFloat)(0)), ((CGFloat)(1)));
        egRotate(((CGFloat)(90)), ((CGFloat)(1)), ((CGFloat)(0)), ((CGFloat)(0)));
        [EGMaterial.stone set];
        [egTexture(@"Gravel.png") draw:^void() {
            egDrawJasModel(RailGravel);
        }];
        [EGMaterial.wood set];
        egDrawJasModel(RailTies);
        [EGMaterial.steel set];
        egDrawJasModel(Rails);
    } else {
        if(rail.form == TRRailForm.topRight) {
            egRotate(((CGFloat)(270)), ((CGFloat)(0)), ((CGFloat)(0)), ((CGFloat)(1)));
        } else {
            if(rail.form == TRRailForm.bottomRight) {
                egRotate(((CGFloat)(180)), ((CGFloat)(0)), ((CGFloat)(0)), ((CGFloat)(1)));
            } else {
                if(rail.form == TRRailForm.leftBottom) egRotate(((CGFloat)(90)), ((CGFloat)(0)), ((CGFloat)(0)), ((CGFloat)(1)));
            }
        }
        egRotate(((CGFloat)(90)), ((CGFloat)(1)), ((CGFloat)(0)), ((CGFloat)(0)));
        egColor3(0.5, 0.5, 0.5);
        [EGMaterial.stone set];
        [egTexture(@"Gravel.png") draw:^void() {
            egDrawJasModel(RailTurnGravel);
        }];
        [EGMaterial.wood set];
        egDrawJasModel(RailTurnTies);
        [EGMaterial.steel set];
        egDrawJasModel(RailsTurn);
    }
    glPopMatrix();
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    return YES;
}

- (NSUInteger)hash {
    return 0;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendString:@">"];
    return description;
}

@end


@implementation TRSwitchView

+ (id)switchView {
    return [[TRSwitchView alloc] init];
}

- (id)init {
    self = [super init];
    
    return self;
}

- (void)drawTheSwitch:(TRSwitch*)theSwitch {
    TRRailConnector* connector = theSwitch.connector;
    glPushMatrix();
    egTranslate(((CGFloat)(theSwitch.tile.x)), ((CGFloat)(theSwitch.tile.y)), 0.03);
    egRotate(((CGFloat)(connector.angle)), ((CGFloat)(0)), ((CGFloat)(0)), ((CGFloat)(1)));
    TRRail* rail = [theSwitch activeRail];
    TRRailForm* form = rail.form;
    [EGMaterial.emerald set];
    egTranslate(-0.5, ((CGFloat)(0)), ((CGFloat)(0)));
    if(form.start.x + form.end.x == 0) {
        egRotate(((CGFloat)(90)), ((CGFloat)(1)), ((CGFloat)(0)), ((CGFloat)(0)));
        egDrawJasModel(SwitchStraight);
    } else {
        TRRailConnector* otherConnector = ((form.start == connector) ? form.end : form.start);
        NSInteger x = connector.x;
        NSInteger y = connector.y;
        NSInteger ox = otherConnector.x;
        NSInteger oy = otherConnector.y;
        if((x == -1 && oy == -1) || (y == 1 && ox == -1) || (y == -1 && ox == 1) || (x == 1 && oy == 1)) egScale(((CGFloat)(1)), ((CGFloat)(-1)), ((CGFloat)(1)));
        egRotate(((CGFloat)(90)), ((CGFloat)(1)), ((CGFloat)(0)), ((CGFloat)(0)));
        egDrawJasModel(SwitchTurn);
    }
    glPopMatrix();
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    return YES;
}

- (NSUInteger)hash {
    return 0;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendString:@">"];
    return description;
}

@end


@implementation TRLightView

+ (id)lightView {
    return [[TRLightView alloc] init];
}

- (id)init {
    self = [super init];
    
    return self;
}

- (void)drawLight:(TRLight*)light {
    glPushMatrix();
    egTranslate(((CGFloat)(light.tile.x)), ((CGFloat)(light.tile.y)), ((CGFloat)(0)));
    egRotate(((CGFloat)(light.connector.angle)), ((CGFloat)(0)), ((CGFloat)(0)), ((CGFloat)(1)));
    egTranslate(-0.45, 0.2, ((CGFloat)(0)));
    if(light.isGreen) [EGMaterial.emerald set];
    else [EGMaterial.ruby set];
    glutSolidCube(0.1);
    glPopMatrix();
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    return YES;
}

- (NSUInteger)hash {
    return 0;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendString:@">"];
    return description;
}

@end


@implementation TRDamageView

+ (id)damageView {
    return [[TRDamageView alloc] init];
}

- (id)init {
    self = [super init];
    
    return self;
}

- (void)drawPoint:(TRRailPoint*)point {
    glPushMatrix();
    egTranslate(point.point.x, point.point.y, 0.01);
    egColor4(1.0, 0.0, 0.0, 0.5);
    egNormal3(((CGFloat)(0)), ((CGFloat)(0)), ((CGFloat)(1)));
    egRect(-0.1, -0.1, 0.1, 0.1);
    glPopMatrix();
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    return YES;
}

- (NSUInteger)hash {
    return 0;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendString:@">"];
    return description;
}

@end


