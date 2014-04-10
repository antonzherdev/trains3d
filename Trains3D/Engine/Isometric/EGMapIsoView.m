#import "EGMapIsoView.h"

#import "EGMapIso.h"
#import "EGMaterial.h"
#import "EGVertex.h"
#import "EGCameraIso.h"
#import "GEMat4.h"
#import "EGIndex.h"
#import "EGVertexArray.h"
#import "GL.h"
#import "EGContext.h"
@implementation EGMapSsoView
static ODClassType* _EGMapSsoView_type;
@synthesize map = _map;
@synthesize material = _material;
@synthesize plane = _plane;

+ (instancetype)mapSsoViewWithMap:(EGMapSso*)map material:(EGMaterial*)material {
    return [[EGMapSsoView alloc] initWithMap:map material:material];
}

- (instancetype)initWithMap:(EGMapSso*)map material:(EGMaterial*)material {
    self = [super init];
    if(self) {
        _map = map;
        _material = material;
        __lazy_axisVertexBuffer = [CNLazy lazyWithF:^id<EGVertexBuffer>() {
            return ({
                GEMat4* mi = [EGCameraIso.m inverse];
                [EGVBO vec4Data:[ arrs(GEVec4, 4) {[mi mulVec4:GEVec4Make(0.0, 0.0, 0.0, 1.0)], [mi mulVec4:GEVec4Make(1.0, 0.0, 0.0, 1.0)], [mi mulVec4:GEVec4Make(0.0, 1.0, 0.0, 1.0)], [mi mulVec4:GEVec4Make(0.0, 0.0, 1.0, 1.0)]}]];
            });
        }];
        _plane = ({
            GERectI limits = _map.limits;
            CGFloat l = (geRectIX(limits) - _map.size.x) - 0.5;
            CGFloat r = geRectIX2(limits) + 1.5;
            CGFloat t = (geRectIY(limits) - _map.size.y) - 0.5;
            CGFloat b = geRectIY2(limits) + 1.5;
            NSInteger w = geRectIWidth(limits) + 7;
            NSInteger h = geRectIHeight(limits) + 7;
            [EGMesh meshWithVertex:[EGVBO meshData:[ arrs(EGMeshData, 4) {EGMeshDataMake((GEVec2Make(0.0, 0.0)), (GEVec3Make(0.0, 1.0, 0.0)), (GEVec3Make(((float)(l)), 0.0, ((float)(b))))), EGMeshDataMake((GEVec2Make(((float)(w)), 0.0)), (GEVec3Make(0.0, 1.0, 0.0)), (GEVec3Make(((float)(r)), 0.0, ((float)(b))))), EGMeshDataMake((GEVec2Make(0.0, ((float)(h)))), (GEVec3Make(0.0, 1.0, 0.0)), (GEVec3Make(((float)(l)), 0.0, ((float)(t))))), EGMeshDataMake((GEVec2Make(((float)(w)), ((float)(h)))), (GEVec3Make(0.0, 1.0, 0.0)), (GEVec3Make(((float)(r)), 0.0, ((float)(t)))))}]] index:EGEmptyIndexSource.triangleStrip];
        });
        _planeVao = [_plane vaoMaterial:_material shadow:NO];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGMapSsoView class]) _EGMapSsoView_type = [ODClassType classTypeWithCls:[EGMapSsoView class]];
}

- (id<EGVertexBuffer>)axisVertexBuffer {
    return [__lazy_axisVertexBuffer get];
}

- (void)drawLayout {
    [[EGColorSource applyColor:GEVec4Make(1.0, 0.0, 0.0, 1.0)] drawVertex:[self axisVertexBuffer] index:[EGArrayIndexSource arrayIndexSourceWithArray:[ arrui4(2) {0, 1}] mode:GL_LINES]];
    [[EGColorSource applyColor:GEVec4Make(0.0, 1.0, 0.0, 1.0)] drawVertex:[self axisVertexBuffer] index:[EGArrayIndexSource arrayIndexSourceWithArray:[ arrui4(2) {0, 2}] mode:GL_LINES]];
    [[EGColorSource applyColor:GEVec4Make(0.0, 0.0, 1.0, 1.0)] drawVertex:[self axisVertexBuffer] index:[EGArrayIndexSource arrayIndexSourceWithArray:[ arrui4(2) {0, 3}] mode:GL_LINES]];
}

- (void)draw {
    EGCullFace* __tmp_0self = EGGlobal.context.cullFace;
    {
        unsigned int oldValue = [__tmp_0self disable];
        [_planeVao draw];
        if(oldValue != GL_NONE) [__tmp_0self setValue:oldValue];
    }
}

- (ODClassType*)type {
    return [EGMapSsoView type];
}

+ (ODClassType*)type {
    return _EGMapSsoView_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"map=%@", self.map];
    [description appendFormat:@", material=%@", self.material];
    [description appendString:@">"];
    return description;
}

@end


