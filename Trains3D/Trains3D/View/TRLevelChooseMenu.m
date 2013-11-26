#import "TRLevelChooseMenu.h"

#import "EGProgress.h"
#import "TRGameDirector.h"
#import "EGSprite.h"
#import "EGCamera2D.h"
#import "EGContext.h"
#import "EGGameCenterPlat.h"
#import "EGDirector.h"
#import "EGGameCenter.h"
#import "EGMaterial.h"
#import "TRStrings.h"
#import "EGInput.h"
@implementation TRLevelChooseMenu{
    NSString* _name;
    NSInteger _maxLevel;
    id<CNSeq> _buttons;
    EGFont* _fontRes;
    NSMutableDictionary* __scores;
}
static GEVec4(^_TRLevelChooseMenu_rankProgress)(float);
static ODClassType* _TRLevelChooseMenu_type;
@synthesize name = _name;
@synthesize maxLevel = _maxLevel;

+ (id)levelChooseMenu {
    return [[TRLevelChooseMenu alloc] init];
}

- (id)init {
    self = [super init];
    __weak TRLevelChooseMenu* _weakSelf = self;
    if(self) {
        _name = @"Level Choose manu";
        _maxLevel = [TRGameDirector.instance maxAvailableLevel];
        _buttons = [[[intTo(0, 3) chain] flatMap:^CNChain*(id y) {
            return [[intTo(0, 3) chain] map:^EGButton*(id x) {
                NSInteger level = (3 - unumi(y)) * 4 + unumi(x) + 1;
                return [EGButton applyRect:geRectApplyXYWidthHeight(((float)(unumi(x))), ((float)(unumi(y))), 1.0, 1.0) onDraw:[_weakSelf drawButtonX:unumi(x) y:unumi(y) level:level] onClick:^void() {
                    [TRGameDirector.instance setLevel:level];
                }];
            }];
        }] toArray];
        __scores = [NSMutableDictionary mutableDictionary];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _TRLevelChooseMenu_type = [ODClassType classTypeWithCls:[TRLevelChooseMenu class]];
    _TRLevelChooseMenu_rankProgress = [EGProgress progressVec4:geVec4DivI(GEVec4Make(229.0, 255.0, 217.0, 255.0), 255) vec42:geVec4DivI(GEVec4Make(255.0, 223.0, 217.0, 255.0), 255)];
}

+ (EGScene*)scene {
    return [EGScene applySceneView:[TRLevelChooseMenu levelChooseMenu]];
}

- (EGCamera2D*)camera {
    return [EGCamera2D camera2DWithSize:GEVec2Make(4.0, 4.0)];
}

- (void)reshapeWithViewport:(GERect)viewport {
    _fontRes = [EGGlobal fontWithName:@"lucida_grande" size:18];
}

- (void)start {
    [intTo(1, 16) forEach:^void(id level) {
        [EGGameCenter.instance localPlayerScoreLeaderboard:[NSString stringWithFormat:@"grp.com.antonzherdev.Trains3D.Level%@", level] callback:^void(id score) {
            if([score isDefined]) {
                [__scores setKey:numui(((NSUInteger)(unumi(level)))) value:[score get]];
                [[EGDirector current] redraw];
            }
        }];
    }];
}

+ (GEVec4)rankColorScore:(EGLocalPlayerScore*)score {
    return _TRLevelChooseMenu_rankProgress(((float)([score percent])));
}

- (void(^)(GERect))drawButtonX:(NSInteger)x y:(NSInteger)y level:(NSInteger)level {
    return ^void(GERect rect) {
        BOOL dis = level > _maxLevel;
        id score = [__scores optKey:numui(((NSUInteger)(level)))];
        GEVec4 color = (([score isDefined]) ? [TRLevelChooseMenu rankColorScore:[score get]] : GEVec4Make(0.95, 0.95, 0.95, 1.0));
        [EGD2D drawSpriteMaterial:[EGColorSource applyColor:color] at:GEVec3Make(((float)(x)), ((float)(y + 0.8)), 0.0) rect:geRectApplyXYWidthHeight(0.0, 0.0, 1.0, 0.2)];
        if(!(dis)) [EGD2D drawSpriteMaterial:[EGColorSource applyColor:color] at:GEVec3Make(((float)(x)), ((float)(y)), 0.0) rect:geRectApplyXYWidthHeight(0.0, 0.0, 1.0, 0.2)];
        [EGBlendFunction.standard applyDraw:^void() {
            [_fontRes drawText:[TRStr.Loc levelNumber:((NSUInteger)(level))] at:GEVec3Make(((float)(x + 0.5)), ((float)(y + 0.92)), 0.0) alignment:egTextAlignmentApplyXY(0.0, 0.0) color:GEVec4Make(0.0, 0.0, 0.0, 1.0)];
            if(dis) {
                [EGD2D drawSpriteMaterial:[EGColorSource applyColor:GEVec4Make(1.0, 1.0, 1.0, 0.9)] at:GEVec3Make(((float)(x)), ((float)(y)), 0.0) rect:geRectApplyXYWidthHeight(0.0, 0.0, 1.0, 1.0)];
            } else {
                [_fontRes drawText:[TRStr.Loc formatCost:(([score isDefined]) ? ((NSInteger)(((EGLocalPlayerScore*)([score get])).value)) : [TRGameDirector.instance bestScoreLevelNumber:((NSUInteger)(level))])] at:GEVec3Make(((float)(x + 0.02)), ((float)(y + 0.1)), 0.0) alignment:egTextAlignmentApplyXY(-1.0, 0.0) color:GEVec4Make(0.0, 0.0, 0.0, 1.0)];
                if([score isDefined]) [_fontRes drawText:[TRStr.Loc topScore:[score get]] at:GEVec3Make(((float)(x + 0.98)), ((float)(y + 0.1)), 0.0) alignment:egTextAlignmentApplyXY(1.0, 0.0) color:GEVec4Make(0.0, 0.0, 0.0, 1.0)];
            }
        }];
    };
}

- (void)draw {
    [EGGlobal.context.depthTest disabledF:^void() {
        [EGD2D drawSpriteMaterial:[EGColorSource applyTexture:[EGGlobal textureForFile:@"Levels.jpg"]] at:GEVec3Make(0.0, 0.0, 0.0) quad:geRectStripQuad(geRectApplyXYWidthHeight(0.0, 0.0, 4.0, 4.0)) uv:geRectUpsideDownStripQuad(geRectApplyXYWidthHeight(0.0, 0.0, 1.0, 0.75))];
        [EGBlendFunction.standard applyDraw:^void() {
            [_buttons forEach:^void(EGButton* _) {
                [((EGButton*)(_)) draw];
            }];
        }];
        [intTo(1, 3) forEach:^void(id c) {
            [EGD2D drawLineMaterial:[EGColorSource applyColor:GEVec4Make(0.5, 0.5, 0.5, 1.0)] p0:GEVec2Make(((float)(unumi(c))), 0.0) p1:GEVec2Make(((float)(unumi(c))), 5.0)];
            [EGD2D drawLineMaterial:[EGColorSource applyColor:GEVec4Make(0.5, 0.5, 0.5, 1.0)] p0:GEVec2Make(0.0, ((float)(unumi(c)))) p1:GEVec2Make(5.0, ((float)(unumi(c))))];
        }];
    }];
}

- (BOOL)isProcessorActive {
    return YES;
}

- (EGRecognizers*)recognizers {
    return [EGRecognizers applyRecognizer:[EGRecognizer applyTp:[EGTap apply] on:^BOOL(id<EGEvent> event) {
        return [_buttons existsWhere:^BOOL(EGButton* _) {
            return [((EGButton*)(_)) tapEvent:event];
        }];
    }]];
}

- (GERect)viewportWithViewSize:(GEVec2)viewSize {
    return geRectApplyXYSize(0.0, 0.0, viewSize);
}

- (void)prepare {
}

- (EGEnvironment*)environment {
    return EGEnvironment.aDefault;
}

- (void)updateWithDelta:(CGFloat)delta {
}

- (void)stop {
}

- (ODClassType*)type {
    return [TRLevelChooseMenu type];
}

+ (ODClassType*)type {
    return _TRLevelChooseMenu_type;
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


