#import "objd.h"
#import "TRTypes.h"
#import "EGTypes.h"
#import "EGMap.h"

@class TRCity;

@interface TRCity : NSObject
@property (nonatomic, readonly) TRColor* color;
@property (nonatomic, readonly) EGMapPoint tile;
@property (nonatomic, readonly) NSInteger angle;

+ (id)cityWithColor:(TRColor*)color tile:(EGMapPoint)tile angle:(NSInteger)angle;
- (id)initWithColor:(TRColor*)color tile:(EGMapPoint)tile angle:(NSInteger)angle;
@end


