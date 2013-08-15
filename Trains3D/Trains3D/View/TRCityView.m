#import "TRCityView.h"

#import "EGGL.h"
#import "EGSchedule.h"
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
    glPushMatrix();
    [city.color set];
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
    [city.expectedTrainAnimation forEach:^void(EGAnimation* a) {
        egTranslate(0, 0, 0.001);
        double x = -[a time] / 2;
        egColor3(1.0, 0.5 - x, 0.5 - x);
        egRect(-0.5, -0.5, 0.5, 0.5);
    }];
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


