#import "objd.h"
#import "GEVec.h"
@class CNChain;

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
float egCameraReserveWidth(EGCameraReserve self);
float egCameraReserveHeight(EGCameraReserve self);
EGCameraReserve egCameraReserveMulF4(EGCameraReserve self, float f4);
EGCameraReserve egCameraReserveDivF4(EGCameraReserve self, float f4);
NSString* egCameraReserveDescription(EGCameraReserve self);
BOOL egCameraReserveIsEqualTo(EGCameraReserve self, EGCameraReserve to);
NSUInteger egCameraReserveHash(EGCameraReserve self);
CNPType* egCameraReserveType();
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
- (CNClassType*)type;
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
- (NSString*)description;
+ (CGFloat)ISO;
+ (CNClassType*)type;
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
NSString* egMapTileCutStateDescription(EGMapTileCutState self);
BOOL egMapTileCutStateIsEqualTo(EGMapTileCutState self, EGMapTileCutState to);
NSUInteger egMapTileCutStateHash(EGMapTileCutState self);
CNPType* egMapTileCutStateType();
@interface EGMapTileCutStateWrap : NSObject
@property (readonly, nonatomic) EGMapTileCutState value;

+ (id)wrapWithValue:(EGMapTileCutState)value;
- (id)initWithValue:(EGMapTileCutState)value;
@end



