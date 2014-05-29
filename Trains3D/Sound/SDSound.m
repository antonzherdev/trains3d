#import "SDSound.h"

#import "SDSoundPlat.h"
#import "CNDispatchQueue.h"
@implementation SDSound
static CNClassType* _SDSound_type;

+ (instancetype)sound {
    return [[SDSound alloc] init];
}

- (instancetype)init {
    self = [super init];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [SDSound class]) _SDSound_type = [CNClassType classTypeWithCls:[SDSound class]];
}

+ (SDSimpleSound*)applyFile:(NSString*)file {
    return [SDSimpleSoundPlat simpleSoundPlatWithFile:file];
}

+ (SDSimpleSound*)applyFile:(NSString*)file volume:(float)volume {
    SDSimpleSoundPlat* s = [SDSimpleSoundPlat simpleSoundPlatWithFile:file];
    [s setVolume:volume];
    return s;
}

+ (SDParSound*)parLimit:(NSInteger)limit file:(NSString*)file volume:(float)volume {
    return [SDParSound parSoundWithLimit:limit create:^SDSimpleSound*() {
        return [SDSound applyFile:file volume:volume];
    }];
}

+ (SDParSound*)parLimit:(NSInteger)limit file:(NSString*)file {
    return [SDSound parLimit:limit file:file volume:1.0];
}

- (void)play {
    @throw @"Method play is abstract";
}

- (void)playLoops:(NSUInteger)loops {
    @throw @"Method play is abstract";
}

- (void)playAlways {
    @throw @"Method playAlways is abstract";
}

- (void)stop {
    @throw @"Method stop is abstract";
}

- (BOOL)isPlaying {
    @throw @"Method isPlaying is abstract";
}

- (void)pause {
    @throw @"Method pause is abstract";
}

- (void)resume {
    @throw @"Method resume is abstract";
}

- (NSString*)description {
    return @"Sound";
}

- (CNClassType*)type {
    return [SDSound type];
}

+ (CNClassType*)type {
    return _SDSound_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation SDSimpleSound
static CNClassType* _SDSimpleSound_type;
@synthesize file = _file;

+ (instancetype)simpleSoundWithFile:(NSString*)file {
    return [[SDSimpleSound alloc] initWithFile:file];
}

- (instancetype)initWithFile:(NSString*)file {
    self = [super init];
    if(self) _file = file;
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [SDSimpleSound class]) _SDSimpleSound_type = [CNClassType classTypeWithCls:[SDSimpleSound class]];
}

- (float)pan {
    @throw @"Method pan is abstract";
}

- (void)setPan:(float)pan {
    @throw @"Method set is abstract";
}

- (float)volume {
    @throw @"Method volume is abstract";
}

- (void)setVolume:(float)volume {
    @throw @"Method set is abstract";
}

- (CGFloat)time {
    @throw @"Method time is abstract";
}

- (void)setTime:(CGFloat)time {
    @throw @"Method set is abstract";
}

- (CGFloat)duration {
    @throw @"Method duration is abstract";
}

- (NSString*)description {
    return [NSString stringWithFormat:@"SimpleSound(%@)", _file];
}

- (CNClassType*)type {
    return [SDSimpleSound type];
}

+ (CNClassType*)type {
    return _SDSimpleSound_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation SDParSound
static CNClassType* _SDParSound_type;
@synthesize limit = _limit;
@synthesize create = _create;

+ (instancetype)parSoundWithLimit:(NSInteger)limit create:(SDSimpleSound*(^)())create {
    return [[SDParSound alloc] initWithLimit:limit create:create];
}

- (instancetype)initWithLimit:(NSInteger)limit create:(SDSimpleSound*(^)())create {
    self = [super init];
    if(self) {
        _limit = limit;
        _create = [create copy];
        _sounds = [CNMArray array];
        _paused = [CNMHashSet hashSet];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [SDParSound class]) _SDParSound_type = [CNClassType classTypeWithCls:[SDParSound class]];
}

- (void)play {
    [CNDispatchQueue.aDefault asyncF:^void() {
        @synchronized(self) {
            [((SDSimpleSound*)([self sound])) play];
        }
    }];
}

- (void)playLoops:(NSUInteger)loops {
    [CNDispatchQueue.aDefault asyncF:^void() {
        @synchronized(self) {
            [((SDSimpleSound*)([self sound])) playLoops:loops];
        }
    }];
}

- (void)playAlways {
    [CNDispatchQueue.aDefault asyncF:^void() {
        @synchronized(self) {
            [((SDSimpleSound*)([self sound])) playAlways];
        }
    }];
}

- (void)pause {
    [CNDispatchQueue.aDefault asyncF:^void() {
        @synchronized(self) {
            for(SDSimpleSound* sound in _sounds) {
                if([((SDSimpleSound*)(sound)) isPlaying]) {
                    [((SDSimpleSound*)(sound)) pause];
                    [_paused appendItem:sound];
                }
            }
        }
    }];
}

- (void)resume {
    [CNDispatchQueue.aDefault asyncF:^void() {
        @synchronized(self) {
            {
                id<CNIterator> __il__0rp0_0i = [_paused iterator];
                while([__il__0rp0_0i hasNext]) {
                    SDSound* _ = [__il__0rp0_0i next];
                    [((SDSound*)(_)) resume];
                }
            }
            [_paused clear];
        }
    }];
}

- (BOOL)isPlaying {
    @synchronized(self) {
        return [_sounds existsWhere:^BOOL(SDSimpleSound* _) {
            return [((SDSimpleSound*)(_)) isPlaying];
        }];
    }
}

- (void)stop {
    @synchronized(self) {
        for(SDSimpleSound* _ in _sounds) {
            [((SDSimpleSound*)(_)) stop];
        }
    }
}

- (void)playWithVolume:(float)volume {
    [CNDispatchQueue.aDefault asyncF:^void() {
        @synchronized(self) {
            SDSimpleSound* s = [self sound];
            if(s != nil) {
                [((SDSimpleSound*)(s)) setVolume:volume];
                [((SDSimpleSound*)(s)) play];
            }
        }
    }];
}

- (SDSimpleSound*)sound {
    SDSimpleSound* s = [_sounds findWhere:^BOOL(SDSimpleSound* _) {
        return !([((SDSimpleSound*)(_)) isPlaying]);
    }];
    if(s != nil) {
        return ((SDSimpleSound*)(s));
    } else {
        if([_sounds count] >= _limit) {
            return nil;
        } else {
            SDSimpleSound* newSound = _create();
            [_sounds appendItem:newSound];
            return newSound;
        }
    }
}

- (NSString*)description {
    return [NSString stringWithFormat:@"ParSound(%ld)", (long)_limit];
}

- (CNClassType*)type {
    return [SDParSound type];
}

+ (CNClassType*)type {
    return _SDParSound_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

