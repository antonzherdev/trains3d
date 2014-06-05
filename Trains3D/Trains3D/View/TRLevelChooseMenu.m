#import "TRLevelChooseMenu.h"

#import "PGProgress.h"
#import "TRGameDirector.h"
#import "PGDirector.h"
#import "TRShopView.h"
#import "CNChain.h"
#import "PGPlatformPlat.h"
#import "PGPlatform.h"
#import "PGContext.h"
#import "TRStrings.h"
#import "PGCamera2D.h"
#import "PGGameCenter.h"
#import "PGMaterial.h"
#import "PGD2D.h"
#import "PGInput.h"
@implementation TRLevelChooseMenu
static PGVec4(^_TRLevelChooseMenu_rankProgress)(float);
static PGVec4 _TRLevelChooseMenu_textColor = (PGVec4){0.1, 0.1, 0.1, 1.0};
static CNClassType* _TRLevelChooseMenu_type;
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
        _maxLevel = [[TRGameDirector instance] maxAvailableLevel];
        _buttons = [[[intTo(0, 3) chain] flatMapF:^CNChain*(id y) {
            return [[intTo(0, 3) chain] mapF:^TRShopButton*(id x) {
                TRLevelChooseMenu* _self = _weakSelf;
                if(_self != nil) {
                    NSInteger level = (3 - unumi(y)) * 4 + unumi(x) + 1;
                    return [TRShopButton applyRect:pgRectApplyXYWidthHeight(((float)(unumi(x))), ((float)(unumi(y))), 1.0, 1.0) onDraw:[_self drawButtonX:unumi(x) y:unumi(y) level:level] onClick:^void() {
                        [[TRGameDirector instance] setLevel:level];
                        [[PGDirector current] resume];
                    }];
                } else {
                    return nil;
                }
            }];
        }] toArray];
        _fontRes = [[PGGlobal mainFontWithSize:((egPlatform()->_isPhone) ? 14 : 16)] beReadyForText:[[[TRStr Loc] levelNumber:1] stringByAppendingString:@"0123456789"]];
        _fontBottom = [[PGGlobal mainFontWithSize:((egPlatform()->_isPhone) ? 12 : 14)] beReadyForText:@"$0123456789'%"];
        __scores = [CNMHashMap hashMap];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [TRLevelChooseMenu class]) {
        _TRLevelChooseMenu_type = [CNClassType classTypeWithCls:[TRLevelChooseMenu class]];
        _TRLevelChooseMenu_rankProgress = [PGProgress progressVec4:pgVec4DivI((PGVec4Make(232.0, 255.0, 208.0, 255.0)), 255) vec42:pgVec4DivI((PGVec4Make(255.0, 249.0, 217.0, 255.0)), 255)];
    }
}

+ (PGScene*)scene {
    return [PGScene applySceneView:[TRLevelChooseMenu levelChooseMenu]];
}

- (id<PGCamera>)camera {
    return [PGCamera2D camera2DWithSize:PGVec2Make(4.0, 4.0)];
}

- (void)start {
    __weak TRLevelChooseMenu* _weakSelf = self;
    [[PGGlobal context] clearCache];
    {
        id<CNIterator> __il__1i = [intTo(1, 16) iterator];
        while([__il__1i hasNext]) {
            id level = [__il__1i next];
            [[TRGameDirector instance] localPlayerScoreLevel:((NSUInteger)(unumi(level))) callback:^void(PGLocalPlayerScore* score) {
                TRLevelChooseMenu* _self = _weakSelf;
                if(_self != nil) {
                    if(score != nil) {
                        [_self->__scores setKey:numui(((NSUInteger)(unumi(level)))) value:score];
                        [[PGDirector current] redraw];
                    }
                }
            }];
        }
    }
}

- (void)stop {
    [[PGGlobal context] clearCache];
}

+ (PGVec4)rankColorScore:(PGLocalPlayerScore*)score {
    return _TRLevelChooseMenu_rankProgress(((float)([score percent])));
}

- (void(^)(PGRect))drawButtonX:(NSInteger)x y:(NSInteger)y level:(NSInteger)level {
    BOOL ph = egPlatform()->_isPhone;
    return ^void(PGRect rect) {
        BOOL dis = level > _maxLevel;
        PGLocalPlayerScore* score = [__scores applyKey:numui(((NSUInteger)(level)))];
        PGVec4 color;
        {
            id __tmp_1_2;
            {
                PGLocalPlayerScore* _ = score;
                if(_ != nil) __tmp_1_2 = wrap(PGVec4, [TRLevelChooseMenu rankColorScore:_]);
                else __tmp_1_2 = nil;
            }
            if(__tmp_1_2 != nil) color = uwrap(PGVec4, __tmp_1_2);
            else color = PGVec4Make(0.95, 0.95, 0.95, 1.0);
        }
        [PGD2D drawSpriteMaterial:[PGColorSource applyColor:color] at:PGVec3Make(((float)(x)), ((float)(y + 0.8)), 0.0) rect:pgRectApplyXYWidthHeight(0.0, 0.0, 1.0, 0.2)];
        if(!(dis)) [PGD2D drawSpriteMaterial:[PGColorSource applyColor:color] at:PGVec3Make(((float)(x)), ((float)(y)), 0.0) rect:pgRectApplyXYWidthHeight(0.0, 0.0, 1.0, ((ph) ? 0.34 : 0.14))];
        PGEnablingState* __il__1_5__tmp__il__0self = [PGGlobal context]->_blend;
        {
            BOOL __il__1_5__il__0changed = [__il__1_5__tmp__il__0self enable];
            {
                [[PGGlobal context] setBlendFunction:[PGBlendFunction standard]];
                {
                    [_fontRes drawText:[[TRStr Loc] levelNumber:((NSUInteger)(level))] at:PGVec3Make(((float)(x + 0.5)), ((float)(y + 0.91)), 0.0) alignment:pgTextAlignmentApplyXY(0.0, 0.0) color:_TRLevelChooseMenu_textColor];
                    if(dis) {
                        [PGD2D drawSpriteMaterial:[PGColorSource applyColor:PGVec4Make(1.0, 1.0, 1.0, 0.8)] at:PGVec3Make(((float)(x)), ((float)(y)), 0.0) rect:pgRectApplyXYWidthHeight(0.0, 0.0, 1.0, 1.0)];
                    } else {
                        long ss = ((score != nil) ? ((PGLocalPlayerScore*)(nonnil(score)))->_value : ((long)([[TRGameDirector instance] bestScoreLevelNumber:((NSUInteger)(level))])));
                        if(ss > 0 || score != nil) [_fontBottom drawText:[[TRStr Loc] formatCost:((NSInteger)(ss))] at:PGVec3Make(((float)(x + 0.02)), ((float)(y + ((ph) ? 0.25 : 0.07))), 0.0) alignment:pgTextAlignmentApplyXY(-1.0, 0.0) color:_TRLevelChooseMenu_textColor];
                        if(score != nil) [_fontBottom drawText:[[TRStr Loc] topScore:score] at:PGVec3Make(((float)(x + ((ph) ? 0.02 : 0.98))), ((float)(y + ((ph) ? 0.11 : 0.07))), 0.0) alignment:pgTextAlignmentApplyXY(((ph) ? -1.0 : 1.0), 0.0) color:_TRLevelChooseMenu_textColor];
                    }
                }
            }
            if(__il__1_5__il__0changed) [__il__1_5__tmp__il__0self disable];
        }
    };
}

- (void)draw {
    PGEnablingState* __tmp__il__0self = [PGGlobal context]->_depthTest;
    {
        BOOL __il__0changed = [__tmp__il__0self disable];
        {
            [PGD2D drawSpriteMaterial:[PGColorSource applyTexture:[PGGlobal textureForFile:@"Levels" fileFormat:PGTextureFileFormat_JPEG]] at:PGVec3Make(0.0, 0.0, 0.0) quad:pgRectStripQuad((pgRectApplyXYWidthHeight(0.0, 0.0, 4.0, 4.0))) uv:pgRectUpsideDownStripQuad((pgRectApplyXYWidthHeight(0.0, 0.0, 1.0, 0.75)))];
            PGEnablingState* __il__0rp0_1__tmp__il__0self = [PGGlobal context]->_blend;
            {
                BOOL __il__0rp0_1__il__0changed = [__il__0rp0_1__tmp__il__0self enable];
                {
                    [[PGGlobal context] setBlendFunction:[PGBlendFunction standard]];
                    for(TRShopButton* _ in _buttons) {
                        [((TRShopButton*)(_)) draw];
                    }
                }
                if(__il__0rp0_1__il__0changed) [__il__0rp0_1__tmp__il__0self disable];
            }
            {
                id<CNIterator> __il__0rp0_2i = [intTo(1, 3) iterator];
                while([__il__0rp0_2i hasNext]) {
                    id c = [__il__0rp0_2i next];
                    {
                        [PGD2D drawLineMaterial:[PGColorSource applyColor:PGVec4Make(0.5, 0.5, 0.5, 1.0)] p0:PGVec2Make(((float)(unumi(c))), 0.0) p1:PGVec2Make(((float)(unumi(c))), 5.0)];
                        [PGD2D drawLineMaterial:[PGColorSource applyColor:PGVec4Make(0.5, 0.5, 0.5, 1.0)] p0:PGVec2Make(0.0, ((float)(unumi(c)))) p1:PGVec2Make(5.0, ((float)(unumi(c))))];
                    }
                }
            }
        }
        if(__il__0changed) [__tmp__il__0self enable];
    }
}

- (BOOL)isProcessorActive {
    return YES;
}

- (PGRecognizers*)recognizers {
    return [PGRecognizers applyRecognizer:[PGRecognizer applyTp:[PGTap apply] on:^BOOL(id<PGEvent> event) {
        return [_buttons existsWhere:^BOOL(TRShopButton* _) {
            return [((TRShopButton*)(_)) tapEvent:event];
        }];
    }]];
}

- (PGRect)viewportWithViewSize:(PGVec2)viewSize {
    return pgRectApplyXYSize(0.0, 0.0, viewSize);
}

- (NSString*)description {
    return @"LevelChooseMenu";
}

- (CNClassType*)type {
    return [TRLevelChooseMenu type];
}

+ (CNClassType*)type {
    return _TRLevelChooseMenu_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

