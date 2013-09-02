#import "TRLevelBackgroundView.h"

#import "EG.h"
#import "EGTexture.h"
#import "TRLevel.h"
#import "EGMapIso.h"
#import "EGMaterial.h"
@implementation TRLevelBackgroundView{
    EGMapSso* _map;
    EGMapSsoView* _mapView;
}
static ODClassType* _TRLevelBackgroundView_type;
@synthesize map = _map;
@synthesize mapView = _mapView;

+ (id)levelBackgroundViewWithMap:(EGMapSso*)map {
    return [[TRLevelBackgroundView alloc] initWithMap:map];
}

- (id)initWithMap:(EGMapSso*)map {
    self = [super init];
    if(self) {
        _map = map;
        _mapView = [EGMapSsoView mapSsoViewWithMap:_map];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _TRLevelBackgroundView_type = [ODClassType classTypeWithCls:[TRLevelBackgroundView class]];
}

- (void)draw {
    [_mapView drawPlaneWithMaterial:[EGMaterial applyTexture:[EGTexture textureWithFile:@"Grass.png"]]];
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


