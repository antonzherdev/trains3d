#import "TRCityView.h"

#import "EGMesh.h"
#import "EGTexture.h"
#import "EGContext.h"
#import "EGMaterial.h"
#import "TRCity.h"
#import "GEMat4.h"
#import "TRModels.h"
#import "GL.h"
#import "EGSchedule.h"
@implementation TRCityView{
    EGMesh* _expectedTrainModel;
    EGTexture* _roofTexture;
    EGStandardMaterial* _windowMaterial;
}
static ODClassType* _TRCityView_type;
@synthesize expectedTrainModel = _expectedTrainModel;
@synthesize roofTexture = _roofTexture;
@synthesize windowMaterial = _windowMaterial;

+ (id)cityView {
    return [[TRCityView alloc] init];
}

- (id)init {
    self = [super init];
    if(self) {
        _expectedTrainModel = [EGMesh applyVertexData:[ arrs(EGMeshData, 32) {0, 0, 0, 1, 0, -0.5, 0.001, -0.5, 1, 0, 0, 1, 0, 0.5, 0.001, -0.5, 1, 1, 0, 1, 0, 0.5, 0.001, 0.5, 0, 1, 0, 1, 0, -0.5, 0.001, 0.5}] indexData:[ arrui4(6) {0, 1, 2, 2, 3, 0}]];
        _roofTexture = [EGGlobal textureForFile:@"Roof.png"];
        _windowMaterial = [EGStandardMaterial standardMaterialWithDiffuse:[EGColorSource applyTexture:[EGGlobal textureForFile:@"Window.png"]] specularColor:GEVec4Make(1.0, 1.0, 1.0, 1.0) specularSize:1.0];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _TRCityView_type = [ODClassType classTypeWithCls:[TRCityView class]];
}

- (void)drawCity:(TRCity*)city {
    [EGGlobal.matrix applyModify:^EGMatrixModel*(EGMatrixModel* _) {
        return [[_ modifyW:^GEMat4*(GEMat4* w) {
            return [w translateX:((float)(city.tile.x)) y:((float)(city.tile.y)) z:0.0];
        }] modifyM:^GEMat4*(GEMat4* m) {
            return [m rotateAngle:((float)(city.angle.angle)) x:0.0 y:-1.0 z:0.0];
        }];
    } f:^void() {
        [[EGStandardMaterial applyColor:city.color.color] drawMesh:TRModels.cityBodies];
        if(!([EGGlobal.context.renderTarget isKindOfClass:[EGShadowRenderTarget class]])) {
            glDisable(GL_CULL_FACE);
            EGStandardMaterial* roofMaterial = [EGStandardMaterial standardMaterialWithDiffuse:[EGColorSource applyColor:city.color.color texture:_roofTexture] specularColor:GEVec4Make(0.5, 0.5, 0.5, 1.0) specularSize:1.0];
            [roofMaterial drawMesh:TRModels.cityRoofs];
            glEnable(GL_CULL_FACE);
            [_windowMaterial drawMesh:TRModels.cityWindows];
            [city.expectedTrainCounter forF:^void(CGFloat time) {
                CGFloat x = -time / 2;
                [[EGStandardMaterial applyColor:GEVec4Make(1.0, ((float)(0.5 - x)), ((float)(0.5 - x)), 1.0)] drawMesh:_expectedTrainModel];
            }];
        }
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


