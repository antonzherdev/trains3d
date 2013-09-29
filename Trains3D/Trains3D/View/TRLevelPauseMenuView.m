#import "TRLevelPauseMenuView.h"

#import "TRLevel.h"
#import "EGCamera2D.h"
#import "EGSprite.h"
#import "EGContext.h"
#import "EGDirector.h"
#import "GL.h"
#import "TRStrings.h"
#import "TRLevelFactory.h"
@implementation TRLevelPauseMenuView{
    TRLevel* _level;
    GEVec2 __lastViewportSize;
    id<EGCamera> __lastCamera;
    CNCache* _cameraCache;
    NSInteger _width;
    EGSprite* _menuBackSprite;
    EGLine2d* _resumeLine;
    EGLine2d* _restartLine;
    EGLine2d* _mainMenuLine;
    EGFont* _font;
}
static ODClassType* _TRLevelPauseMenuView_type;
@synthesize level = _level;
@synthesize width = _width;
@synthesize menuBackSprite = _menuBackSprite;
@synthesize resumeLine = _resumeLine;
@synthesize restartLine = _restartLine;
@synthesize mainMenuLine = _mainMenuLine;
@synthesize font = _font;

+ (id)levelPauseMenuViewWithLevel:(TRLevel*)level {
    return [[TRLevelPauseMenuView alloc] initWithLevel:level];
}

- (id)initWithLevel:(TRLevel*)level {
    self = [super init];
    if(self) {
        _level = level;
        __lastViewportSize = GEVec2Make(0.0, 0.0);
        _cameraCache = [CNCache cacheWithF:^EGCamera2D*(id viewport) {
            return [EGCamera2D camera2DWithSize:GEVec2Make(geRectWidth(uwrap(GERect, viewport)), geRectHeight(uwrap(GERect, viewport)))];
        }];
        _width = 350;
        _menuBackSprite = [EGSprite applyMaterial:[EGColorSource applyColor:geVec4DivI(GEVec4Make(220.0, 220.0, 220.0, 255.0), 255)] size:GEVec2Make(((float)(_width)), 150.0)];
        _resumeLine = [EGLine2d applyMaterial:[EGColorSource applyColor:geVec4DivI(GEVec4Make(49.0, 90.0, 3.0, 255.0), 255)]];
        _restartLine = [EGLine2d applyMaterial:[EGColorSource applyColor:geVec4DivI(GEVec4Make(248.0, 149.0, 21.0, 255.0), 255)]];
        _mainMenuLine = [EGLine2d applyMaterial:[EGColorSource applyColor:geVec4DivI(GEVec4Make(211.0, 131.0, 235.0, 255.0), 255)]];
        _font = [EGGlobal fontWithName:@"lucida_grande_24"];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _TRLevelPauseMenuView_type = [ODClassType classTypeWithCls:[TRLevelPauseMenuView class]];
}

- (id<EGCamera>)cameraWithViewport:(GERect)viewport {
    return [_cameraCache applyX:wrap(GERect, viewport)];
}

- (void)draw {
    if(!([[EGGlobal director] isPaused])) return ;
    egBlendFunctionApplyDraw(egBlendFunctionStandard(), ^void() {
        glDisable(GL_DEPTH_TEST);
        glLineWidth(2.0);
        [EGD2D drawSpriteMaterial:[EGColorSource applyColor:GEVec4Make(0.0, 0.0, 0.0, 0.5)] in:GERectMake(GEVec2Make(0.0, 0.0), geVec2ApplyVec2i([EGGlobal.context viewport].size))];
        GEVec2 p = geRectMoveToCenterForSize([_menuBackSprite rect], geVec2ApplyVec2i([EGGlobal.context viewport].size)).p0;
        _menuBackSprite.position = p;
        [_menuBackSprite draw];
        _resumeLine.p0 = GEVec2Make(p.x, p.y + 100);
        _resumeLine.p1 = GEVec2Make(p.x + _width, p.y + 100);
        [_resumeLine draw];
        [_font drawText:[TRStr.Loc resumeGame] color:GEVec4Make(0.0, 0.0, 0.0, 1.0) at:GEVec3Make(p.x + 35, p.y + 118, 0.0) alignment:egTextAlignmentBaselineX(-1.0)];
        _restartLine.p0 = GEVec2Make(p.x, p.y + 50);
        _restartLine.p1 = GEVec2Make(p.x + _width, p.y + 50);
        [_restartLine draw];
        [_font drawText:[TRStr.Loc restartLevel] color:GEVec4Make(0.0, 0.0, 0.0, 1.0) at:GEVec3Make(p.x + 35, p.y + 68, 0.0) alignment:egTextAlignmentBaselineX(-1.0)];
        _mainMenuLine.p0 = GEVec2Make(p.x, p.y);
        _mainMenuLine.p1 = GEVec2Make(p.x + _width, p.y);
        [_mainMenuLine draw];
        [_font drawText:[TRStr.Loc mainMenu] color:GEVec4Make(0.0, 0.0, 0.0, 1.0) at:GEVec3Make(p.x + 35, p.y + 18, 0.0) alignment:egTextAlignmentBaselineX(-1.0)];
        glLineWidth(1.0);
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
    GEVec2 p = [event location];
    if([_menuBackSprite containsVec2:p]) {
        if(p.y > _resumeLine.p0.y) {
            [[EGGlobal director] resume];
        } else {
            if(p.y > _restartLine.p0.y) {
                [TRLevelFactory restartLevel];
                [[EGGlobal director] resume];
            }
        }
        return YES;
    } else {
        return NO;
    }
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


