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
    EGColor col = city.color.color;
    glColor3f(col.r, col.g, col.b);
    glutSolidCube(1.0);
    glPopMatrix();
}

@end


