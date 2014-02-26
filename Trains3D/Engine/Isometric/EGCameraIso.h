#import "objd.h"
#import "EGScene.h"
#import "GEVec.h"
#import "EGInput.h"
@class EGMapSso;
@class GEMat4;
@class EGMatrixModel;
@class EGImMatrixModel;
@class EGDirector;

@class EGCameraIso;
@class EGCameraIsoMove;
typedef struct EGCameraReserve EGCameraReserve;

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



@interface EGCameraIso : NSObject<EGCamera>
@property (nonatomic, readonly) GEVec2 tilesOnScreen;
@property (nonatomic, readonly) EGCameraReserve reserve;
@property (nonatomic, readonly) CGFloat viewportRatio;
@property (nonatomic, readonly) GEVec2 center;
@property (nonatomic, readonly) EGMatrixModel* matrixModel;

+ (instancetype)cameraIsoWithTilesOnScreen:(GEVec2)tilesOnScreen reserve:(EGCameraReserve)reserve viewportRatio:(CGFloat)viewportRatio center:(GEVec2)center;
- (instancetype)initWithTilesOnScreen:(GEVec2)tilesOnScreen reserve:(EGCameraReserve)reserve viewportRatio:(CGFloat)viewportRatio center:(GEVec2)center;
- (ODClassType*)type;
+ (EGCameraIso*)applyTilesOnScreen:(GEVec2)tilesOnScreen reserve:(EGCameraReserve)reserve viewportRatio:(CGFloat)viewportRatio;
- (NSUInteger)cullFace;
- (GEVec2)naturalCenter;
+ (GEMat4*)m;
+ (GEMat4*)w;
+ (ODClassType*)type;
@end


@interface EGCameraIsoMove : NSObject<EGInputProcessor>
@property (nonatomic, readonly) EGCameraIso* base;
@property (nonatomic, readonly) CGFloat misScale;
@property (nonatomic, readonly) CGFloat maxScale;
@property (nonatomic, readonly) NSUInteger panFingers;
@property (nonatomic, readonly) NSUInteger tapFingers;
@property (nonatomic) BOOL panEnabled;
@property (nonatomic) BOOL tapEnabled;
@property (nonatomic) BOOL pinchEnabled;

+ (instancetype)cameraIsoMoveWithBase:(EGCameraIso*)base misScale:(CGFloat)misScale maxScale:(CGFloat)maxScale panFingers:(NSUInteger)panFingers tapFingers:(NSUInteger)tapFingers;
- (instancetype)initWithBase:(EGCameraIso*)base misScale:(CGFloat)misScale maxScale:(CGFloat)maxScale panFingers:(NSUInteger)panFingers tapFingers:(NSUInteger)tapFingers;
- (ODClassType*)type;
- (EGCameraIso*)camera;
- (CGFloat)scale;
- (void)setScale:(CGFloat)scale;
- (GEVec2)center;
- (void)setCenter:(GEVec2)center;
- (CGFloat)viewportRatio;
- (void)setViewportRatio:(CGFloat)viewportRatio;
- (EGCameraReserve)reserve;
- (void)setReserve:(EGCameraReserve)reserve;
- (EGRecognizers*)recognizers;
+ (CNNotificationHandle*)cameraChangedNotification;
+ (ODClassType*)type;
@end


