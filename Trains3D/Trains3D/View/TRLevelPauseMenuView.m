#import "TRLevelPauseMenuView.h"

#import "TRLevel.h"
#import "EGSprite.h"
#import "EGMaterial.h"
#import "EGCamera2D.h"
#import "EGContext.h"
#import "EGDirector.h"
#import "TRStrings.h"
#import "TRSceneFactory.h"
@implementation TRLevelPauseMenuView{
    TRLevel* _level;
    NSString* _name;
    EGSprite* _menuBackSprite;
    EGLine2d* _resumeLine;
    EGLine2d* _restartLine;
    EGLine2d* _mainMenuLine;
    id<EGCamera> _camera;
}
static ODClassType* _TRLevelPauseMenuView_type;
@synthesize level = _level;
@synthesize name = _name;
@synthesize camera = _camera;

+ (id)levelPauseMenuViewWithLevel:(TRLevel*)level {
    return [[TRLevelPauseMenuView alloc] initWithLevel:level];
}

- (id)initWithLevel:(TRLevel*)level {
    self = [super init];
    if(self) {
        _level = level;
        _name = @"LevelPauseMenu";
        _menuBackSprite = [EGSprite applyMaterial:[EGColorSource applyColor:geVec4DivI(GEVec4Make(220.0, 220.0, 220.0, 255.0), 255)] size:GEVec2Make(350.0, 150.0)];
        _resumeLine = [EGLine2d applyMaterial:[EGColorSource applyColor:geVec4DivI(GEVec4Make(49.0, 90.0, 3.0, 255.0), 255)]];
        _restartLine = [EGLine2d applyMaterial:[EGColorSource applyColor:geVec4DivI(GEVec4Make(248.0, 149.0, 21.0, 255.0), 255)]];
        _mainMenuLine = [EGLine2d applyMaterial:[EGColorSource applyColor:geVec4DivI(GEVec4Make(211.0, 131.0, 235.0, 255.0), 255)]];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _TRLevelPauseMenuView_type = [ODClassType classTypeWithCls:[TRLevelPauseMenuView class]];
}

- (void)reshapeWithViewport:(GERect)viewport {
    _camera = [EGCamera2D camera2DWithSize:GEVec2Make(geRectWidth(viewport), geRectHeight(viewport))];
}

- (void)draw {
    if(!([[EGGlobal director] isPaused])) return ;
    [EGBlendFunction.standard applyDraw:^void() {
        [EGGlobal.context.depthTest disabledF:^void() {
            CGFloat s = EGGlobal.context.scale;
            CGFloat width = 350 * s;
            CGFloat height = 150 * s;
            [EGD2D drawSpriteMaterial:[EGColorSource applyColor:GEVec4Make(0.0, 0.0, 0.0, 0.5)] at:GEVec3Make(0.0, 0.0, 0.0) rect:GERectMake(GEVec2Make(0.0, 0.0), geVec2ApplyVec2i([EGGlobal.context viewport].size))];
            _menuBackSprite.size = GEVec2Make(((float)(width)), ((float)(height)));
            GEVec2 p = geRectMoveToCenterForSize([_menuBackSprite rect], geVec2ApplyVec2i([EGGlobal.context viewport].size)).p0;
            _menuBackSprite.position = p;
            [_menuBackSprite draw];
            CGFloat d = 50 * s;
            EGFont* font = [EGGlobal fontWithName:@"lucida_grande" size:24];
            GEVec2 textRel = geVec2AddVec2(p, geVec2MulF(GEVec2Make(35.0, 18.0), s));
            _resumeLine.p0 = GEVec2Make(p.x, p.y + 2 * d);
            _resumeLine.p1 = GEVec2Make(p.x + width, p.y + 2 * d);
            [_resumeLine draw];
            [font drawText:[TRStr.Loc resumeGame] color:GEVec4Make(0.0, 0.0, 0.0, 1.0) at:geVec3ApplyVec2Z(geVec2AddVec2(textRel, GEVec2Make(0.0, ((float)(2 * d)))), 0.0) alignment:egTextAlignmentBaselineX(-1.0)];
            _restartLine.p0 = GEVec2Make(p.x, p.y + d);
            _restartLine.p1 = GEVec2Make(p.x + width, p.y + d);
            [_restartLine draw];
            [font drawText:[TRStr.Loc restartLevel] color:GEVec4Make(0.0, 0.0, 0.0, 1.0) at:geVec3ApplyVec2Z(geVec2AddVec2(textRel, GEVec2Make(0.0, ((float)(d)))), 0.0) alignment:egTextAlignmentBaselineX(-1.0)];
            _mainMenuLine.p0 = GEVec2Make(p.x, p.y);
            _mainMenuLine.p1 = GEVec2Make(p.x + width, p.y);
            [_mainMenuLine draw];
            [font drawText:[TRStr.Loc mainMenu] color:GEVec4Make(0.0, 0.0, 0.0, 1.0) at:geVec3ApplyVec2Z(textRel, 0.0) alignment:egTextAlignmentBaselineX(-1.0)];
        }];
    }];
}

- (BOOL)isProcessorActive {
    return [[EGGlobal director] isPaused];
}

- (BOOL)processEvent:(EGEvent*)event {
    return [event tapProcessor:self];
}

- (BOOL)tapEvent:(EGEvent*)event {
    GEVec2 p = [event location];
    if([_menuBackSprite containsVec2:p]) {
        if(p.y > _resumeLine.p0.y) {
            [[EGGlobal director] resume];
        } else {
            if(p.y > _restartLine.p0.y) {
                [TRSceneFactory restartLevel];
                [[EGGlobal director] resume];
            }
        }
        return YES;
    } else {
        return NO;
    }
}

- (void)prepare {
}

- (EGEnvironment*)environment {
    return EGEnvironment.aDefault;
}

- (void)updateWithDelta:(CGFloat)delta {
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


