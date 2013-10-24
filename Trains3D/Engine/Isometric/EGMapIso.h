#import "objd.h"
#import "GEVec.h"

@class EGMapSso;
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
- (BOOL)isVisibleTile:(GEVec2i)tile;
- (BOOL)isVisibleVec2:(GEVec2)vec2;
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



