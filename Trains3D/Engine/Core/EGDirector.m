#import "EGDirector.h"

#import "EGTime.h"
#import "EGScene.h"
#import "EGContext.h"
#import "EGInput.h"
#import "GL.h"
#import "EGStat.h"
#import "SDSoundDirector.h"
@implementation EGDirector{
    id __scene;
    BOOL __isStarted;
    BOOL __isPaused;
    EGTime* _time;
    GEVec2 __lastViewSize;
    CGFloat __timeSpeed;
    id __stat;
}
static EGDirector* _EGDirector__current;
static CNNotificationHandle* _EGDirector_reshapeNotification;
static ODClassType* _EGDirector_type;
@synthesize time = _time;

+ (id)director {
    return [[EGDirector alloc] init];
}

- (id)init {
    self = [super init];
    if(self) {
        __scene = [CNOption none];
        __isStarted = NO;
        __isPaused = NO;
        _time = [EGTime time];
        __lastViewSize = GEVec2Make(0.0, 0.0);
        __timeSpeed = 1.0;
        __stat = [CNOption none];
        [self _init];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGDirector_type = [ODClassType classTypeWithCls:[EGDirector class]];
    _EGDirector_reshapeNotification = [CNNotificationHandle notificationHandleWithName:@"Reshape"];
}

+ (EGDirector*)current {
    return _EGDirector__current;
}

- (id)scene {
    return __scene;
}

- (void)setScene:(EGScene*(^)())scene {
    [self lock];
    if([__scene isDefined]) {
        [((EGScene*)([__scene get])) stop];
        [self clearRecognizers];
    }
    EGGlobal.context.scale = [self scale];
    EGScene* sc = ((EGScene*(^)())(scene))();
    __scene = [CNOption applyValue:sc];
    [EGGlobal.context clearCache];
    if(!(GEVec2Eq(__lastViewSize, GEVec2Make(0.0, 0.0)))) [sc reshapeWithViewSize:__lastViewSize];
    [[sc recognizersTypes] forEach:^void(EGRecognizerType* _) {
        [self registerRecognizerType:_];
    }];
    [sc start];
    if(__isPaused) [self redraw];
    [self unlock];
}

- (void)clearRecognizers {
    @throw @"Method clearRecognizers is abstract";
}

- (void)registerRecognizerType:(EGRecognizerType*)recognizerType {
    @throw @"Method register is abstract";
}

- (CGFloat)scale {
    @throw @"Method scale is abstract";
}

- (void)lock {
    @throw @"Method lock is abstract";
}

- (void)unlock {
    @throw @"Method unlock is abstract";
}

- (void)redraw {
    @throw @"Method redraw is abstract";
}

- (void)_init {
    _EGDirector__current = self;
}

- (GEVec2)viewSize {
    return __lastViewSize;
}

- (void)reshapeWithSize:(GEVec2)size {
    if(!(GEVec2Eq(__lastViewSize, size))) {
        EGGlobal.context.viewSize = geVec2iApplyVec2(size);
        EGGlobal.context.scale = [self scale];
        __lastViewSize = size;
        [__scene forEach:^void(EGScene* _) {
            [((EGScene*)(_)) reshapeWithViewSize:size];
        }];
        [_EGDirector_reshapeNotification postSender:self data:wrap(GEVec2, size)];
    }
}

- (void)prepare {
    if([__scene isEmpty]) return ;
    if(__lastViewSize.x <= 0 || __lastViewSize.y <= 0) return ;
    EGScene* sc = [__scene get];
    _EGDirector__current = self;
    [EGGlobal.context clear];
    [EGGlobal.context.depthTest enable];
    [sc prepareWithViewSize:__lastViewSize];
}

- (void)draw {
    if([__scene isEmpty]) return ;
    if(__lastViewSize.x <= 0 || __lastViewSize.y <= 0) return ;
    EGScene* sc = [__scene get];
    [EGGlobal.context clear];
    [EGGlobal.context.depthTest enable];
    [EGGlobal.context clearColorColor:((EGScene*)([__scene get])).backgroundColor];
    [EGGlobal.context setViewport:geRectIApplyRect(GERectMake(GEVec2Make(0.0, 0.0), __lastViewSize))];
    glClear(GL_COLOR_BUFFER_BIT + GL_DEPTH_BUFFER_BIT);
    [sc drawWithViewSize:__lastViewSize];
    if([__stat isDefined]) {
        [EGGlobal.context.depthTest disable];
        [((EGStat*)([__stat get])) draw];
    }
}

- (void)processEvent:(id<EGEvent>)event {
    [__scene forEach:^void(EGScene* _) {
        [((EGScene*)(_)) processEvent:event];
    }];
}

- (BOOL)isStarted {
    return __isStarted;
}

- (void)start {
    __isStarted = YES;
    [_time start];
}

- (void)stop {
    __isStarted = NO;
}

- (BOOL)isPaused {
    return __isPaused;
}

- (void)pause {
    __isPaused = YES;
    [__scene forEach:^void(EGScene* _) {
        [((EGScene*)(_)) pause];
    }];
    [self redraw];
}

- (void)resignActive {
    __isPaused = YES;
    [__scene forEach:^void(EGScene* _) {
        [((EGScene*)(_)) pause];
    }];
}

- (void)resume {
    if(__isPaused) {
        __isPaused = NO;
        [_time start];
        [__scene forEach:^void(EGScene* _) {
            [((EGScene*)(_)) resume];
        }];
    }
}

- (CGFloat)timeSpeed {
    return __timeSpeed;
}

- (void)setTimeSpeed:(CGFloat)timeSpeed {
    if(!(eqf(__timeSpeed, timeSpeed))) {
        __timeSpeed = timeSpeed;
        [SDSoundDirector.instance setTimeSpeed:__timeSpeed];
    }
}

- (void)tick {
    _EGDirector__current = self;
    [_time tick];
    [__scene forEach:^void(EGScene* _) {
        [((EGScene*)(_)) updateWithDelta:_time.delta * __timeSpeed];
    }];
    [__stat forEach:^void(EGStat* _) {
        [((EGStat*)(_)) tickWithDelta:_time.delta];
    }];
}

- (id)stat {
    return __stat;
}

- (BOOL)isDisplayingStats {
    return [__stat isDefined];
}

- (void)displayStats {
    __stat = [CNOption applyValue:[EGStat stat]];
}

- (void)cancelDisplayingStats {
    __stat = [CNOption none];
}

- (ODClassType*)type {
    return [EGDirector type];
}

+ (CNNotificationHandle*)reshapeNotification {
    return _EGDirector_reshapeNotification;
}

+ (ODClassType*)type {
    return _EGDirector_type;
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


