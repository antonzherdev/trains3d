#import "TRStrings.h"

#import "TRTrain.h"
#import "TRLevel.h"
#import "EGGameCenter.h"
#import "TRCity.h"
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

- (NSString*)callRepairer {
    return @"Call the\n"
        "service train";
}

- (NSString*)undo {
    return @"Undo";
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
    if(egInterfaceIdiom() == EGInterfaceIdiom.computer) return @"Click to contiunue";
    else return @"Tap to continue";
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

- (NSString*)shareButton {
    return @"Share with friends";
}

- (NSString*)supportButton {
    return @"Email the developer";
}

- (NSString*)supportEmailText {
    return @"Report a problem or tell me about your ideas.\n"
        "I will definetely reply to you and try to fix problems as soon as posible.\n"
        "Thank you very much, Anton Zhedev, Developer";
}

- (NSString*)rateText {
    return @"If you enjoy playing Raildale, would you mind taking\n"
        "a moment to rate it? It won’t take more than a minute.\n"
        "\n"
        "If you are faced with a problem, please, report it to me.\n"
        "I will try to fix it as soon as possible.\n"
        "\n"
        "Thanks for your support!\n"
        "Best Regards, Anton Zherdev, Developer";
}

- (NSString*)rateSignature {
    return @"Anton Zherdev, Developer";
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
        "Hang in the allotted time with a positive balance and win a level.";
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
        "Press the snail button at the right top corner of the screen.\n"
        "A few number of uses is restored every day.\n"
        "You can buy the additional slow motions\n"
        "or get them for free sharing the game on Facebook or Twitter.";
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

- (NSString*)linesAdvice {
    return @"You can connect cities using more than one line.\n"
        "Thus two trains coming from the opposite direction\n"
        "would not collide with each other.";
}

- (NSString*)shareSubject {
    return @"Raildale is a great game for iOS and Mac";
}

- (NSString*)shareTextUrl:(NSString*)url {
    return [NSString stringWithFormat:@"Raildale is an exciting railway building game for iOS and Mac OS X: %@", url];
}

- (NSString*)twitterTextUrl:(NSString*)url {
    return [NSString stringWithFormat:@"@RaildaleGame is an exciting railway building  game for iOS and Mac OS X: %@", url];
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

- (NSString*)startLevelNumber:(NSUInteger)number {
    return [self levelNumber:number];
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

- (NSString*)callRepairer {
    return @"Вызвать\n"
        "ремонтников";
}

- (NSString*)undo {
    return @"Отменить";
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
    if(egInterfaceIdiom() == EGInterfaceIdiom.computer) return @"Кликните для продолжения";
    else return @"Нажмите для продолжения";
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
        "Вы можете купить дополнительные использования\n"
        "или получить их бесплатно поделившись с друзьями через Facebook или Twitter";
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
        "Спасибо большое, Антон Жердев, Разработчик";
}

- (NSString*)rateText {
    return @"Если вам понравилась игра Raildale, не будете ли вы возражать\n"
        "против того, чтобы уделить время и оценить ее?\n"
        "\n"
        "Если вы столкнулись с проблемой, сообщите мне об этом.\n"
        "Я постараюсь исправить ее как можно скорее.\n"
        "\n"
        "Спасибо вам за поддержку!\n"
        "С наилучшими пожеланиями, Антон Жердев, Разработчик";
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
    return [NSString stringWithFormat:@"@RaildaleGame - великолепная игра о строительстве железной дороги для iOS и Mac OS X: %@", url];
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

- (NSString*)startLevelNumber:(NSUInteger)number {
    return [self levelNumber:number];
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


