#import "TRCityView.h"

#import "EGGL.h"
#import "TRCity.h"
#import "TRTypes.h"
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
    egTranslate(city.tile.x, city.tile.y, 0);
    egRotate(city.angle.angle, 0, 0, -1);
    egTranslate(0, 0, 0.001);
    egColor3(0.2, 0.2, 0.2);
    glBegin(GL_QUADS);
    egVertex2(0, 0.05);
    egVertex2(0.5, 0.05);
    egVertex2(0.5, -0.05);
    egVertex2(0, -0.05);
    glEnd();
    egTranslate(0, 0, -0.001);
    [city.color gl];
    egTranslate(0.3, -0.3, 0);
    glutSolidCube(0.15);
    egTranslate(-0.3, 0, 0);
    glutSolidCube(0.15);
    egTranslate(-0.3, 0, 0);
    glutSolidCube(0.15);
    egTranslate(0, 0.6, 0);
    glutSolidCube(0.15);
    egTranslate(0.3, 0, 0);
    glutSolidCube(0.15);
    egTranslate(0.3, 0, 0);
    glutSolidCube(0.15);
    glPopMatrix();
}

@end


