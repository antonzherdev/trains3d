#import "objd.h"
#import "GEVec.h"

@class EGMapSso;
typedef struct EGCameraReserve EGCameraReserve;
typedef struct EGMapTileCutState EGMapTileCutState;

struct EGCameraReserve {
    float left;
    float right;
    float top;
    float bottom;
};
static inline EGCameraReserve EGCameraReserveMake(float left, float right, float top, float bottom) {
    return (EGCameraReserve){left, right, top, bottom};
}
static inline BOOL EGCameraReserveEq(EGCameraReserve s1, EGCameraReserve s2) {
    return eqf4(s1.left, s2.left) && eqf4(s1.right, s2.right) && eqf4(s1.top, s2.top) && eqf4(s1.bottom, s2.bottom);
}
static inline NSUInteger EGCameraReserveHash(EGCameraReserve self) {
    NSUInteger hash = 0;
    hash = hash * 31 + float4Hash(self.left);
    hash = hash * 31 + float4Hash(self.right);
    hash = hash * 31 + float4Hash(self.top);
    hash = hash * 31 + float4Hash(self.bottom);
    return hash;
}
NSString* EGCameraReserveDescription(EGCameraReserve self);
float egCameraReserveWidth(EGCameraReserve self);
float egCameraReserveHeight(EGCameraReserve self);
EGCameraReserve egCameraReserveMulF4(EGCameraReserve self, float f4);
EGCameraReserve egCameraReserveDivF4(EGCameraReserve self, float f4);
ODPType* egCameraReserveType();
@interface EGCameraReserveWrap : NSObject
@property (readonly, nonatomic) EGCameraReserve value;

+ (id)wrapWithValue:(EGCameraReserve)value;
- (id)initWithValue:(EGCameraReserve)value;
@end



@interface EGMapSso : NSObject {
@protected
    GEVec2i _size;
    GERectI _limits;
    NSArray* _fullTiles;
    NSArray* _partialTiles;
    NSArray* _allTiles;
}
@property (nonatomic, readonly) GEVec2i size;
@property (nonatomic, readonly) GERectI limits;
@property (nonatomic, readonly) NSArray* fullTiles;
@property (nonatomic, readonly) NSArray* partialTiles;
@property (nonatomic, readonly) NSArray* allTiles;

+ (instancetype)mapSsoWithSize:(GEVec2i)size;
- (instancetype)initWithSize:(GEVec2i)size;
- (ODClassType*)type;
- (BOOL)isFullTile:(GEVec2i)tile;
- (BOOL)isPartialTile:(GEVec2i)tile;
- (BOOL)isLeftTile:(GEVec2i)tile;
- (BOOL)isTopTile:(GEVec2i)tile;
- (BOOL)isRightTile:(GEVec2i)tile;
- (BOOL)isBottomTile:(GEVec2i)tile;
- (BOOL)isVisibleTile:(GEVec2i)tile;
- (BOOL)isVisibleVec2:(GEVec2)vec2;
- (GEVec2)distanceToMapVec2:(GEVec2)vec2;
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



