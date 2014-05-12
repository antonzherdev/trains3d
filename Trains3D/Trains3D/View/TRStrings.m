#import "TRStrings.h"

#import "TRLevel.h"
#import "TRTrain.h"
#import "TRCity.h"
#import "TRCar.h"
#import "EGGameCenter.h"
#import "EGPlatformPlat.h"
#import "EGPlatform.h"
@implementation TRStr
static TRStrings* _TRStr_Loc;
static ODClassType* _TRStr_type;

+ (void)initialize {
    [super initialize];
    if(self == [TRStr class]) {
        _TRStr_type = [ODClassType classTypeWithCls:[TRStr class]];
        _TRStr_Loc = ({
            id<CNImMap> locales = [[[(@[((TRStrings*)([TREnStrings enStrings])), ((TRStrings*)([TRRuStrings ruStrings])), ((TRStrings*)([TRJpStrings jpStrings])), ((TRStrings*)([TRKoStrings koStrings])), ((TRStrings*)([TRChinaStrings chinaStrings])), ((TRStrings*)([TRPtStrings ptStrings])), ((TRStrings*)([TRItStrings itStrings])), ((TRStrings*)([TRSpStrings spStrings])), ((TRStrings*)([TRGeStrings geStrings])), ((TRStrings*)([TRFrStrings frStrings]))]) chain] map:^CNTuple*(TRStrings* strs) {
                return tuple(((TRStrings*)(strs)).language, strs);
            }] toMap];
            ({
                TRStrings* __tmp_1 = [[[[OSLocale preferredLanguages] chain] mapOpt:^TRStrings*(NSString* lng) {
                    return [locales optKey:[lng substrBegin:0 end:2]];
                }] head];
                ((__tmp_1 != nil) ? ((TRStrings*)(__tmp_1)) : [TREnStrings enStrings]);
            });
        });
    }
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

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendString:@">"];
    return description;
}

@end


@implementation TRStrings
static TRLevel* _TRStrings_fakeLevel;
static TRTrain* _TRStrings_fakeTrain;
static TRTrain* _TRStrings_fakeCrazyTrain;
static ODClassType* _TRStrings_type;
@synthesize language = _language;

+ (instancetype)stringsWithLanguage:(NSString*)language {
    return [[TRStrings alloc] initWithLanguage:language];
}

- (instancetype)initWithLanguage:(NSString*)language {
    self = [super init];
    if(self) _language = language;
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [TRStrings class]) {
        _TRStrings_type = [ODClassType classTypeWithCls:[TRStrings class]];
        _TRStrings_fakeLevel = [TRLevel levelWithNumber:0 rules:[TRLevelRules aDefault]];
        _TRStrings_fakeTrain = [TRTrain trainWithLevel:_TRStrings_fakeLevel trainType:TRTrainType.simple color:TRCityColor.orange carTypes:(@[TRCarType.engine]) speed:10];
        _TRStrings_fakeCrazyTrain = [TRTrain trainWithLevel:_TRStrings_fakeLevel trainType:TRTrainType.crazy color:TRCityColor.grey carTypes:(@[TRCarType.engine]) speed:10];
    }
}

- (NSString*)formatCost:(NSInteger)cost {
    __block NSInteger i = 0;
    unichar a = unums(nonnil([@"'" head]));
    NSString* str = [[[[[[NSString stringWithFormat:@"%ld", (long)cost] chain] reverse] flatMap:^id<CNImSeq>(id s) {
        i++;
        if(i == 3) return ((id<CNImSeq>)([CNImList applyItem:s tail:[CNImList applyItem:nums(a)]]));
        else return ((id<CNImSeq>)((@[s])));
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

- (NSString*)railRemovedCost:(NSInteger)cost {
    return [NSString stringWithFormat:@"-%@: Payment for takedown of the railway", [self formatCost:cost]];
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
    return [[[[[[[[[[[[[@"0123456789" stringByAppendingString:[self resumeGame]] stringByAppendingString:[self restartLevel:1]] stringByAppendingString:[self replayLevel:1]] stringByAppendingString:[self goToNextLevel:1]] stringByAppendingString:[self chooseLevel]] stringByAppendingString:[self supportButton]] stringByAppendingString:[self shareButton]] stringByAppendingString:[self leaderboard]] stringByAppendingString:[self buyButton]] stringByAppendingString:[self rateNow]] stringByAppendingString:[self rateLater]] stringByAppendingString:[self rateClose]] stringByAppendingString:[self rateProblem]];
}

- (NSString*)resumeGame {
    @throw @"Method resumeGame is abstract";
}

- (NSString*)restartLevel:(NSUInteger)level {
    @throw @"Method restart is abstract";
}

- (NSString*)replayLevel:(NSUInteger)level {
    @throw @"Method replay is abstract";
}

- (NSString*)goToNextLevel:(NSUInteger)level {
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

- (NSString*)rewind {
    return @"Rewind";
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

- (NSString*)helpToRemove {
    return @"To remove a superfluous railway\n"
        "press the bulldozer button in the bottom left-hand corner\n"
        "and press on the area with unnecessary rails";
}

- (NSString*)linesAdvice {
    @throw @"Method linesAdvice is abstract";
}

- (NSString*)helpRewind {
    return @"";
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

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"language=%@", self.language];
    [description appendString:@">"];
    return description;
}

@end


@implementation TREnStrings
static ODClassType* _TREnStrings_type;

+ (instancetype)enStrings {
    return [[TREnStrings alloc] init];
}

- (instancetype)init {
    self = [super initWithLanguage:@"en"];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [TREnStrings class]) _TREnStrings_type = [ODClassType classTypeWithCls:[TREnStrings class]];
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

- (NSString*)restartLevel:(NSUInteger)level {
    return [NSString stringWithFormat:@"Restart the level %lu", (unsigned long)level];
}

- (NSString*)replayLevel:(NSUInteger)level {
    return [NSString stringWithFormat:@"Play level %lu again", (unsigned long)level];
}

- (NSString*)goToNextLevel:(NSUInteger)level {
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

- (NSString*)rewind {
    return @"Rewind";
}

- (NSString*)buyButton {
    return @"Buy rewinds";
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
    return [NSString stringWithFormat:@"Turn railroad switches using a%@,\n"
        "so the train will arrive at the %@ city.\n"
        "If train can’t go further, it’ll move back.", ((egPlatform().touch) ? @" tap" : @" click"), to];
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

- (NSString*)helpRewind {
    return @"Use the rewind to go back to a few moments ago.\n"
        "Press the rewind button in the top right-hand corner of the screen.\n"
        "A small number of uses are restored every day.\n"
        "If you want to make the game easier,\n"
        "you can buy additional rewinds\n"
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

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendString:@">"];
    return description;
}

@end


@implementation TRRuStrings
static ODClassType* _TRRuStrings_type;

+ (instancetype)ruStrings {
    return [[TRRuStrings alloc] init];
}

- (instancetype)init {
    self = [super initWithLanguage:@"ru"];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [TRRuStrings class]) _TRRuStrings_type = [ODClassType classTypeWithCls:[TRRuStrings class]];
}

- (NSString*)railRemovedCost:(NSInteger)cost {
    return [NSString stringWithFormat:@"-%@: Плата за демонтаж железной дороги", [self formatCost:cost]];
}

- (NSString*)helpToRemove {
    return @"Чтобы удалить ненужную железную дорогу,\n"
        "нажмите кнопку бульдозера в левом нижнем углу\n"
        "и нажмите на область с ненужными рельсами.";
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

- (NSString*)restartLevel:(NSUInteger)level {
    return [NSString stringWithFormat:@"Начать заново уровень %lu", (unsigned long)level];
}

- (NSString*)replayLevel:(NSUInteger)level {
    return [NSString stringWithFormat:@"Переиграть уровень %lu", (unsigned long)level];
}

- (NSString*)goToNextLevel:(NSUInteger)level {
    return [NSString stringWithFormat:@"Перейти к уровеню %lu", (unsigned long)level + 1];
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
    return @"Купить перемотки";
}

- (NSString*)rewind {
    return @"Отмотать назад";
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
        "чтобы этот поезд попал в %@ город.\n"
        "Если поезд встретит на пути закрытую стрелку или красный светофор, он поедет назад.", ((egPlatform().touch) ? @" касанием" : @" кликом"), to];
}

- (NSString*)helpExpressTrain {
    return @"Это очень быстрый экспресс.\n"
        "Он не успеет остановиться перед стрелкой.\n"
        "Если заблокировать его стрелкой, то он уничтожится.\n"
        "Но можно использовать светофоры.";
}

- (NSString*)helpToMakeZoom {
    return @"Вы можете изменять масштаб с помощью жеста.";
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

- (NSString*)helpRewind {
    return @"Используйте перемотку, для того чтобы вернуться на несколько мгновений назад.\n"
        "Нажмите кнопку в правом верхнем углу экрана.\n"
        "Количество использование восстанавливается каждый день.\n"
        "Если вы хотите сделать игру проще,\n"
        "вы можете купить дополнительные перемотки\n"
        "или получить их бесплатно поделившись с друзьями информацией об игре\n"
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

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendString:@">"];
    return description;
}

@end


@implementation TRJpStrings
static ODClassType* _TRJpStrings_type;

+ (instancetype)jpStrings {
    return [[TRJpStrings alloc] init];
}

- (instancetype)init {
    self = [super initWithLanguage:@"ja"];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [TRJpStrings class]) _TRJpStrings_type = [ODClassType classTypeWithCls:[TRJpStrings class]];
}

- (NSString*)railRemovedCost:(NSInteger)cost {
    return [NSString stringWithFormat:@"-%@: 鉄道路線を取り壊す為の支払い", [self formatCost:cost]];
}

- (NSString*)helpToRemove {
    return @"不要な鉄道路線を削除する為には、\n"
        "左下隅にあるブルドーザーのボタンを\n"
        "押し、鉄道路線の上をなぞって下さい。";
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

- (NSString*)restartLevel:(NSUInteger)level {
    return [NSString stringWithFormat:@"レベル%luをやり直す", (unsigned long)level];
}

- (NSString*)replayLevel:(NSUInteger)level {
    return [NSString stringWithFormat:@"レベル%luをもう一度プレイ", (unsigned long)level];
}

- (NSString*)goToNextLevel:(NSUInteger)level {
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

- (NSString*)buyButton {
    return @"巻き戻しを購入";
}

- (NSString*)rewind {
    return @"巻き戻し";
}

- (NSString*)helpRewind {
    return @"巻き戻しを使って難しい瞬間を切り抜けましょう。\n"
        "画面右上角の巻き戻しのボタンを押してください。\n"
        "使用回数は毎日少しずつ回復します。\n"
        "ゲームを簡単にしたい場合は追加巻き戻しを購入するか、\n"
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

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendString:@">"];
    return description;
}

@end


@implementation TRKoStrings
static ODClassType* _TRKoStrings_type;

+ (instancetype)koStrings {
    return [[TRKoStrings alloc] init];
}

- (instancetype)init {
    self = [super initWithLanguage:@"ko"];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [TRKoStrings class]) _TRKoStrings_type = [ODClassType classTypeWithCls:[TRKoStrings class]];
}

- (NSString*)railRemovedCost:(NSInteger)cost {
    return [NSString stringWithFormat:@"-%@: 철도의 제거에 대한 지불", [self formatCost:cost]];
}

- (NSString*)helpToRemove {
    return @"불필요한 철도를 제거하려면,\n"
        "왼쪽 하단 모서리에 있는 불도저 버튼을\n"
        "누르고 철도를 손가락으로 통과합니다.";
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

- (NSString*)restartLevel:(NSUInteger)level {
    return [NSString stringWithFormat:@"레벨 %lu 다시 시작", (unsigned long)level];
}

- (NSString*)replayLevel:(NSUInteger)level {
    return [NSString stringWithFormat:@"다시 레벨 %lu 플레이", (unsigned long)level];
}

- (NSString*)goToNextLevel:(NSUInteger)level {
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

- (NSString*)buyButton {
    return @"되감기 구매";
}

- (NSString*)rewind {
    return @"되감기";
}

- (NSString*)helpRewind {
    return @"어려운 순간에 자신을 돕기 위해 되감기합니다.\n"
        "화면의 오른쪽 상단 모서리에 있는 되감기 버튼을 누릅니다.\n"
        "작은 숫자의 사용은 매일 복원됩니다.\n"
        "당신이 게임을 쉽게 하려면, 되감기 추가 구매하거나\n"
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

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendString:@">"];
    return description;
}

@end


@implementation TRChinaStrings
static ODClassType* _TRChinaStrings_type;

+ (instancetype)chinaStrings {
    return [[TRChinaStrings alloc] init];
}

- (instancetype)init {
    self = [super initWithLanguage:@"zh"];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [TRChinaStrings class]) _TRChinaStrings_type = [ODClassType classTypeWithCls:[TRChinaStrings class]];
}

- (NSString*)railRemovedCost:(NSInteger)cost {
    return [NSString stringWithFormat:@"-%@: 撤除铁路的费用支付", [self formatCost:cost]];
}

- (NSString*)helpToRemove {
    return @"若要删除多余的铁路，\n"
        "按下在底部左手边的推土机按钮并用手指划下需要删除的铁路。";
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

- (NSString*)restartLevel:(NSUInteger)level {
    return [NSString stringWithFormat:@"重新挑战第%lu关", (unsigned long)level];
}

- (NSString*)replayLevel:(NSUInteger)level {
    return [NSString stringWithFormat:@"再次挑战第%lu关", (unsigned long)level];
}

- (NSString*)goToNextLevel:(NSUInteger)level {
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

- (NSString*)buyButton {
    return @"买倒带";
}

- (NSString*)rewind {
    return @"倒带";
}

- (NSString*)helpRewind {
    return @"使用倒带来克服困难的时刻。\n"
        "只需按下屏幕顶部右上角的倒带按钮。\n"
        "每天少量的使用都可修复。\n"
        "如果您想简化游戏，\n"
        "您可以购买额外的倒带或通过在\n"
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

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendString:@">"];
    return description;
}

@end


@implementation TRPtStrings
static ODClassType* _TRPtStrings_type;

+ (instancetype)ptStrings {
    return [[TRPtStrings alloc] init];
}

- (instancetype)init {
    self = [super initWithLanguage:@"pt"];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [TRPtStrings class]) _TRPtStrings_type = [ODClassType classTypeWithCls:[TRPtStrings class]];
}

- (NSString*)railRemovedCost:(NSInteger)cost {
    return [NSString stringWithFormat:@"-%@: Pagamento pelo desmonte da ferrovia", [self formatCost:cost]];
}

- (NSString*)helpToRemove {
    return @"Para remover uma ferrovia supérflua,\n"
        "pressione o botão do trator no canto inferior esquerdo\n"
        "e passe um dedo sobre a ferrovia.";
}

- (NSString*)levelNumber:(NSUInteger)number {
    return [NSString stringWithFormat:@"Nível %lu", (unsigned long)number];
}

- (NSString*)railBuiltCost:(NSInteger)cost {
    return [NSString stringWithFormat:@"-%@: Pagamento pela construção da ferrovia", [self formatCost:cost]];
}

- (NSString*)trainArrivedTrain:(TRTrain*)train cost:(NSInteger)cost {
    return [NSString stringWithFormat:@"+%@: Recompensa pelo trem de chegada", [self formatCost:cost]];
}

- (NSString*)trainDestroyedCost:(NSInteger)cost {
    return [NSString stringWithFormat:@"-%@:  Multa pelo trem destruído", [self formatCost:cost]];
}

- (NSString*)trainDelayedFineTrain:(TRTrain*)train cost:(NSInteger)cost {
    return [NSString stringWithFormat:@"-%@: Multa pelo trem atrasado", [self formatCost:cost]];
}

- (NSString*)damageFixedPaymentCost:(NSInteger)cost {
    return [NSString stringWithFormat:@"-%@: Pagamento pelos reparos na ferrovia", [self formatCost:cost]];
}

- (NSString*)resumeGame {
    return @"Continuar o jogo";
}

- (NSString*)restartLevel:(NSUInteger)level {
    return [NSString stringWithFormat:@"Reiniciar o nível %lu", (unsigned long)level];
}

- (NSString*)replayLevel:(NSUInteger)level {
    return [NSString stringWithFormat:@"Jogar nível %lu novamente", (unsigned long)level];
}

- (NSString*)goToNextLevel:(NSUInteger)level {
    return @"Jogar o próximo nível";
}

- (NSString*)chooseLevel {
    return @"Escolher o nível";
}

- (NSString*)victory {
    return @"Vitória!";
}

- (NSString*)defeat {
    return @"Derrota!";
}

- (NSString*)moneyOver {
    return @"O dinheiro acabou";
}

- (NSString*)cityBuilt {
    return @"A nova cidade foi construída";
}

- (NSString*)tapToContinue {
    if(egPlatform().isComputer) return @"Toque para continuar";
    else return @"Toque para continuar";
}

- (NSString*)error {
    return @"Erro";
}

- (NSString*)shareButton {
    return @"Compartilhar com amigos";
}

- (NSString*)supportButton {
    return @"Enviar e-mail ao desenvolvedor";
}

- (NSString*)rateText {
    return @"Se gosta de jogar Raildale, você se importaria em dedicar\n"
        "um momento para avaliá-lo?\n"
        "Não vai levar mais do que um minuto.\n"
        "\n"
        "Se você encontrar um problema, por favor, relate-o para mim.\n"
        "Vou tentar resolvê-lo assim que possível.\n"
        "\n"
        "Obrigado pelo apoio! Tudo de bom, Anton Zherdev, desenvolvedor";
}

- (NSString*)rateNow {
    return @"Avaliar agora";
}

- (NSString*)rateProblem {
    return @"Relatar um problema";
}

- (NSString*)rateLater {
    return @"Lembrar-me depois";
}

- (NSString*)rateClose {
    return @"Não, obrigado";
}

- (NSString*)helpConnectTwoCities {
    return [NSString stringWithFormat:@"Conecte duas cidades por trilhos.\n"
        "%@", ((egPlatform().touch) ? @"Basta pintar os trilhos usando o seu dedo." : @"Use um mouse ou movimente dois dedos em um touchpad.")];
}

- (NSString*)helpRules {
    return @"Não deixe que o saldo da conta desça abaixo de zero.\n"
        "Fique dentro do tempo estabelecido, com um saldo positivo,\n"
        "para vencer um nível.";
}

- (NSString*)helpNewCity {
    return @"Às vezes, novas cidades aparecem.\n"
        "Conecte-as à sua ferrovia. ";
}

- (NSString*)helpTrainTo:(NSString*)to {
    return @"Você pode reconhecer o sentido do trem pela sua cor.";
}

- (NSString*)helpTrainWithSwitchesTo:(NSString*)to {
    return [NSString stringWithFormat:@"Vire os desvios da ferrovia com um%@\n"
        "para que o trem chegue na cidade de seu destino.", ((egPlatform().touch) ? @" toque" : @" clique")];
}

- (NSString*)helpExpressTrain {
    return @"Este é um trem expresso muito rápido.\n"
        "Ele não tem tempo de parar em frente a um desvio.\n"
        "Neste caso, o trem será destruído.\n"
        "Mas você pode usar semáforos para conduzi-lo.";
}

- (NSString*)helpToMakeZoom {
    return @"Você pode mudar a escala com um gesto em pinça. ";
}

- (NSString*)helpInZoom {
    return @"Use um dedo para mover a tela.\n"
        "Pressione o botão de martelo no topo para construir trilhos.\n"
        "Pressione novamente para voltar ao modo de rolagem.";
}

- (NSString*)helpSporadicDamage {
    return @"Às vezes, os trilhos podem se quebrar.";
}

- (NSString*)helpDamage {
    return @"Chame o trem de serviço usando os botões para consertar os danos.\n"
        "É melhor chamar o trem a partir da cidade mais próxima aos danos.";
}

- (NSString*)helpCrazy {
    return @"O maquinista do trem é louco.\n"
        "Ele não presta atenção em semáforos ou desvios fechados.\n"
        "Envie este trem a qualquer cidade.";
}

- (NSString*)helpRepairer {
    return @"Conduza o trem de serviço através dos danos\n"
        "e envie-o para qualquer cidade.";
}

- (NSString*)buyButton {
    return @"Comprar retrocessos";
}

- (NSString*)rewind {
    return @"Retroceder";
}

- (NSString*)helpRewind {
    return @"Use o retrocesso para se ajudar em momentos difíceis.\n"
        "Pressione o botão do retrocesso no canto superior direito da tela.\n"
        "Um pequeno número de utilizações é restaurado todos os dias.\n"
        "Se quiser deixar o jogo mais fácil,\n"
        "você pode comprar retrocessos adicionais\n"
        "ou consegui-las de graça, compartilhando o jogo no Facebook ou Twitter.\n"
        "Mas você consegue dar conta sem elas.";
}

- (NSString*)linesAdvice {
    return @"Você pode conectar cidades usando mais de uma linha de trem.\n"
        "Assim, dois trens vindo de sentidos opostos\n"
        "não iriam colidir um com o outro.";
}

- (NSString*)result {
    return @"Pontuação";
}

- (NSString*)best {
    return @"Seu recorde";
}

- (NSString*)topScore:(EGLocalPlayerScore*)score {
    if(score.rank == 1) {
        return @"O primeiríssimo!";
    } else {
        if(score.rank == 2) {
            return @"O segundo melhor!";
        } else {
            if(score.rank == 3) {
                return @"O terceiro melhor!";
            } else {
                CGFloat p = ((CGFloat)(score.rank)) / score.maxRank;
                if(p <= 5) {
                    return @"Entre os 5% melhores";
                } else {
                    if(p <= 10) {
                        return @"Entre os 10% melhores";
                    } else {
                        if(p <= 20) {
                            return @"Entre os 20% melhores";
                        } else {
                            if(p <= 30) {
                                return @"Entre os 30% melhores";
                            } else {
                                if(p <= 50) return @"Melhor que a média";
                                else return @"Pior que a média";
                            }
                        }
                    }
                }
            }
        }
    }
}

- (NSString*)leaderboard {
    return @"Os melhores resultados";
}

- (NSString*)shareSubject {
    return @"Raildale é um grande jogo para iOS e Mac";
}

- (NSString*)shareTextUrl:(NSString*)url {
    return [NSString stringWithFormat:@"Raildale é um jogo emocionante de construção de ferrovias para iOS e Mac OS X: %@", url];
}

- (NSString*)twitterTextUrl:(NSString*)url {
    return [NSString stringWithFormat:@"%@: @RaildaleGame é um jogo de construção de ferrovias para iOS e Mac", url];
}

- (ODClassType*)type {
    return [TRPtStrings type];
}

+ (ODClassType*)type {
    return _TRPtStrings_type;
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


@implementation TRItStrings
static ODClassType* _TRItStrings_type;

+ (instancetype)itStrings {
    return [[TRItStrings alloc] init];
}

- (instancetype)init {
    self = [super initWithLanguage:@"it"];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [TRItStrings class]) _TRItStrings_type = [ODClassType classTypeWithCls:[TRItStrings class]];
}

- (NSString*)railRemovedCost:(NSInteger)cost {
    return [NSString stringWithFormat:@"-%@: Pagamento per lo smontaggio del binario", [self formatCost:cost]];
}

- (NSString*)helpToRemove {
    return @"Per rimuovere un binario superfluo,\n"
        "premi il tasto bulldozer nell'angolo in basso a sinistra\n"
        "e fai scorrere un dito sul binario.";
}

- (NSString*)levelNumber:(NSUInteger)number {
    return [NSString stringWithFormat:@"Livello %lu", (unsigned long)number];
}

- (NSString*)railBuiltCost:(NSInteger)cost {
    return [NSString stringWithFormat:@"-%@: Pagamento per la costruzione della ferrovia", [self formatCost:cost]];
}

- (NSString*)trainArrivedTrain:(TRTrain*)train cost:(NSInteger)cost {
    return [NSString stringWithFormat:@"+%@: Ricompensa per il treno arrivato", [self formatCost:cost]];
}

- (NSString*)trainDestroyedCost:(NSInteger)cost {
    return [NSString stringWithFormat:@"-%@:  Va bene per il treno distrutto", [self formatCost:cost]];
}

- (NSString*)trainDelayedFineTrain:(TRTrain*)train cost:(NSInteger)cost {
    return [NSString stringWithFormat:@"-%@: Va bene per il treno ritardato", [self formatCost:cost]];
}

- (NSString*)damageFixedPaymentCost:(NSInteger)cost {
    return [NSString stringWithFormat:@"-%@: Pagamento per le riparazioni ferroviarie", [self formatCost:cost]];
}

- (NSString*)resumeGame {
    return @"Continua il gioco";
}

- (NSString*)restartLevel:(NSUInteger)level {
    return [NSString stringWithFormat:@"Riavvia il livello %lu", (unsigned long)level];
}

- (NSString*)replayLevel:(NSUInteger)level {
    return [NSString stringWithFormat:@"Gioca di nuovo al livello %lu", (unsigned long)level];
}

- (NSString*)goToNextLevel:(NSUInteger)level {
    return @"Gioca al livello successivo";
}

- (NSString*)chooseLevel {
    return @"Scegli il livello";
}

- (NSString*)victory {
    return @"Vittoria!";
}

- (NSString*)defeat {
    return @"Sconfitta!";
}

- (NSString*)moneyOver {
    return @"I soldi son finiti";
}

- (NSString*)cityBuilt {
    return @"La nuova città è stata costruita";
}

- (NSString*)tapToContinue {
    if(egPlatform().isComputer) return @"Clicca per continuare";
    else return @"Tocca per continuare";
}

- (NSString*)error {
    return @"Errore";
}

- (NSString*)shareButton {
    return @"Condividi con gli amici";
}

- (NSString*)supportButton {
    return @"Contatta l'autore";
}

- (NSString*)rateText {
    return @"Se ti piace giocare a Raildale, potresti dedicarci\n"
        "un momento per votarlo? Non ci vorrà più di un minuto.\n"
        "\n"
        "Se hai un problema, fammelo sapere. Cercherò\n"
        "di risolverlo il problema al più presto possibile.\n"
        "\n"
        "Grazie per il tuo supporto!\n"
        "Con i migliori saluti, Anton Zherdev, sviluppatore";
}

- (NSString*)rateNow {
    return @"Vota ora";
}

- (NSString*)rateProblem {
    return @"Segnala un problema";
}

- (NSString*)rateLater {
    return @"Ricordami più tardi";
}

- (NSString*)rateClose {
    return @"No, grazie";
}

- (NSString*)helpConnectTwoCities {
    return [NSString stringWithFormat:@"Collega due città in treno.\n"
        "%@", ((egPlatform().touch) ? @"Basta dipingere le rotaie con il dito." : @"Utilizza un mouse o muovi due dita sul touchpad.")];
}

- (NSString*)helpRules {
    return @"Non permettere che il saldo del tuo conto vada sotto lo zero.\n"
        "Rimani nel tempo assegnato,\n"
        "con un saldo positivo per vincere un livello.";
}

- (NSString*)helpNewCity {
    return @"A volte compaiono nuove città.\n"
        "Inseriscile nella tua ferrovia. ";
}

- (NSString*)helpTrainTo:(NSString*)to {
    return @"Puoi riconoscere la direzione del treno dal colore.";
}

- (NSString*)helpTrainWithSwitchesTo:(NSString*)to {
    return [NSString stringWithFormat:@"Girare gli scambi ferroviari con un %@,\n"
        "così il treno arriverà alla città di destinazione.", ((egPlatform().touch) ? @" tocco" : @" clic")];
}

- (NSString*)helpExpressTrain {
    return @"Questo è un treno espresso molto veloce.\n"
        "Non ha il tempo di fermarsi di fronte a uno scambio.\n"
        "In questo caso il treno sarà distrutto.\n"
        "Ma puoi utilizzare i semafori per condurre il treno.";
}

- (NSString*)helpToMakeZoom {
    return @"Puoi modificare la scala con un gesto di pinch.";
}

- (NSString*)helpInZoom {
    return @"Utilizza un dito per scorrere.\n"
        "Premi il pulsante del martello in alto per costruire le rotaie.\n"
        "Premi di nuovo per tornare alla modalità di scorrimento.";
}

- (NSString*)helpSporadicDamage {
    return @"A volte le rotaie possono essere rotte.";
}

- (NSString*)helpDamage {
    return @"Chiama il treno di servizio\n"
        "utilizzando uno dei pulsanti per riparare il danno.\n"
        "È meglio chiamare il treno dalla città più vicina al danno.";
}

- (NSString*)helpCrazy {
    return @"L'ingegnere del treno è pazzo.\n"
        "Non presta attenzione ai semafori o agli scambi chiusi.\n"
        "Manda questo treno in qualsiasi città.";
}

- (NSString*)helpRepairer {
    return @"Conduci il treno di servizio nell'incidente\n"
        "e invialo in qualsiasi città.";
}

- (NSString*)buyButton {
    return @"Acquista riavvolgimento";
}

- (NSString*)rewind {
    return @"Riavvolgere";
}

- (NSString*)helpRewind {
    return @"Utilizza il riavvolgimento per aiutare te stesso nei momenti difficili.\n"
        "Premi il pulsante della riavvolgimento nell'angolo in alto a destra dello schermo.\n"
        "Un piccolo numero di utilizzi vengono ripristinati ogni giorno.\n"
        "Se vuoi rendere il gioco più facile puoi acquistare ulteriori riavvolgimento\n"
        "o ottenerli gratuitamente condividendo il gioco su Facebook o Twitter.\n"
        "Ma puoi farne a meno.";
}

- (NSString*)linesAdvice {
    return @"Puoi collegare le città con più di una linea.\n"
        "Così due treni che provengono da direzioni opposte\n"
        "non si scontreranno.";
}

- (NSString*)result {
    return @"Punteggio";
}

- (NSString*)best {
    return @"Il tuo migliore";
}

- (NSString*)topScore:(EGLocalPlayerScore*)score {
    if(score.rank == 1) {
        return @"Il meglio!";
    } else {
        if(score.rank == 2) {
            return @"Il secondo di sempre!";
        } else {
            if(score.rank == 3) {
                return @"Il terzo di sempre!";
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
                                if(p <= 50) return @"Meglio della media";
                                else return @"Peggio della media";
                            }
                        }
                    }
                }
            }
        }
    }
}

- (NSString*)leaderboard {
    return @"I migliori risultati";
}

- (NSString*)shareSubject {
    return @"Raildale è un grande gioco per iOS e Mac";
}

- (NSString*)shareTextUrl:(NSString*)url {
    return [NSString stringWithFormat:@"Raildale è un gioco di costruzione ferroviaria emozionante per iOS e Mac OS X: %@", url];
}

- (NSString*)twitterTextUrl:(NSString*)url {
    return [NSString stringWithFormat:@"%@: @RaildaleGame è un gioco di costruzione ferroviaria emozionante per iOS e Mac", url];
}

- (ODClassType*)type {
    return [TRItStrings type];
}

+ (ODClassType*)type {
    return _TRItStrings_type;
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


@implementation TRSpStrings
static ODClassType* _TRSpStrings_type;

+ (instancetype)spStrings {
    return [[TRSpStrings alloc] init];
}

- (instancetype)init {
    self = [super initWithLanguage:@"es"];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [TRSpStrings class]) _TRSpStrings_type = [ODClassType classTypeWithCls:[TRSpStrings class]];
}

- (NSString*)railRemovedCost:(NSInteger)cost {
    return [NSString stringWithFormat:@"-%@: Pago por derribo de la vía férrea", [self formatCost:cost]];
}

- (NSString*)helpToRemove {
    return @"Para eliminar vía férrea superflua,\n"
        "pulsa el botón del bulldozer en la esquina inferior izquierda\n"
        "y pasa un dedo sobre la vía férrea.";
}

- (NSString*)levelNumber:(NSUInteger)number {
    return [NSString stringWithFormat:@"Nivel %lu", (unsigned long)number];
}

- (NSString*)railBuiltCost:(NSInteger)cost {
    return [NSString stringWithFormat:@"-%@: Pago por construir la vía", [self formatCost:cost]];
}

- (NSString*)trainArrivedTrain:(TRTrain*)train cost:(NSInteger)cost {
    return [NSString stringWithFormat:@"+%@: Recompensa por la llegada del tren", [self formatCost:cost]];
}

- (NSString*)trainDestroyedCost:(NSInteger)cost {
    return [NSString stringWithFormat:@"-%@:  Multa por la destrucción del tren", [self formatCost:cost]];
}

- (NSString*)trainDelayedFineTrain:(TRTrain*)train cost:(NSInteger)cost {
    return [NSString stringWithFormat:@"-%@: Multa por el retraso del tren", [self formatCost:cost]];
}

- (NSString*)damageFixedPaymentCost:(NSInteger)cost {
    return [NSString stringWithFormat:@"-%@: Pago por reparaciones de la vía", [self formatCost:cost]];
}

- (NSString*)resumeGame {
    return @"Seguir jugando";
}

- (NSString*)restartLevel:(NSUInteger)level {
    return [NSString stringWithFormat:@"Volver a empezar nivel %lu", (unsigned long)level];
}

- (NSString*)replayLevel:(NSUInteger)level {
    return [NSString stringWithFormat:@"Jugar nivel %lu", (unsigned long)level];
}

- (NSString*)goToNextLevel:(NSUInteger)level {
    return @"Jugar al siguiente nivel";
}

- (NSString*)chooseLevel {
    return @"Elige el nivel";
}

- (NSString*)victory {
    return @"¡Victoria!";
}

- (NSString*)defeat {
    return @"¡Derrota!";
}

- (NSString*)moneyOver {
    return @"Se acabó el dinero";
}

- (NSString*)cityBuilt {
    return @"La nueva ciudad se ha construido";
}

- (NSString*)tapToContinue {
    if(egPlatform().isComputer) return @"Haz clic para seguir";
    else return @"Toca para seguir";
}

- (NSString*)error {
    return @"Error";
}

- (NSString*)shareButton {
    return @"Comparte con tus amigos";
}

- (NSString*)supportButton {
    return @"Escríbele al desarrollador";
}

- (NSString*)rateText {
    return @"Si te gustó jugar a Raildale ¿Te tomarías\n"
        "un momento para puntuarla? Solo llevará un minuto.\n"
        "\n"
        "Si tienes algún problema, por favor avísame.\n"
        "Intentaré arreglarlo lo antes posible.\n"
        "\n"
        "¡Gracias por tu apoyo!\n"
        "Un cordial saludo, Anton Zherdev, desarrollador";
}

- (NSString*)rateNow {
    return @"Ponle nota";
}

- (NSString*)rateProblem {
    return @"Informa de un problema";
}

- (NSString*)rateLater {
    return @"Recuérdamelo más tarde";
}

- (NSString*)rateClose {
    return @"No, gracias";
}

- (NSString*)helpConnectTwoCities {
    return [NSString stringWithFormat:@"Conecta dos ciudades con el ferrocarril.\n"
        "%@", ((egPlatform().touch) ? @"Solo tienes que trazar los raíles con el dedo." : @"Usa el ratón o mueve dos dedos en un tablero táctil.")];
}

- (NSString*)helpRules {
    return @"No permitas que tu balance de cuentas\n"
        "caiga por debajo de cero.\n"
        "Mantén tu balance positivo en el periodo\n"
        "de tiempo designado para ganar un nivel.";
}

- (NSString*)helpNewCity {
    return @"A veces, nuevas ciudades aparecen.\n"
        "Conéctalas a tu red de ferrocarriles.";
}

- (NSString*)helpTrainTo:(NSString*)to {
    return @"Puedes reconocer la dirección del tren por su color.";
}

- (NSString*)helpTrainWithSwitchesTo:(NSString*)to {
    return [NSString stringWithFormat:@"Conmuta las vías de tren con un%@\n"
        "para que el tren llegue a su destino.", ((egPlatform().touch) ? @" toque" : @" clic")];
}

- (NSString*)helpExpressTrain {
    return @"Este es un tren exprés y va muy rápido.\n"
        "No tiene tiempo para detenerse enfrente de un cambio de vías.\n"
        "En este caso, el tren será destruido.\n"
        "Pero puedes usar luces para guiar el tren.";
}

- (NSString*)helpToMakeZoom {
    return @"Puedes cambiar la escala con un pellizco.";
}

- (NSString*)helpInZoom {
    return @"Usa un dedo para moverte.\n"
        "Haz clic en el botón del martillo para hacer los raíles.\n"
        "Tócalo de nuevo para volver atrás.";
}

- (NSString*)helpSporadicDamage {
    return @"A veces, los raíles se rompen.";
}

- (NSString*)helpDamage {
    return @"Llama al tren de servicio\n"
        "con alguno de los botones para reparar el daño.\n"
        "Es mejor llamar al tren de la ciudad más cercana al accidente.";
}

- (NSString*)helpCrazy {
    return @"El maquinista de este tren está loco.\n"
        "No presta atención a las luces o a los cambios de vía.\n"
        "Envía este tren a alguna ciudad.";
}

- (NSString*)helpRepairer {
    return @"Lleva el tren de servicio a través de los daños\n"
        "y envíalo a cualquier ciudad.";
}

- (NSString*)buyButton {
    return @"Compra rebobinados";
}

- (NSString*)rewind {
    return @"Rebobino";
}

- (NSString*)helpRewind {
    return @"Usa el rebobinado para ayudarte en los momentos más difíciles.\n"
        "Toca el botón del rebobinado en la parte superior derecha de la pantalla.\n"
        "Cada día se restablecen algunos usos.\n"
        "Si quieres hacer el juego más fácil,\n"
        "puedes comprar más momentos de rebobinado\n"
        "o conseguirlos gratis si compartes el juego en Facebook o Twitter.\n"
        "Pero es posible apañárselas sin ellos.";
}

- (NSString*)linesAdvice {
    return @"Puedes conectar ciudades usando más de una línea.\n"
        "De esta manera, dos trenes que circulan\n"
        "en direcciones opuestas no tienen por qué colisionar.";
}

- (NSString*)result {
    return @"Puntuación";
}

- (NSString*)best {
    return @"Su mejor";
}

- (NSString*)topScore:(EGLocalPlayerScore*)score {
    if(score.rank == 1) {
        return @"¡La mejor!";
    } else {
        if(score.rank == 2) {
            return @"¡La segunda mejor!";
        } else {
            if(score.rank == 3) {
                return @"¡La tercera mejor!";
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
                                if(p <= 50) return @"Mejor que la media";
                                else return @"Peor que la media";
                            }
                        }
                    }
                }
            }
        }
    }
}

- (NSString*)leaderboard {
    return @"Mejores resultados";
}

- (NSString*)shareSubject {
    return @"Raildale es un gran juego para iOS y Mac";
}

- (NSString*)shareTextUrl:(NSString*)url {
    return [NSString stringWithFormat:@"Raildale es un interesante juego de construir ferrocarriles para iOS y Mac: %@", url];
}

- (NSString*)twitterTextUrl:(NSString*)url {
    return [NSString stringWithFormat:@"%@: @RaildaleGame es un interesante juego de construir ferrocarriles para iOS", url];
}

- (ODClassType*)type {
    return [TRSpStrings type];
}

+ (ODClassType*)type {
    return _TRSpStrings_type;
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


@implementation TRGeStrings
static ODClassType* _TRGeStrings_type;

+ (instancetype)geStrings {
    return [[TRGeStrings alloc] init];
}

- (instancetype)init {
    self = [super initWithLanguage:@"de"];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [TRGeStrings class]) _TRGeStrings_type = [ODClassType classTypeWithCls:[TRGeStrings class]];
}

- (NSString*)railRemovedCost:(NSInteger)cost {
    return [NSString stringWithFormat:@"-%@: Zahlung für Takedown der Bahnlinie", [self formatCost:cost]];
}

- (NSString*)helpToRemove {
    return @"Um eine überflüssige Bahnlinie zu entfernen,\n"
        "drücken Sie den Bulldozer-Button in der linken unteren Ecke\n"
        "und fahren Sie mit einem Finger über die Bahnlinie.";
}

- (NSString*)levelNumber:(NSUInteger)number {
    return [NSString stringWithFormat:@"Level %lu", (unsigned long)number];
}

- (NSString*)railBuiltCost:(NSInteger)cost {
    return [NSString stringWithFormat:@"-%@: Bezahlung für den Gleisbau", [self formatCost:cost]];
}

- (NSString*)trainArrivedTrain:(TRTrain*)train cost:(NSInteger)cost {
    return [NSString stringWithFormat:@"+%@: Belohnung für die Zugankunft", [self formatCost:cost]];
}

- (NSString*)trainDestroyedCost:(NSInteger)cost {
    return [NSString stringWithFormat:@"-%@:  Bußgeld für den zerstörten Zug", [self formatCost:cost]];
}

- (NSString*)trainDelayedFineTrain:(TRTrain*)train cost:(NSInteger)cost {
    return [NSString stringWithFormat:@"-%@: Bußgeld für die Zugverspätung", [self formatCost:cost]];
}

- (NSString*)damageFixedPaymentCost:(NSInteger)cost {
    return [NSString stringWithFormat:@"-%@: Bußgeld für die Reparaturarbeiten an den Gleisen", [self formatCost:cost]];
}

- (NSString*)resumeGame {
    return @"Spiel fortsetzen";
}

- (NSString*)restartLevel:(NSUInteger)level {
    return [NSString stringWithFormat:@"uint %lu neu starten", (unsigned long)level];
}

- (NSString*)replayLevel:(NSUInteger)level {
    return [NSString stringWithFormat:@"uint %lu wiederholen", (unsigned long)level];
}

- (NSString*)goToNextLevel:(NSUInteger)level {
    return @"Nächstes uint spielen";
}

- (NSString*)chooseLevel {
    return @"uint wählen";
}

- (NSString*)victory {
    return @"Gewonnen!";
}

- (NSString*)defeat {
    return @"Verloren!";
}

- (NSString*)moneyOver {
    return @"Kein Geld mehr";
}

- (NSString*)cityBuilt {
    return @"Die neue Stadt wurde fertiggestellt";
}

- (NSString*)tapToContinue {
    if(egPlatform().isComputer) return @"Zum Fortsetzen klicken";
    else return @"Zum Fortsetzen berühren";
}

- (NSString*)error {
    return @"Fehler";
}

- (NSString*)shareButton {
    return @"Mit Freunden teilen";
}

- (NSString*)supportButton {
    return @"E-Mail an den Entwickler";
}

- (NSString*)rateText {
    return @"Wenn dir Raildale gefällt, könntest du dir bitte\n"
        "einen Augenblick Zeit nehmen und die App bewerten?\n"
        "\n"
        "Falls du ein Problem mit der App hast, schreibe mir bitte.\n"
        "Ich werde mich so schnell wie möglich darum kümmern.\n"
        "\n"
        "Vielen Dank für deine Unterstützung!\n"
        "Viele Grüße, Anton Zherdev – der Entwickler";
}

- (NSString*)rateNow {
    return @"Jetzt bewerten";
}

- (NSString*)rateProblem {
    return @"Problem melden";
}

- (NSString*)rateLater {
    return @"Später erinnern";
}

- (NSString*)rateClose {
    return @"Nein, danke";
}

- (NSString*)helpConnectTwoCities {
    return [NSString stringWithFormat:@"Verbinde zwei Städte mit einer Zugstrecke.\n"
        "%@", ((egPlatform().touch) ? @"Zeichne die Gleise einfach mit deinem Finger." : @"Verwende eine Computermaus oder fahre\n"
        "mit zwei Fingern über ein Touchpad.")];
}

- (NSString*)helpRules {
    return @"Pass auf, dass dein Konto keine roten Zahlen schreibt.\n"
        "Um das uint zu gewinnen, musst du\n"
        "innerhalb der vorgegebenen Zeit im Plus bleiben.";
}

- (NSString*)helpNewCity {
    return @"Mitunter erscheinen neue Städte.\n"
        "Schließe sie an dein Zugnetz an.";
}

- (NSString*)helpTrainTo:(NSString*)to {
    return @"Du kannst die Richtung der Züge an der Farbe erkennen.";
}

- (NSString*)helpTrainWithSwitchesTo:(NSString*)to {
    return [NSString stringWithFormat:@"Steuere Weichen per%@,\n"
        "damit der Zug am Zielort ankommt.", ((egPlatform().touch) ? @" Fingerberührung" : @" Klick")];
}

- (NSString*)helpExpressTrain {
    return @"Dies ist ein rasanter Schnellzug.\n"
        "Er hält vor einer Weiche nicht extra an und wird dadurch zerstört.\n"
        "Du kannst jedoch Ampeln verwenden, um den Zug anzuhalten.";
}

- (NSString*)helpToMakeZoom {
    return @"Du kannst die Größe über die Pinchgeste ändern.";
}

- (NSString*)helpInZoom {
    return @"Scrolle mit deinem Finger.\n"
        "Drücke oben auf den Hammer-Button, um Gleise zu legen.\n"
        "Drücke noch einmal, um zum Scrollmodus zurückzukehren.";
}

- (NSString*)helpSporadicDamage {
    return @"Es kann auch vorkommen, dass Gleise kaputt gehen.";
}

- (NSString*)helpDamage {
    return @"Rufe den Service-Zug über einen der Buttons,\n"
        "um den Schaden zu beheben.\n"
        "Es empfiehlt sich, den Service-Zug\n"
        "von der nächstgelegenen Stadt aus zu rufen.";
}

- (NSString*)helpCrazy {
    return @"Der Zugführer ist verrückt.\n"
        "Er achtet weder auf Ampeln noch auf geschlossene Weichen.\n"
        "Leite diesen Zug in eine beliebige Stadt.";
}

- (NSString*)helpRepairer {
    return @"Leite den Service-Zug über den Schaden\n"
        "und schicke den Zug dann in eine beliebige Stadt.";
}

- (NSString*)buyButton {
    return @"Zurückspulen kaufen";
}

- (NSString*)rewind {
    return @"Zurückspulen";
}

- (NSString*)helpRewind {
    return @"Nutze der Zurückspulen,\n"
        "um in schwierigen Momenten Abhilfe zu schaffen.\n"
        "Drücke oben rechts in der Ecke auf den Button mit der Zurückspulen.\n"
        "Eine kleine Anzahl an aufgebrauchten Zeitlupen\n"
        "werden jeden Tag wieder aufgestockt.\n"
        "Wenn du dir das Spiel leichter gestalten möchtest,\n"
        "kannst du zusätzliche Zurückspulen kaufen oder kostenlos erhalten,\n"
        "indem du dieses Spiel auf Facebook oder Twitter teilst.\n"
        "Du kannst es jedoch auch ohne Zurückspulen schaffen.";
}

- (NSString*)linesAdvice {
    return @"Du kannst Städte über mehr als eine Strecke verbinden.\n"
        "So verhinderst du, dass zwei Züge\n"
        "aus unterschiedlichen Richtungen kollidieren.";
}

- (NSString*)result {
    return @"Punkte";
}

- (NSString*)best {
    return @"Dein bestes Ergebnis";
}

- (NSString*)topScore:(EGLocalPlayerScore*)score {
    if(score.rank == 1) {
        return @"Der Erste aller Zeiten!";
    } else {
        if(score.rank == 2) {
            return @"Der Zweite aller Zeiten!";
        } else {
            if(score.rank == 3) {
                return @"Der Dritte aller Zeiten!";
            } else {
                CGFloat p = ((CGFloat)(score.rank)) / score.maxRank;
                if(p <= 5) {
                    return @"Beste 5%";
                } else {
                    if(p <= 10) {
                        return @"Beste 10%";
                    } else {
                        if(p <= 20) {
                            return @"Beste 20%";
                        } else {
                            if(p <= 30) {
                                return @"Beste 30%";
                            } else {
                                if(p <= 50) return @"Über dem Durchschnitt";
                                else return @"Unter dem Durchschnitt";
                            }
                        }
                    }
                }
            }
        }
    }
}

- (NSString*)leaderboard {
    return @"Beste Ergebnisse";
}

- (NSString*)shareSubject {
    return @"Raildale ist ein tolles Spiel für iOS und Mac";
}

- (NSString*)shareTextUrl:(NSString*)url {
    return [NSString stringWithFormat:@"Raildale ist ein spannendes Gleisbauspiel für iOS und Mac OS X: %@", url];
}

- (NSString*)twitterTextUrl:(NSString*)url {
    return [NSString stringWithFormat:@"%@: @RaildaleGame ist ein spannendes Gleisbauspiel für iOS und Mac OS X", url];
}

- (ODClassType*)type {
    return [TRGeStrings type];
}

+ (ODClassType*)type {
    return _TRGeStrings_type;
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


@implementation TRFrStrings
static ODClassType* _TRFrStrings_type;

+ (instancetype)frStrings {
    return [[TRFrStrings alloc] init];
}

- (instancetype)init {
    self = [super initWithLanguage:@"fr"];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [TRFrStrings class]) _TRFrStrings_type = [ODClassType classTypeWithCls:[TRFrStrings class]];
}

- (NSString*)railRemovedCost:(NSInteger)cost {
    return [NSString stringWithFormat:@"-%@: Paiement pour le démontage de la voie ferrée", [self formatCost:cost]];
}

- (NSString*)helpToRemove {
    return @"Pour retirer une voie ferrée inutile,\n"
        "appuyez sur le bouton bulldozer dans le coin en bas à gauche\n"
        "et passez un doigt sur la voie ferrée.";
}

- (NSString*)levelNumber:(NSUInteger)number {
    return [NSString stringWithFormat:@"Niveau %lu", (unsigned long)number];
}

- (NSString*)railBuiltCost:(NSInteger)cost {
    return [NSString stringWithFormat:@"-%@: Paiement pour la construction du chemin de fer", [self formatCost:cost]];
}

- (NSString*)trainArrivedTrain:(TRTrain*)train cost:(NSInteger)cost {
    return [NSString stringWithFormat:@"+%@: Prime pour le train arrivé", [self formatCost:cost]];
}

- (NSString*)trainDestroyedCost:(NSInteger)cost {
    return [NSString stringWithFormat:@"-%@:  Amende pour le train détruit ", [self formatCost:cost]];
}

- (NSString*)trainDelayedFineTrain:(TRTrain*)train cost:(NSInteger)cost {
    return [NSString stringWithFormat:@"-%@: Amende pour le train retardé ", [self formatCost:cost]];
}

- (NSString*)damageFixedPaymentCost:(NSInteger)cost {
    return [NSString stringWithFormat:@"-%@: Amende pour les réparations", [self formatCost:cost]];
}

- (NSString*)resumeGame {
    return @"Continuez le jeu ";
}

- (NSString*)restartLevel:(NSUInteger)level {
    return [NSString stringWithFormat:@"Redémarrez le niveau %lu", (unsigned long)level];
}

- (NSString*)replayLevel:(NSUInteger)level {
    return [NSString stringWithFormat:@"Jouez le niveau %lu de nouveau", (unsigned long)level];
}

- (NSString*)goToNextLevel:(NSUInteger)level {
    return @"Jouez le niveau suivant";
}

- (NSString*)chooseLevel {
    return @"Choisissez le niveau";
}

- (NSString*)victory {
    return @"Victoire!";
}

- (NSString*)defeat {
    return @"Défaite!";
}

- (NSString*)moneyOver {
    return @"Plus d’argent";
}

- (NSString*)cityBuilt {
    return @"La nouvelle ville a été construite";
}

- (NSString*)tapToContinue {
    if(egPlatform().isComputer) return @"Cliquez pour continuer";
    else return @"Tapez pour continuer";
}

- (NSString*)error {
    return @"Erreur";
}

- (NSString*)shareButton {
    return @"Partagez avec vos amis";
}

- (NSString*)supportButton {
    return @"E-mail le développeur";
}

- (NSString*)rateText {
    return @"Si vous aimez jouer à Raildale,\n"
        "cela vous dérangerait-il  de prendre un moment pour l’évaluer?\n"
        "Cela ne prendra pas plus d'une minute.\n"
        "\n"
        "Si vous êtes confronté à un problème, veuillez me le signaler.\n"
        "Je vais essayer de le corriger dès que possible\n"
        "\n"
        "Merci pour votre soutien !\n"
        "Cordialement, Anton Zherdev, développeur";
}

- (NSString*)rateNow {
    return @"Évaluez-le maintenant";
}

- (NSString*)rateProblem {
    return @"Signalez un problème";
}

- (NSString*)rateLater {
    return @"Rappelez-moi plus tard";
}

- (NSString*)rateClose {
    return @"Non, merci";
}

- (NSString*)helpConnectTwoCities {
    return [NSString stringWithFormat:@"Connectez deux villes par le train.\n"
        "%@", ((egPlatform().touch) ? @"Peignez les rails à l'aide de votre doigt." : @"Utilisez une souris ou déplacez deux doigts sur un écran tactile.")];
}

- (NSString*)helpRules {
    return @"Ne laissez pas le solde du compte tomber plus bas que zéro.\n"
        "Restez dans le temps imparti\n"
        "avec un solde positif pour gagner un niveau.";
}

- (NSString*)helpNewCity {
    return @"Parfois, de nouvelles villes apparaissent.\n"
        "Connectez-les à votre chemin de fer.";
}

- (NSString*)helpTrainTo:(NSString*)to {
    return @"Vous pouvez reconnaître la direction de la gare par la couleur.";
}

- (NSString*)helpTrainWithSwitchesTo:(NSString*)to {
    return [NSString stringWithFormat:@"Tournez  les commutateurs du chemin de fer à l'aide d'un%@,\n"
        "pour que le train arrive à la ville de destination.", ((egPlatform().touch) ? @" tap" : @" click")];
}

- (NSString*)helpExpressTrain {
    return @"Il s'agit d'un train express très rapide.\n"
        "Il n'a pas le temps de s'arrêter devant un commutateur.\n"
        "Dans ce cas, le train sera détruit.\n"
        "Mais vous pouvez utiliser les lumières pour conduire le train.";
}

- (NSString*)helpToMakeZoom {
    return @"Vous pouvez modifier l'échelle avec un pincement.";
}

- (NSString*)helpInZoom {
    return @"Utilisez un doigt pour scroll.\n"
        "Appuyez sur le bouton du marteau au top pour construire des rails.\n"
        "Appuyez encore pour revenir au mode scroll.";
}

- (NSString*)helpSporadicDamage {
    return @"Parfois les rails peuvent être brisés.";
}

- (NSString*)helpDamage {
    return @"Appelez le train de service en utilisant\n"
        "l'un des boutons pour réparer les dégâts.\n"
        "C’est préférable d'appeler le train\n"
        "de la ville la plus proche du dégât.";
}

- (NSString*)helpCrazy {
    return @"L'ingénieur du train est fou.\n"
        "Il ne fait pas attention aux lumières ou aux commutateurs fermés.\n"
        "Envoyer ce train dans n'importe quelle ville.";
}

- (NSString*)helpRepairer {
    return @"Menez le train de service à travers les dégâts\n"
        "et envoyez-le vers n'importe quelle ville.";
}

- (NSString*)buyButton {
    return @"Acheter des rembobinage";
}

- (NSString*)rewind {
    return @"Rembobine";
}

- (NSString*)helpRewind {
    return @"Utilisez le rembobinage pour vous aider dans les moments difficiles.\n"
        "Appuyez sur le bouton d'rembobinage dans le coin en haut à droite de l'écran.\n"
        "Un petit nombre d'utilisations sont restaurées chaque jour.\n"
        "Si vous voulez rendre le jeu plus facile,\n"
        "vous pouvez acheter des rembobinage supplémentaires\n"
        "ou les obtenir gratis pour le partage du jeu sur Facebook ou sur Twitter.\n"
        "Mais il est possible de s'en passer.";
}

- (NSString*)linesAdvice {
    return @"Vous pouvez vous connecter  des villes avec plus d'une ligne.\n"
        "Ainsi deux trains venant de directions opposées ne se heurteront pas.";
}

- (NSString*)result {
    return @"Score";
}

- (NSString*)best {
    return @"Votre meilleur";
}

- (NSString*)topScore:(EGLocalPlayerScore*)score {
    if(score.rank == 1) {
        return @"Le 1er meilleur classement!";
    } else {
        if(score.rank == 2) {
            return @"Le 2e meilleur classement!";
        } else {
            if(score.rank == 3) {
                return @"Le 3e meilleur classement!";
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
                                if(p <= 50) return @"Mieux que la moyenne";
                                else return @"Pire que la moyenne";
                            }
                        }
                    }
                }
            }
        }
    }
}

- (NSString*)leaderboard {
    return @"Les meilleurs résultats";
}

- (NSString*)shareSubject {
    return @"Raildale est un grand jeu pour iOS et Mac";
}

- (NSString*)shareTextUrl:(NSString*)url {
    return [NSString stringWithFormat:@"Raildale est un jeu passionnant de construction de chemin de fer pour iOS et Mac OS X: %@", url];
}

- (NSString*)twitterTextUrl:(NSString*)url {
    return [NSString stringWithFormat:@"%@: @RaildaleGame est un jeu de construction de chemin de fer pour iOS et Mac", url];
}

- (ODClassType*)type {
    return [TRFrStrings type];
}

+ (ODClassType*)type {
    return _TRFrStrings_type;
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


