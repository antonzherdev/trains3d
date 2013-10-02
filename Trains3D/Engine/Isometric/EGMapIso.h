#import "objd.h"
#import "GEVec.h"
@class EGVertexBuffer;
@class EGCameraIso;
@class GEMat4;
@class EGMesh;
@class EGColorSource;
@class EGMaterial;

@class EGMapSso;
@class EGMapSsoView;
typedef struct EGMapTileCutState EGMapTileCutState;

@interface EGMapSso : NSObject
@property (nonatomic, readonly) GEVec2i size;
@property (nonatomic, readonly) GERectI limits;
@property (nonatomic, readonly) id<CNSeq> fullTiles;
@property (nonatomic, readonly) id<CNSeq> partialTiles;
@property (nonatomic, readonly) id<CNSeq> allTiles;

+ (id)mapSsoWithSize:(GEVec2i)size;
- (id)initWithSize:(GEVec2i)size;
- (ODClassType*)type;
- (BOOL)isFullTile:(GEVec2i)tile;
- (BOOL)isPartialTile:(GEVec2i)tile;
- (EGMapTileCutState)cutStateForTile:(GEVec2i)tile;
+ (CGFloat)ISO;
+ (ODClassType*)type;
@end


struct EGMapTileCutState {
    NSInteger x;
    NSInteger y;
    NSInteger x2;
    NSInteger y2;
};
static inline EGMapTileCutState EGMapTileCutStateMake(NSInteger x, NSInteger y, NSInteger x2, NSInteger y2) {
    return (EGMapTileCutState){x, y, x2, y2};
}
static inline BOOL EGMapTileCutStateEq(EGMapTileCutState s1, EGMapTileCutState s2) {
    return s1.x == s2.x && s1.y == s2.y && s1.x2 == s2.x2 && s1.y2 == s2.y2;
}
static inline NSUInteger EGMapTileCutStateHash(EGMapTileCutState self) {
    NSUInteger hash = 0;
    hash = hash * 31 + self.x;
    hash = hash * 31 + self.y;
    hash = hash * 31 + self.x2;
    hash = hash * 31 + self.y2;
    return hash;
}
NSString* EGMapTileCutStateDescription(EGMapTileCutState self);
ODPType* egMapTileCutStateType();
@interface EGMapTileCutStateWrap : NSObject
@property (readonly, nonatomic) EGMapTileCutState value;

+ (id)wrapWithValue:(EGMapTileCutState)value;
- (id)initWithValue:(EGMapTileCutState)value;
@end



@interface EGMapSsoView : NSObject
@property (nonatomic, readonly) EGMapSso* map;
@property (nonatomic, readonly) EGMesh* plane;

+ (id)mapSsoViewWithMap:(EGMapSso*)map;
- (id)initWithMap:(EGMapSso*)map;
- (ODClassType*)type;
- (EGVertexBuffer*)axisVertexBuffer;
- (void)drawLayout;
- (void)drawPlaneWithMaterial:(EGMaterial*)material;
+ (ODClassType*)type;
@end


