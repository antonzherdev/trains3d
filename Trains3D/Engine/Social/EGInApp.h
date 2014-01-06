#import "objd.h"

@class EGInAppProduct;

@interface EGInAppProduct : NSObject
@property (nonatomic, readonly) NSString* id;
@property (nonatomic, readonly) NSString* name;
@property (nonatomic, readonly) NSString* price;

+ (id)inAppProductWithId:(NSString*)id name:(NSString*)name price:(NSString*)price;
- (id)initWithId:(NSString*)id name:(NSString*)name price:(NSString*)price;
- (ODClassType*)type;
+ (ODClassType*)type;
@end


