#import "objd.h"
#import "EGScene.h"
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

@interface TRForestRules : NSObject
@property (nonatomic, readonly) TRForestType* forestType;
@property (nonatomic, readonly) CGFloat thickness;

+ (id)forestRulesWithForestType:(TRForestType*)forestType thickness:(CGFloat)thickness;
- (id)initWithForestType:(TRForestType*)forestType thickness:(CGFloat)thickness;
- (ODClassType*)type;
+ (ODClassType*)type;
@end


@interface TRForest : NSObject<EGUpdatable>
@property (nonatomic, readonly) EGMapSso* map;
@property (nonatomic, readonly) TRForestRules* rules;
@property (nonatomic, readonly) TRWeather* weather;

+ (id)forestWithMap:(EGMapSso*)map rules:(TRForestRules*)rules weather:(TRWeather*)weather;
- (id)initWithMap:(EGMapSso*)map rules:(TRForestRules*)rules weather:(TRWeather*)weather;
- (ODClassType*)type;
- (id<CNIterable>)trees;
- (void)cutDownTile:(GEVec2i)tile;
- (void)cutDownForRail:(TRRail*)rail;
- (void)cutDownForASwitch:(TRSwitch*)aSwitch;
- (void)cutDownForLight:(TRRailLight*)light;
- (void)cutDownRect:(GERect)rect;
- (void)updateWithDelta:(CGFloat)delta;
+ (ODClassType*)type;
@end


@interface TRTree : NSObject<ODComparable>
@property (nonatomic, readonly) TRTreeType* treeType;
@property (nonatomic, readonly) GEVec2 position;
@property (nonatomic, readonly) GEVec2 size;
@property (nonatomic, readonly) NSInteger z;
@property (nonatomic, readonly) CGFloat rigidity;
@property (nonatomic) CGFloat rustle;
@property (nonatomic, readonly) id body;

+ (id)treeWithTreeType:(TRTreeType*)treeType position:(GEVec2)position size:(GEVec2)size;
- (id)initWithTreeType:(TRTreeType*)treeType position:(GEVec2)position size:(GEVec2)size;
- (ODClassType*)type;
- (NSInteger)compareTo:(TRTree*)to;
- (GEVec2)incline;
- (void)updateWithWind:(GEVec2)wind delta:(CGFloat)delta;
- (void)cutDown;
+ (CNNotificationHandle*)cutDownNotification;
+ (ODClassType*)type;
@end


@interface TRForestType : ODEnum
@property (nonatomic, readonly) id<CNSeq> treeTypes;

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


