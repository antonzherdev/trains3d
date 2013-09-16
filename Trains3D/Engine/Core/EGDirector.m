#import "EGDirector.h"

#import "EGScene.h"
#import "EGTime.h"
#import "EGContext.h"
#import "GL.h"
#import "EGStat.h"
#import "EGProcessor.h"
@implementation EGDirector{
    EGScene* _scene;
    BOOL __isStarted;
    BOOL __isPaused;
    EGTime* _time;
    id __stat;
}
static ODClassType* _EGDirector_type;
@synthesize scene = _scene;
@synthesize time = _time;

+ (id)director {
    return [[EGDirector alloc] init];
}

- (id)init {
    self = [super init];
    if(self) {
        __isStarted = NO;
        __isPaused = NO;
        _time = [EGTime time];
        __stat = [CNOption none];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGDirector_type = [ODClassType classTypeWithCls:[EGDirector class]];
}

- (void)drawWithSize:(GEVec2)size {
    EGGlobal.context.director = self;
    glClearColor(0.0, 0.0, 0.0, 1.0);
    egClear();
    [EGGlobal.matrix clear];
    glEnable(GL_DEPTH_TEST);
    glEnable(GL_CULL_FACE);
    [_scene drawWithViewSize:size];
    glDisable(GL_DEPTH_TEST);
    [__stat forEach:^void(EGStat* _) {
        [_ draw];
    }];
}

- (void)processEvent:(EGEvent*)event {
    [_scene processEvent:event];
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
}

- (void)resume {
    if(__isPaused) {
        __isPaused = NO;
        [_time start];
    }
}

- (void)tick {
    [_time tick];
    [_scene updateWithDelta:_time.delta];
    [__stat forEach:^void(EGStat* _) {
        [_ tickWithDelta:_time.delta];
    }];
}

- (id)stat {
    return __stat;
}

- (BOOL)isDisplayingStats {
    return [__stat isDefined];
}

- (void)displayStats {
    __stat = [CNOption opt:[EGStat stat]];
}

- (void)cancelDisplayingStats {
    __stat = [CNOption none];
}

- (ODClassType*)type {
    return [EGDirector type];
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

