#import <Foundation/Foundation.h>

@protocol ODComparable<NSObject>
- (NSInteger)compareTo:(id)to;
@end

@interface NSNumber(ODObject)<ODComparable>
- (NSInteger)compareTo:(id)to;
@end