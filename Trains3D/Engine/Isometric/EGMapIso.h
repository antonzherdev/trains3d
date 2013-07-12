#import "objd.h"
#import "EGTypes.h"

@class EGMapSso;

@interface EGMapSso : NSObject
@property (nonatomic, readonly) EGISize size;
@property (nonatomic, readonly) EGIRect limits;
@property (nonatomic, readonly) NSArray* fullTiles;
@property (nonatomic, readonly) NSArray* partialTiles;

+ (id)mapSsoWithSize:(EGISize)size;
- (id)initWithSize:(EGISize)size;
- (BOOL)isFullTile:(EGIPoint)tile;
- (BOOL)isPartialTile:(EGIPoint)tile;
- (void)drawLayout;
- (void)drawPlane;
- (EGIRect)cutRectForTile:(EGIPoint)tile;
@end


