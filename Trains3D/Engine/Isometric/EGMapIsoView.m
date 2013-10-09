#import "EGMapIsoView.h"

#import "EGMapIso.h"
#import "EGCameraIso.h"
#import "GEMat4.h"
#import "EGMaterial.h"
#import "GL.h"
#import "EGContext.h"
@implementation EGMapSsoView{
    EGMapSso* _map;
    CNLazy* __lazy_axisVertexBuffer;
    EGMesh* _plane;
}
static ODClassType* _EGMapSsoView_type;
@synthesize map = _map;
@synthesize plane = _plane;

+ (id)mapSsoViewWithMap:(EGMapSso*)map {
    return [[EGMapSsoView alloc] initWithMap:map];
}

- (id)initWithMap:(EGMapSso*)map {
    self = [super init];
    if(self) {
        _map = map;
        __lazy_axisVertexBuffer = [CNLazy lazyWithF:^EGVertexBuffer*() {
            return ^EGVertexBuffer*() {
                GEMat4* mi = [EGCameraIso.m inverse];
                return [[EGVertexBuffer vec4] setData:[ arrs(GEVec4, 4) {[mi mulVec4:GEVec4Make(0.0, 0.0, 0.0, 1.0)], [mi mulVec4:GEVec4Make(1.0, 0.0, 0.0, 1.0)], [mi mulVec4:GEVec4Make(0.0, 1.0, 0.0, 1.0)], [mi mulVec4:GEVec4Make(0.0, 0.0, 1.0, 1.0)]}]];
            }();
        }];
        _plane = ^EGMesh*() {
            GERectI limits = _map.limits;
            CGFloat l = geRectIX(limits) - 2.5;
            CGFloat r = geRectIX2(limits) + 0.5;
            CGFloat t = geRectIY(limits) - 2.5;
            CGFloat b = geRectIY2(limits) + 0.5;
            NSInteger w = geRectIWidth(limits) + 3;
            NSInteger h = geRectIHeight(limits) + 3;
            return [EGMesh applyVertexData:[ arrs(EGMeshData, 4) {EGMeshDataMake(GEVec2Make(0.0, 0.0), GEVec3Make(0.0, 1.0, 0.0), GEVec3Make(((float)(l)), 0.0, ((float)(b)))), EGMeshDataMake(GEVec2Make(((float)(w)), 0.0), GEVec3Make(0.0, 1.0, 0.0), GEVec3Make(((float)(r)), 0.0, ((float)(b)))), EGMeshDataMake(GEVec2Make(((float)(w)), ((float)(h))), GEVec3Make(0.0, 1.0, 0.0), GEVec3Make(((float)(r)), 0.0, ((float)(t)))), EGMeshDataMake(GEVec2Make(0.0, ((float)(h))), GEVec3Make(0.0, 1.0, 0.0), GEVec3Make(((float)(l)), 0.0, ((float)(t))))}] indexData:[ arrui4(6) {0, 1, 2, 2, 3, 0}]];
        }();
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGMapSsoView_type = [ODClassType classTypeWithCls:[EGMapSsoView class]];
}

- (EGVertexBuffer*)axisVertexBuffer {
    return ((EGVertexBuffer*)([__lazy_axisVertexBuffer get]));
}

- (void)drawLayout {
    [[EGColorSource applyColor:GEVec4Make(1.0, 0.0, 0.0, 1.0)] drawVb:[self axisVertexBuffer] index:[ arrui4(2) {0, 1}] mode:((unsigned int)(GL_LINES))];
    [[EGColorSource applyColor:GEVec4Make(0.0, 1.0, 0.0, 1.0)] drawVb:[self axisVertexBuffer] index:[ arrui4(2) {0, 2}] mode:((unsigned int)(GL_LINES))];
    [[EGColorSource applyColor:GEVec4Make(0.0, 0.0, 1.0, 1.0)] drawVb:[self axisVertexBuffer] index:[ arrui4(2) {0, 3}] mode:((unsigned int)(GL_LINES))];
}

- (void)drawPlaneWithMaterial:(EGMaterial*)material {
    [EGGlobal.context.cullFace disabledF:^void() {
        [material drawMesh:_plane];
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
    return [self.map isEqual:o.map];
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.map hash];
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"map=%@", self.map];
    [description appendString:@">"];
    return description;
}

@end


