#import "TRLevelMenuView.h"

#import "TRLevel.h"
#import "EGProgress.h"
#import "EGSchedule.h"
#import "EGContext.h"
#import "TRScore.h"
#import "EGSprite.h"
#import "TRNotification.h"
#import "EGDirector.h"
#import "EGCamera2D.h"
@implementation TRLevelMenuView{
    TRLevel* _level;
    CNLazy* __lazy_res1x;
    CNLazy* __lazy_res2x;
    GEVec4(^_notificationProgress)(float);
    NSString* _notificationText;
    EGCounter* _notificationAnimation;
}
static ODClassType* _TRLevelMenuView_type;
@synthesize level = _level;
@synthesize notificationProgress = _notificationProgress;

+ (id)levelMenuViewWithLevel:(TRLevel*)level {
    return [[TRLevelMenuView alloc] initWithLevel:level];
}

- (id)initWithLevel:(TRLevel*)level {
    self = [super init];
    if(self) {
        _level = level;
        __lazy_res1x = [CNLazy lazyWithF:^TRLevelMenuViewRes1x*() {
            return [TRLevelMenuViewRes1x levelMenuViewRes1x];
        }];
        __lazy_res2x = [CNLazy lazyWithF:^TRLevelMenuViewRes2x*() {
            return [TRLevelMenuViewRes2x levelMenuViewRes2x];
        }];
        _notificationProgress = ^id() {
            float(^__l)(float) = [EGProgress gapT1:0.7 t2:1.0];
            GEVec4(^__r)(float) = ^GEVec4(float _) {
                return GEVec4Make(0.0, 0.0, 0.0, 1 - _);
            };
            return ^GEVec4(float _) {
                return __r(__l(_));
            };
        }();
        _notificationText = @"";
        _notificationAnimation = [EGCounter apply];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _TRLevelMenuView_type = [ODClassType classTypeWithCls:[TRLevelMenuView class]];
}

- (TRLevelMenuViewRes1x*)res1x {
    return ((TRLevelMenuViewRes1x*)([__lazy_res1x get]));
}

- (TRLevelMenuViewRes2x*)res2x {
    return ((TRLevelMenuViewRes2x*)([__lazy_res2x get]));
}

- (id<EGCamera>)cameraWithViewport:(GERect)viewport {
    return [[self resHeight:geRectHeight(viewport)] cameraWithViewport:viewport];
}

- (TRLevelMenuViewRes*)res {
    if([EGGlobal.context viewport].size.y > 47) return [self res2x];
    else return [self res1x];
}

- (TRLevelMenuViewRes*)resHeight:(float)height {
    if(height > 47) return [self res2x];
    else return [self res1x];
}

- (EGFont*)font {
    return [[self res] font];
}

- (void)draw {
    egBlendFunctionApplyDraw(egBlendFunctionPremultiplied(), ^void() {
        float w = [EGGlobal.context viewport].size.x / [[self res] pixelsInPoint];
        [[[self res] font] drawText:[self formatScore:[_level.score score]] color:GEVec4Make(0.0, 0.0, 0.0, 1.0) at:GEVec3Make(10.0, 14.0, 0.0) alignment:egTextAlignmentBaselineX(-1.0)];
        EGSprite* pauseSprite = [[self res] pauseSprite];
        pauseSprite.position = GEVec2Make(w - 46, 0.0);
        [pauseSprite draw];
        [_notificationAnimation forF:^void(CGFloat t) {
            [[[self res] notificationFont] drawText:_notificationText color:_notificationProgress(((float)(t))) at:GEVec3Make(w / 2, 15.0, 0.0) alignment:egTextAlignmentBaselineX(0.0)];
        }];
    });
}

- (NSString*)formatScore:(NSInteger)score {
    __block NSInteger i = 0;
    unichar a = unums([[@"'" head] get]);
    NSString* str = [[[[[[NSString stringWithFormat:@"%li", score] chain] reverse] flatMap:^CNList*(id s) {
        i++;
        if(i == 3) return [CNList applyItem:s tail:[CNList applyItem:nums(a)]];
        else return [CNOption applyValue:s];
    }] reverse] charsToString];
    return [NSString stringWithFormat:@"$%@", str];
}

- (void)updateWithDelta:(CGFloat)delta {
    if([_notificationAnimation isRun]) {
        [_notificationAnimation updateWithDelta:delta];
    } else {
        if(!([_level.notifications isEmpty])) {
            _notificationText = [[_level.notifications take] get];
            _notificationAnimation = [EGCounter applyLength:1.0];
        }
    }
}

- (BOOL)processEvent:(EGEvent*)event {
    return [event leftMouseProcessor:self];
}

- (BOOL)mouseUpEvent:(EGEvent*)event {
    GEVec2 p = [event location];
    if([[[self resHeight:geRectHeight(((EGEventCamera*)([event.camera get])).viewport)] pauseSprite] containsVec2:p]) if([[EGGlobal director] isPaused]) [[EGGlobal director] resume];
    else [[EGGlobal director] pause];
    return NO;
}

- (id<EGCamera>)camera {
    return [self cameraWithViewport:geRectApplyXYWidthHeight(-1.0, -1.0, 2.0, 2.0)];
}

- (EGEnvironment*)environment {
    return EGEnvironment.aDefault;
}

- (BOOL)isProcessorActive {
    return !([[EGGlobal director] isPaused]);
}

- (BOOL)mouseDownEvent:(EGEvent*)event {
    return NO;
}

- (BOOL)mouseDragEvent:(EGEvent*)event {
    return NO;
}

- (ODClassType*)type {
    return [TRLevelMenuView type];
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


@implementation TRLevelMenuViewRes{
    CNCache* _cameraCache;
}
static ODClassType* _TRLevelMenuViewRes_type;
@synthesize cameraCache = _cameraCache;

+ (id)levelMenuViewRes {
    return [[TRLevelMenuViewRes alloc] init];
}

- (id)init {
    self = [super init];
    __weak TRLevelMenuViewRes* _weakSelf = self;
    if(self) _cameraCache = [CNCache cacheWithF:^EGCamera2D*(id viewport) {
        return [EGCamera2D camera2DWithSize:GEVec2Make(geRectWidth(uwrap(GERect, viewport)) / [_weakSelf pixelsInPoint], 46.0)];
    }];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _TRLevelMenuViewRes_type = [ODClassType classTypeWithCls:[TRLevelMenuViewRes class]];
}

- (EGFont*)font {
    @throw @"Method font is abstract";
}

- (EGFont*)notificationFont {
    @throw @"Method notificationFont is abstract";
}

- (EGSprite*)pauseSprite {
    @throw @"Method pauseSprite is abstract";
}

- (float)pixelsInPoint {
    @throw @"Method pixelsInPoint is abstract";
}

- (id<EGCamera>)cameraWithViewport:(GERect)viewport {
    return [_cameraCache applyX:wrap(GERect, viewport)];
}

- (ODClassType*)type {
    return [TRLevelMenuViewRes type];
}

+ (ODClassType*)type {
    return _TRLevelMenuViewRes_type;
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


@implementation TRLevelMenuViewRes1x{
    EGFont* _font;
    EGFont* _notificationFont;
    float _pixelsInPoint;
    EGSprite* _pauseSprite;
}
static ODClassType* _TRLevelMenuViewRes1x_type;
@synthesize font = _font;
@synthesize notificationFont = _notificationFont;
@synthesize pixelsInPoint = _pixelsInPoint;
@synthesize pauseSprite = _pauseSprite;

+ (id)levelMenuViewRes1x {
    return [[TRLevelMenuViewRes1x alloc] init];
}

- (id)init {
    self = [super init];
    if(self) {
        _font = [EGGlobal fontWithName:@"lucida_grande_24"];
        _notificationFont = [EGGlobal fontWithName:@"lucida_grande_16"];
        _pixelsInPoint = 1.0;
        _pauseSprite = [EGSprite applyMaterial:[EGColorSource applyTexture:[EGGlobal nearestTextureForFile:@"Pause.png"]] uv:geRectApplyXYWidthHeight(0.0, 0.0, 46.0, 46.0) pixelsInPoint:1.0];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _TRLevelMenuViewRes1x_type = [ODClassType classTypeWithCls:[TRLevelMenuViewRes1x class]];
}

- (ODClassType*)type {
    return [TRLevelMenuViewRes1x type];
}

+ (ODClassType*)type {
    return _TRLevelMenuViewRes1x_type;
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


@implementation TRLevelMenuViewRes2x{
    EGFont* _font;
    EGFont* _notificationFont;
    float _pixelsInPoint;
    EGSprite* _pauseSprite;
}
static ODClassType* _TRLevelMenuViewRes2x_type;
@synthesize font = _font;
@synthesize notificationFont = _notificationFont;
@synthesize pixelsInPoint = _pixelsInPoint;
@synthesize pauseSprite = _pauseSprite;

+ (id)levelMenuViewRes2x {
    return [[TRLevelMenuViewRes2x alloc] init];
}

- (id)init {
    self = [super init];
    if(self) {
        _font = [EGGlobal fontWithName:@"lucida_grande_48"];
        _notificationFont = [EGGlobal fontWithName:@"lucida_grande_32"];
        _pixelsInPoint = 2.0;
        _pauseSprite = [EGSprite applyMaterial:[EGColorSource applyTexture:[EGGlobal nearestTextureForFile:@"Pause_2x.png"]] uv:geRectApplyXYWidthHeight(0.0, 0.0, 92.0, 92.0) pixelsInPoint:2.0];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _TRLevelMenuViewRes2x_type = [ODClassType classTypeWithCls:[TRLevelMenuViewRes2x class]];
}

- (ODClassType*)type {
    return [TRLevelMenuViewRes2x type];
}

+ (ODClassType*)type {
    return _TRLevelMenuViewRes2x_type;
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


