#import "TRCityView.h"

#import "EGMesh.h"
#import "EG.h"
#import "TRCity.h"
#import "GEMatrix.h"
#import "TRTypes.h"
#import "EGMaterial.h"
#import "TR3D.h"
#import "EGSchedule.h"
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
    [EG.matrix applyModify:^EGMatrixModel*(EGMatrixModel* _) {
        return [[_ modifyW:^GEMatrix*(GEMatrix* w) {
            return [w translateX:((float)(city.tile.x)) y:((float)(city.tile.y)) z:0.0];
        }] modifyM:^GEMatrix*(GEMatrix* m) {
            return [m rotateAngle:((float)(city.angle.angle)) x:0.0 y:-1.0 z:0.0];
        }];
    } f:^void() {
        [[EGStandardMaterial applyDiffuse:[EGColorSource applyColor:city.color.color]] drawMesh:TR3D.city];
        [city.expectedTrainAnimation forEach:^void(EGAnimation* a) {
            CGFloat x = -[a time] / 2;
            [[EGStandardMaterial applyDiffuse:[EGColorSource applyColor:EGColorMake(1.0, ((float)(0.5 - x)), ((float)(0.5 - x)), 1.0)]] drawMesh:_expectedTrainModel];
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


