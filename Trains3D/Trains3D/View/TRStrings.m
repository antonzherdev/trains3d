#import "TRStrings.h"

#import "TRTrain.h"
#import "TRLevel.h"
#import "EGGameCenter.h"
#import "TRCity.h"
#import "GL.h"
#import "EGPlatform.h"
@implementation TRStr
static TRStrings* _TRStr_Loc;
static ODClassType* _TRStr_type;

+ (void)initialize {
    [super initialize];
    _TRStr_type = [ODClassType classTypeWithCls:[TRStr class]];
    _TRStr_Loc = ^TRStrings*() {
        id<CNMap> locales = [[[(@[[TREnStrings enStrings], [TRRuStrings ruStrings], [TRJpStrings jpStrings]]) chain] map:^CNTuple*(TREnStrings* strs) {
            return tuple(((TREnStrings*)(strs)).language, strs);
        }] toMap];
        return [[[[[OSLocale preferredLanguages] chain] flatMap:^id(NSString* lng) {
            return [locales optKey:lng];
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

- (NSString*)buyButton {
    @throw @"Method buyButton is abstract";
}

- (NSString*)supportButton {
    @throw @"Method supportButton is abstract";
}

- (NSString*)shareButton {
    @throw @"Method shareButton is abstract";
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

- (NSString*)leaderboard {
    @throw @"Method leaderboard is abstract";
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
    else return [NSString stringWithFormat:@"+%@: Reward for the arrived %@ train", [self formatCost:cost], train.color.localName];
}

- (NSString*)trainDestroyedCost:(NSInteger)cost {
    return [NSString stringWithFormat:@"-%@: Fine for the destroyed train", [self formatCost:cost]];
}

- (NSString*)trainDelayedFineTrain:(TRTrain*)train cost:(NSInteger)cost {
    if(train.trainType == TRTrainType.crazy) return [NSString stringWithFormat:@"-%@: Fine for the delayed crazy train", [self formatCost:cost]];
    else return [NSString stringWithFormat:@"-%@: Fine for the delayed %@ train", [self formatCost:cost], train.color.localName];
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
    return @"Best results";
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
    else return [NSString stringWithFormat:@"+%@: Доход от прибытия поезда в %@ город", [self formatCost:cost], train.color.localName];
}

- (NSString*)trainDestroyedCost:(NSInteger)cost {
    return [NSString stringWithFormat:@"-%@: Штраф за уничтожение поезда", [self formatCost:cost]];
}

- (NSString*)trainDelayedFineTrain:(TRTrain*)train cost:(NSInteger)cost {
    if(train.trainType == TRTrainType.crazy) return [NSString stringWithFormat:@"-%@: Штраф за задерживающийся сумасшедший поезд", [self formatCost:cost]];
    else return [NSString stringWithFormat:@"-%@: Штраф за задерживающийся %@ поезд", [self formatCost:cost], train.color.localName];
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
        "評価を残していただけませんか？\n"
        "1分以内に評価できます。\n"
        "問題があれば、ご報告ください。\n"
        "できるだけ早く修正できるよう努めます。\n"
        "\n"
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


