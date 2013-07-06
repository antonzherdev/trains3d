#import "objd.h"
#import "EGTypes.h"
#import "TRTypes.h"
@class TRCity;
@class TRLevel;

@class TRTrain;
@class TRCar;

@interface TRTrain : NSObject
@property (nonatomic, readonly, weak) TRLevel* level;
@property (nonatomic, readonly) TRColor* color;
@property (nonatomic, readonly) NSArray* cars;
@property (nonatomic, readonly) CGFloat speed;
@property (nonatomic) CGPoint head;

+ (id)trainWithLevel:(TRLevel*)level color:(TRColor*)color cars:(NSArray*)cars speed:(CGFloat)speed;
- (id)initWithLevel:(TRLevel*)level color:(TRColor*)color cars:(NSArray*)cars speed:(CGFloat)speed;
- (void)startFromCity:(TRCity*)city;
@end


@interface TRCar : NSObject
@property (nonatomic) CGPoint head;
@property (nonatomic) CGPoint tail;

+ (id)car;
- (id)init;
- (CGFloat)length;
@end


