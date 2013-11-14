#import "objd.h"
@class TRPrecipitation;
@class TRPrecipitationType;

@class TRPrecipitationView;
@class TRRainView;

@interface TRPrecipitationView : NSObject
+ (id)precipitationView;
- (id)init;
- (ODClassType*)type;
+ (TRPrecipitationView*)applyPrecipitation:(TRPrecipitation*)precipitation;
- (void)draw;
+ (ODClassType*)type;
@end


@interface TRRainView : TRPrecipitationView
@property (nonatomic, readonly) CGFloat strength;

+ (id)rainViewWithStrength:(CGFloat)strength;
- (id)initWithStrength:(CGFloat)strength;
- (ODClassType*)type;
- (void)draw;
+ (ODClassType*)type;
@end


