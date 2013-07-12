#import "TRRailroadView.h"

#import "EGGL.h"
#import "EGModel.h"
#import "TRRailroad.h"
@implementation TRRailroadView{
    TRRailView* _railView;
    TRSwitchView* _switchView;
}

+ (id)railroadView {
    return [[TRRailroadView alloc] init];
}

- (id)init {
    self = [super init];
    if(self) {
        _railView = [TRRailView railView];
        _switchView = [TRSwitchView switchView];
    }
    
    return self;
}

- (void)drawRailroad:(TRRailroad*)railroad {
    [railroad.rails forEach:^void(TRRail* _) {
        [_railView drawRail:_];
    }];
    [railroad.switches forEach:^void(TRSwitch* _) {
        [_switchView drawTheSwitch:_];
    }];
    [railroad.builder.rail forEach:^void(TRRail* _) {
        [_railView drawRail:_];
    }];
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
    glTranslatef(rail.tile.x, rail.tile.y, 0.001);
    glColor3f(0.2, 0.2, 0.2);
    if(rail.form == [TRRailForm bottomTop]) {
        glRotatef(90, 1, 0, 0);
        egDrawJasModel(Rail);
    } else {
        if(rail.form == [TRRailForm leftRight]) {
            glRotatef(90, 0, 0, 1);
            glRotatef(90, 1, 0, 0);
            egDrawJasModel(Rail);
        } else {
            if(rail.form.start.x == 0 && rail.form.start.y == 1) {
                glRotatef(90, 0, 0, 1);
            } else {
                if(rail.form.start.x == -1 && rail.form.end.y == 1) {
                    glRotatef(180, 0, 0, 1);
                } else {
                    if(rail.form.start.x == -1 && rail.form.end.y == -1) glRotatef(270, 0, 0, 1);
                }
            }
            glRotatef(90, 1, 0, 0);
            egDrawJasModel(RailTurn);
        }
    }
    glPopMatrix();
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
    glTranslatef(theSwitch.tile.x, theSwitch.tile.y, 0.01);
    glRotatef(connector.angle, 0, 0, 1);
    TRRail* rail = [theSwitch activeRail];
    TRRailForm* form = rail.form;
    glColor3f(0.2, 0.8, 0.2);
    if(form.start.x + form.end.x == 0) {
        glBegin(GL_QUADS);
        glVertex2f(-0.5, 0.05);
        glVertex2f(-0.5, -0.05);
        glVertex2f(-0.25, -0.02);
        glVertex2f(-0.25, 0.02);
        glEnd();
    } else {
        TRRailConnector* otherConnector = form.start == connector ? form.end : form.start;
        NSInteger x = connector.x;
        NSInteger y = connector.y;
        NSInteger ox = otherConnector.x;
        NSInteger oy = otherConnector.y;
        if((x == -1 && oy == -1) || (y == 1 && ox == 1) || (y == -1 && ox == 1) || (x == 1 && oy == 1)) glScalef(1, -1, 1);
        glBegin(GL_QUADS);
        glVertex2f(-0.5, 0.05);
        glVertex2f(-0.5, -0.05);
        glVertex2f(-0.25, 0.1);
        glVertex2f(-0.25, 0.15);
        glEnd();
    }
    glPopMatrix();
}

@end


