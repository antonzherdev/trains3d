#import "objd.h"
#import "EGTypes.h"
@class CNChain;
#import "CNRange.h"

@class EGMapSso;

@interface EGMapSso : NSObject
@property (nonatomic, readonly) EGSizeI size;
@property (nonatomic, readonly) EGRectI limits;
@property (nonatomic, readonly) id<CNList> fullTiles;
@property (nonatomic, readonly) id<CNList> partialTiles;
@property (nonatomic, readonly) id<CNList> allTiles;

+ (id)mapSsoWithSize:(EGSizeI)size;
- (id)initWithSize:(EGSizeI)size;
- (BOOL)isFullTile:(EGPointI)tile;
- (BOOL)isPartialTile:(EGPointI)tile;
- (void)drawLayout;
- (void)drawPlane;
- (EGRectI)cutRectForTile:(EGPointI)tile;
+ (CGFloat)ISO;
@end


