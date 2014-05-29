#import "objd.h"
#import "iRate.h"

@class EGRate;

@interface EGRate : NSObject<iRateDelegate>
+ (id)rate;
- (id)init;
- (CNClassType*)type;
- (BOOL)isRated;
- (BOOL)isRatedThisVersion;
- (void)showRate;
+ (EGRate*)instance;

- (void)later;

+ (CNClassType*)type;

- (void)never;

- (BOOL)shouldShowEveryVersion:(BOOL)everyVersion;

- (void)setIdsIos:(NSUInteger)ios osx:(NSUInteger)osx;
@end


