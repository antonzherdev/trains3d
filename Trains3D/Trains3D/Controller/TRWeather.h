#import "objd.h"
#import "EGScene.h"
#import "GEVec.h"

@class TRWeatherRules;
@class TRWeather;

@interface TRWeatherRules : NSObject
@property (nonatomic, readonly) CGFloat windStrength;

+ (id)weatherRulesWithWindStrength:(CGFloat)windStrength;
- (id)initWithWindStrength:(CGFloat)windStrength;
- (ODClassType*)type;
+ (ODClassType*)type;
@end


@interface TRWeather : NSObject<EGController>
@property (nonatomic, readonly) TRWeatherRules* rules;

+ (id)weatherWithRules:(TRWeatherRules*)rules;
- (id)initWithRules:(TRWeatherRules*)rules;
- (ODClassType*)type;
- (GEVec3)wind;
- (void)updateWithDelta:(CGFloat)delta;
+ (ODClassType*)type;
@end


