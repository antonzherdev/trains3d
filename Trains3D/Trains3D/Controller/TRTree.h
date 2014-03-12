#import "objd.h"
#import "ATActor.h"
#import "GEVec.h"
@class EGMapSso;
@class TRWeather;
@class TRRail;
@class TRRailForm;
@class TRRailConnector;
@class TRSwitch;
@class TRRailLight;
@class EGCollisionBox;
@class EGRigidBody;
@class GEMat4;
@class EGPlatform;

@class TRForestRules;
@class TRForest;
@class TRTree;
@class TRForestType;
@class TRTreeType;

@interface TRForestRules : NSObject {
@private
    TRForestType* _forestType;
    CGFloat _thickness;
}
@property (nonatomic, readonly) TRForestType* forestType;
@property (nonatomic, readonly) CGFloat thickness;

+ (instancetype)forestRulesWithForestType:(TRForestType*)forestType thickness:(CGFloat)thickness;
- (instancetype)initWithForestType:(TRForestType*)forestType thickness:(CGFloat)thickness;
- (ODClassType*)type;
+ (ODClassType*)type;
@end


@interface TRForest : ATActor {
@private
    EGMapSso* _map;
    TRForestRules* _rules;
    TRWeather* _weather;
    id<CNIterable> __trees;
    NSUInteger __treesCount;
}
@property (nonatomic, readonly) EGMapSso* map;
@property (nonatomic, readonly) TRForestRules* rules;
@property (nonatomic, readonly) TRWeather* weather;

+ (instancetype)forestWithMap:(EGMapSso*)map rules:(TRForestRules*)rules weather:(TRWeather*)weather;
- (instancetype)initWithMap:(EGMapSso*)map rules:(TRForestRules*)rules weather:(TRWeather*)weather;
- (ODClassType*)type;
- (void)_init;
- (CNFuture*)trees;
- (NSUInteger)treesCount;
- (CNFuture*)cutDownTile:(GEVec2i)tile;
- (CNFuture*)cutDownForRail:(TRRail*)rail;
- (CNFuture*)cutDownForASwitch:(TRSwitch*)aSwitch;
- (CNFuture*)cutDownForLight:(TRRailLight*)light;
- (CNFuture*)updateWithDelta:(CGFloat)delta;
+ (CNNotificationHandle*)cutDownNotification;
+ (ODClassType*)type;
@end


@interface TRTree : NSObject<ODComparable> {
@private
    TRTreeType* _treeType;
    GEVec2 _position;
    GEVec2 _size;
    NSInteger _z;
    CGFloat _rigidity;
    BOOL __rustleUp;
    CGFloat _rustle;
    GEVec2 __incline;
    BOOL __inclineUp;
    id _body;
}
@property (nonatomic, readonly) TRTreeType* treeType;
@property (nonatomic, readonly) GEVec2 position;
@property (nonatomic, readonly) GEVec2 size;
@property (nonatomic, readonly) NSInteger z;
@property (nonatomic, readonly) CGFloat rigidity;
@property (nonatomic) CGFloat rustle;
@property (nonatomic, readonly) id body;

+ (instancetype)treeWithTreeType:(TRTreeType*)treeType position:(GEVec2)position size:(GEVec2)size;
- (instancetype)initWithTreeType:(TRTreeType*)treeType position:(GEVec2)position size:(GEVec2)size;
- (ODClassType*)type;
- (NSInteger)compareTo:(TRTree*)to;
- (GEVec2)incline;
- (void)updateWithWind:(GEVec2)wind delta:(CGFloat)delta;
+ (ODClassType*)type;
@end


@interface TRForestType : ODEnum
@property (nonatomic, readonly) id<CNImSeq> treeTypes;

+ (TRForestType*)Pine;
+ (TRForestType*)Leaf;
+ (TRForestType*)SnowPine;
+ (TRForestType*)Palm;
+ (NSArray*)values;
@end


@interface TRTreeType : ODEnum
@property (nonatomic, readonly) GERect uv;
@property (nonatomic, readonly) CGFloat scale;
@property (nonatomic, readonly) CGFloat rustleStrength;
@property (nonatomic, readonly) BOOL collisions;
@property (nonatomic, readonly) GEQuad uvQuad;
@property (nonatomic, readonly) GEVec2 size;

+ (TRTreeType*)Pine;
+ (TRTreeType*)SnowPine;
+ (TRTreeType*)Leaf;
+ (TRTreeType*)WeakLeaf;
+ (TRTreeType*)Palm;
+ (NSArray*)values;
@end


