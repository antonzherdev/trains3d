#import "TRCityView.h"

#import "EGGL.h"
#import "TRCity.h"
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
    glRotatef(city.angle, 0, 0, -1);
    glTranslatef(0, 0, 0.001);
    glColor3f(0.2, 0.2, 0.2);
    glBegin(GL_QUADS);
    glVertex2f(0, 0.05);
    glVertex2f(0.5, 0.05);
    glVertex2f(0.5, -0.05);
    glVertex2f(0, -0.05);
    glEnd();
    glTranslatef(0, 0, -0.001);
    [city.color gl];
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


