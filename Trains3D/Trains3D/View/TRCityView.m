#import "TRCityView.h"

#import "EG.h"
#import "EGSchedule.h"
#import "EGMesh.h"
#import "EG.h"
#import "EGMaterial.h"
#import "TRCity.h"
#import "TRTypes.h"
#import "TR3D.h"
@implementation TRCityView{
    EGMesh* _expectedTrainModel;
}
static ODClassType* _TRCityView_type;
@synthesize expectedTrainModel = _expectedTrainModel;

+ (id)cityView {
    return [[TRCityView alloc] init];
}

- (id)init {
    self = [super init];
    if(self) _expectedTrainModel = [EGMesh applyVertexData:[ arrf4(32) {0, 0, 0, 1, 0, -0.5, 0.001, -0.5, 1, 0, 0, 1, 0, 0.5, 0.001, -0.5, 1, 1, 0, 1, 0, 0.5, 0.001, 0.5, 0, 1, 0, 1, 0, -0.5, 0.001, 0.5}] index:[ arrui4(6) {0, 1, 2, 2, 3, 0}]];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _TRCityView_type = [ODClassType classTypeWithCls:[TRCityView class]];
}

- (void)drawCity:(TRCity*)city {
    [EG keepMWF:^void() {
        [[EG worldMatrix] translateX:((CGFloat)(city.tile.x)) y:((CGFloat)(city.tile.y)) z:0.0];
        [[EG modelMatrix] rotateAngle:((CGFloat)(city.angle.angle)) x:0.0 y:-1.0 z:0.0];
        [TR3D.city drawWithMaterial:[EGMaterial applyColor:city.color.color]];
        [city.expectedTrainAnimation forEach:^void(EGAnimation* a) {
            CGFloat x = -[a time] / 2;
            [_expectedTrainModel drawWithMaterial:[EGMaterial applyColor:EGColorMake(1.0, 0.5 - x, 0.5 - x, 1.0)]];
        }];
    }];
}

- (ODClassType*)type {
    return [TRCityView type];
}

+ (ODClassType*)type {
    return _TRCityView_type;
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


