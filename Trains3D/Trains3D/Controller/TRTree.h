#import "objd.h"
#import "GEVec.h"
#import "CNActor.h"
#import "TRRailPoint.h"
@class EGPlatform;
@class EGOS;
@class EGMapSso;
@class TRWeather;
@class CNSignal;
@class CNFuture;
@class CNChain;
@class TRRail;
@class TRSwitch;
@class TRRailLight;
@class EGRigidBody;
@class EGCollisionBox;
@class GEMat4;

@class TRForestRules;
@class TRForest;
@class TRTree;
@class TRTreeType;
@class TRForestType;

typedef enum TRTreeTypeR {
    TRTreeType_Nil = 0,
    TRTreeType_Pine = 1,
    TRTreeType_SnowPine = 2,
    TRTreeType_Leaf = 3,
    TRTreeType_WeakLeaf = 4,
    TRTreeType_Palm = 5
} TRTreeTypeR;
@interface TRTreeType : CNEnum
@property (nonatomic, readonly) GERect uv;
@property (nonatomic, readonly) CGFloat scale;
@property (nonatomic, readonly) CGFloat rustleStrength;
@property (nonatomic, readonly) BOOL collisions;
@property (nonatomic, readonly) GEQuad uvQuad;
@property (nonatomic, readonly) GEVec2 size;

+ (NSArray*)values;
@end
static TRTreeType* TRTreeType_Values[5];
static TRTreeType* TRTreeType_Pine_Desc;
static TRTreeType* TRTreeType_SnowPine_Desc;
static TRTreeType* TRTreeType_Leaf_Desc;
static TRTreeType* TRTreeType_WeakLeaf_Desc;
static TRTreeType* TRTreeType_Palm_Desc;


typedef enum TRForestTypeR {
    TRForestType_Nil = 0,
    TRForestType_Pine = 1,
    TRForestType_Leaf = 2,
    TRForestType_SnowPine = 3,
    TRForestType_Palm = 4
} TRForestTypeR;
@interface TRForestType : CNEnum
@property (nonatomic, readonly) NSArray* treeTypes;

+ (NSArray*)values;
@end
static TRForestType* TRForestType_Values[4];
static TRForestType* TRForestType_Pine_Desc;
static TRForestType* TRForestType_Leaf_Desc;
static TRForestType* TRForestType_SnowPine_Desc;
static TRForestType* TRForestType_Palm_Desc;


@interface TRForestRules : NSObject {
@protected
    TRForestTypeR _forestType;
    CGFloat _thickness;
}
@property (nonatomic, readonly) TRForestTypeR forestType;
@property (nonatomic, readonly) CGFloat thickness;

+ (instancetype)forestRulesWithForestType:(TRForestTypeR)forestType thickness:(CGFloat)thickness;
- (instancetype)initWithForestType:(TRForestTypeR)forestType thickness:(CGFloat)thickness;
- (CNClassType*)type;
- (NSString*)description;
- (BOOL)isEqual:(id)to;
- (NSUInteger)hash;
+ (CNClassType*)type;
@end


@interface TRForest : CNActor {
@protected
    EGMapSso* _map;
    TRForestRules* _rules;
    TRWeather* _weather;
    NSArray* __trees;
    NSUInteger __treesCount;
    CNSignal* _stateWasRestored;
    CNSignal* _treeWasCutDown;
}
@property (nonatomic, readonly) EGMapSso* map;
@property (nonatomic, readonly) TRForestRules* rules;
@property (nonatomic, readonly) TRWeather* weather;
@property (nonatomic, readonly) CNSignal* stateWasRestored;
@property (nonatomic, readonly) CNSignal* treeWasCutDown;

+ (instancetype)forestWithMap:(EGMapSso*)map rules:(TRForestRules*)rules weather:(TRWeather*)weather;
- (instancetype)initWithMap:(EGMapSso*)map rules:(TRForestRules*)rules weather:(TRWeather*)weather;
- (CNClassType*)type;
- (CNFuture*)restoreTrees:(NSArray*)trees;
- (void)_init;
- (CNFuture*)trees;
- (NSUInteger)treesCount;
- (CNFuture*)cutDownTile:(GEVec2i)tile;
- (CNFuture*)cutDownForRail:(TRRail*)rail;
- (CNFuture*)cutDownForASwitch:(TRSwitch*)aSwitch;
- (CNFuture*)cutDownForLight:(TRRailLight*)light;
- (CNFuture*)updateWithDelta:(CGFloat)delta;
- (NSString*)description;
+ (CNClassType*)type;
@end


@interface TRTree : NSObject<CNComparable> {
@protected
    TRTreeTypeR _treeType;
    GEVec2 _position;
    GEVec2 _size;
    NSInteger _z;
    CGFloat _rigidity;
    BOOL __rustleUp;
    CGFloat _rustle;
    GEVec2 __incline;
    BOOL __inclineUp;
    EGRigidBody* _body;
}
@property (nonatomic, readonly) TRTreeTypeR treeType;
@property (nonatomic, readonly) GEVec2 position;
@property (nonatomic, readonly) GEVec2 size;
@property (nonatomic, readonly) NSInteger z;
@property (nonatomic, readonly) CGFloat rigidity;
@property (nonatomic) CGFloat rustle;
@property (nonatomic, readonly) EGRigidBody* body;

+ (instancetype)treeWithTreeType:(TRTreeTypeR)treeType position:(GEVec2)position size:(GEVec2)size;
- (instancetype)initWithTreeType:(TRTreeTypeR)treeType position:(GEVec2)position size:(GEVec2)size;
- (CNClassType*)type;
- (NSInteger)compareTo:(TRTree*)to;
- (GEVec2)incline;
- (void)updateWithWind:(GEVec2)wind delta:(CGFloat)delta;
- (NSString*)description;
+ (CNClassType*)type;
@end


