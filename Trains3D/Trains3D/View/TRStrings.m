#import "TRStrings.h"

#import "GL.h"
#import "EGPlatform.h"
@implementation TREnStrings
static ODClassType* _TREnStrings_type;

+ (id)enStrings {
    return [[TREnStrings alloc] init];
}

- (id)init {
    self = [super init];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _TREnStrings_type = [ODClassType classTypeWithCls:[TREnStrings class]];
}

- (NSString*)railBuiltCost:(NSInteger)cost {
    return [NSString stringWithFormat:@"-%@: For the railroad building", [self formatCost:cost]];
}

- (NSString*)trainArrivedCost:(NSInteger)cost {
    return [NSString stringWithFormat:@"+%@: For the arrived train", [self formatCost:cost]];
}

- (NSString*)trainDestroyedCost:(NSInteger)cost {
    return [NSString stringWithFormat:@"-%@: For the train destroying", [self formatCost:cost]];
}

- (NSString*)trainDelayedFineCost:(NSInteger)cost {
    return [NSString stringWithFormat:@"-%@: Fine for the delayed train", [self formatCost:cost]];
}

- (NSString*)resumeGame {
    return @"Continue the game";
}

- (NSString*)restartLevel {
    return @"Restart the level";
}

- (NSString*)mainMenu {
    return @"Main menu";
}

- (NSString*)callRepairer {
    return @"Call\n"
        "repairers";
}

- (NSString*)undo {
    return @"Undo";
}

- (NSString*)colorOrange {
    return @"orange";
}

- (NSString*)colorGreen {
    return @"green";
}

- (NSString*)colorPink {
    return @"pink";
}

- (NSString*)colorGrey {
    return @"grey";
}

- (NSString*)helpConnectTwoCities {
    return [NSString stringWithFormat:@"Connect two cities by rails.\n"
        "%@", ((egPlatform().touch) ? @"Simply paint rails by your finger." : @"Use mouse or\n"
        "move two fingers on a touchpad.")];
}

- (NSString*)helpNewCity {
    return @"New cities sometimes appear.\n"
        "Connect theirs to your railroad.";
}

- (NSString*)helpTrainTo:(NSString*)to {
    return [NSString stringWithFormat:@"This train is going to %@ city.\n"
        "You can understand it by train's color.", to];
}

- (NSString*)helpTrainWithSwitchesTo:(NSString*)to {
    return [NSString stringWithFormat:@"Turn railroad switches by%@,\n"
        "so train arrive at %@ city.", ((egPlatform().touch) ? @" tap" : @" click"), to];
}

- (NSString*)formatCost:(NSInteger)cost {
    return [NSString stringWithFormat:@"%ld", (long)cost];
}

- (ODClassType*)type {
    return [TREnStrings type];
}

+ (ODClassType*)type {
    return _TREnStrings_type;
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


@implementation TRRuStrings
static ODClassType* _TRRuStrings_type;

+ (id)ruStrings {
    return [[TRRuStrings alloc] init];
}

- (id)init {
    self = [super init];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _TRRuStrings_type = [ODClassType classTypeWithCls:[TRRuStrings class]];
}

- (NSString*)railBuiltCost:(NSInteger)cost {
    return [NSString stringWithFormat:@"-%@: За постройку железной дороги", [self formatCost:cost]];
}

- (NSString*)trainArrivedCost:(NSInteger)cost {
    return [NSString stringWithFormat:@"+%@: За прибывший поезд", [self formatCost:cost]];
}

- (NSString*)trainDestroyedCost:(NSInteger)cost {
    return [NSString stringWithFormat:@"-%@: За уничтожение поезда", [self formatCost:cost]];
}

- (NSString*)trainDelayedFineCost:(NSInteger)cost {
    return [NSString stringWithFormat:@"-%@: Штраф за задерживающийся поезд", [self formatCost:cost]];
}

- (NSString*)resumeGame {
    return @"Продолжить игру";
}

- (NSString*)restartLevel {
    return @"Начать уровень заново";
}

- (NSString*)mainMenu {
    return @"Основное меню";
}

- (NSString*)callRepairer {
    return @"Вызвать\n"
        "ремонтников";
}

- (NSString*)undo {
    return @"Отменить";
}

- (NSString*)colorOrange {
    return @"оранжевый";
}

- (NSString*)colorGreen {
    return @"зеленый";
}

- (NSString*)colorPink {
    return @"розовый";
}

- (NSString*)colorGrey {
    return @"серый";
}

- (NSString*)helpConnectTwoCities {
    return [NSString stringWithFormat:@"Соедините два города рельсами.\n"
        "%@", ((egPlatform().touch) ? @"Для этого просто проведите пальцем по экрану." : @"Используйте мышку или\n"
        "проведите двумя пальцами по тачпаду.")];
}

- (NSString*)helpNewCity {
    return @"Иногда появляются новые города.\n"
        "Подсоединяйте их к своей железной дороге.";
}

- (NSString*)helpTrainTo:(NSString*)to {
    return [NSString stringWithFormat:@"Этот поезд направляется в %@ город.\n"
        "Вы можете понять это по цвету поезда.", to];
}

- (NSString*)helpTrainWithSwitchesTo:(NSString*)to {
    return [NSString stringWithFormat:@"Переключите железнодорожные стрелки%@,\n"
        "чтобы этот поезд попал в %@ город.", ((egPlatform().touch) ? @" касанием" : @" кликом"), to];
}

- (NSString*)formatCost:(NSInteger)cost {
    return [NSString stringWithFormat:@"%ld", (long)cost];
}

- (ODClassType*)type {
    return [TRRuStrings type];
}

+ (ODClassType*)type {
    return _TRRuStrings_type;
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


@implementation TRStr
static id<CNMap> _TRStr_locales;
static id<TRStrings> _TRStr_Loc;
static ODClassType* _TRStr_type;

+ (void)initialize {
    [super initialize];
    _TRStr_type = [ODClassType classTypeWithCls:[TRStr class]];
    _TRStr_locales = [[(@[tuple(@"en", [TREnStrings enStrings]), tuple(@"ru", [TRRuStrings ruStrings])]) chain] toMap];
    _TRStr_Loc = [[_TRStr_locales optKey:[OSLocale currentLanguageId]] getOrElseF:^id<TRStrings>() {
        return [TREnStrings enStrings];
    }];
}

- (ODClassType*)type {
    return [TRStr type];
}

+ (id<TRStrings>)Loc {
    return _TRStr_Loc;
}

+ (ODClassType*)type {
    return _TRStr_type;
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


