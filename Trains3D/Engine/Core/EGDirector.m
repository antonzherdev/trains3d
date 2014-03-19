#import "EGDirector.h"

#import "ATReact.h"
#import "EGTime.h"
#import "ATConcurrentQueue.h"
#import "EGScene.h"
#import "EGInput.h"
#import "EGContext.h"
#import "GL.h"
#import "EGStat.h"
#import "SDSoundDirector.h"
@implementation EGDirector
static EGDirector* _EGDirector__current;
static CNNotificationHandle* _EGDirector_reshapeNotification;
static ODClassType* _EGDirector_type;
@synthesize isPaused = _isPaused;
@synthesize time = _time;

+ (instancetype)director {
    return [[EGDirector alloc] init];
}

- (instancetype)init {
    self = [super init];
    if(self) {
        __scene = [CNOption none];
        __isStarted = NO;
        __isPaused = [ATVar applyInitial:@NO];
        _isPaused = __isPaused;
        __lazyScene = [CNOption none];
        _time = [EGTime time];
        __lastViewSize = GEVec2Make(0.0, 0.0);
        __timeSpeed = 1.0;
        __updateFuture = [CNFuture successfulResult:nil];
        __stat = [CNOption none];
        __defers = [ATConcurrentQueue concurrentQueue];
        if([self class] == [EGDirector class]) [self _init];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGDirector class]) {
        _EGDirector_type = [ODClassType classTypeWithCls:[EGDirector class]];
        _EGDirector_reshapeNotification = [CNNotificationHandle notificationHandleWithName:@"Reshape"];
    }
}

+ (EGDirector*)current {
    return _EGDirector__current;
}

- (id)scene {
    return __scene;
}

- (void)setScene:(EGScene*(^)())scene {
    __lazyScene = [CNOption applyValue:scene];
    if([__scene isDefined]) {
        [((EGScene*)([__scene get])) stop];
        __scene = [CNOption none];
        [self clearRecognizers];
    }
    if(unumb([__isPaused value])) [self redraw];
}

- (void)maybeNewScene {
    if([__lazyScene isDefined]) {
        EGScene*(^f)() = [__lazyScene get];
        EGScene* sc = ((EGScene*(^)())(f))();
        __lazyScene = [CNOption none];
        __scene = [CNOption applyValue:sc];
        if(!(GEVec2Eq(__lastViewSize, (GEVec2Make(0.0, 0.0))))) [sc reshapeWithViewSize:__lastViewSize];
        [[sc recognizersTypes] forEach:^void(EGRecognizerType* _) {
            [self registerRecognizerType:_];
        }];
        [sc start];
    }
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
        [EGGlobal.context.viewSize setValue:wrap(GEVec2i, geVec2iApplyVec2(size))];
        __lastViewSize = size;
        [__scene forEach:^void(EGScene* _) {
            [((EGScene*)(_)) reshapeWithViewSize:size];
        }];
        [_EGDirector_reshapeNotification postSender:self data:wrap(GEVec2, size)];
    }
}

- (void)drawFrame {
    [self prepare];
    [self draw];
    [self complete];
}

- (void)processFrame {
    [self drawFrame];
    [self tick];
}

- (void)prepare {
    [__updateFuture waitResultPeriod:1.0];
    [self executeDefers];
    if(__lastViewSize.x <= 0 || __lastViewSize.y <= 0) return ;
    [self maybeNewScene];
    if([__scene isEmpty]) return ;
    EGScene* sc = [__scene get];
    egPushGroupMarker(@"Prepare");
    _EGDirector__current = self;
    [EGGlobal.context clear];
    [EGGlobal.context.depthTest enable];
    [sc prepareWithViewSize:__lastViewSize];
    egPopGroupMarker();
}

- (void)draw {
    if([__scene isEmpty]) return ;
    if(__lastViewSize.x <= 0 || __lastViewSize.y <= 0) return ;
    EGScene* sc = [__scene get];
    egPushGroupMarker(@"Draw");
    [EGGlobal.context clear];
    [EGGlobal.context.depthTest enable];
    [EGGlobal.context clearColorColor:((EGScene*)([__scene get])).backgroundColor];
    [EGGlobal.context setViewport:geRectIApplyRect((GERectMake((GEVec2Make(0.0, 0.0)), __lastViewSize)))];
    glClear(GL_COLOR_BUFFER_BIT + GL_DEPTH_BUFFER_BIT);
    [sc drawWithViewSize:__lastViewSize];
    if([__stat isDefined]) {
        [EGGlobal.context.depthTest disable];
        [((EGStat*)([__stat get])) draw];
    }
    egPopGroupMarker();
}

- (void)complete {
    egPushGroupMarker(@"Complete");
    [__scene forEach:^void(EGScene* _) {
        [((EGScene*)(_)) complete];
    }];
    egPopGroupMarker();
}

- (void)processEvent:(id<EGEvent>)event {
    if([__scene isDefined]) [((EGScene*)([__scene get])) processEvent:event];
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

- (void)pause {
    [__isPaused setValue:@YES];
    [self redraw];
}

- (void)becomeActive {
}

- (void)resignActive {
    [__isPaused setValue:@YES];
}

- (void)resume {
    if(unumb([__isPaused value])) {
        [_time start];
        [__isPaused setValue:@NO];
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
    CGFloat dt = _time.delta * __timeSpeed;
    if([__scene isDefined]) __updateFuture = [((EGScene*)([__scene get])) updateWithDelta:dt];
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

- (void)onGLThreadF:(void(^)())f {
    [__defers enqueueItem:f];
}

- (void)executeDefers {
    while(YES) {
        id f = [__defers dequeue];
        if([f isEmpty]) break;
        void(^ff)() = [f get];
        ((void(^)())(ff))();
    }
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


