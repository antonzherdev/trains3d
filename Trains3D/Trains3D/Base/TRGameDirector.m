#import "TRGameDirector.h"

#import "DTKeyValueStorage.h"
#import "EGScene.h"
#import "TRSceneFactory.h"
#import "EGDirector.h"
#import "TRLevel.h"
#import "TRLevelFactory.h"
@implementation TRGameDirector{
    DTKeyValueStorage* _storage;
}
static TRGameDirector* _TRGameDirector_instance;
static ODClassType* _TRGameDirector_type;

+ (id)gameDirector {
    return [[TRGameDirector alloc] init];
}

- (id)init {
    self = [super init];
    if(self) {
        _storage = [DTKeyValueStorage keyValueStorageWithDefaults:(@{@"maxLevel" : @1, @"currentLevel" : @1})];
        [self _init];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _TRGameDirector_type = [ODClassType classTypeWithCls:[TRGameDirector class]];
    _TRGameDirector_instance = [TRGameDirector gameDirector];
}

- (void)_init {
    [CNNotificationCenter.aDefault addObserverName:@"level was passed" block:^void(id _) {
        [_storage keepMaxKey:@"maxLevel" i:unumi(_) + 1];
        [_storage keepMaxKey:@"currentLevel" i:unumi(_) + 1];
        [_storage synchronize];
    }];
}

- (NSInteger)maxAvailableLevel {
    return [_storage intForKey:@"maxLevel"];
}

- (EGScene*)restoreLastScene {
    return [TRSceneFactory sceneForLevelWithNumber:((NSUInteger)([_storage intForKey:@"currentLevel"]))];
}

- (void)restartLevel {
    [[ODObject asKindOfClass:[TRLevel class] object:((EGScene*)([[[EGDirector current] scene] get])).controller] forEach:^void(TRLevel* level) {
        [[EGDirector current] setScene:[TRSceneFactory sceneForLevel:[TRLevel levelWithNumber:((TRLevel*)(level)).number rules:((TRLevel*)(level)).rules]]];
        [_storage keepMaxKey:@"currentLevel" i:((NSInteger)(((TRLevel*)(level)).number))];
        [[EGDirector current] resume];
    }];
}

- (void)chooseLevel {
    [[EGDirector current] resume];
}

- (void)nextLevel {
    [[ODObject asKindOfClass:[TRLevel class] object:((EGScene*)([[[EGDirector current] scene] get])).controller] forEach:^void(TRLevel* level) {
        [_storage keepMaxKey:@"currentLevel" i:((NSInteger)(((TRLevel*)(level)).number + 1))];
        [[EGDirector current] setScene:[TRSceneFactory sceneForLevel:[TRLevelFactory levelWithNumber:((TRLevel*)(level)).number + 1]]];
        [[EGDirector current] resume];
    }];
}

- (ODClassType*)type {
    return [TRGameDirector type];
}

+ (TRGameDirector*)instance {
    return _TRGameDirector_instance;
}

+ (ODClassType*)type {
    return _TRGameDirector_type;
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


