#import "objd.h"
#import "EGTypes.h"

@class EGMapSso;

@interface EGMapSso : NSObject
@property (nonatomic, readonly) EGSizeI size;
@property (nonatomic, readonly) EGRectI limits;
@property (nonatomic, readonly) NSArray* fullTiles;
@property (nonatomic, readonly) NSArray* partialTiles;

+ (id)mapSsoWithSize:(EGSizeI)size;
- (id)initWithSize:(EGSizeI)size;
- (BOOL)isFullTile:(EGPointI)tile;
- (BOOL)isPartialTile:(EGPointI)tile;
- (void)drawLayout;
- (void)drawPlane;
- (EGRectI)cutRectForTile:(EGPointI)tile;
@end


