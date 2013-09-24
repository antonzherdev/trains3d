#import "TRLevelPauseMenuView.h"

#import "TRLevel.h"
#import "EGCamera2D.h"
#import "EGContext.h"
#import "EGDirector.h"
#import "GL.h"
#import "EGSprite.h"
@implementation TRLevelPauseMenuView{
    TRLevel* _level;
    GEVec2 __lastViewportSize;
    id<EGCamera> __lastCamera;
}
static ODClassType* _TRLevelPauseMenuView_type;
@synthesize level = _level;

+ (id)levelPauseMenuViewWithLevel:(TRLevel*)level {
    return [[TRLevelPauseMenuView alloc] initWithLevel:level];
}

- (id)initWithLevel:(TRLevel*)level {
    self = [super init];
    if(self) {
        _level = level;
        __lastViewportSize = GEVec2Make(0.0, 0.0);
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _TRLevelPauseMenuView_type = [ODClassType classTypeWithCls:[TRLevelPauseMenuView class]];
}

- (id<EGCamera>)cameraWithViewport:(GERect)viewport {
    if(GEVec2Eq(viewport.size, __lastViewportSize)) {
        return __lastCamera;
    } else {
        __lastViewportSize = viewport.size;
        __lastCamera = [EGCamera2D camera2DWithSize:GEVec2Make(geRectWidth(viewport), geRectHeight(viewport))];
        return __lastCamera;
    }
}

- (void)draw {
    if(!([[EGGlobal director] isPaused])) return ;
    egBlendFunctionApplyDraw(egBlendFunctionStandard(), ^void() {
        glDisable(GL_DEPTH_TEST);
        [EGSprite drawMaterial:[EGColorSource applyColor:GEVec4Make(0.0, 0.0, 0.0, 0.5)] in:GERectMake(GEVec2Make(0.0, 0.0), geVec2ApplyVec2i([EGGlobal.context viewport].size))];
        glEnable(GL_DEPTH_TEST);
    });
}

- (BOOL)isProcessorActive {
    return [[EGGlobal director] isPaused];
}

- (BOOL)processEvent:(EGEvent*)event {
    return [event leftMouseProcessor:self];
}

- (BOOL)mouseUpEvent:(EGEvent*)event {
    return NO;
}

- (id<EGCamera>)camera {
    return [self cameraWithViewport:geRectApplyXYWidthHeight(-1.0, -1.0, 2.0, 2.0)];
}

- (EGEnvironment*)environment {
    return EGEnvironment.aDefault;
}

- (void)updateWithDelta:(CGFloat)delta {
}

- (BOOL)mouseDownEvent:(EGEvent*)event {
    return NO;
}

- (BOOL)mouseDragEvent:(EGEvent*)event {
    return NO;
}

- (ODClassType*)type {
    return [TRLevelPauseMenuView type];
}

+ (ODClassType*)type {
    return _TRLevelPauseMenuView_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    TRLevelPauseMenuView* o = ((TRLevelPauseMenuView*)(other));
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


