#import "TRLevelMenuView.h"

#import "TRLevel.h"
#import "EGCamera2D.h"
#import "EGProgress.h"
#import "EGSchedule.h"
#import "EGContext.h"
#import "TRScore.h"
#import "EGMaterial.h"
#import "EGSprite.h"
#import "TRRailroad.h"
#import "TRNotification.h"
@implementation TRLevelMenuView{
    TRLevel* _level;
    id<EGCamera> _camera;
    CNLazy* __lazy_res1x;
    CNLazy* __lazy_res2x;
    GEVec4(^_notificationProgress)(float);
    NSString* _notificationText;
    EGCounter* _notificationAnimation;
}
static ODClassType* _TRLevelMenuView_type;
@synthesize level = _level;
@synthesize camera = _camera;
@synthesize notificationProgress = _notificationProgress;

+ (id)levelMenuViewWithLevel:(TRLevel*)level {
    return [[TRLevelMenuView alloc] initWithLevel:level];
}

- (id)initWithLevel:(TRLevel*)level {
    self = [super init];
    if(self) {
        _level = level;
        _camera = [EGCamera2D camera2DWithSize:GEVec2Make(16.0, 1.0)];
        __lazy_res1x = [CNLazy lazyWithF:^TRLevelMenuViewRes1x*() {
            return [TRLevelMenuViewRes1x levelMenuViewRes1x];
        }];
        __lazy_res2x = [CNLazy lazyWithF:^TRLevelMenuViewRes2x*() {
            return [TRLevelMenuViewRes2x levelMenuViewRes2x];
        }];
        _notificationProgress = ^id() {
            float(^__l)(float) = [EGProgress gapT1:0.7 t2:1.0];
            GEVec4(^__r)(float) = ^GEVec4(float _) {
                return GEVec4Make(1.0, 1.0, 1.0, 1 - _);
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

- (id<TRLevelMenuViewRes>)res {
    if([EGGlobal.context viewport].size.y > 46) return [self res2x];
    else return [self res1x];
}

- (EGFont*)font {
    return [[self res] font];
}

- (void)drawView {
    [[self font] drawText:[NSString stringWithFormat:@"%li", [_level.score score]] color:GEVec4Make(1.0, 1.0, 1.0, 1.0) at:GEVec2Make(0.0, 0.0) alignment:egTextAlignmentApplyXY(-1.0, -1.0)];
    NSInteger seconds = ((NSInteger)([_level.schedule time]));
    [[self font] drawText:[NSString stringWithFormat:@"%li", seconds] color:GEVec4Make(1.0, 1.0, 1.0, 1.0) at:GEVec2Make(15.0, 0.0) alignment:egTextAlignmentApplyXY(1.0, -1.0)];
    [EGSprite drawMaterial:[EGColorSource applyColor:GEVec4Make(1.0, 0.0, 0.0, 1.0)] in:geRectApplyXYWidthHeight(15.0, 0.0, 1.0, 1.0)];
    [_notificationAnimation forF:^void(CGFloat t) {
        [[self font] drawText:_notificationText color:_notificationProgress(((float)(t))) at:GEVec2Make(8.0, 0.0) alignment:egTextAlignmentApplyXY(0.0, -1.0)];
    }];
    if(!([[_level.railroad damagesPoints] isEmpty]) && [[_level repairer] isEmpty]) {
    }
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

- (EGEnvironment*)environment {
    return EGEnvironment.aDefault;
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


@implementation TRLevelMenuViewRes1x{
    EGFont* _font;
}
static ODClassType* _TRLevelMenuViewRes1x_type;
@synthesize font = _font;

+ (id)levelMenuViewRes1x {
    return [[TRLevelMenuViewRes1x alloc] init];
}

- (id)init {
    self = [super init];
    if(self) _font = [EGGlobal fontWithName:@"verdana" size:14];
    
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
}
static ODClassType* _TRLevelMenuViewRes2x_type;
@synthesize font = _font;

+ (id)levelMenuViewRes2x {
    return [[TRLevelMenuViewRes2x alloc] init];
}

- (id)init {
    self = [super init];
    if(self) _font = [EGGlobal fontWithName:@"verdana" size:28];
    
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


