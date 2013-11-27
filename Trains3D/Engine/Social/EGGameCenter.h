#import "objd.h"

@class EGLocalPlayerScore;

@interface EGLocalPlayerScore : NSObject
@property (nonatomic, readonly) long value;
@property (nonatomic, readonly) NSUInteger rank;
@property (nonatomic, readonly) NSUInteger maxRank;

+ (id)localPlayerScoreWithValue:(long)value rank:(NSUInteger)rank maxRank:(NSUInteger)maxRank;
- (id)initWithValue:(long)value rank:(NSUInteger)rank maxRank:(NSUInteger)maxRank;
- (ODClassType*)type;
- (CGFloat)percent;
+ (ODClassType*)type;
@end


