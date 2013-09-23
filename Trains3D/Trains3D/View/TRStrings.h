#import "objd.h"

@class TREnStrings;
@class TRRuStrings;
@class TRStr;
@protocol TRStrings;

@protocol TRStrings<NSObject>
- (NSString*)railBuiltCost:(NSInteger)cost;
- (NSString*)formatCost:(NSInteger)cost;
@end


@interface TREnStrings : NSObject<TRStrings>
+ (id)enStrings;
- (id)init;
- (ODClassType*)type;
- (NSString*)railBuiltCost:(NSInteger)cost;
+ (ODClassType*)type;
@end


@interface TRRuStrings : NSObject<TRStrings>
+ (id)ruStrings;
- (id)init;
- (ODClassType*)type;
- (NSString*)railBuiltCost:(NSInteger)cost;
+ (ODClassType*)type;
@end


@interface TRStr : NSObject
- (ODClassType*)type;
+ (id<TRStrings>)Strs;
+ (ODClassType*)type;
@end


