#import "TRRailroadView.h"

#import "EGGL.h"
#import "EGModel.h"
#import "TRRailroad.h"
@implementation TRRailroadView{
    TRRailView* _railView;
    TRSwitchView* _switchView;
    TRLightView* _lightView;
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
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
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
    egTranslate(rail.tile.x, rail.tile.y, 0.001);
    egColor3(0.2, 0.2, 0.2);
    if(rail.form == [TRRailForm bottomTop]) {
        egRotate(90, 1, 0, 0);
        egDrawJasModel(Rail);
    } else {
        if(rail.form == [TRRailForm leftRight]) {
            egRotate(90, 0, 0, 1);
            egRotate(90, 1, 0, 0);
            egDrawJasModel(Rail);
        } else {
            if(rail.form.start.x == 0 && rail.form.start.y == 1) {
                egRotate(90, 0, 0, 1);
            } else {
                if(rail.form.start.x == -1 && rail.form.end.y == 1) {
                    egRotate(180, 0, 0, 1);
                } else {
                    if(rail.form.start.x == -1 && rail.form.end.y == -1) egRotate(270, 0, 0, 1);
                }
            }
            egRotate(90, 1, 0, 0);
            egDrawJasModel(RailTurn);
        }
    }
    glPopMatrix();
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
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
    egTranslate(theSwitch.tile.x, theSwitch.tile.y, 0.01);
    egRotate(connector.angle, 0, 0, 1);
    TRRail* rail = [theSwitch activeRail];
    TRRailForm* form = rail.form;
    egColor3(0.2, 0.8, 0.2);
    if(form.start.x + form.end.x == 0) {
        glBegin(GL_QUADS);
        egVertex2(-0.5, 0.05);
        egVertex2(-0.5, -0.05);
        egVertex2(-0.25, -0.02);
        egVertex2(-0.25, 0.02);
        glEnd();
    } else {
        TRRailConnector* otherConnector = form.start == connector ? form.end : form.start;
        NSInteger x = connector.x;
        NSInteger y = connector.y;
        NSInteger ox = otherConnector.x;
        NSInteger oy = otherConnector.y;
        if((x == -1 && oy == -1) || (y == 1 && ox == 1) || (y == -1 && ox == 1) || (x == 1 && oy == 1)) egScale(1, -1, 1);
        glBegin(GL_QUADS);
        egVertex2(-0.5, 0.05);
        egVertex2(-0.5, -0.05);
        egVertex2(-0.25, 0.1);
        egVertex2(-0.25, 0.15);
        glEnd();
    }
    glPopMatrix();
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
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
    egTranslate(light.tile.x, light.tile.y, 0);
    egRotate(light.connector.angle, 0, 0, 1);
    egTranslate(-0.45, 0.2, 0);
    if(light.isGreen) egColor3(0, 1, 0);
    else egColor3(1, 0, 0);
    glutSolidCube(0.1);
    glPopMatrix();
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end


