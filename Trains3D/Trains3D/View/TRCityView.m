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
    egTranslate(((float)(city.tile.x)), ((float)(city.tile.y)), ((float)(0)));
    egRotate(((float)(city.angle.angle)), ((float)(0)), ((float)(0)), ((float)(-1)));
    egTranslate(((float)(0)), ((float)(0)), 0.001);
    egColor3(0.2, 0.2, 0.2);
    glBegin(GL_QUADS);
    egVertex2(((float)(0)), 0.05);
    egVertex2(0.5, 0.05);
    egVertex2(0.5, -0.05);
    egVertex2(((float)(0)), -0.05);
    glEnd();
    egTranslate(((float)(0)), ((float)(0)), -0.001);
    glPushMatrix();
    [city.color setMaterial];
    egTranslate(0.3, -0.3, ((float)(0)));
    glutSolidCube(0.15);
    egTranslate(-0.3, ((float)(0)), ((float)(0)));
    glutSolidCube(0.15);
    egTranslate(-0.3, ((float)(0)), ((float)(0)));
    glutSolidCube(0.15);
    egTranslate(((float)(0)), 0.6, ((float)(0)));
    glutSolidCube(0.15);
    egTranslate(0.3, ((float)(0)), ((float)(0)));
    glutSolidCube(0.15);
    egTranslate(0.3, ((float)(0)), ((float)(0)));
    glutSolidCube(0.15);
    glPopMatrix();
    [city.expectedTrainAnimation forEach:^void(EGAnimation* a) {
        egTranslate(((float)(0)), ((float)(0)), 0.001);
        float x = -[a time] / 2;
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


