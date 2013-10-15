#import "TRCityView.h"

#import "TRLevel.h"
#import "EGMesh.h"
#import "EGMaterial.h"
#import "EGTexture.h"
#import "GL.h"
#import "EGContext.h"
#import "TRModels.h"
#import "TRCity.h"
#import "GEMat4.h"
#import "EGSchedule.h"
@implementation TRCityView{
    TRLevel* _level;
    EGVertexArray* _expectedTrainModel;
    EGTexture* _cityTexture;
    EGVertexArray* _vaoBody;
}
static ODClassType* _TRCityView_type;
@synthesize level = _level;
@synthesize expectedTrainModel = _expectedTrainModel;
@synthesize cityTexture = _cityTexture;
@synthesize vaoBody = _vaoBody;

+ (id)cityViewWithLevel:(TRLevel*)level {
    return [[TRCityView alloc] initWithLevel:level];
}

- (id)initWithLevel:(TRLevel*)level {
    self = [super init];
    if(self) {
        _level = level;
        _expectedTrainModel = [[EGMesh applyVertexData:[ arrs(EGMeshData, 32) {0, 0, 0, 1, 0, -0.5, 0.001, -0.5, 1, 0, 0, 1, 0, 0.5, 0.001, -0.5, 1, 1, 0, 1, 0, 0.5, 0.001, 0.5, 0, 1, 0, 1, 0, -0.5, 0.001, 0.5}] indexData:[ arrui4(6) {0, 1, 2, 2, 3, 0}]] vaoMaterial:[EGStandardMaterial applyColor:GEVec4Make(1.0, 1.0, 1.0, 1.0)] shadow:NO];
        _cityTexture = [EGGlobal textureForFile:@"City.png" magFilter:GL_LINEAR minFilter:GL_LINEAR_MIPMAP_NEAREST];
        _vaoBody = [TRModels.city vaoMaterial:[EGStandardMaterial applyTexture:_cityTexture] shadow:YES];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _TRCityView_type = [ODClassType classTypeWithCls:[TRCityView class]];
}

- (void)draw {
    egPushGroupMarker(@"Cities");
    [[_level cities] forEach:^void(TRCity* city) {
        [EGGlobal.matrix applyModify:^EGMatrixModel*(EGMatrixModel* _) {
            return [[_ modifyW:^GEMat4*(GEMat4* w) {
                return [w translateX:((float)(city.tile.x)) y:((float)(city.tile.y)) z:0.0];
            }] modifyM:^GEMat4*(GEMat4* m) {
                return [m rotateAngle:((float)(city.angle.angle)) x:0.0 y:-1.0 z:0.0];
            }];
        } f:^void() {
            [_vaoBody drawParam:[EGStandardMaterial applyDiffuse:[EGColorSource applyColor:city.color.color texture:_cityTexture]]];
            if(!([EGGlobal.context.renderTarget isKindOfClass:[EGShadowRenderTarget class]])) [city.expectedTrainCounter forF:^void(CGFloat time) {
                CGFloat x = -time / 2;
                [_expectedTrainModel drawParam:[EGStandardMaterial applyColor:GEVec4Make(1.0, ((float)(0.5 - x)), ((float)(0.5 - x)), 1.0)]];
            }];
        }];
    }];
    egPopGroupMarker();
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
    TRCityView* o = ((TRCityView*)(other));
    return [self.level isEqual:o.level];
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.level hash];
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"level=%@", self.level];
    [description appendString:@">"];
    return description;
}

@end


