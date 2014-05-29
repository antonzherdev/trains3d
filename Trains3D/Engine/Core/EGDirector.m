#import "EGDirector.h"

#import "EGScene.h"
#import "CNReact.h"
#import "EGTime.h"
#import "CNFuture.h"
#import "EGStat.h"
#import "CNConcurrentQueue.h"
#import "EGInput.h"
#import "EGContext.h"
#import "GL.h"
#import "SDSoundDirector.h"
@implementation EGDirector
static EGDirector* _EGDirector__current;
static CNClassType* _EGDirector_type;
@synthesize isPaused = _isPaused;
@synthesize time = _time;

+ (instancetype)director {
    return [[EGDirector alloc] init];
}

- (instancetype)init {
    self = [super init];
    if(self) {
        __scene = nil;
        __isStarted = NO;
        __isPaused = [CNVar varWithInitial:@NO];
        _isPaused = __isPaused;
        __lazyScene = nil;
        _time = [EGTime time];
        __lastViewSize = GEVec2Make(0.0, 0.0);
        __timeSpeed = 1.0;
        __updateFuture = [CNFuture successfulResult:nil];
        __stat = nil;
        __defers = [CNConcurrentQueue concurrentQueue];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGDirector class]) _EGDirector_type = [CNClassType classTypeWithCls:[EGDirector class]];
}

+ (EGDirector*)current {
    return ((EGDirector*)(nonnil(_EGDirector__current)));
}

- (EGScene*)scene {
    return __scene;
}

- (void)setScene:(EGScene*(^)())scene {
    __lazyScene = scene;
    {
        EGScene* sc = __scene;
        if(sc != nil) {
            [((EGScene*)(sc)) stop];
            __scene = nil;
            [self clearRecognizers];
        }
    }
    if(unumb([__isPaused value])) [self redraw];
}

- (void)maybeNewScene {
    EGScene*(^f)() = __lazyScene;
    if(f != nil) {
        EGScene* sc = ((EGScene*(^)())(f))();
        __lazyScene = nil;
        __scene = sc;
        if(!(geVec2IsEqualTo(__lastViewSize, (GEVec2Make(0.0, 0.0))))) [sc reshapeWithViewSize:__lastViewSize];
        {
            id<CNIterator> __il__0_4i = [[sc recognizersTypes] iterator];
            while([__il__0_4i hasNext]) {
                EGRecognizerType* _ = [__il__0_4i next];
                [self registerRecognizerType:_];
            }
        }
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
    if(!(geVec2IsEqualTo(__lastViewSize, size))) {
        autoreleasePoolStart();
        [EGGlobal.context.viewSize setValue:wrap(GEVec2i, geVec2iApplyVec2(size))];
        __lastViewSize = size;
        [((EGScene*)(__scene)) reshapeWithViewSize:size];
        autoreleasePoolEnd();
    }
}

- (void)drawFrame {
    autoreleasePoolStart();
    [self prepare];
    [self draw];
    [self complete];
    autoreleasePoolEnd();
}

- (void)processFrame {
    autoreleasePoolStart();
    [self prepare];
    [self draw];
    [self complete];
    [self tick];
    autoreleasePoolEnd();
}

- (void)prepare {
    [__updateFuture waitResultPeriod:1.0];
    [self executeDefers];
    if(__lastViewSize.x <= 0 || __lastViewSize.y <= 0) return ;
    [self maybeNewScene];
    {
        EGScene* sc = __scene;
        if(sc != nil) {
            egPushGroupMarker(@"Prepare");
            _EGDirector__current = self;
            [EGGlobal.context clear];
            [EGGlobal.context.depthTest enable];
            [((EGScene*)(sc)) prepareWithViewSize:__lastViewSize];
            egCheckError();
            egPopGroupMarker();
        }
    }
}

- (void)draw {
    if(__lastViewSize.x <= 0 || __lastViewSize.y <= 0) return ;
    {
        EGScene* sc = __scene;
        if(sc != nil) {
            egPushGroupMarker(@"Draw");
            [EGGlobal.context clear];
            [EGGlobal.context.depthTest enable];
            [EGGlobal.context clearColorColor:((EGScene*)(sc)).backgroundColor];
            [EGGlobal.context setViewport:geRectIApplyRect((GERectMake((GEVec2Make(0.0, 0.0)), __lastViewSize)))];
            glClear(GL_COLOR_BUFFER_BIT + GL_DEPTH_BUFFER_BIT);
            [((EGScene*)(sc)) drawWithViewSize:__lastViewSize];
            {
                EGStat* stat = __stat;
                if(stat != nil) {
                    [EGGlobal.context.depthTest disable];
                    [((EGStat*)(stat)) draw];
                }
            }
            egCheckError();
            egPopGroupMarker();
        }
    }
}

- (void)complete {
    egPushGroupMarker(@"Complete");
    [((EGScene*)(__scene)) complete];
    egCheckError();
    egPopGroupMarker();
}

- (void)processEvent:(id<EGEvent>)event {
    numb([((EGScene*)(__scene)) processEvent:event]);
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
    {
        EGScene* _ = __scene;
        if(_ != nil) [((EGScene*)(_)) updateWithDelta:dt];
    }
    [((EGStat*)(__stat)) tickWithDelta:_time.delta];
}

- (EGStat*)stat {
    return __stat;
}

- (BOOL)isDisplayingStats {
    return __stat != nil;
}

- (void)displayStats {
    __stat = [EGStat stat];
}

- (void)cancelDisplayingStats {
    __stat = nil;
}

- (void)onGLThreadF:(void(^)())f {
    [__defers enqueueItem:f];
}

- (void)executeDefers {
    while(YES) {
        void(^f)() = [__defers dequeue];
        if(f == nil) break;
        void(^ff)() = ((void(^)())(nonnil(f)));
        ff();
    }
}

- (NSString*)description {
    return @"Director";
}

- (CNClassType*)type {
    return [EGDirector type];
}

+ (CNClassType*)type {
    return _EGDirector_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

