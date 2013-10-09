#import "EGDirector.h"

#import "EGTime.h"
#import "EGScene.h"
#import "EGContext.h"
#import "GL.h"
#import "EGStat.h"
#import "EGInput.h"
@implementation EGDirector{
    id __scene;
    BOOL __isStarted;
    BOOL __isPaused;
    EGTime* _time;
    id __stat;
}
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
        __stat = [CNOption none];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGDirector_type = [ODClassType classTypeWithCls:[EGDirector class]];
}

- (id)scene {
    return __scene;
}

- (void)setScene:(EGScene*)scene {
    [self lock];
    if([__scene isDefined]) [((EGScene*)([__scene get])) stop];
    __scene = [CNOption applyValue:scene];
    [scene start];
    [self unlock];
}

- (void)lock {
    @throw @"Method lock is abstract";
}

- (void)unlock {
    @throw @"Method unlock is abstract";
}

- (void)drawWithSize:(GEVec2)size {
    if([__scene isEmpty]) return ;
    if(size.x <= 0 || size.y <= 0) return ;
    EGGlobal.context.director = self;
    [EGGlobal.context clear];
    GEVec4 color = ((EGScene*)([__scene get])).backgroundColor;
    glClearColor(color.x, color.y, color.z, color.w);
    glClear(GL_COLOR_BUFFER_BIT + GL_DEPTH_BUFFER_BIT);
    [EGGlobal.context.depthTest enable];
    [self beforeDraw];
    [((EGScene*)([__scene get])) drawWithViewSize:size];
    [EGGlobal.context.depthTest disable];
    [EGGlobal.matrix clear];
    [EGGlobal.context setViewport:geRectIApplyRect(GERectMake(GEVec2Make(0.0, 0.0), size))];
    [__stat forEach:^void(EGStat* _) {
        [_ draw];
    }];
}

- (void)beforeDraw {
    @throw @"Method beforeDraw is abstract";
}

- (void)processEvent:(EGEvent*)event {
    [__scene forEach:^void(EGScene* _) {
        [_ processEvent:event];
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
        [_ pause];
    }];
}

- (void)resume {
    if(__isPaused) {
        __isPaused = NO;
        [_time start];
        [__scene forEach:^void(EGScene* _) {
            [_ resume];
        }];
    }
}

- (void)tick {
    [_time tick];
    [__scene forEach:^void(EGScene* _) {
        [_ updateWithDelta:_time.delta];
    }];
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
    __stat = [CNOption applyValue:[EGStat stat]];
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


