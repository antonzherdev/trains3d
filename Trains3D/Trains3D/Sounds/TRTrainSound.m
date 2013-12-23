#import "TRTrainSound.h"

#import "TRLevel.h"
#import "SDSound.h"
#import "TRTrain.h"
@implementation TRTrainSound{
    TRLevel* _level;
    EGSoundParallel* _choo;
}
static ODClassType* _TRTrainSound_type;
@synthesize level = _level;
@synthesize choo = _choo;

+ (id)trainSoundWithLevel:(TRLevel*)level {
    return [[TRTrainSound alloc] initWithLevel:level];
}

- (id)initWithLevel:(TRLevel*)level {
    self = [super init];
    if(self) {
        _level = level;
        _choo = [EGSoundParallel soundParallelWithLimit:8 create:^SDSound*() {
            return [SDSound applyFile:@"Choo.wav" volume:0.05];
        }];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _TRTrainSound_type = [ODClassType classTypeWithCls:[TRTrainSound class]];
}

- (void)updateWithDelta:(CGFloat)delta {
    [[_level trains] forEach:^void(TRTrain* train) {
        TRTrainSoundData* sd = ((TRTrainSoundData*)(((TRTrain*)(train)).soundData));
        if(sd == nil) {
            sd = [TRTrainSoundData trainSoundData];
            ((TRTrain*)(train)).soundData = sd;
        }
        if(sd.chooCounter > 0 && sd.toNextChoo <= 0.0) {
            [_choo play];
            [sd nextChoo];
        } else {
            TRRailPoint h = [((TRTrain*)(train)) head];
            if(!(GEVec2iEq(h.tile, sd.lastTile))) {
                [_choo play];
                sd.lastTile = h.tile;
                sd.lastX = h.x;
                [sd nextChoo];
            } else {
                if(sd.chooCounter > 0) [sd nextHead:h];
            }
        }
    }];
}

- (void)start {
}

- (void)stop {
}

- (void)pause {
}

- (void)resume {
}

- (ODClassType*)type {
    return [TRTrainSound type];
}

+ (ODClassType*)type {
    return _TRTrainSound_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    TRTrainSound* o = ((TRTrainSound*)(other));
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


@implementation TRTrainSoundData{
    NSInteger _chooCounter;
    CGFloat _toNextChoo;
    GEVec2i _lastTile;
    CGFloat _lastX;
}
static ODClassType* _TRTrainSoundData_type;
@synthesize chooCounter = _chooCounter;
@synthesize toNextChoo = _toNextChoo;
@synthesize lastTile = _lastTile;
@synthesize lastX = _lastX;

+ (id)trainSoundData {
    return [[TRTrainSoundData alloc] init];
}

- (id)init {
    self = [super init];
    if(self) {
        _chooCounter = 0;
        _toNextChoo = 0.0;
        _lastTile = GEVec2iMake(0, 0);
        _lastX = 0.0;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _TRTrainSoundData_type = [ODClassType classTypeWithCls:[TRTrainSoundData class]];
}

- (void)nextChoo {
    if(_chooCounter == 0) {
        _toNextChoo = 0.03;
        _chooCounter = 1;
    } else {
        if(_chooCounter == 1) {
            _chooCounter = 2;
            _toNextChoo = 0.15;
        } else {
            if(_chooCounter == 2) {
                _toNextChoo = 0.03;
                _chooCounter = 3;
            } else {
                if(_chooCounter == 3) _chooCounter = 0;
            }
        }
    }
}

- (void)nextHead:(TRRailPoint)head {
    _toNextChoo -= floatAbs(_lastX - head.x);
    _lastX = head.x;
}

- (ODClassType*)type {
    return [TRTrainSoundData type];
}

+ (ODClassType*)type {
    return _TRTrainSoundData_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendString:@">"];
    return description;
}

@end


