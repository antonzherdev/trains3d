#import <Foundation/Foundation.h>
#import "TRTypes.h"
#import "EGTypes.h"
#import "EGMap.h"

@interface TRCity : NSObject
@property (nonatomic, readonly) TRColor* color;
@property (nonatomic, readonly) EGTilePoint tile;

+ (id)cityWithColor:(TRColor*)color tile:(EGTilePoint)tile;
- (id)initWithColor:(TRColor*)color tile:(EGTilePoint)tile;
@end


