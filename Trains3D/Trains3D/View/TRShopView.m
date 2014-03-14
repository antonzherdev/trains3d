#import "TRShopView.h"

#import "EGInput.h"
#import "ATReact.h"
#import "EGTexture.h"
#import "EGContext.h"
#import "TRGameDirector.h"
#import "EGMaterial.h"
#import "EGSprite.h"
#import "EGInApp.h"
@implementation TRShopButton
static ODClassType* _TRShopButton_type;
@synthesize onDraw = _onDraw;
@synthesize onClick = _onClick;
@synthesize rect = _rect;

+ (instancetype)shopButtonWithOnDraw:(void(^)(GERect))onDraw onClick:(void(^)())onClick {
    return [[TRShopButton alloc] initWithOnDraw:onDraw onClick:onClick];
}

- (instancetype)initWithOnDraw:(void(^)(GERect))onDraw onClick:(void(^)())onClick {
    self = [super init];
    if(self) {
        _onDraw = [onDraw copy];
        _onClick = [onClick copy];
        _rect = geRectApplyXYWidthHeight(0.0, 0.0, 1.0, 1.0);
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [TRShopButton class]) _TRShopButton_type = [ODClassType classTypeWithCls:[TRShopButton class]];
}

+ (TRShopButton*)applyRect:(GERect)rect onDraw:(void(^)(GERect))onDraw onClick:(void(^)())onClick {
    TRShopButton* b = [TRShopButton shopButtonWithOnDraw:onDraw onClick:onClick];
    b.rect = rect;
    return b;
}

- (BOOL)tapEvent:(id<EGEvent>)event {
    if(geRectContainsVec2(_rect, [event location])) {
        ((void(^)())(_onClick))();
        return YES;
    } else {
        return NO;
    }
}

- (void)draw {
    _onDraw(_rect);
}

+ (void(^)(GERect))drawTextFont:(EGFont*)font color:(GEVec4)color text:(NSString*)text {
    ATVar* r = [ATVar var];
    EGText* tc = [EGText applyFont:[ATReact applyValue:font] text:[ATReact applyValue:text] position:r alignment:[ATReact applyValue:wrap(EGTextAlignment, (egTextAlignmentApplyXY(0.0, 0.0)))] color:[ATReact applyValue:wrap(GEVec4, color)]];
    return ^void(GERect rect) {
        [r setValue:wrap(GEVec3, geVec3ApplyVec2(geRectCenter(rect)))];
        [tc draw];
    };
}

- (ODClassType*)type {
    return [TRShopButton type];
}

+ (ODClassType*)type {
    return _TRShopButton_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    TRShopButton* o = ((TRShopButton*)(other));
    return [self.onDraw isEqual:o.onDraw] && [self.onClick isEqual:o.onClick];
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.onDraw hash];
    hash = hash * 31 + [self.onClick hash];
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendString:@">"];
    return description;
}

@end


@implementation TRSlowMotionShopMenu
static ODClassType* _TRSlowMotionShopMenu_type;
@synthesize shareFont = _shareFont;

+ (instancetype)slowMotionShopMenu {
    return [[TRSlowMotionShopMenu alloc] init];
}

- (instancetype)init {
    self = [super init];
    if(self) {
        __lazy_shop = [CNLazy lazyWithF:^EGTexture*() {
            return [EGGlobal scaledTextureForName:@"Shop" format:EGTextureFormat.RGBA4];
        }];
        _shareFont = [EGGlobal mainFontWithSize:18];
        _buttonSize = GEVec2Make(150.0, 150.0);
        _curButtons = (@[]);
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [TRSlowMotionShopMenu class]) _TRSlowMotionShopMenu_type = [ODClassType classTypeWithCls:[TRSlowMotionShopMenu class]];
}

- (EGTexture*)shop {
    return [__lazy_shop get];
}

- (void)reshapeWithViewport:(GERect)viewport {
    [_shareFont beReadyForText:@"0123456789,.FacebookTwitter"];
}

- (void)drawBuyButtonCount:(NSUInteger)count price:(NSString*)price rect:(GERect)rect {
    [self drawSnailColor:GEVec3Make(0.95, 1.0, 0.95) count:count rect:rect];
    [_shareFont drawText:(([[TRGameDirector.instance purchasing] containsItem:numui(count)]) ? @"..." : price) at:geVec3ApplyVec2((geVec2AddVec2((geRectPXY(rect, 0.5, 0.1)), (GEVec2Make(0.0, 16.0))))) alignment:egTextAlignmentApplyXY(0.0, 0.0) color:GEVec4Make(0.1, 0.1, 0.1, 1.0)];
}

- (void)drawShareButtonColor:(GEVec3)color texture:(EGTexture*)texture name:(NSString*)name count:(NSUInteger)count rect:(GERect)rect {
    [self drawSnailColor:color count:count rect:rect];
    GEVec2 pos = geRectPXY(rect, 0.1, 0.1);
    [EGD2D drawSpriteMaterial:[EGColorSource applyTexture:texture] at:geVec3ApplyVec2Z(pos, 0.0) rect:geRectApplyXYWidthHeight(0.0, 0.0, 32.0, 32.0)];
    [_shareFont drawText:name at:geVec3ApplyVec2((geVec2AddVec2(pos, (GEVec2Make(36.0, 16.0))))) alignment:egTextAlignmentApplyXY(-1.0, 0.0) color:GEVec4Make(0.1, 0.1, 0.1, 1.0)];
}

- (void)drawButtonBackgroundColor:(GEVec3)color rect:(GERect)rect {
    [EGD2D drawSpriteMaterial:[EGColorSource applyColor:geVec4ApplyVec3W(color, 0.9)] at:geVec3ApplyVec2Z(rect.p, 0.0) rect:geRectApplyXYSize(0.0, 0.0, (geVec2SubVec2(rect.size, (GEVec2Make(2.0, 2.0)))))];
}

- (void)drawSnailColor:(GEVec3)color count:(NSUInteger)count rect:(GERect)rect {
    if(count != 10 && count != 20 && count != 50 && count != 200) return ;
    [self drawButtonBackgroundColor:color rect:rect];
    GEVec2 pos = geRectPXY(rect, 0.5, 0.6);
    GEVec2 snailPos = ((count == 10) ? GEVec2Make(0.0, 128.0) : ((count == 20) ? GEVec2Make(128.0, 128.0) : ((count == 50) ? GEVec2Make(128.0, 64.0) : GEVec2Make(0.0, 64.0))));
    [EGD2D drawSpriteMaterial:[EGColorSource applyTexture:[[self shop] regionX:snailPos.x y:snailPos.y width:128.0 height:64.0]] at:geVec3ApplyVec2Z(pos, 0.0) rect:geRectApplyXYWidthHeight(-64.0, -32.0, 128.0, 64.0)];
}

- (void)drawCloseButtonRect:(GERect)rect {
    [self drawButtonBackgroundColor:GEVec3Make(0.95, 0.95, 0.95) rect:rect];
    [EGD2D drawSpriteMaterial:[EGColorSource applyTexture:[[self shop] regionX:0.0 y:0.0 width:64.0 height:64.0]] at:geVec3ApplyVec2((geRectPXY(rect, 0.5, 0.5))) rect:geRectApplyXYWidthHeight(-32.0, -32.0, 64.0, 64.0)];
}

- (void)draw {
    id<CNImSeq> buttons = [[(@[tuple(numb([TRGameDirector.instance isShareToFacebookAvailable]), ([TRShopButton shopButtonWithOnDraw:^void(GERect _) {
    [self drawShareButtonColor:GEVec3Make(0.92, 0.95, 1.0) texture:[[self shop] regionX:128.0 y:0.0 width:32.0 height:32.0] name:@"Facebook" count:((NSUInteger)(TRGameDirector.facebookShareRate)) rect:_];
} onClick:^void() {
    [TRGameDirector.instance shareToFacebook];
}])), tuple(numb([TRGameDirector.instance isShareToTwitterAvailable]), ([TRShopButton shopButtonWithOnDraw:^void(GERect _) {
    [self drawShareButtonColor:GEVec3Make(0.92, 0.95, 1.0) texture:[[self shop] regionX:160.0 y:0.0 width:32.0 height:32.0] name:@"Twitter" count:((NSUInteger)(TRGameDirector.twitterShareRate)) rect:_];
} onClick:^void() {
    [TRGameDirector.instance shareToTwitter];
}]))]) addSeq:[[[[TRGameDirector.instance slowMotionPrices] chain] map:^CNTuple*(CNTuple* item) {
        return tuple(@YES, [TRShopButton shopButtonWithOnDraw:^void(GERect rect) {
            [self drawBuyButtonCount:unumui(((CNTuple*)(item)).a) price:[[((CNTuple*)(item)).b mapF:^NSString*(EGInAppProduct* _) {
                return ((EGInAppProduct*)(_)).price;
            }] getOrValue:@""] rect:rect];
        } onClick:^void() {
            [((CNTuple*)(item)).b forEach:^void(EGInAppProduct* _) {
                [TRGameDirector.instance buySlowMotionsProduct:_];
            }];
        }]);
    }] toArray]] addSeq:(@[tuple(@YES, [TRShopButton shopButtonWithOnDraw:^void(GERect _) {
    [self drawCloseButtonRect:_];
} onClick:^void() {
    [TRGameDirector.instance closeShop];
}])])];
    _curButtons = [[[[buttons chain] filter:^BOOL(CNTuple* _) {
        return ((BOOL(^)())(((CNTuple*)(_)).a))();
    }] map:^TRShopButton*(CNTuple* _) {
        return ((CNTuple*)(_)).b;
    }] toArray];
    GEVec2 size = geVec2MulVec2((GEVec2Make(((float)(((NSUInteger)(([_curButtons count] + 1) / 2)))), 2.0)), _buttonSize);
    __block GEVec2 pos = geVec2AddVec2((geVec2DivI((geVec2SubVec2((uwrap(GEVec2, [EGGlobal.context.scaledViewSize value])), size)), 2)), (GEVec2Make(0.0, _buttonSize.y)));
    __block NSInteger row = 0;
    [_curButtons forEach:^void(TRShopButton* btn) {
        ((TRShopButton*)(btn)).rect = GERectMake(pos, _buttonSize);
        if(row == 0) {
            row++;
            pos = geVec2AddVec2(pos, (GEVec2Make(0.0, -_buttonSize.y)));
        } else {
            row = 0;
            pos = geVec2AddVec2(pos, (GEVec2Make(_buttonSize.x, _buttonSize.y)));
        }
        [((TRShopButton*)(btn)) draw];
    }];
}

- (BOOL)tapEvent:(id<EGEvent>)event {
    return [[_curButtons findWhere:^BOOL(TRShopButton* _) {
        return [((TRShopButton*)(_)) tapEvent:event];
    }] isDefined];
}

- (ODClassType*)type {
    return [TRSlowMotionShopMenu type];
}

+ (ODClassType*)type {
    return _TRSlowMotionShopMenu_type;
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


