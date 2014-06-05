#import "TRShopView.h"

#import "PGInput.h"
#import "CNReact.h"
#import "PGText.h"
#import "PGContext.h"
#import "TRGameDirector.h"
#import "PGMaterial.h"
#import "PGD2D.h"
#import "PGInApp.h"
#import "CNChain.h"
@implementation TRShopButton
static CNClassType* _TRShopButton_type;
@synthesize onDraw = _onDraw;
@synthesize onClick = _onClick;
@synthesize rect = _rect;

+ (instancetype)shopButtonWithOnDraw:(void(^)(PGRect))onDraw onClick:(void(^)())onClick {
    return [[TRShopButton alloc] initWithOnDraw:onDraw onClick:onClick];
}

- (instancetype)initWithOnDraw:(void(^)(PGRect))onDraw onClick:(void(^)())onClick {
    self = [super init];
    if(self) {
        _onDraw = [onDraw copy];
        _onClick = [onClick copy];
        _rect = pgRectApplyXYWidthHeight(0.0, 0.0, 1.0, 1.0);
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [TRShopButton class]) _TRShopButton_type = [CNClassType classTypeWithCls:[TRShopButton class]];
}

+ (TRShopButton*)applyRect:(PGRect)rect onDraw:(void(^)(PGRect))onDraw onClick:(void(^)())onClick {
    TRShopButton* b = [TRShopButton shopButtonWithOnDraw:onDraw onClick:onClick];
    b->_rect = rect;
    return b;
}

- (BOOL)tapEvent:(id<PGEvent>)event {
    if(pgRectContainsVec2(_rect, [event location])) {
        _onClick();
        return YES;
    } else {
        return NO;
    }
}

- (void)draw {
    _onDraw(_rect);
}

+ (void(^)(PGRect))drawTextFont:(PGFont*)font color:(PGVec4)color text:(NSString*)text {
    CNVar* r = [CNVar applyInitial:wrap(PGVec3, (PGVec3Make(0.0, 0.0, 0.0)))];
    PGText* tc = [PGText applyFont:[CNReact applyValue:font] text:[CNReact applyValue:text] position:r alignment:[CNReact applyValue:wrap(PGTextAlignment, (pgTextAlignmentApplyXY(0.0, 0.0)))] color:[CNReact applyValue:wrap(PGVec4, color)]];
    return ^void(PGRect rect) {
        [r setValue:wrap(PGVec3, pgVec3ApplyVec2(pgRectCenter(rect)))];
        [tc draw];
    };
}

- (NSString*)description {
    return [NSString stringWithFormat:@")"];
}

- (CNClassType*)type {
    return [TRShopButton type];
}

+ (CNClassType*)type {
    return _TRShopButton_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation TRShopMenu
static CNClassType* _TRShopMenu_type;
@synthesize shareFont = _shareFont;

+ (instancetype)shopMenu {
    return [[TRShopMenu alloc] init];
}

- (instancetype)init {
    self = [super init];
    if(self) {
        __lazy_shop = [CNLazy lazyWithF:^PGTexture*() {
            return [PGGlobal scaledTextureForName:@"Shop" format:PGTextureFormat_RGBA4];
        }];
        _shareFont = [[PGGlobal mainFontWithSize:18] beReadyForText:@"0123456789,.FacebookTwitter"];
        _buttonSize = PGVec2Make(150.0, 150.0);
        _curButtons = ((NSArray*)((@[])));
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [TRShopMenu class]) _TRShopMenu_type = [CNClassType classTypeWithCls:[TRShopMenu class]];
}

- (PGTexture*)shop {
    return [__lazy_shop get];
}

- (void)drawBuyButtonCount:(NSUInteger)count price:(NSString*)price rect:(PGRect)rect {
    [self drawSnailColor:PGVec3Make(0.95, 1.0, 0.95) count:count rect:rect];
    [_shareFont drawText:(([[[TRGameDirector instance] purchasing] containsItem:numui(count)]) ? @"..." : price) at:pgVec3ApplyVec2((pgVec2AddVec2((pgRectPXY(rect, 0.5, 0.1)), (PGVec2Make(0.0, 16.0))))) alignment:pgTextAlignmentApplyXY(0.0, 0.0) color:PGVec4Make(0.1, 0.1, 0.1, 1.0)];
}

- (void)drawShareButtonColor:(PGVec3)color texture:(PGTexture*)texture name:(NSString*)name count:(NSUInteger)count rect:(PGRect)rect {
    [self drawSnailColor:color count:count rect:rect];
    PGVec2 pos = pgRectPXY(rect, 0.1, 0.1);
    [PGD2D drawSpriteMaterial:[PGColorSource applyTexture:texture] at:pgVec3ApplyVec2Z(pos, 0.0) rect:pgRectApplyXYWidthHeight(0.0, 0.0, 32.0, 32.0)];
    [_shareFont drawText:name at:pgVec3ApplyVec2((pgVec2AddVec2(pos, (PGVec2Make(36.0, 16.0))))) alignment:pgTextAlignmentApplyXY(-1.0, 0.0) color:PGVec4Make(0.1, 0.1, 0.1, 1.0)];
}

- (void)drawButtonBackgroundColor:(PGVec3)color rect:(PGRect)rect {
    [PGD2D drawSpriteMaterial:[PGColorSource applyColor:pgVec4ApplyVec3W(color, 0.9)] at:pgVec3ApplyVec2Z(rect.p, 0.0) rect:pgRectApplyXYSize(0.0, 0.0, (pgVec2SubVec2(rect.size, (PGVec2Make(2.0, 2.0)))))];
}

- (void)drawSnailColor:(PGVec3)color count:(NSUInteger)count rect:(PGRect)rect {
    if(count != 10 && count != 20 && count != 50 && count != 200) return ;
    [self drawButtonBackgroundColor:color rect:rect];
    PGVec2 pos = pgRectPXY(rect, 0.5, 0.6);
    PGVec2 snailPos = ((count == 10) ? PGVec2Make(0.0, 128.0) : ((count == 20) ? PGVec2Make(128.0, 128.0) : ((count == 50) ? PGVec2Make(128.0, 64.0) : PGVec2Make(0.0, 64.0))));
    [PGD2D drawSpriteMaterial:[PGColorSource applyTexture:[[self shop] regionX:snailPos.x y:snailPos.y width:128.0 height:64.0]] at:pgVec3ApplyVec2Z(pos, 0.0) rect:pgRectApplyXYWidthHeight(-64.0, -32.0, 128.0, 64.0)];
}

- (void)drawCloseButtonRect:(PGRect)rect {
    [self drawButtonBackgroundColor:PGVec3Make(0.95, 0.95, 0.95) rect:rect];
    [PGD2D drawSpriteMaterial:[PGColorSource applyTexture:[[self shop] regionX:0.0 y:0.0 width:64.0 height:64.0]] at:pgVec3ApplyVec2((pgRectPXY(rect, 0.5, 0.5))) rect:pgRectApplyXYWidthHeight(-32.0, -32.0, 64.0, 64.0)];
}

- (void)draw {
    __weak TRShopMenu* _weakSelf = self;
    NSArray* buttons = [[(@[tuple(^BOOL() {
    return [[TRGameDirector instance] isShareToFacebookAvailable];
}, ([TRShopButton shopButtonWithOnDraw:^void(PGRect _) {
    TRShopMenu* _self = _weakSelf;
    if(_self != nil) [_self drawShareButtonColor:PGVec3Make(0.92, 0.95, 1.0) texture:[[_self shop] regionX:128.0 y:0.0 width:32.0 height:32.0] name:@"Facebook" count:((NSUInteger)([TRGameDirector facebookShareRate])) rect:_];
} onClick:^void() {
    [[TRGameDirector instance] shareToFacebook];
}])), tuple(^BOOL() {
    return [[TRGameDirector instance] isShareToTwitterAvailable];
}, ([TRShopButton shopButtonWithOnDraw:^void(PGRect _) {
    TRShopMenu* _self = _weakSelf;
    if(_self != nil) [_self drawShareButtonColor:PGVec3Make(0.92, 0.95, 1.0) texture:[[_self shop] regionX:160.0 y:0.0 width:32.0 height:32.0] name:@"Twitter" count:((NSUInteger)([TRGameDirector twitterShareRate])) rect:_];
} onClick:^void() {
    [[TRGameDirector instance] shareToTwitter];
}]))]) addSeq:[[[[[TRGameDirector instance] rewindPrices] chain] mapF:^CNTuple*(CNTuple* item) {
        return tuple(^BOOL() {
            return YES;
        }, [TRShopButton shopButtonWithOnDraw:^void(PGRect rect) {
            TRShopMenu* _self = _weakSelf;
            if(_self != nil) [_self drawBuyButtonCount:unumui(((CNTuple*)(item))->_a) price:({
                PGInAppProduct* __tmp_0abp0lrp1 = ((CNTuple*)(item))->_b;
                ((__tmp_0abp0lrp1 != nil) ? ((PGInAppProduct*)(((CNTuple*)(item))->_b))->_price : @"");
            }) rect:rect];
        } onClick:^void() {
            PGInAppProduct* _ = ((CNTuple*)(item))->_b;
            if(_ != nil) [[TRGameDirector instance] buyRewindsProduct:_];
        }]);
    }] toArray]] addSeq:(@[tuple(^BOOL() {
    return YES;
}, [TRShopButton shopButtonWithOnDraw:^void(PGRect _) {
    TRShopMenu* _self = _weakSelf;
    if(_self != nil) [_self drawCloseButtonRect:_];
} onClick:^void() {
    [[TRGameDirector instance] closeShop];
}])])];
    _curButtons = [[[[buttons chain] filterWhen:^BOOL(CNTuple* _) {
        return ((BOOL(^)())(((CNTuple*)(_))->_a))();
    }] mapF:^TRShopButton*(CNTuple* _) {
        return ((CNTuple*)(_))->_b;
    }] toArray];
    PGVec2 size = pgVec2MulVec2((PGVec2Make(((float)(((NSUInteger)(([_curButtons count] + 1) / 2)))), 2.0)), _buttonSize);
    __block PGVec2 pos = pgVec2AddVec2((pgVec2DivI((pgVec2SubVec2((uwrap(PGVec2, [[PGGlobal context]->_scaledViewSize value])), size)), 2)), (PGVec2Make(0.0, _buttonSize.y)));
    __block NSInteger row = 0;
    for(TRShopButton* btn in _curButtons) {
        ((TRShopButton*)(btn))->_rect = PGRectMake(pos, _buttonSize);
        if(row == 0) {
            row++;
            pos = pgVec2AddVec2(pos, (PGVec2Make(0.0, -_buttonSize.y)));
        } else {
            row = 0;
            pos = pgVec2AddVec2(pos, (PGVec2Make(_buttonSize.x, _buttonSize.y)));
        }
        [((TRShopButton*)(btn)) draw];
    }
}

- (BOOL)tapEvent:(id<PGEvent>)event {
    return [_curButtons findWhere:^BOOL(TRShopButton* _) {
        return [((TRShopButton*)(_)) tapEvent:event];
    }] != nil;
}

- (NSString*)description {
    return @"ShopMenu";
}

- (CNClassType*)type {
    return [TRShopMenu type];
}

+ (CNClassType*)type {
    return _TRShopMenu_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

