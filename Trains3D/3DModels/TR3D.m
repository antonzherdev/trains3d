#import "TR3D.h"

#import "EGMesh.h"
#import "TR3DRail.h"

@implementation TR3D
static EGMesh* _TR3D_railTies = nil;
static EGMesh* _TR3D_railGravel = nil;
static EGMesh* _TR3D_rails = nil;
static ODType* _TR3D_type;

+ (id)r3D {
    return [[TR3D alloc] init];
}

- (id)init {
    self = [super init];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _TR3D_type = [ODType typeWithCls:[TR3D class]];
    _TR3D_railTies = egJasModel(RailTies);
    _TR3D_railGravel = egJasModel(RailGravel);
    _TR3D_rails = egJasModel(Rails);
}

- (ODType*)type {
    return _TR3D_type;
}

+ (EGMesh*)railTies {
    return _TR3D_railTies;
}

+ (EGMesh*)railGravel {
    return _TR3D_railGravel;
}

+ (EGMesh*)rails {
    return _TR3D_rails;
}

+ (ODType*)type {
    return _TR3D_type;
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


