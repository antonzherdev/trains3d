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
    egTranslate(((CGFloat)(city.tile.x)), ((CGFloat)(city.tile.y)), ((CGFloat)(0)));
    egRotate(((CGFloat)(city.angle.angle)), ((CGFloat)(0)), ((CGFloat)(0)), ((CGFloat)(-1)));
    egTranslate(((CGFloat)(0)), ((CGFloat)(0)), 0.001);
    egColor3(0.2, 0.2, 0.2);
    glBegin(GL_QUADS);
    egVertex2(((CGFloat)(0)), 0.05);
    egVertex2(0.5, 0.05);
    egVertex2(0.5, -0.05);
    egVertex2(((CGFloat)(0)), -0.05);
    glEnd();
    egTranslate(((CGFloat)(0)), ((CGFloat)(0)), -0.001);
    glPushMatrix();
    [city.color setMaterial];
    egTranslate(0.3, -0.3, ((CGFloat)(0)));
    glutSolidCube(0.15);
    egTranslate(-0.3, ((CGFloat)(0)), ((CGFloat)(0)));
    glutSolidCube(0.15);
    egTranslate(-0.3, ((CGFloat)(0)), ((CGFloat)(0)));
    glutSolidCube(0.15);
    egTranslate(((CGFloat)(0)), 0.6, ((CGFloat)(0)));
    glutSolidCube(0.15);
    egTranslate(0.3, ((CGFloat)(0)), ((CGFloat)(0)));
    glutSolidCube(0.15);
    egTranslate(0.3, ((CGFloat)(0)), ((CGFloat)(0)));
    glutSolidCube(0.15);
    glPopMatrix();
    [city.expectedTrainAnimation forEach:^void(EGAnimation* a) {
        egTranslate(((CGFloat)(0)), ((CGFloat)(0)), 0.001);
        CGFloat x = -[a time] / 2;
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


