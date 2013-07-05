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
    glColor3f(0.2, 0.2, 0.2);
    if(rail.start.x == rail.end.x) {
        glRotatef(90, 1, 0, 0);
        egDrawJasModel(Rail);
    } else if(rail.start.y == rail.end.y) {
        glRotatef(90, 0, 0, 1);
        glRotatef(90, 1, 0, 0);
        egDrawJasModel(Rail);
    } else {
        if(rail.start.x == 0 && rail.start.y == 1) glRotatef(90, 0, 0, 1);
        else if(rail.start.x == -1 && rail.end.y == 1) glRotatef(180, 0, 0, 1);
        else if(rail.start.x == -1 && rail.end.y == -1) glRotatef(270, 0, 0, 1);
        glRotatef(90, 1, 0, 0);
        egDrawJasModel(RailTurn);
    }
    glPopMatrix();
}

@end


