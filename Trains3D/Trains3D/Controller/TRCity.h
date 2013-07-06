#import "objd.h"
#import "TRTypes.h"
#import "EGTypes.h"

@class TRCity;

@interface TRCity : NSObject
@property (nonatomic, readonly) TRColor* color;
@property (nonatomic, readonly) EGIPoint tile;
@property (nonatomic, readonly) NSInteger angle;

+ (id)cityWithColor:(TRColor*)color tile:(EGIPoint)tile angle:(NSInteger)angle;
- (id)initWithColor:(TRColor*)color tile:(EGIPoint)tile angle:(NSInteger)angle;
@end


