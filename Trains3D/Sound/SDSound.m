#import "SDSound.h"

#import "SDSoundPlat.h"
@implementation SDSound
static ODClassType* _SDSound_type;

+ (instancetype)sound {
    return [[SDSound alloc] init];
}

- (instancetype)init {
    self = [super init];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [SDSound class]) _SDSound_type = [ODClassType classTypeWithCls:[SDSound class]];
}

+ (SDSimpleSound*)applyFile:(NSString*)file {
    return [SDSimpleSound simpleSoundWithFile:file];
}

+ (SDSimpleSound*)applyFile:(NSString*)file volume:(float)volume {
    SDSimpleSound* s = [SDSimpleSound simpleSoundWithFile:file];
    s.volume = volume;
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

- (ODClassType*)type {
    return [SDSound type];
}

+ (ODClassType*)type {
    return _SDSound_type;
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


@implementation SDParSound
static ODClassType* _SDParSound_type;
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
        _sounds = [NSMutableArray mutableArray];
        _paused = [NSMutableSet mutableSet];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [SDParSound class]) _SDParSound_type = [ODClassType classTypeWithCls:[SDParSound class]];
}

- (void)play {
    [CNDispatchQueue.aDefault asyncF:^void() {
        @synchronized(self) {
            [[self sound] forEach:^void(SDSimpleSound* _) {
                [((SDSimpleSound*)(_)) play];
            }];
        }
    }];
}

- (void)playLoops:(NSUInteger)loops {
    [CNDispatchQueue.aDefault asyncF:^void() {
        @synchronized(self) {
            [[self sound] forEach:^void(SDSimpleSound* _) {
                [((SDSimpleSound*)(_)) playLoops:loops];
            }];
        }
    }];
}

- (void)playAlways {
    [CNDispatchQueue.aDefault asyncF:^void() {
        @synchronized(self) {
            [[self sound] forEach:^void(SDSimpleSound* _) {
                [((SDSimpleSound*)(_)) playAlways];
            }];
        }
    }];
}

- (void)pause {
    [CNDispatchQueue.aDefault asyncF:^void() {
        @synchronized(self) {
            [_sounds forEach:^void(SDSimpleSound* sound) {
                if([((SDSimpleSound*)(sound)) isPlaying]) {
                    [((SDSimpleSound*)(sound)) pause];
                    [_paused appendItem:sound];
                }
            }];
        }
    }];
}

- (void)resume {
    [CNDispatchQueue.aDefault asyncF:^void() {
        @synchronized(self) {
            [_paused forEach:^void(SDSound* _) {
                [((SDSound*)(_)) resume];
            }];
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
        [_sounds forEach:^void(SDSimpleSound* _) {
            [((SDSimpleSound*)(_)) stop];
        }];
    }
}

- (void)playWithVolume:(float)volume {
    [CNDispatchQueue.aDefault asyncF:^void() {
        [[self sound] forEach:^void(SDSimpleSound* s) {
            ((SDSimpleSound*)(s)).volume = volume;
            [((SDSimpleSound*)(s)) play];
        }];
    }];
}

- (id)sound {
    id s = [_sounds findWhere:^BOOL(SDSimpleSound* _) {
        return !([((SDSimpleSound*)(_)) isPlaying]);
    }];
    if([s isDefined]) {
        return s;
    } else {
        if([_sounds count] >= _limit) {
            return [CNOption none];
        } else {
            SDSimpleSound* newSound = ((SDSimpleSound*(^)())(_create))();
            [_sounds appendItem:newSound];
            return [CNOption applyValue:newSound];
        }
    }
}

- (ODClassType*)type {
    return [SDParSound type];
}

+ (ODClassType*)type {
    return _SDParSound_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    SDParSound* o = ((SDParSound*)(other));
    return self.limit == o.limit && [self.create isEqual:o.create];
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + self.limit;
    hash = hash * 31 + [self.create hash];
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"limit=%ld", (long)self.limit];
    [description appendString:@">"];
    return description;
}

@end


