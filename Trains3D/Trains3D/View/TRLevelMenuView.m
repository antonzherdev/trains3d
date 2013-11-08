#import "TRLevelMenuView.h"

#import "TRLevel.h"
#import "EGSprite.h"
#import "EGProgress.h"
#import "EGSchedule.h"
#import "EGContext.h"
#import "EGCamera2D.h"
#import "EGMaterial.h"
#import "GL.h"
#import "EGTexture.h"
#import "TRScore.h"
#import "TRStrings.h"
#import "TRNotification.h"
#import "EGDirector.h"
@implementation TRLevelMenuView{
    TRLevel* _level;
    NSString* _name;
    EGSprite* _pauseSprite;
    EGSprite* _backSprite;
    GEVec4(^_notificationProgress)(float);
    GERect _pauseReg;
    NSInteger _width;
    id<EGCamera> _camera;
    EGText* _scoreText;
    EGText* _notificationText;
    id _levelText;
    EGCounter* _notificationAnimation;
    EGFinisher* _levelAnimation;
}
static GEVec4 _TRLevelMenuView_backgroundColor = (GEVec4){0.85, 0.9, 0.75, 1.0};
static ODClassType* _TRLevelMenuView_type;
@synthesize level = _level;
@synthesize name = _name;
@synthesize pauseSprite = _pauseSprite;
@synthesize backSprite = _backSprite;
@synthesize notificationProgress = _notificationProgress;
@synthesize pauseReg = _pauseReg;
@synthesize camera = _camera;
@synthesize levelText = _levelText;

+ (id)levelMenuViewWithLevel:(TRLevel*)level {
    return [[TRLevelMenuView alloc] initWithLevel:level];
}

- (id)initWithLevel:(TRLevel*)level {
    self = [super init];
    __weak TRLevelMenuView* _weakSelf = self;
    if(self) {
        _level = level;
        _name = @"LevelMenu";
        _pauseSprite = [EGSprite sprite];
        _backSprite = [EGSprite sprite];
        _notificationProgress = ^id() {
            float(^__l)(float) = [EGProgress gapT1:0.7 t2:1.0];
            GEVec4(^__r)(float) = ^GEVec4(float _) {
                return GEVec4Make(0.0, 0.0, 0.0, 1 - _);
            };
            return ^GEVec4(float _) {
                return __r(__l(_));
            };
        }();
        _pauseReg = geRectApplyXYWidthHeight(0.0, 0.0, ((float)(46.0 / 64)), ((float)(46.0 / 64)));
        _width = 0;
        _scoreText = [EGText applyFont:nil text:@"" position:GEVec3Make(10.0, 14.0, 0.0) alignment:egTextAlignmentBaselineX(-1.0) color:GEVec4Make(0.0, 0.0, 0.0, 1.0)];
        _notificationText = [EGText applyFont:nil text:@"" position:GEVec3Make(0.0, 0.0, 0.0) alignment:egTextAlignmentBaselineX(0.0) color:GEVec4Make(0.0, 0.0, 0.0, 1.0)];
        _levelText = [CNOption applyValue:[EGText applyFont:nil text:@"" position:GEVec3Make(0.0, 0.0, 0.0) alignment:egTextAlignmentBaselineX(0.0) color:GEVec4Make(0.0, 0.0, 0.0, 1.0)]];
        _notificationAnimation = [EGCounter apply];
        _levelAnimation = [EGFinisher finisherWithCounter:[EGCounter applyLength:5.0] finish:^void() {
            _weakSelf.levelText = [CNOption none];
        }];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _TRLevelMenuView_type = [ODClassType classTypeWithCls:[TRLevelMenuView class]];
}

- (void)reshapeWithViewport:(GERect)viewport {
    _camera = [EGCamera2D camera2DWithSize:GEVec2Make(geRectWidth(viewport) / EGGlobal.context.scale, 46.0)];
    EGFont* font = [EGGlobal fontWithName:@"lucida_grande" size:24];
    EGFont* notificationFont = [EGGlobal fontWithName:@"lucida_grande" size:16];
    [_notificationText setFont:font];
    _width = ((NSInteger)(viewport.size.x / EGGlobal.context.scale));
    [_scoreText setFont:font];
    [_notificationText setFont:notificationFont];
    [_notificationText setPosition:GEVec3Make(((float)(_width / 2)), 15.0, 0.0)];
    [_levelText forEach:^void(EGText* _) {
        [((EGText*)(_)) setFont:font];
        [((EGText*)(_)) setPosition:GEVec3Make(((float)(_width / 2)), 14.0, 0.0)];
    }];
    _backSprite.material = [EGColorSource applyColor:GEVec4Make(1.0, 1.0, 1.0, 0.7)];
    [_backSprite setRect:geRectApplyXYWidthHeight(0.0, 0.0, ((float)(_width)), 46.0)];
    _pauseSprite.position = GEVec2Make(((float)(_width - 46)), 0.0);
    _pauseSprite.material = [EGColorSource applyTexture:[EGTextureRegion textureRegionWithTexture:[EGGlobal scaledTextureForName:@"Pause" format:@"png" magFilter:GL_NEAREST minFilter:GL_NEAREST] uv:_pauseReg]];
    [_pauseSprite adjustSize];
}

- (void)draw {
    [EGGlobal.context.depthTest disabledF:^void() {
        [EGBlendFunction.standard applyDraw:^void() {
            [_backSprite draw];
            [_scoreText setText:[self formatScore:[_level.score score]]];
            [_scoreText draw];
            [_pauseSprite draw];
            [_levelAnimation forF:^void(CGFloat t) {
                [_levelText forEach:^void(EGText* _) {
                    [((EGText*)(_)) setText:[TRStr.Loc startLevelNumber:_level.number]];
                    ((EGText*)(_)).color = _notificationProgress(((float)(t / 3.0)));
                    [((EGText*)(_)) draw];
                }];
            }];
            [_notificationAnimation forF:^void(CGFloat t) {
                _notificationText.color = _notificationProgress(((float)(t)));
                [_notificationText draw];
            }];
        }];
    }];
}

- (NSString*)formatScore:(NSInteger)score {
    __block NSInteger i = 0;
    unichar a = unums([@"'" head]);
    NSString* str = [[[[[[NSString stringWithFormat:@"%ld", (long)score] chain] reverse] flatMap:^CNList*(id s) {
        i++;
        if(i == 3) return [CNList applyItem:s tail:[CNList applyItem:nums(a)]];
        else return [CNOption applyValue:s];
    }] reverse] charsToString];
    return [NSString stringWithFormat:@"$%@", str];
}

- (void)updateWithDelta:(CGFloat)delta {
    if([_levelAnimation isRunning]) {
        [_levelAnimation updateWithDelta:delta];
    } else {
        if([_notificationAnimation isRunning]) {
            [_notificationAnimation updateWithDelta:delta];
        } else {
            if(!([_level.notifications isEmpty])) {
                [_notificationText setText:[[_level.notifications take] get]];
                _notificationAnimation = [EGCounter applyLength:2.0];
            }
        }
    }
}

- (BOOL)processEvent:(EGEvent*)event {
    return [event tapProcessor:self];
}

- (BOOL)tapEvent:(EGEvent*)event {
    GEVec2 p = [event location];
    if([_pauseSprite containsVec2:p]) {
        if([[EGDirector current] isPaused]) [[EGDirector current] resume];
        else [[EGDirector current] pause];
    }
    return NO;
}

- (void)prepare {
}

- (EGEnvironment*)environment {
    return EGEnvironment.aDefault;
}

- (BOOL)isProcessorActive {
    return !([[EGDirector current] isPaused]);
}

- (ODClassType*)type {
    return [TRLevelMenuView type];
}

+ (GEVec4)backgroundColor {
    return _TRLevelMenuView_backgroundColor;
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


