#import "EGContext.h"

#import "EGTexture.h"
#import "EGMatrix.h"
@implementation EGContext{
    NSMutableDictionary* _textureCache;
    EGMatrixModel* _matrixModel;
}
@synthesize matrixModel = _matrixModel;

+ (id)context {
    return [[EGContext alloc] init];
}

- (id)init {
    self = [super init];
    if(self) {
        _textureCache = [NSMutableDictionary mutableDictionary];
        _matrixModel = [EGMatrixModel matrixModel];
    }
    
    return self;
}

- (EGTexture*)textureForFile:(NSString*)file {
    return ((EGTexture*)([_textureCache objectForKey:file orUpdateWith:^EGTexture*() {
        return [EGTexture textureWithFile:file];
    }]));
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


@implementation EGMatrixModel{
    EGMatrix* __model;
    EGMatrix* __view;
    EGMatrix* __projection;
}

+ (id)matrixModel {
    return [[EGMatrixModel alloc] init];
}

- (id)init {
    self = [super init];
    if(self) {
        __model = [EGMatrix identity];
        __view = [EGMatrix identity];
        __projection = [EGMatrix identity];
    }
    
    return self;
}

- (EGMatrix*)mvp {
    return [[__projection multiply:__view] multiply:__model];
}

- (void)clear {
    __model = [EGMatrix identity];
    __view = [EGMatrix identity];
    __projection = [EGMatrix identity];
}

- (EGMatrix*)model {
    return __model;
}

- (void)setModelMatrix:(EGMatrix*)matrix {
    __model = matrix;
}

- (EGMatrix*)view {
    return __view;
}

- (void)setViewMatrix:(EGMatrix*)matrix {
    __view = matrix;
}

- (EGMatrix*)projection {
    return __projection;
}

- (void)setProjectionMatrix:(EGMatrix*)matrix {
    __projection = matrix;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendString:@">"];
    return description;
}

@end


@implementation EGMutableMatrix{
    EGMatrix* __value;
}

+ (id)mutableMatrix {
    return [[EGMutableMatrix alloc] init];
}

- (id)init {
    self = [super init];
    
    return self;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendString:@">"];
    return description;
}

@end


