#import "TRLevelChooseMenu.h"

#import "TRGameDirector.h"
#import "EGProgress.h"
#import "EGDirector.h"
#import "EGSprite.h"
#import "EGCamera2D.h"
#import "EGPlatformPlat.h"
#import "EGPlatform.h"
#import "EGContext.h"
#import "TRStrings.h"
#import "EGGameCenter.h"
#import "EGMaterial.h"
#import "EGTexture.h"
#import "EGInput.h"
@implementation TRLevelChooseMenu{
    NSString* _name;
    id<CNImSeq> _buttons;
    EGFont* _fontRes;
    EGFont* _fontBottom;
    NSMutableDictionary* __scores;
}
static NSInteger _TRLevelChooseMenu_maxLevel;
static GEVec4(^_TRLevelChooseMenu_rankProgress)(float);
static GEVec4 _TRLevelChooseMenu_textColor = (GEVec4){0.1, 0.1, 0.1, 1.0};
static ODClassType* _TRLevelChooseMenu_type;
@synthesize name = _name;
@synthesize fontRes = _fontRes;
@synthesize fontBottom = _fontBottom;
@synthesize _scores = __scores;

+ (instancetype)levelChooseMenu {
    return [[TRLevelChooseMenu alloc] init];
}

- (instancetype)init {
    self = [super init];
    __weak TRLevelChooseMenu* _weakSelf = self;
    if(self) {
        _name = @"Level Choose manu";
        _buttons = [[[intTo(0, 3) chain] flatMap:^CNChain*(id y) {
            return [[intTo(0, 3) chain] map:^EGButton*(id x) {
                NSInteger level = (3 - unumi(y)) * 4 + unumi(x) + 1;
                return [EGButton applyRect:geRectApplyXYWidthHeight(((float)(unumi(x))), ((float)(unumi(y))), 1.0, 1.0) onDraw:[_weakSelf drawButtonX:unumi(x) y:unumi(y) level:level] onClick:^void() {
                    [TRGameDirector.instance setLevel:level];
                    [[EGDirector current] resume];
                }];
            }];
        }] toArray];
        __scores = [NSMutableDictionary mutableDictionary];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [TRLevelChooseMenu class]) {
        _TRLevelChooseMenu_type = [ODClassType classTypeWithCls:[TRLevelChooseMenu class]];
        _TRLevelChooseMenu_maxLevel = [TRGameDirector.instance maxAvailableLevel];
        _TRLevelChooseMenu_rankProgress = [EGProgress progressVec4:geVec4DivI((GEVec4Make(232.0, 255.0, 208.0, 255.0)), 255) vec42:geVec4DivI((GEVec4Make(255.0, 249.0, 217.0, 255.0)), 255)];
    }
}

+ (EGScene*)scene {
    return [EGScene applySceneView:[TRLevelChooseMenu levelChooseMenu]];
}

- (id<EGCamera>)camera {
    return [EGCamera2D camera2DWithSize:GEVec2Make(4.0, 4.0)];
}

- (void)reshapeWithViewport:(GERect)viewport {
    _fontRes = [EGGlobal mainFontWithSize:((egPlatform().isPhone) ? 14 : 16)];
    [_fontRes beReadyForText:[[TRStr.Loc levelNumber:1] stringByAppendingString:@"0123456789"]];
    _fontBottom = [EGGlobal mainFontWithSize:((egPlatform().isPhone) ? 12 : 14)];
    [_fontBottom beReadyForText:@"$0123456789'%"];
}

- (void)start {
    [EGGlobal.context clearCache];
    __weak TRLevelChooseMenu* ws = self;
    [intTo(1, 16) forEach:^void(id level) {
        [TRGameDirector.instance localPlayerScoreLevel:((NSUInteger)(unumi(level))) callback:^void(id score) {
            if([score isDefined]) {
                [ws._scores setKey:numui(((NSUInteger)(unumi(level)))) value:[score get]];
                [[EGDirector current] redraw];
            }
        }];
    }];
}

- (void)stop {
    [EGGlobal.context clearCache];
}

+ (GEVec4)rankColorScore:(EGLocalPlayerScore*)score {
    return _TRLevelChooseMenu_rankProgress(((float)([score percent])));
}

- (void(^)(GERect))drawButtonX:(NSInteger)x y:(NSInteger)y level:(NSInteger)level {
    BOOL ph = egPlatform().isPhone;
    __weak TRLevelChooseMenu* ws = self;
    return ^void(GERect rect) {
        BOOL dis = level > _TRLevelChooseMenu_maxLevel;
        id score = [ws._scores optKey:numui(((NSUInteger)(level)))];
        GEVec4 color = (([score isDefined]) ? [TRLevelChooseMenu rankColorScore:[score get]] : GEVec4Make(0.95, 0.95, 0.95, 1.0));
        [EGD2D drawSpriteMaterial:[EGColorSource applyColor:color] at:GEVec3Make(((float)(x)), ((float)(y + 0.8)), 0.0) rect:geRectApplyXYWidthHeight(0.0, 0.0, 1.0, 0.2)];
        if(!(dis)) [EGD2D drawSpriteMaterial:[EGColorSource applyColor:color] at:GEVec3Make(((float)(x)), ((float)(y)), 0.0) rect:geRectApplyXYWidthHeight(0.0, 0.0, 1.0, ((ph) ? 0.34 : 0.14))];
        [EGBlendFunction.standard applyDraw:^void() {
            [ws.fontRes drawText:[TRStr.Loc levelNumber:((NSUInteger)(level))] at:GEVec3Make(((float)(x + 0.5)), ((float)(y + 0.91)), 0.0) alignment:egTextAlignmentApplyXY(0.0, 0.0) color:_TRLevelChooseMenu_textColor];
            if(dis) {
                [EGD2D drawSpriteMaterial:[EGColorSource applyColor:GEVec4Make(1.0, 1.0, 1.0, 0.8)] at:GEVec3Make(((float)(x)), ((float)(y)), 0.0) rect:geRectApplyXYWidthHeight(0.0, 0.0, 1.0, 1.0)];
            } else {
                long ss = (([score isDefined]) ? ((EGLocalPlayerScore*)([score get])).value : ((long)([TRGameDirector.instance bestScoreLevelNumber:((NSUInteger)(level))])));
                if(ss > 0 || [score isDefined]) [ws.fontBottom drawText:[TRStr.Loc formatCost:((NSInteger)(ss))] at:GEVec3Make(((float)(x + 0.02)), ((float)(y + ((ph) ? 0.25 : 0.07))), 0.0) alignment:egTextAlignmentApplyXY(-1.0, 0.0) color:_TRLevelChooseMenu_textColor];
                if([score isDefined]) [ws.fontBottom drawText:[TRStr.Loc topScore:[score get]] at:GEVec3Make(((float)(x + ((ph) ? 0.02 : 0.98))), ((float)(y + ((ph) ? 0.11 : 0.07))), 0.0) alignment:egTextAlignmentApplyXY(((ph) ? -1.0 : 1.0), 0.0) color:_TRLevelChooseMenu_textColor];
            }
        }];
    };
}

- (void)draw {
    [EGGlobal.context.depthTest disabledF:^void() {
        [EGD2D drawSpriteMaterial:[EGColorSource applyTexture:[EGGlobal textureForFile:@"Levels" fileFormat:EGTextureFileFormat.JPEG]] at:GEVec3Make(0.0, 0.0, 0.0) quad:geRectStripQuad((geRectApplyXYWidthHeight(0.0, 0.0, 4.0, 4.0))) uv:geRectUpsideDownStripQuad((geRectApplyXYWidthHeight(0.0, 0.0, 1.0, 0.75)))];
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

- (ODClassType*)type {
    return [TRLevelChooseMenu type];
}

+ (NSInteger)maxLevel {
    return _TRLevelChooseMenu_maxLevel;
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


