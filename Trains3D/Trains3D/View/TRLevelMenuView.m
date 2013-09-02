#import "TRLevelMenuView.h"

#import "EGCamera2D.h"
#import "EGText.h"
#import "EGSchedule.h"
#import "TRLevel.h"
#import "TRScore.h"
#import "TRCity.h"
#import "TRRailroad.h"
#import "TRTypes.h"
@implementation TRLevelMenuView{
    TRLevel* _level;
    id<EGCamera> _camera;
}
static ODClassType* _TRLevelMenuView_type;
@synthesize level = _level;
@synthesize camera = _camera;

+ (id)levelMenuViewWithLevel:(TRLevel*)level {
    return [[TRLevelMenuView alloc] initWithLevel:level];
}

- (id)initWithLevel:(TRLevel*)level {
    self = [super init];
    if(self) {
        _level = level;
        _camera = [EGCamera2D camera2DWithSize:EGSizeMake(2.0, 1.0)];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _TRLevelMenuView_type = [ODClassType classTypeWithCls:[TRLevelMenuView class]];
}

- (void)drawView {
    egColor3(1.0, 1.0, 1.0);
    egTextGlutDraw([NSString stringWithFormat:@"%li", [_level.score score]], GLUT_BITMAP_HELVETICA_18, EGPointMake(1.0, 1.0));
    NSInteger seconds = ((NSInteger)([_level.schedule time]));
    egTextGlutDraw([NSString stringWithFormat:@"%li", seconds], GLUT_BITMAP_HELVETICA_18, EGPointMake(1.5, 1.0));
    if(!([[_level.railroad damagesPoints] isEmpty]) && [[_level repairer] isEmpty]) {
    }
}

- (EGEnvironment*)environment {
    return EGEnvironment.aDefault;
}

- (void)updateWithDelta:(CGFloat)delta {
}

- (ODClassType*)type {
    return [TRLevelMenuView type];
}

+ (ODClassType*)type {
    return _TRLevelMenuView_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    TRLevelMenuView* o = ((TRLevelMenuView*)(other));
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


