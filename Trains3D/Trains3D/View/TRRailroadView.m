#import "TRRailroadView.h"

@implementation TRRailroadView{
    TRRailView* _railView;
}

+ (id)railroadView {
    return [[TRRailroadView alloc] init];
}

- (id)init {
    self = [super init];
    if(self) _railView = [TRRailView railView];
    
    return self;
}

- (void)drawRailroad:(TRRailroad*)railroad {
    [railroad.rails forEach:^void(TRRail* _) {
        [_railView drawRail:_];
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
    glScalef(0.5, 0.5, 0);
    glColor3f(0.2, 0.2, 0.2);
    glBegin(GL_QUADS);
    if(rail.start.y == 0) {
        glVertex2f(rail.start.x, -0.05);
        glVertex2f(rail.start.x, 0.05);
    } else {
        glVertex2f(-0.05, rail.start.y);
        glVertex2f(0.05, rail.start.y);
    }
    if(rail.end.y == 0) {
        glVertex2f(rail.end.x, 0.05);
        glVertex2f(rail.end.x, -0.05);
    } else {
        glVertex2f(0.05, rail.end.y);
        glVertex2f(-0.05, rail.end.y);
    }
    glEnd();
    glPopMatrix();
}

@end


