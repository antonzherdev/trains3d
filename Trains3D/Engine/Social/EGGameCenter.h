#import "objd.h"

@class EGLocalPlayerScore;

@interface EGLocalPlayerScore : NSObject {
@protected
    long _value;
    NSUInteger _rank;
    NSUInteger _maxRank;
}
@property (nonatomic, readonly) long value;
@property (nonatomic, readonly) NSUInteger rank;
@property (nonatomic, readonly) NSUInteger maxRank;

+ (instancetype)localPlayerScoreWithValue:(long)value rank:(NSUInteger)rank maxRank:(NSUInteger)maxRank;
- (instancetype)initWithValue:(long)value rank:(NSUInteger)rank maxRank:(NSUInteger)maxRank;
- (ODClassType*)type;
- (CGFloat)percent;
+ (ODClassType*)type;
@end


