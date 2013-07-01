#import "TRCityView.h"

@implementation TRCityView

+ (id)cityView {
    return [[TRCityView alloc] init];
}

- (id)init {
    self = [super init];
    
    return self;
}

- (void)drawCity:(TRCity*)city {
    glPushMatrix();
    glTranslatef(city.tile.x, city.tile.y, 0);
    glTranslatef(0, 0, 0.001);
    glColor3f(0.5, 0.5, 0.5);
    glBegin(GL_QUADS);
    glVertex2f(0, 0.05);
    glVertex2f(0.5, 0.05);
    glVertex2f(0.5, -0.05);
    glVertex2f(0, -0.05);
    glEnd();
    glTranslatef(0, 0, -0.001);
    EGColor col = city.color.color;
    glColor3f(col.r, col.g, col.b);
    glTranslatef(0.3, -0.3, 0);
    glutSolidCube(0.15);
    glTranslatef(-0.3, 0, 0);
    glutSolidCube(0.15);
    glTranslatef(-0.3, 0, 0);
    glutSolidCube(0.15);
    glTranslatef(0, 0.6, 0);
    glutSolidCube(0.15);
    glTranslatef(0.3, 0, 0);
    glutSolidCube(0.15);
    glTranslatef(0.3, 0, 0);
    glutSolidCube(0.15);
    glPopMatrix();
}

@end

