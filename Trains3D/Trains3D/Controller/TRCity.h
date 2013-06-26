#import "objd.h"
#import "TRTypes.h"
#import "EGTypes.h"
#import "EGMap.h"

@interface TRCity : NSObject
@property (nonatomic, readonly) TRColor* color;
@property (nonatomic, readonly) EGMapPoint tile;

+ (id)cityWithColor:(TRColor*)color tile:(EGMapPoint)tile;
- (id)initWithColor:(TRColor*)color tile:(EGMapPoint)tile;
@end


