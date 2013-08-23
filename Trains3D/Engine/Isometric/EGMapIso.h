#import "objd.h"
@class CNChain;
#import "CNRange.h"
#import "EGTypes.h"
@class EGBuffer;

@class EGMapSso;
@class EGMapSsoView;

@interface EGMapSso : NSObject
@property (nonatomic, readonly) EGSizeI size;
@property (nonatomic, readonly) EGRectI limits;
@property (nonatomic, readonly) id<CNSeq> fullTiles;
@property (nonatomic, readonly) id<CNSeq> partialTiles;
@property (nonatomic, readonly) id<CNSeq> allTiles;

+ (id)mapSsoWithSize:(EGSizeI)size;
- (id)initWithSize:(EGSizeI)size;
- (BOOL)isFullTile:(EGPointI)tile;
- (BOOL)isPartialTile:(EGPointI)tile;
- (EGRectI)cutRectForTile:(EGPointI)tile;
+ (CGFloat)ISO;
@end


@interface EGMapSsoView : NSObject
@property (nonatomic, readonly) EGMapSso* map;

+ (id)mapSsoViewWithMap:(EGMapSso*)map;
- (id)initWithMap:(EGMapSso*)map;
- (void)drawLayout;
- (void)drawPlane;
@end


