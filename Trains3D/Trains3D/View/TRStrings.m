#import "TRStrings.h"

#import "TRTrain.h"
#import "TRCity.h"
#import "TRLevel.h"
#import "EGGameCenter.h"
#import "GL.h"
#import "EGPlatform.h"
@implementation TRStr
static TRStrings* _TRStr_Loc;
static ODClassType* _TRStr_type;

+ (void)initialize {
    [super initialize];
    _TRStr_type = [ODClassType classTypeWithCls:[TRStr class]];
    _TRStr_Loc = ^TRStrings*() {
        id<CNMap> locales = [[[(@[[TREnStrings enStrings], [TRRuStrings ruStrings], [TRJpStrings jpStrings], [TRKoStrings koStrings], [TRChinaStrings chinaStrings]]) chain] map:^CNTuple*(TREnStrings* strs) {
            return tuple(((TREnStrings*)(strs)).language, strs);
        }] toMap];
        return [[[[[OSLocale preferredLanguages] chain] flatMap:^id(NSString* lng) {
            return [locales optKey:[lng substrBegin:0 end:2]];
        }] headOpt] getOrElseF:^TRStrings*() {
            return [TREnStrings enStrings];
        }];
    }();
}

- (ODClassType*)type {
    return [TRStr type];
}

+ (TRStrings*)Loc {
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


@implementation TRStrings{
    NSString* _language;
}
static TRTrain* _TRStrings_fakeTrain;
static TRTrain* _TRStrings_fakeCrazyTrain;
static TRLevel* _TRStrings_fakeLevel;
static ODClassType* _TRStrings_type;
@synthesize language = _language;

+ (id)stringsWithLanguage:(NSString*)language {
    return [[TRStrings alloc] initWithLanguage:language];
}

- (id)initWithLanguage:(NSString*)language {
    self = [super init];
    if(self) _language = language;
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _TRStrings_type = [ODClassType classTypeWithCls:[TRStrings class]];
    _TRStrings_fakeTrain = [TRTrain trainWithLevel:nil trainType:TRTrainType.simple color:TRCityColor.orange __cars:^id<CNSeq>(TRTrain* _) {
        return (@[]);
    } speed:10];
    _TRStrings_fakeCrazyTrain = [TRTrain trainWithLevel:nil trainType:TRTrainType.crazy color:TRCityColor.grey __cars:^id<CNSeq>(TRTrain* _) {
        return (@[]);
    } speed:10];
    _TRStrings_fakeLevel = [TRLevel levelWithNumber:1 rules:nil];
}

- (NSString*)formatCost:(NSInteger)cost {
    __block NSInteger i = 0;
    unichar a = unums([@"'" head]);
    NSString* str = [[[[[[NSString stringWithFormat:@"%ld", (long)cost] chain] reverse] flatMap:^CNList*(id s) {
        i++;
        if(i == 3) return [CNList applyItem:s tail:[CNList applyItem:nums(a)]];
        else return [CNOption applyValue:s];
    }] reverse] charsToString];
    return [NSString stringWithFormat:@"$%@", str];
}

- (NSString*)notificationsCharSet {
    return [[[[[[[[@"$0123456789'" stringByAppendingString:[self railBuiltCost:0]] stringByAppendingString:[self trainArrivedTrain:_TRStrings_fakeTrain cost:0]] stringByAppendingString:[self trainArrivedTrain:_TRStrings_fakeCrazyTrain cost:0]] stringByAppendingString:[self trainDelayedFineTrain:_TRStrings_fakeTrain cost:0]] stringByAppendingString:[self trainDelayedFineTrain:_TRStrings_fakeCrazyTrain cost:0]] stringByAppendingString:[self trainDestroyedCost:0]] stringByAppendingString:[self damageFixedPaymentCost:0]] stringByAppendingString:[self cityBuilt]];
}

- (NSString*)levelNumber:(NSUInteger)number {
    @throw @"Method level is abstract";
}

- (NSString*)startLevelNumber:(NSUInteger)number {
    return [self levelNumber:number];
}

- (NSString*)railBuiltCost:(NSInteger)cost {
    @throw @"Method railBuilt is abstract";
}

- (NSString*)trainArrivedTrain:(TRTrain*)train cost:(NSInteger)cost {
    @throw @"Method trainArrived is abstract";
}

- (NSString*)trainDestroyedCost:(NSInteger)cost {
    @throw @"Method trainDestroyed is abstract";
}

- (NSString*)trainDelayedFineTrain:(TRTrain*)train cost:(NSInteger)cost {
    @throw @"Method trainDelayedFine is abstract";
}

- (NSString*)damageFixedPaymentCost:(NSInteger)cost {
    @throw @"Method damageFixedPayment is abstract";
}

- (NSString*)cityBuilt {
    @throw @"Method cityBuilt is abstract";
}

- (NSString*)menuButtonsCharacterSet {
    return [[[[[[[[[@"0123456789" stringByAppendingString:[self resumeGame]] stringByAppendingString:[self restartLevel:_TRStrings_fakeLevel]] stringByAppendingString:[self replayLevel:_TRStrings_fakeLevel]] stringByAppendingString:[self goToNextLevel:_TRStrings_fakeLevel]] stringByAppendingString:[self chooseLevel]] stringByAppendingString:[self supportButton]] stringByAppendingString:[self shareButton]] stringByAppendingString:[self leaderboard]] stringByAppendingString:[self buyButton]];
}

- (NSString*)resumeGame {
    @throw @"Method resumeGame is abstract";
}

- (NSString*)restartLevel:(TRLevel*)level {
    @throw @"Method restart is abstract";
}

- (NSString*)replayLevel:(TRLevel*)level {
    @throw @"Method replay is abstract";
}

- (NSString*)goToNextLevel:(TRLevel*)level {
    @throw @"Method goToNext is abstract";
}

- (NSString*)chooseLevel {
    @throw @"Method chooseLevel is abstract";
}

- (NSString*)supportButton {
    @throw @"Method supportButton is abstract";
}

- (NSString*)shareButton {
    @throw @"Method shareButton is abstract";
}

- (NSString*)leaderboard {
    @throw @"Method leaderboard is abstract";
}

- (NSString*)buyButton {
    @throw @"Method buyButton is abstract";
}

- (NSString*)victory {
    @throw @"Method victory is abstract";
}

- (NSString*)defeat {
    @throw @"Method defeat is abstract";
}

- (NSString*)moneyOver {
    @throw @"Method moneyOver is abstract";
}

- (NSString*)result {
    @throw @"Method result is abstract";
}

- (NSString*)best {
    @throw @"Method best is abstract";
}

- (NSString*)error {
    @throw @"Method error is abstract";
}

- (NSString*)supportEmailText {
    return @"Report a problem or tell me about your ideas.\n"
        "I will definitely reply to you and try to fix problems as soon as possible.\n"
        "Thank you very much, Anton Zherdev, developer";
}

- (NSString*)rateText {
    @throw @"Method rateText is abstract";
}

- (NSString*)rateNow {
    @throw @"Method rateNow is abstract";
}

- (NSString*)rateProblem {
    @throw @"Method rateProblem is abstract";
}

- (NSString*)rateLater {
    @throw @"Method rateLater is abstract";
}

- (NSString*)rateClose {
    @throw @"Method rateClose is abstract";
}

- (NSString*)topScore:(EGLocalPlayerScore*)score {
    @throw @"Method top is abstract";
}

- (NSString*)tapToContinue {
    @throw @"Method tapToContinue is abstract";
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

- (NSString*)colorPurple {
    return @"purple";
}

- (NSString*)colorGrey {
    return @"grey";
}

- (NSString*)colorBlue {
    return @"blue";
}

- (NSString*)colorMint {
    return @"mint";
}

- (NSString*)colorRed {
    return @"red";
}

- (NSString*)colorBeige {
    return @"beige";
}

- (NSString*)colorYellow {
    return @"yellow";
}

- (NSString*)helpConnectTwoCities {
    @throw @"Method helpConnectTwoCities is abstract";
}

- (NSString*)helpRules {
    @throw @"Method helpRules is abstract";
}

- (NSString*)helpNewCity {
    @throw @"Method helpNewCity is abstract";
}

- (NSString*)helpSporadicDamage {
    @throw @"Method helpSporadicDamage is abstract";
}

- (NSString*)helpDamage {
    @throw @"Method helpDamage is abstract";
}

- (NSString*)helpRepairer {
    @throw @"Method helpRepairer is abstract";
}

- (NSString*)helpCrazy {
    @throw @"Method helpCrazy is abstract";
}

- (NSString*)helpInZoom {
    @throw @"Method helpInZoom is abstract";
}

- (NSString*)helpExpressTrain {
    @throw @"Method helpExpressTrain is abstract";
}

- (NSString*)helpTrainTo:(NSString*)to {
    @throw @"Method helpTrain is abstract";
}

- (NSString*)helpTrainWithSwitchesTo:(NSString*)to {
    @throw @"Method helpTrainWithSwitches is abstract";
}

- (NSString*)helpToMakeZoom {
    @throw @"Method helpToMakeZoom is abstract";
}

- (NSString*)linesAdvice {
    @throw @"Method linesAdvice is abstract";
}

- (NSString*)helpSlowMotion {
    @throw @"Method helpSlowMotion is abstract";
}

- (NSString*)shareTextUrl:(NSString*)url {
    @throw @"Method shareText is abstract";
}

- (NSString*)shareSubject {
    @throw @"Method shareSubject is abstract";
}

- (NSString*)twitterTextUrl:(NSString*)url {
    @throw @"Method twitterText is abstract";
}

- (ODClassType*)type {
    return [TRStrings type];
}

+ (ODClassType*)type {
    return _TRStrings_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    TRStrings* o = ((TRStrings*)(other));
    return [self.language isEqual:o.language];
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.language hash];
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"language=%@", self.language];
    [description appendString:@">"];
    return description;
}

@end


@implementation TREnStrings
static ODClassType* _TREnStrings_type;

+ (id)enStrings {
    return [[TREnStrings alloc] init];
}

- (id)init {
    self = [super initWithLanguage:@"en"];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _TREnStrings_type = [ODClassType classTypeWithCls:[TREnStrings class]];
}

- (NSString*)levelNumber:(NSUInteger)number {
    return [NSString stringWithFormat:@"Level %lu", (unsigned long)number];
}

- (NSString*)railBuiltCost:(NSInteger)cost {
    return [NSString stringWithFormat:@"-%@: Payment for the railroad building", [self formatCost:cost]];
}

- (NSString*)trainArrivedTrain:(TRTrain*)train cost:(NSInteger)cost {
    if(train.trainType == TRTrainType.crazy) return [NSString stringWithFormat:@"+%@: Reward for the arrived crazy train", [self formatCost:cost]];
    else return [NSString stringWithFormat:@"+%@: Reward for the arrived %@ train", [self formatCost:cost], [train.color localName]];
}

- (NSString*)trainDestroyedCost:(NSInteger)cost {
    return [NSString stringWithFormat:@"-%@: Fine for the destroyed train", [self formatCost:cost]];
}

- (NSString*)trainDelayedFineTrain:(TRTrain*)train cost:(NSInteger)cost {
    if(train.trainType == TRTrainType.crazy) return [NSString stringWithFormat:@"-%@: Fine for the delayed crazy train", [self formatCost:cost]];
    else return [NSString stringWithFormat:@"-%@: Fine for the delayed %@ train", [self formatCost:cost], [train.color localName]];
}

- (NSString*)damageFixedPaymentCost:(NSInteger)cost {
    return [NSString stringWithFormat:@"-%@: Payment for the railroad repairs", [self formatCost:cost]];
}

- (NSString*)resumeGame {
    return @"Continue the game";
}

- (NSString*)restartLevel:(TRLevel*)level {
    return [NSString stringWithFormat:@"Restart the level %lu", (unsigned long)level.number];
}

- (NSString*)replayLevel:(TRLevel*)level {
    return [NSString stringWithFormat:@"Play level %lu again", (unsigned long)level.number];
}

- (NSString*)goToNextLevel:(TRLevel*)level {
    return @"Play the next level";
}

- (NSString*)chooseLevel {
    return @"Choose the level";
}

- (NSString*)victory {
    return @"Victory!";
}

- (NSString*)defeat {
    return @"Defeat!";
}

- (NSString*)moneyOver {
    return @"Money is over";
}

- (NSString*)cityBuilt {
    return @"The new city has been built";
}

- (NSString*)tapToContinue {
    if(egPlatform().isComputer) return @"Click to continue";
    else return @"Tap to continue";
}

- (NSString*)error {
    return @"Error";
}

- (NSString*)buyButton {
    return @"Buy slow motions";
}

- (NSString*)shareButton {
    return @"Share with friends";
}

- (NSString*)supportButton {
    return @"Email the developer";
}

- (NSString*)rateText {
    return @"If you enjoy playing Raildale, would you mind taking\n"
        "a moment to rate it? It won’t take more than a minute.\n"
        "\n"
        "If you are faced with a problem, please, report it to me.\n"
        "I will try to fix it as soon as possible.\n"
        "\n"
        "Thanks for your support!\n"
        "Best Regards, Anton Zherdev, developer";
}

- (NSString*)rateNow {
    return @"Rate it now";
}

- (NSString*)rateProblem {
    return @"Report a problem";
}

- (NSString*)rateLater {
    return @"Remind me later";
}

- (NSString*)rateClose {
    return @"No, thanks";
}

- (NSString*)helpConnectTwoCities {
    return [NSString stringWithFormat:@"Connect two cities by rail.\n"
        "%@", ((egPlatform().touch) ? @"Simply paint the rails using your finger." : @"Use a mouse or\n"
        "move two fingers on a touchpad.")];
}

- (NSString*)helpRules {
    return @"Don't allow account balance to fall lower than zero.\n"
        "Stay in the allotted time with a positive balance to win a level.";
}

- (NSString*)helpNewCity {
    return @"Sometimes new cities appear.\n"
        "Connect them to your railway.";
}

- (NSString*)helpTrainTo:(NSString*)to {
    return [NSString stringWithFormat:@"This train is going to the %@ city.\n"
        "You can recognize it by the color of the train.", to];
}

- (NSString*)helpTrainWithSwitchesTo:(NSString*)to {
    return [NSString stringWithFormat:@"Turn railroad switches using a %@,\n"
        "so the train will arrive at the %@ city.", ((egPlatform().touch) ? @" tap" : @" click"), to];
}

- (NSString*)helpExpressTrain {
    return @"This is a very fast express train.\n"
        "It doesn't have time to stop in front of a switch.\n"
        "In this case the train will be destroyed.\n"
        "But you can use lights to conduct the train.";
}

- (NSString*)helpToMakeZoom {
    return @"You can change the scale using a pinch gesture.";
}

- (NSString*)helpInZoom {
    return @"Use a finger to scroll.\n"
        "Press the hammer button at the top to build rails.\n"
        "Press again to come back to the scroll mode.";
}

- (NSString*)helpSporadicDamage {
    return @"Sometimes rails can be broken.";
}

- (NSString*)helpDamage {
    return @"Call the service train using one of the buttons to fix the damage.\n"
        "It is better to call the train from the closest city to the damage.";
}

- (NSString*)helpCrazy {
    return @"The engineer of the train is crazy.\n"
        "He doesn't pay attention to lights or closed switches.\n"
        "Send this train to any city.";
}

- (NSString*)helpRepairer {
    return @"Conduct the service train through the damage\n"
        "and send it to any city.";
}

- (NSString*)helpSlowMotion {
    return @"Use the slow motion to help yourself in difficult moments.\n"
        "Press the snail button in the top right-hand corner of the screen.\n"
        "A small number of uses are restored every day.\n"
        "If you want to make the game easier,\n"
        "you can buy additional slow motions\n"
        "or get them for free sharing the game on Facebook or Twitter.\n"
        "But it is possible to manage without.";
}

- (NSString*)linesAdvice {
    return @"You can connect cities using more than one line.\n"
        "Thus two trains coming from the opposite direction\n"
        "would not collide with each other.";
}

- (NSString*)result {
    return @"Score";
}

- (NSString*)best {
    return @"Your best";
}

- (NSString*)topScore:(EGLocalPlayerScore*)score {
    if(score.rank == 1) {
        return @"The 1-st ever!";
    } else {
        if(score.rank == 2) {
            return @"The 2-nd ever!";
        } else {
            if(score.rank == 3) {
                return @"The 3-rd ever!";
            } else {
                CGFloat p = ((CGFloat)(score.rank)) / score.maxRank;
                if(p <= 5) {
                    return @"Top 5%";
                } else {
                    if(p <= 10) {
                        return @"Top 10%";
                    } else {
                        if(p <= 20) {
                            return @"Top 20%";
                        } else {
                            if(p <= 30) {
                                return @"Top 30%";
                            } else {
                                if(p <= 50) return @"Better than average";
                                else return @"Worse than average";
                            }
                        }
                    }
                }
            }
        }
    }
}

- (NSString*)leaderboard {
    return @"The best results";
}

- (NSString*)shareSubject {
    return @"Raildale is a great game for iOS and Mac";
}

- (NSString*)shareTextUrl:(NSString*)url {
    return [NSString stringWithFormat:@"Raildale is an exciting railway building game for iOS and Mac OS X: %@", url];
}

- (NSString*)twitterTextUrl:(NSString*)url {
    return [NSString stringWithFormat:@"%@: @RaildaleGame is an exciting railway building game for iOS and Mac", url];
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
    self = [super initWithLanguage:@"ru"];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _TRRuStrings_type = [ODClassType classTypeWithCls:[TRRuStrings class]];
}

- (NSString*)levelNumber:(NSUInteger)number {
    return [NSString stringWithFormat:@"Уровень %lu", (unsigned long)number];
}

- (NSString*)railBuiltCost:(NSInteger)cost {
    return [NSString stringWithFormat:@"-%@: Плата за постройку железной дороги", [self formatCost:cost]];
}

- (NSString*)trainArrivedTrain:(TRTrain*)train cost:(NSInteger)cost {
    if(train.trainType == TRTrainType.crazy) return [NSString stringWithFormat:@"+%@: Доход от прибытия сумасшедшего поезда", [self formatCost:cost]];
    else return [NSString stringWithFormat:@"+%@: Доход от прибытия поезда в %@ город", [self formatCost:cost], [train.color localName]];
}

- (NSString*)trainDestroyedCost:(NSInteger)cost {
    return [NSString stringWithFormat:@"-%@: Штраф за уничтожение поезда", [self formatCost:cost]];
}

- (NSString*)trainDelayedFineTrain:(TRTrain*)train cost:(NSInteger)cost {
    if(train.trainType == TRTrainType.crazy) return [NSString stringWithFormat:@"-%@: Штраф за задерживающийся сумасшедший поезд", [self formatCost:cost]];
    else return [NSString stringWithFormat:@"-%@: Штраф за задерживающийся %@ поезд", [self formatCost:cost], [train.color localName]];
}

- (NSString*)damageFixedPaymentCost:(NSInteger)cost {
    return [NSString stringWithFormat:@"-%@: Плата за ремонт железной дороги", [self formatCost:cost]];
}

- (NSString*)resumeGame {
    return @"Продолжить игру";
}

- (NSString*)restartLevel:(TRLevel*)level {
    return [NSString stringWithFormat:@"Начать заново уровень %lu", (unsigned long)level.number];
}

- (NSString*)replayLevel:(TRLevel*)level {
    return [NSString stringWithFormat:@"Переиграть уровень %lu", (unsigned long)level.number];
}

- (NSString*)goToNextLevel:(TRLevel*)level {
    return [NSString stringWithFormat:@"Перейти к уровеню %lu", (unsigned long)level.number + 1];
}

- (NSString*)chooseLevel {
    return @"Выбрать уровень";
}

- (NSString*)victory {
    return @"Победа!";
}

- (NSString*)defeat {
    return @"Вы проиграли!";
}

- (NSString*)moneyOver {
    return @"Закончились деньги";
}

- (NSString*)cityBuilt {
    return @"Построен новый город";
}

- (NSString*)tapToContinue {
    if(egPlatform().isComputer) return @"Кликните для продолжения";
    else return @"Нажмите для продолжения";
}

- (NSString*)error {
    return @"Ошибка";
}

- (NSString*)buyButton {
    return @"Купить замедления";
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

- (NSString*)colorPurple {
    return @"cиреневый";
}

- (NSString*)colorGrey {
    return @"серый";
}

- (NSString*)colorBlue {
    return @"синий";
}

- (NSString*)colorMint {
    return @"мятный";
}

- (NSString*)colorRed {
    return @"красный";
}

- (NSString*)colorBeige {
    return @"бежевый";
}

- (NSString*)colorYellow {
    return @"желтый";
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

- (NSString*)helpExpressTrain {
    return @"Это очень быстрый экспресс.\n"
        "Он не успеет остановиться перед стрелкой.\n"
        "Если заблокировать его стрелкой, то он уничтожится.\n"
        "Но можно использовать светофоры.";
}

- (NSString*)helpToMakeZoom {
    return @"Вы можете изменять масштаб с помощью жеста.\n"
        "Для прокрутки используйте два пальца.\n"
        "Для строительства рельсов один.";
}

- (NSString*)helpInZoom {
    return @"Прокручивайте одним пальцем.\n"
        "Чтобы построить рельсы нажмите кнопку с молотком вверху.\n"
        "Нажмите ее еще раз чтобы вернуться в режим прокрутки.";
}

- (NSString*)helpRules {
    return @"Не позволяйте балансу опускаться ниже нуля.\n"
        "Продержитесь с положительным балансом отведенное время\n"
        "и выйграйте уровень.";
}

- (NSString*)helpSporadicDamage {
    return @"Иногда рельсы могут ломаться сами по себе.";
}

- (NSString*)helpDamage {
    return @"Вызовите специальный поезд с помощью кнопки, чтобы починить рельсы.\n"
        "Лучше вызвать из города, который находиться ближе к повреждению.";
}

- (NSString*)helpRepairer {
    return @"Проведите ремонтный поезд через повреждение\n"
        "и отправьте его в любой город.";
}

- (NSString*)helpCrazy {
    return @"Машинист этого поезда сошел с ума.\n"
        "Он не обращает внимания на светофоры или закрытые стрелки.\n"
        "Отправьте этот поезд в любой город.";
}

- (NSString*)linesAdvice {
    return @"Вы можете соединять города несколькими линиями.\n"
        "В таком случае встречные поезда смогут разъехаться.";
}

- (NSString*)helpSlowMotion {
    return @"Используйте замедленное время, чтобы помочь себе в трудных ситуациях.\n"
        "Нажмите кнопку с изображением улитки в правом нижнем углу экрана.\n"
        "Количество использование восстанавливается каждый день.\n"
        "Если вы хотите упростить игру,\n"
        "вы можете купить дополнительные использования\n"
        "или получить их бесплатно поделившись с друзьями\n"
        "через Facebook или Twitter.";
}

- (NSString*)shareButton {
    return @"Поделиться с друзьями";
}

- (NSString*)supportButton {
    return @"Написать разработчику";
}

- (NSString*)supportEmailText {
    return @"Сообщите о проблеме или напишите ваши идеи.\n"
        "Я обязательно вам отвечу и постараюсь исправить возникшие проблемы как можно скорее.\n"
        "Спасибо большое, Антон Жердев, разработчик";
}

- (NSString*)rateText {
    return @"Если вам понравилась игра Raildale, не будете ли вы возражать\n"
        "против того, чтобы уделить время и оценить ее?\n"
        "\n"
        "Если вы столкнулись с проблемой, сообщите мне об этом.\n"
        "Я постараюсь исправить ее как можно скорее.\n"
        "\n"
        "Спасибо вам за поддержку!\n"
        "С наилучшими пожеланиями, Антон Жердев, разработчик";
}

- (NSString*)rateNow {
    return @"Оценить сейчас";
}

- (NSString*)rateProblem {
    return @"Сообщить о проблеме";
}

- (NSString*)rateLater {
    return @"Напомнить позже";
}

- (NSString*)rateClose {
    return @"Нет, спасибо";
}

- (NSString*)result {
    return @"Счет";
}

- (NSString*)best {
    return @"Ваш лучший";
}

- (NSString*)topScore:(EGLocalPlayerScore*)score {
    if(score.rank == 1) {
        return @"1-й!";
    } else {
        if(score.rank == 2) {
            return @"2-й!";
        } else {
            if(score.rank == 3) {
                return @"3-й!";
            } else {
                CGFloat p = ((CGFloat)(score.rank)) / score.maxRank;
                if(p <= 5) {
                    return @"Лучшие 5%";
                } else {
                    if(p <= 10) {
                        return @"Лучшие 10%";
                    } else {
                        if(p <= 20) {
                            return @"Лучшие 20%";
                        } else {
                            if(p <= 30) {
                                return @"Лучшие 30%";
                            } else {
                                if(p <= 50) return @"Выше среднего";
                                else return @"Ниже среднего";
                            }
                        }
                    }
                }
            }
        }
    }
}

- (NSString*)leaderboard {
    return @"Лучшие результаты";
}

- (NSString*)shareSubject {
    return @"Raildale - отличная игра для iOS и Mac";
}

- (NSString*)shareTextUrl:(NSString*)url {
    return [NSString stringWithFormat:@"Raildale - великолепная игра о строительстве железной дороги для iOS и Mac OS X: %@", url];
}

- (NSString*)twitterTextUrl:(NSString*)url {
    return [NSString stringWithFormat:@"%@: @RaildaleGame - великолепная игра о железной дороге для iOS и Mac", url];
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


@implementation TRJpStrings
static ODClassType* _TRJpStrings_type;

+ (id)jpStrings {
    return [[TRJpStrings alloc] init];
}

- (id)init {
    self = [super initWithLanguage:@"ja"];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _TRJpStrings_type = [ODClassType classTypeWithCls:[TRJpStrings class]];
}

- (NSString*)levelNumber:(NSUInteger)number {
    return [NSString stringWithFormat:@"レベル%lu", (unsigned long)number];
}

- (NSString*)railBuiltCost:(NSInteger)cost {
    return [NSString stringWithFormat:@"-%@: 鉄道建設の支払い", [self formatCost:cost]];
}

- (NSString*)trainArrivedTrain:(TRTrain*)train cost:(NSInteger)cost {
    return [NSString stringWithFormat:@"+%@: に対する到着列車報酬", [self formatCost:cost]];
}

- (NSString*)trainDestroyedCost:(NSInteger)cost {
    return [NSString stringWithFormat:@"-%@: 列車破壊に対する罰金", [self formatCost:cost]];
}

- (NSString*)trainDelayedFineTrain:(TRTrain*)train cost:(NSInteger)cost {
    return [NSString stringWithFormat:@"-%@: 列車遅延に対する罰金", [self formatCost:cost]];
}

- (NSString*)damageFixedPaymentCost:(NSInteger)cost {
    return [NSString stringWithFormat:@"-%@: 鉄道修理の支払い", [self formatCost:cost]];
}

- (NSString*)resumeGame {
    return @"ゲームを続ける";
}

- (NSString*)restartLevel:(TRLevel*)level {
    return [NSString stringWithFormat:@"レベル%luをやり直す", (unsigned long)level.number];
}

- (NSString*)replayLevel:(TRLevel*)level {
    return [NSString stringWithFormat:@"レベル%luをもう一度プレイ", (unsigned long)level.number];
}

- (NSString*)goToNextLevel:(TRLevel*)level {
    return @"次のレベルをプレイ";
}

- (NSString*)chooseLevel {
    return @"レベルを選んでください";
}

- (NSString*)victory {
    return @"勝利!";
}

- (NSString*)defeat {
    return @"敗北!";
}

- (NSString*)moneyOver {
    return @"資金切れです";
}

- (NSString*)cityBuilt {
    return @"新しい都市ができました";
}

- (NSString*)tapToContinue {
    if(egPlatform().isComputer) return @"クリックして続行";
    else return @"タップして続行";
}

- (NSString*)error {
    return @"エラー";
}

- (NSString*)buyButton {
    return @"スローモーションを購入";
}

- (NSString*)shareButton {
    return @"友達と共有";
}

- (NSString*)supportButton {
    return @"開発者にメール";
}

- (NSString*)rateText {
    return @"Raildaleをお楽しみいただけていれば、\n"
        "評価を残していただけませんか？1分以内に評価できます。\n"
        "\n"
        "問題があれば、ご報告ください。\n"
        "できるだけ早く修正できるよう努めます。\n"
        "\n"
        "サポートをありがとうございます！\n"
        "開発者Anton Zherdevより";
}

- (NSString*)rateNow {
    return @"今すぐ評価";
}

- (NSString*)rateProblem {
    return @"問題を報告";
}

- (NSString*)rateLater {
    return @"後で表示";
}

- (NSString*)rateClose {
    return @"後で表示";
}

- (NSString*)helpConnectTwoCities {
    return [NSString stringWithFormat:@"2つの都市を線路で結びましょう。\n"
        "%@", ((egPlatform().touch) ? @"指を使って簡単にレールを敷きます。" : @"マウスを使うかタッチパッドで2本の指を使います。")];
}

- (NSString*)helpRules {
    return @"残額を赤字にしないようにしましょう。\n"
        "規定時間黒字を保てればレベルクリアです。";
}

- (NSString*)helpNewCity {
    return @"時々新しい都市が登場します。\n"
        "自分の鉄道とつなげましょう。";
}

- (NSString*)helpTrainTo:(NSString*)to {
    return @"列車の方向は色でわかります。";
}

- (NSString*)helpTrainWithSwitchesTo:(NSString*)to {
    if(egPlatform().touch) return @"鉄道スイッチをタップで切り替えて、列車を目的地に到着させましょう。";
    else return @"鉄道スイッチをクリック切り替えて、列車を目的地に到着させましょう。";
}

- (NSString*)helpExpressTrain {
    return @"これはとても速い急行列車です。\n"
        "スイッチの前で止まる時間がありません。\n"
        "この場合列車は破壊されます。\n"
        "でも信号機を使って列車を制御できます。";
}

- (NSString*)helpToMakeZoom {
    return @"つまみジェスチャーで拡大・縮小できます。";
}

- (NSString*)helpInZoom {
    return @"指でスクロールします。\n"
        "画面上部のハンマーボタンでレールを敷きます。\n"
        "もう一度押すとスクロールモードに戻ります。";
}

- (NSString*)helpSporadicDamage {
    return @"時々線路が壊れてしまいます。";
}

- (NSString*)helpDamage {
    return @"ボタンのひとつを使って整備列車を呼んで破損部分を修理しましょう。\n"
        "最寄りの都市から列車を呼ぶほうが賢明です。";
}

- (NSString*)helpCrazy {
    return @"列車の運転手がおかしいです。\n"
        "信号や閉鎖スイッチを無視しています。\n"
        "この列車をどこかの都市に送ってください。";
}

- (NSString*)helpRepairer {
    return @"破損部分に整備列車を走らせ、どこかの都市に送ってください。";
}

- (NSString*)helpSlowMotion {
    return @"スローモーションを使って難しい瞬間を切り抜けましょう。\n"
        "画面右上角のカタツムリのボタンを押してください。\n"
        "使用回数は毎日少しずつ回復します。\n"
        "ゲームを簡単にしたい場合は追加スローモーションを購入するか、\n"
        "このゲームをFacebookやTwitterで共有して手に入れられます。\n"
        "でもそうしなくてもクリアはできます。";
}

- (NSString*)linesAdvice {
    return @"複数路線で都市をつなげることもできます。\n"
        "そうすれば反対方向の電車が衝突することがありません。";
}

- (NSString*)result {
    return @"スコア";
}

- (NSString*)best {
    return @"あなたの最高の";
}

- (NSString*)topScore:(EGLocalPlayerScore*)score {
    if(score.rank == 1) {
        return @"第1位！";
    } else {
        if(score.rank == 2) {
            return @"第2位！";
        } else {
            if(score.rank == 3) {
                return @"第3位！";
            } else {
                CGFloat p = ((CGFloat)(score.rank)) / score.maxRank;
                if(p <= 5) {
                    return @"トップ5%";
                } else {
                    if(p <= 10) {
                        return @"トップ10%";
                    } else {
                        if(p <= 20) {
                            return @"トップ20%";
                        } else {
                            if(p <= 30) {
                                return @"トップ30%";
                            } else {
                                if(p <= 50) return @"平均以上";
                                else return @"平均以下";
                            }
                        }
                    }
                }
            }
        }
    }
}

- (NSString*)leaderboard {
    return @"最高結果";
}

- (NSString*)shareSubject {
    return @"RaildaleはiOSやMacに最適のゲームです";
}

- (NSString*)shareTextUrl:(NSString*)url {
    return [NSString stringWithFormat:@"iOSやMac OS X用のRaildaleは興奮の鉄道建築ゲームです: %@", url];
}

- (NSString*)twitterTextUrl:(NSString*)url {
    return [NSString stringWithFormat:@"%@: iOSやMac OS X用の @RaildaleGame は興奮の鉄道建築ゲームです", url];
}

- (ODClassType*)type {
    return [TRJpStrings type];
}

+ (ODClassType*)type {
    return _TRJpStrings_type;
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


@implementation TRKoStrings
static ODClassType* _TRKoStrings_type;

+ (id)koStrings {
    return [[TRKoStrings alloc] init];
}

- (id)init {
    self = [super initWithLanguage:@"ko"];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _TRKoStrings_type = [ODClassType classTypeWithCls:[TRKoStrings class]];
}

- (NSString*)levelNumber:(NSUInteger)number {
    return [NSString stringWithFormat:@"레벨 %lu", (unsigned long)number];
}

- (NSString*)railBuiltCost:(NSInteger)cost {
    return [NSString stringWithFormat:@"-%@: 철도 건물에 대한 지불", [self formatCost:cost]];
}

- (NSString*)trainArrivedTrain:(TRTrain*)train cost:(NSInteger)cost {
    return [NSString stringWithFormat:@"+%@: 도착한 기차에 대한 보상", [self formatCost:cost]];
}

- (NSString*)trainDestroyedCost:(NSInteger)cost {
    return [NSString stringWithFormat:@"-%@: 파괴된 열차에 대한 벌금", [self formatCost:cost]];
}

- (NSString*)trainDelayedFineTrain:(TRTrain*)train cost:(NSInteger)cost {
    return [NSString stringWithFormat:@"-%@: 지연된 열차에 대한 벌금", [self formatCost:cost]];
}

- (NSString*)damageFixedPaymentCost:(NSInteger)cost {
    return [NSString stringWithFormat:@"-%@: 철도 수리 지불", [self formatCost:cost]];
}

- (NSString*)resumeGame {
    return @"게임 계속";
}

- (NSString*)restartLevel:(TRLevel*)level {
    return [NSString stringWithFormat:@"레벨 %lu 다시 시작", (unsigned long)level.number];
}

- (NSString*)replayLevel:(TRLevel*)level {
    return [NSString stringWithFormat:@"다시 레벨 %lu 플레이", (unsigned long)level.number];
}

- (NSString*)goToNextLevel:(TRLevel*)level {
    return @"다음 레벨 플레이";
}

- (NSString*)chooseLevel {
    return @"레벨 선택";
}

- (NSString*)victory {
    return @"승리!";
}

- (NSString*)defeat {
    return @"패배!";
}

- (NSString*)moneyOver {
    return @"돈이 없음";
}

- (NSString*)cityBuilt {
    return @"새로운 도시가 건설됨";
}

- (NSString*)tapToContinue {
    if(egPlatform().isComputer) return @"클릭하여 계속";
    else return @"눌러서 계속";
}

- (NSString*)error {
    return @"오류";
}

- (NSString*)buyButton {
    return @"슬로우 모션 구매";
}

- (NSString*)shareButton {
    return @"친구와 공유";
}

- (NSString*)supportButton {
    return @"개발자에게 이메일 전송";
}

- (NSString*)rateText {
    return @"Raildale 플레이를 즐겨 하는 경우, 잠시 시간을 내주시어 평가해 주시겠습니까?\n"
        "몇 분 걸리지 않습니다.\n"
        "\n"
        "문제에 직면한 경우, 우리에게 알려 주십시오.\n"
        "가능한 한 빨리 문제를 해결하기 위해 노력할 것입니다.\n"
        "\n"
        "\n"
        "지원해 주셔서 감사합니다!\n"
        "안부를 전하며, Anton Zherdev, 개발자";
}

- (NSString*)rateNow {
    return @"지금 평가하기";
}

- (NSString*)rateProblem {
    return @"문제 보고";
}

- (NSString*)rateLater {
    return @"나중에 다시 알림";
}

- (NSString*)rateClose {
    return @"아니요, 감사합니다";
}

- (NSString*)helpConnectTwoCities {
    return [NSString stringWithFormat:@"철도로 두 도시를 연결합니다.\n"
        "%@", ((egPlatform().touch) ? @"단순히 당신의 손가락을 사용하여 선로를 그립니다." : @"마우스를 사용하여 터치 패드에서 두 손가락을 움직입니다.")];
}

- (NSString*)helpRules {
    return @"계정 잔액이 0보다 낮게 떨어지지 않도록 합니다.\n"
        "레벨을 이기려면 주어진 시간에 긍정적인 밸런스를 유지합니다.";
}

- (NSString*)helpNewCity {
    return @"때때로 새로운 도시가 나타납니다.\n"
        "당신의 선로로 이를 연결합니다.";
}

- (NSString*)helpTrainTo:(NSString*)to {
    return @"당신은 색상에 의해 열차의 방향을 인식할 수 있습니다.";
}

- (NSString*)helpTrainWithSwitchesTo:(NSString*)to {
    return @"탭/클릭을 사용하여 철도의 스위치를 켤 수 있으므로, 기차가 목적지에 도착할 수 있습니다.";
}

- (NSString*)helpExpressTrain {
    return @"이는 매우 빠른 급행열차 입니다.\n"
        "스위치 앞에 멈출 시간이 없습니다.\n"
        "이 경우 열차는 파괴될 것입니다.\n"
        "하지만 당신은 기차를 안내하기 위해 조명을 사용할 수 있습니다.";
}

- (NSString*)helpToMakeZoom {
    return @"당신은 핀치 제스처를 사용하여 스케일을 변경할 수 있습니다.";
}

- (NSString*)helpInZoom {
    return @"스크롤하려면 손가락을 사용합니다.\n"
        "선로를 구축하기 위하여 상단에 망치 버튼을 누릅니다.\n"
        "다시 누르면 스크롤 모드로 돌아올 수 있습니다.";
}

- (NSString*)helpSporadicDamage {
    return @"가끔 선로가 고장날 수 있습니다.";
}

- (NSString*)helpDamage {
    return @"손상을 복구하려면 버튼 중 하나를 사용하여 서비스 기차를 호출합니다.\n"
        "손상된 곳에서 가장 가까운 도시에서의 기차를 호출하는 것이 좋습니다.";
}

- (NSString*)helpCrazy {
    return @"열차의 엔지니어는 미쳤습니다.\n"
        "그는 조명 또는 폐쇄 스위치에 관심갖지 않았습니다.\n"
        "이 열차를 다른 도시로 보냅니다.";
}

- (NSString*)helpRepairer {
    return @"손상으로 인해 서비스 기차를 운전하고 다른 도시로 이를 보냅니다.";
}

- (NSString*)helpSlowMotion {
    return @"어려운 순간에 자신을 돕기 위해 슬로우 모션을 사용합니다.\n"
        "화면의 오른쪽 상단 모서리에 있는 달팽이 버튼을 누릅니다.\n"
        "작은 숫자의 사용은 매일 복원됩니다.\n"
        "당신이 게임을 쉽게 하려면, 슬로우 모션을 추가 구매하거나\n"
        "Facebook 또는 Twitter에서 무료로 게임을 공유할 수 있습니다.\n"
        "하지만 없이 관리할 수 있습니다.";
}

- (NSString*)linesAdvice {
    return @"한 라인 이상을 사용하여 도시 간을 연결할 수 있습니다.\n"
        "따라서, 반대 방향에서 오는 두 열차는 서로 충돌하지 않을 것입니다.";
}

- (NSString*)result {
    return @"점수";
}

- (NSString*)best {
    return @"당신의 최고";
}

- (NSString*)topScore:(EGLocalPlayerScore*)score {
    if(score.rank == 1) {
        return @"1위!";
    } else {
        if(score.rank == 2) {
            return @"2위!";
        } else {
            if(score.rank == 3) {
                return @"3위!";
            } else {
                CGFloat p = ((CGFloat)(score.rank)) / score.maxRank;
                if(p <= 5) {
                    return @"상위 5%";
                } else {
                    if(p <= 10) {
                        return @"상위 10%";
                    } else {
                        if(p <= 20) {
                            return @"상위 20%";
                        } else {
                            if(p <= 30) {
                                return @"상위 30%";
                            } else {
                                if(p <= 50) return @"평균 이상";
                                else return @"평균 이하";
                            }
                        }
                    }
                }
            }
        }
    }
}

- (NSString*)leaderboard {
    return @"최고 결과";
}

- (NSString*)shareSubject {
    return @"Raildale은 iOS 및 Mac용 훌륭한 게임입니다.";
}

- (NSString*)shareTextUrl:(NSString*)url {
    return [NSString stringWithFormat:@"Raildale은 iOS 및 Mac OS X용 흥미로운 선로 구축 게임입니다: %@", url];
}

- (NSString*)twitterTextUrl:(NSString*)url {
    return [NSString stringWithFormat:@"%@: @RaildaleGame은 iOS 및 Mac OS X용 흥미로운 선로 구축 게임입니다.", url];
}

- (ODClassType*)type {
    return [TRKoStrings type];
}

+ (ODClassType*)type {
    return _TRKoStrings_type;
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


@implementation TRChinaStrings
static ODClassType* _TRChinaStrings_type;

+ (id)chinaStrings {
    return [[TRChinaStrings alloc] init];
}

- (id)init {
    self = [super initWithLanguage:@"zh"];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _TRChinaStrings_type = [ODClassType classTypeWithCls:[TRChinaStrings class]];
}

- (NSString*)levelNumber:(NSUInteger)number {
    return [NSString stringWithFormat:@"%lu级", (unsigned long)number];
}

- (NSString*)railBuiltCost:(NSInteger)cost {
    return [NSString stringWithFormat:@"-%@: 铁路建设费用", [self formatCost:cost]];
}

- (NSString*)trainArrivedTrain:(TRTrain*)train cost:(NSInteger)cost {
    return [NSString stringWithFormat:@"+%@: 列车到达奖励", [self formatCost:cost]];
}

- (NSString*)trainDestroyedCost:(NSInteger)cost {
    return [NSString stringWithFormat:@"-%@: 损毁列车罚款", [self formatCost:cost]];
}

- (NSString*)trainDelayedFineTrain:(TRTrain*)train cost:(NSInteger)cost {
    return [NSString stringWithFormat:@"-%@: 列车延误罚款", [self formatCost:cost]];
}

- (NSString*)damageFixedPaymentCost:(NSInteger)cost {
    return [NSString stringWithFormat:@"-%@: 铁路维修费用", [self formatCost:cost]];
}

- (NSString*)resumeGame {
    return @"继续游戏";
}

- (NSString*)restartLevel:(TRLevel*)level {
    return [NSString stringWithFormat:@"重新挑战第%lu关", (unsigned long)level.number];
}

- (NSString*)replayLevel:(TRLevel*)level {
    return [NSString stringWithFormat:@"再次挑战第%lu关", (unsigned long)level.number];
}

- (NSString*)goToNextLevel:(TRLevel*)level {
    return @"挑战下一关";
}

- (NSString*)chooseLevel {
    return @"选择关卡";
}

- (NSString*)victory {
    return @"胜利！";
}

- (NSString*)defeat {
    return @"失败！";
}

- (NSString*)moneyOver {
    return @"没资金了";
}

- (NSString*)cityBuilt {
    return @"新城市已建成";
}

- (NSString*)tapToContinue {
    if(egPlatform().isComputer) return @"点击继续";
    else return @"点击继续";
}

- (NSString*)error {
    return @"错误";
}

- (NSString*)buyButton {
    return @"买慢动作";
}

- (NSString*)shareButton {
    return @"与朋友分享";
}

- (NSString*)supportButton {
    return @"给开发者发送电子邮件";
}

- (NSString*)rateText {
    return @"如果你喜欢玩铁路传奇（Raildale），别忘了给它打分哦！\n"
        "这用不了一分钟。\n"
        "\n"
        "如果您遇到问题，可以汇报给我。\n"
        "我会尽快将其修复。\n"
        "\n"
        "谢谢您的支持!\n"
        "此致, Anton Zherdev, 开发者";
}

- (NSString*)rateNow {
    return @"现在就为它打分";
}

- (NSString*)rateProblem {
    return @"报告一个问题";
}

- (NSString*)rateLater {
    return @"稍后再提醒我";
}

- (NSString*)rateClose {
    return @"不，谢谢。";
}

- (NSString*)helpConnectTwoCities {
    return [NSString stringWithFormat:@"用铁轨连接两个城市。\n"
        "%@", ((egPlatform().touch) ? @"用手指即可绘出铁轨。" : @"使用鼠标或在触摸板上用两个手指操作。")];
}

- (NSString*)helpRules {
    return @"不要让收支为负数。\n"
        "在指定时间内使收支为正以赢取关卡。";
}

- (NSString*)helpNewCity {
    return @"有时会有新的城市出现。\n"
        "将它们和你的铁路相连。";
}

- (NSString*)helpTrainTo:(NSString*)to {
    return @"你可以通过颜色识别列车的方向。";
}

- (NSString*)helpTrainWithSwitchesTo:(NSString*)to {
    return @"轻点即可改变铁路的道岔位置从而使列车抵达指定城市。";
}

- (NSString*)helpExpressTrain {
    return @"这是高速的特快列车。\n"
        "它没时间在道岔前停留。\n"
        "如果那样列车会撞毁。\n"
        "但你可以通过信号灯来控制它。";
}

- (NSString*)helpToMakeZoom {
    return @"您可以使用缩放手势改变比例。";
}

- (NSString*)helpInZoom {
    return @"用手指来滚动。\n"
        "点击顶端的锤子来建造铁轨。\n"
        "再按一次可回到滚动模式。";
}

- (NSString*)helpSporadicDamage {
    return @"有时铁轨会损坏。";
}

- (NSString*)helpDamage {
    return @"呼叫服务列车，使用下列按钮之一来修复故障。\n"
        "最好从故障发生最近的城市呼叫服务列车。";
}

- (NSString*)helpCrazy {
    return @"这辆车的工程师疯了。\n"
        "他对信号灯和合上的道岔毫不在乎。\n"
        "把该车送往任何城市。";
}

- (NSString*)helpRepairer {
    return @"将服务车辆驶过故障区域，再将其送往任何城市。";
}

- (NSString*)helpSlowMotion {
    return @"使用慢动作来克服困难的时刻。\n"
        "只需按下屏幕顶部右上角的蜗牛按钮。\n"
        "每天少量的使用都可修复。\n"
        "如果您想简化游戏，\n"
        "您可以购买额外的慢动作或通过在\n"
        "Facebook 或 Twitter 上分享游戏来免费获得。\n"
        "不过没有慢动作也可以正常游戏。";
}

- (NSString*)linesAdvice {
    return @"您能用超过一条的线路连接城市。\n"
        "这样两辆相向行驶的列车就不会相撞了。";
}

- (NSString*)result {
    return @"分数";
}

- (NSString*)best {
    return @"您的最佳成绩";
}

- (NSString*)topScore:(EGLocalPlayerScore*)score {
    if(score.rank == 1) {
        return @"第一名!";
    } else {
        if(score.rank == 2) {
            return @"第二名!";
        } else {
            if(score.rank == 3) {
                return @"第三名!";
            } else {
                CGFloat p = ((CGFloat)(score.rank)) / score.maxRank;
                if(p <= 5) {
                    return @"前5%";
                } else {
                    if(p <= 10) {
                        return @"前10%";
                    } else {
                        if(p <= 20) {
                            return @"前20%";
                        } else {
                            if(p <= 30) {
                                return @"前30%";
                            } else {
                                if(p <= 50) return @"高于平均水平";
                                else return @"低于平均水平";
                            }
                        }
                    }
                }
            }
        }
    }
}

- (NSString*)leaderboard {
    return @"最好成绩";
}

- (NSString*)shareSubject {
    return @"铁路传奇（Raildale）是iOS 和 Mac 平台上的绝佳游戏。";
}

- (NSString*)shareTextUrl:(NSString*)url {
    return [NSString stringWithFormat:@"铁路传奇（Raildale）是iOS 和 Mac OS X 平台上的令人兴奋的铁路建设游戏。 %@", url];
}

- (NSString*)twitterTextUrl:(NSString*)url {
    return [NSString stringWithFormat:@"%@: 铁路传奇（@RaildaleGame）是iOS 和 Mac OS X 平台上的令人兴奋的铁路建设游戏。", url];
}

- (ODClassType*)type {
    return [TRChinaStrings type];
}

+ (ODClassType*)type {
    return _TRChinaStrings_type;
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


