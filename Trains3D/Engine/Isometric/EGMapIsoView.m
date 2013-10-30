#import "EGMapIsoView.h"

#import "EGMapIso.h"
#import "EGMaterial.h"
#import "EGVertex.h"
#import "EGCameraIso.h"
#import "GEMat4.h"
#import "EGIndex.h"
#import "GL.h"
#import "EGContext.h"
@implementation EGMapSsoView{
    EGMapSso* _map;
    EGMaterial* _material;
    CNLazy* __lazy_axisVertexBuffer;
    EGMesh* _plane;
    EGVertexArray* _planeVao;
}
static ODClassType* _EGMapSsoView_type;
@synthesize map = _map;
@synthesize material = _material;
@synthesize plane = _plane;

+ (id)mapSsoViewWithMap:(EGMapSso*)map material:(EGMaterial*)material {
    return [[EGMapSsoView alloc] initWithMap:map material:material];
}

- (id)initWithMap:(EGMapSso*)map material:(EGMaterial*)material {
    self = [super init];
    if(self) {
        _map = map;
        _material = material;
        __lazy_axisVertexBuffer = [CNLazy lazyWithF:^id<EGVertexBuffer>() {
            return ^id<EGVertexBuffer>() {
                GEMat4* mi = [EGCameraIso.m inverse];
                return [EGVBO vec4Data:[ arrs(GEVec4, 4) {[mi mulVec4:GEVec4Make(0.0, 0.0, 0.0, 1.0)], [mi mulVec4:GEVec4Make(1.0, 0.0, 0.0, 1.0)], [mi mulVec4:GEVec4Make(0.0, 1.0, 0.0, 1.0)], [mi mulVec4:GEVec4Make(0.0, 0.0, 1.0, 1.0)]}]];
            }();
        }];
        _plane = ^EGMesh*() {
            GERectI limits = _map.limits;
            CGFloat l = geRectIX(limits) - 3.5;
            CGFloat r = geRectIX2(limits) + 0.5;
            CGFloat t = geRectIY(limits) - 3.5;
            CGFloat b = geRectIY2(limits) + 0.5;
            NSInteger w = geRectIWidth(limits) + 4;
            NSInteger h = geRectIHeight(limits) + 4;
            return [EGMesh meshWithVertex:[EGVBO meshData:[ arrs(EGMeshData, 4) {EGMeshDataMake(GEVec2Make(0.0, 0.0), GEVec3Make(0.0, 1.0, 0.0), GEVec3Make(((float)(l)), 0.0, ((float)(b)))), EGMeshDataMake(GEVec2Make(((float)(w)), 0.0), GEVec3Make(0.0, 1.0, 0.0), GEVec3Make(((float)(r)), 0.0, ((float)(b)))), EGMeshDataMake(GEVec2Make(0.0, ((float)(h))), GEVec3Make(0.0, 1.0, 0.0), GEVec3Make(((float)(l)), 0.0, ((float)(t)))), EGMeshDataMake(GEVec2Make(((float)(w)), ((float)(h))), GEVec3Make(0.0, 1.0, 0.0), GEVec3Make(((float)(r)), 0.0, ((float)(t))))}]] index:EGEmptyIndexSource.triangleStrip];
        }();
        _planeVao = [_plane vaoMaterial:_material shadow:NO];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGMapSsoView_type = [ODClassType classTypeWithCls:[EGMapSsoView class]];
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
    [EGGlobal.context.cullFace disabledF:^void() {
        [_planeVao draw];
    }];
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

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGMapSsoView* o = ((EGMapSsoView*)(other));
    return [self.map isEqual:o.map] && [self.material isEqual:o.material];
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.map hash];
    hash = hash * 31 + [self.material hash];
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"map=%@", self.map];
    [description appendFormat:@", material=%@", self.material];
    [description appendString:@">"];
    return description;
}

@end


