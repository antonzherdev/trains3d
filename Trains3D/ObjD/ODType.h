#import <Foundation/Foundation.h>

@class ODType;

@interface ODType : NSObject
@property (nonatomic, readonly) Class cls;

+ (id)typeWithCls:(Class)cls;
- (id)initWithCls:(Class)cls;
- (NSString*)name;
- (NSString*)description;
- (NSUInteger)hash;
@end


