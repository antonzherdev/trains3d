#import "TRLevelMenuView.h"

#import "TRLevel.h"
#import "EGSprite.h"
#import "EGProgress.h"
#import "EGSchedule.h"
#import "EGContext.h"
#import "EGCamera2D.h"
#import "GL.h"
#import "EGTexture.h"
#import "EGMaterial.h"
#import "TRScore.h"
#import "TRNotification.h"
#import "EGDirector.h"
@implementation TRLevelMenuView{
    TRLevel* _level;
    NSString* _name;
    EGSprite* _pauseSprite;
    GEVec4(^_notificationProgress)(float);
    GERect _pauseReg;
    EGFont* _font;
    EGFont* _notificationFont;
    NSInteger _width;
    id<EGCamera> _camera;
    NSString* _notificationText;
    EGCounter* _notificationAnimation;
}
static ODClassType* _TRLevelMenuView_type;
@synthesize level = _level;
@synthesize name = _name;
@synthesize pauseSprite = _pauseSprite;
@synthesize notificationProgress = _notificationProgress;
@synthesize pauseReg = _pauseReg;
@synthesize camera = _camera;

+ (id)levelMenuViewWithLevel:(TRLevel*)level {
    return [[TRLevelMenuView alloc] initWithLevel:level];
}

- (id)initWithLevel:(TRLevel*)level {
    self = [super init];
    if(self) {
        _level = level;
        _name = @"LevelMenu";
        _pauseSprite = [EGSprite sprite];
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
        _notificationText = @"";
        _notificationAnimation = [EGCounter apply];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _TRLevelMenuView_type = [ODClassType classTypeWithCls:[TRLevelMenuView class]];
}

- (void)reshapeWithViewport:(GERect)viewport {
    _camera = [EGCamera2D camera2DWithSize:GEVec2Make(geRectWidth(viewport) / EGGlobal.context.scale, 46.0)];
    _font = [EGGlobal fontWithName:@"lucida_grande" size:24];
    _notificationFont = [EGGlobal fontWithName:@"lucida_grande" size:16];
    _width = ((NSInteger)(viewport.size.x / EGGlobal.context.scale));
    _pauseSprite.position = GEVec2Make(((float)(_width - 46)), 0.0);
    _pauseSprite.material = [EGColorSource applyTexture:[EGTextureRegion textureRegionWithTexture:[EGGlobal scaledTextureForName:@"Pause" format:@"png" magFilter:GL_NEAREST minFilter:GL_NEAREST] uv:_pauseReg]];
    [_pauseSprite adjustSize];
}

- (void)draw {
    [EGGlobal.context.depthTest disabledF:^void() {
        [EGBlendFunction.premultiplied applyDraw:^void() {
            [_font drawText:[self formatScore:[_level.score score]] color:GEVec4Make(0.0, 0.0, 0.0, 1.0) at:GEVec3Make(10.0, 14.0, 0.0) alignment:egTextAlignmentBaselineX(-1.0)];
            [_pauseSprite draw];
            [_notificationAnimation forF:^void(CGFloat t) {
                [_notificationFont drawText:_notificationText color:_notificationProgress(((float)(t))) at:GEVec3Make(((float)(_width / 2)), 15.0, 0.0) alignment:egTextAlignmentBaselineX(0.0)];
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
    return [event tapProcessor:self];
}

- (BOOL)tapEvent:(EGEvent*)event {
    GEVec2 p = [event location];
    if([_pauseSprite containsVec2:p]) {
        if([[EGGlobal director] isPaused]) [[EGGlobal director] resume];
        else [[EGGlobal director] pause];
    }
    return NO;
}

- (void)prepare {
}

- (EGEnvironment*)environment {
    return EGEnvironment.aDefault;
}

- (BOOL)isProcessorActive {
    return !([[EGGlobal director] isPaused]);
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
    return ((id<EGCamera>)([_cameraCache applyX:wrap(GERect, viewport)]));
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


