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
    NSInteger _width;
    NSInteger _height;
    NSInteger _delta;
    EGFont* _font;
    GEVec2 _textRel;
    EGSprite* _helpBackSprite;
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
        _width = 0;
        _height = 0;
        _delta = 0;
        _helpBackSprite = [EGSprite applyMaterial:[EGColorSource applyColor:geVec4DivI(GEVec4Make(220.0, 220.0, 220.0, 255.0), 255)] size:GEVec2Make(0.0, 0.0)];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _TRLevelPauseMenuView_type = [ODClassType classTypeWithCls:[TRLevelPauseMenuView class]];
}

- (void)reshapeWithViewport:(GERect)viewport {
    _camera = [EGCamera2D camera2DWithSize:GEVec2Make(geRectWidth(viewport), geRectHeight(viewport))];
    CGFloat s = EGGlobal.context.scale;
    _width = ((NSInteger)(350 * s));
    _height = ((NSInteger)(150 * s));
    _delta = ((NSInteger)(50 * s));
    _font = [EGGlobal fontWithName:@"lucida_grande" size:24];
    _menuBackSprite.size = GEVec2Make(((float)(_width)), ((float)(_height)));
    GEVec2 p = geRectMoveToCenterForSize([_menuBackSprite rect], viewport.size).p0;
    _menuBackSprite.position = p;
    _textRel = geVec2AddVec2(p, geVec2MulF(GEVec2Make(35.0, 18.0), s));
}

- (void)draw {
    if(!([[EGGlobal director] isPaused])) return ;
    [EGBlendFunction.standard applyDraw:^void() {
        [EGGlobal.context.depthTest disabledF:^void() {
            [EGD2D drawSpriteMaterial:[EGColorSource applyColor:GEVec4Make(0.0, 0.0, 0.0, 0.5)] at:GEVec3Make(0.0, 0.0, 0.0) rect:GERectMake(GEVec2Make(0.0, 0.0), geVec2ApplyVec2i([EGGlobal.context viewport].size))];
            if([[_level help] isEmpty]) [self drawMenu];
            else [self drawHelp];
        }];
    }];
}

- (void)drawMenu {
    GEVec2 p = _menuBackSprite.position;
    [_menuBackSprite draw];
    _resumeLine.p0 = GEVec2Make(p.x, p.y + 2 * _delta);
    _resumeLine.p1 = GEVec2Make(p.x + _width, p.y + 2 * _delta);
    [_resumeLine draw];
    [_font drawText:[TRStr.Loc resumeGame] color:GEVec4Make(0.0, 0.0, 0.0, 1.0) at:geVec3ApplyVec2Z(geVec2AddVec2(_textRel, GEVec2Make(0.0, ((float)(2 * _delta)))), 0.0) alignment:egTextAlignmentBaselineX(-1.0)];
    _restartLine.p0 = GEVec2Make(p.x, p.y + _delta);
    _restartLine.p1 = GEVec2Make(p.x + _width, p.y + _delta);
    [_restartLine draw];
    [_font drawText:[TRStr.Loc restartLevel] color:GEVec4Make(0.0, 0.0, 0.0, 1.0) at:geVec3ApplyVec2Z(geVec2AddVec2(_textRel, GEVec2Make(0.0, ((float)(_delta)))), 0.0) alignment:egTextAlignmentBaselineX(-1.0)];
    _mainMenuLine.p0 = GEVec2Make(p.x, p.y);
    _mainMenuLine.p1 = GEVec2Make(p.x + _width, p.y);
    [_mainMenuLine draw];
    [_font drawText:[TRStr.Loc mainMenu] color:GEVec4Make(0.0, 0.0, 0.0, 1.0) at:geVec3ApplyVec2Z(_textRel, 0.0) alignment:egTextAlignmentBaselineX(-1.0)];
}

- (void)drawHelp {
    TRHelp* help = [[_level help] get];
    GEVec2 size = [_font measureCText:help.text];
    GERect rect = geVec2RectInCenterWithSize(size, geVec2ApplyVec2i([EGGlobal.context viewport].size));
    [_helpBackSprite setRect:rect];
    [_helpBackSprite draw];
    [_font drawText:help.text color:GEVec4Make(0.0, 0.0, 0.0, 1.0) at:geVec3ApplyVec2(geRectCenter(rect)) alignment:egTextAlignmentApplyXY(0.0, 0.0)];
}

- (BOOL)isProcessorActive {
    return [[EGGlobal director] isPaused];
}

- (BOOL)processEvent:(EGEvent*)event {
    return [event tapProcessor:self];
}

- (BOOL)tapEvent:(EGEvent*)event {
    if([[_level help] isEmpty]) {
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
    } else {
        [_level clearHelp];
        return YES;
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


