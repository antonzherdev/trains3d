#import "TRLevelChooseMenu.h"

#import "TRGameDirector.h"
#import "EGProgress.h"
#import "EGDirector.h"
#import "TRShopView.h"
#import "EGPlatformPlat.h"
#import "EGPlatform.h"
#import "EGContext.h"
#import "TRStrings.h"
#import "EGCamera2D.h"
#import "EGGameCenter.h"
#import "EGMaterial.h"
#import "EGD2D.h"
#import "EGTexture.h"
#import "EGInput.h"
@implementation TRLevelChooseMenu
static NSInteger _TRLevelChooseMenu_maxLevel;
static GEVec4(^_TRLevelChooseMenu_rankProgress)(float);
static GEVec4 _TRLevelChooseMenu_textColor = (GEVec4){0.1, 0.1, 0.1, 1.0};
static ODClassType* _TRLevelChooseMenu_type;
@synthesize name = _name;
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
            return [[intTo(0, 3) chain] map:^TRShopButton*(id x) {
                TRLevelChooseMenu* _self = _weakSelf;
                NSInteger level = (3 - unumi(y)) * 4 + unumi(x) + 1;
                return [TRShopButton applyRect:geRectApplyXYWidthHeight(((float)(unumi(x))), ((float)(unumi(y))), 1.0, 1.0) onDraw:[_self drawButtonX:unumi(x) y:unumi(y) level:level] onClick:^void() {
                    [TRGameDirector.instance setLevel:level];
                    [[EGDirector current] resume];
                }];
            }];
        }] toArray];
        _fontRes = [[EGGlobal mainFontWithSize:((egPlatform().isPhone) ? 14 : 16)] beReadyForText:[[TRStr.Loc levelNumber:1] stringByAppendingString:@"0123456789"]];
        _fontBottom = [[EGGlobal mainFontWithSize:((egPlatform().isPhone) ? 12 : 14)] beReadyForText:@"$0123456789'%"];
        __scores = [NSMutableDictionary mutableDictionary];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [TRLevelChooseMenu class]) {
        _TRLevelChooseMenu_type = [ODClassType classTypeWithCls:[TRLevelChooseMenu class]];
        _TRLevelChooseMenu_maxLevel = [TRGameDirector.instance maxAvailableLevel];
        _TRLevelChooseMenu_rankProgress = [EGProgress progressVec4:geVec4DivF4((GEVec4Make(232.0, 255.0, 208.0, 255.0)), 255.0) vec42:geVec4DivF4((GEVec4Make(255.0, 249.0, 217.0, 255.0)), 255.0)];
    }
}

+ (EGScene*)scene {
    return [EGScene applySceneView:[TRLevelChooseMenu levelChooseMenu]];
}

- (id<EGCamera>)camera {
    return [EGCamera2D camera2DWithSize:GEVec2Make(4.0, 4.0)];
}

- (void)start {
    [EGGlobal.context clearCache];
    __weak TRLevelChooseMenu* ws = self;
    [intTo(1, 16) forEach:^void(id level) {
        [TRGameDirector.instance localPlayerScoreLevel:((NSUInteger)(unumi(level))) callback:^void(EGLocalPlayerScore* score) {
            if(score != nil) {
                [ws._scores setKey:numui(((NSUInteger)(unumi(level)))) value:score];
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
        EGLocalPlayerScore* score = [ws._scores optKey:numui(((NSUInteger)(level)))];
        GEVec4 color;
        {
            id __tmp_2_2;
            {
                EGLocalPlayerScore* _ = ((EGLocalPlayerScore*)(score));
                if(_ != nil) __tmp_2_2 = wrap(GEVec4, [TRLevelChooseMenu rankColorScore:_]);
                else __tmp_2_2 = nil;
            }
            if(__tmp_2_2 != nil) color = uwrap(GEVec4, __tmp_2_2);
            else color = GEVec4Make(0.95, 0.95, 0.95, 1.0);
        }
        [EGD2D drawSpriteMaterial:[EGColorSource applyColor:color] at:GEVec3Make(((float)(x)), ((float)(y + 0.8)), 0.0) rect:geRectApplyXYWidthHeight(0.0, 0.0, 1.0, 0.2)];
        if(!(dis)) [EGD2D drawSpriteMaterial:[EGColorSource applyColor:color] at:GEVec3Make(((float)(x)), ((float)(y)), 0.0) rect:geRectApplyXYWidthHeight(0.0, 0.0, 1.0, ((ph) ? 0.34 : 0.14))];
        [EGBlendFunction.standard applyDraw:^void() {
            [ws.fontRes drawText:[TRStr.Loc levelNumber:((NSUInteger)(level))] at:GEVec3Make(((float)(x + 0.5)), ((float)(y + 0.91)), 0.0) alignment:egTextAlignmentApplyXY(0.0, 0.0) color:_TRLevelChooseMenu_textColor];
            if(dis) {
                [EGD2D drawSpriteMaterial:[EGColorSource applyColor:GEVec4Make(1.0, 1.0, 1.0, 0.8)] at:GEVec3Make(((float)(x)), ((float)(y)), 0.0) rect:geRectApplyXYWidthHeight(0.0, 0.0, 1.0, 1.0)];
            } else {
                long ss = ((score != nil) ? ((EGLocalPlayerScore*)(nonnil(score))).value : ((long)([TRGameDirector.instance bestScoreLevelNumber:((NSUInteger)(level))])));
                if(ss > 0 || score != nil) [ws.fontBottom drawText:[TRStr.Loc formatCost:((NSInteger)(ss))] at:GEVec3Make(((float)(x + 0.02)), ((float)(y + ((ph) ? 0.25 : 0.07))), 0.0) alignment:egTextAlignmentApplyXY(-1.0, 0.0) color:_TRLevelChooseMenu_textColor];
                if(score != nil) [ws.fontBottom drawText:[TRStr.Loc topScore:score] at:GEVec3Make(((float)(x + ((ph) ? 0.02 : 0.98))), ((float)(y + ((ph) ? 0.11 : 0.07))), 0.0) alignment:egTextAlignmentApplyXY(((ph) ? -1.0 : 1.0), 0.0) color:_TRLevelChooseMenu_textColor];
            }
        }];
    };
}

- (void)draw {
    [EGGlobal.context.depthTest disabledF:^void() {
        [EGD2D drawSpriteMaterial:[EGColorSource applyTexture:[EGGlobal textureForFile:@"Levels" fileFormat:EGTextureFileFormat.JPEG]] at:GEVec3Make(0.0, 0.0, 0.0) quad:geRectStripQuad((geRectApplyXYWidthHeight(0.0, 0.0, 4.0, 4.0))) uv:geRectUpsideDownStripQuad((geRectApplyXYWidthHeight(0.0, 0.0, 1.0, 0.75)))];
        [EGBlendFunction.standard applyDraw:^void() {
            for(TRShopButton* _ in _buttons) {
                [((TRShopButton*)(_)) draw];
            }
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
        return [_buttons existsWhere:^BOOL(TRShopButton* _) {
            return [((TRShopButton*)(_)) tapEvent:event];
        }];
    }]];
}

- (GERect)viewportWithViewSize:(GEVec2)viewSize {
    return geRectApplyXYSize(0.0, 0.0, viewSize);
}

- (void)prepare {
}

- (void)complete {
}

- (void)updateWithDelta:(CGFloat)delta {
}

- (EGEnvironment*)environment {
    return EGEnvironment.aDefault;
}

- (void)reshapeWithViewport:(GERect)viewport {
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

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendString:@">"];
    return description;
}

@end


