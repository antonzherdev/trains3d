#import "TRLevelBackgroundView.h"

#import "EGMapIso.h"
#import "EGMaterial.h"
#import "EGContext.h"
@implementation TRLevelBackgroundView{
    EGMapSso* _map;
    EGMapSsoView* _mapView;
    EGStandardMaterial* _material;
}
static ODClassType* _TRLevelBackgroundView_type;
@synthesize map = _map;
@synthesize mapView = _mapView;
@synthesize material = _material;

+ (id)levelBackgroundViewWithMap:(EGMapSso*)map {
    return [[TRLevelBackgroundView alloc] initWithMap:map];
}

- (id)initWithMap:(EGMapSso*)map {
    self = [super init];
    if(self) {
        _map = map;
        _mapView = [EGMapSsoView mapSsoViewWithMap:_map];
        _material = [EGStandardMaterial applyDiffuse:[EGColorSource applyTexture:[EGGlobal textureForFile:@"Grass.png"]]];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _TRLevelBackgroundView_type = [ODClassType classTypeWithCls:[TRLevelBackgroundView class]];
}

- (void)draw {
    [_mapView drawPlaneWithMaterial:_material];
}

- (ODClassType*)type {
    return [TRLevelBackgroundView type];
}

+ (ODClassType*)type {
    return _TRLevelBackgroundView_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    TRLevelBackgroundView* o = ((TRLevelBackgroundView*)(other));
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


