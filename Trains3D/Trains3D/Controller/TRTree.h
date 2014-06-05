#import "objd.h"
#import "PGVec.h"
#import "CNActor.h"
#import "TRRailPoint.h"
@class PGPlatform;
@class PGOS;
@class PGMapSso;
@class TRWeather;
@class CNSignal;
@class CNFuture;
@class CNChain;
@class TRRail;
@class TRSwitch;
@class TRRailLight;
@class PGRigidBody;
@class PGCollisionBox;
@class PGMat4;

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
@property (nonatomic, readonly) PGRect uv;
@property (nonatomic, readonly) CGFloat scale;
@property (nonatomic, readonly) CGFloat rustleStrength;
@property (nonatomic, readonly) BOOL collisions;
@property (nonatomic, readonly) PGQuad uvQuad;
@property (nonatomic, readonly) PGVec2 size;

+ (NSArray*)values;
+ (TRTreeType*)value:(TRTreeTypeR)r;
@end


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
+ (TRForestType*)value:(TRForestTypeR)r;
@end


@interface TRForestRules : NSObject {
@public
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
@public
    PGMapSso* _map;
    TRForestRules* _rules;
    TRWeather* _weather;
    NSArray* __trees;
    NSUInteger __treesCount;
    CNSignal* _stateWasRestored;
    CNSignal* _treeWasCutDown;
}
@property (nonatomic, readonly) PGMapSso* map;
@property (nonatomic, readonly) TRForestRules* rules;
@property (nonatomic, readonly) TRWeather* weather;
@property (nonatomic, readonly) CNSignal* stateWasRestored;
@property (nonatomic, readonly) CNSignal* treeWasCutDown;

+ (instancetype)forestWithMap:(PGMapSso*)map rules:(TRForestRules*)rules weather:(TRWeather*)weather;
- (instancetype)initWithMap:(PGMapSso*)map rules:(TRForestRules*)rules weather:(TRWeather*)weather;
- (CNClassType*)type;
- (CNFuture*)restoreTrees:(NSArray*)trees;
- (void)_init;
- (CNFuture*)trees;
- (NSUInteger)treesCount;
- (CNFuture*)cutDownTile:(PGVec2i)tile;
- (CNFuture*)cutDownForRail:(TRRail*)rail;
- (CNFuture*)cutDownForASwitch:(TRSwitch*)aSwitch;
- (CNFuture*)cutDownForLight:(TRRailLight*)light;
- (CNFuture*)updateWithDelta:(CGFloat)delta;
- (NSString*)description;
+ (CNClassType*)type;
@end


@interface TRTree : NSObject<CNComparable> {
@public
    TRTreeTypeR _treeType;
    PGVec2 _position;
    PGVec2 _size;
    NSInteger _z;
    CGFloat _rigidity;
    BOOL __rustleUp;
    CGFloat _rustle;
    PGVec2 __incline;
    BOOL __inclineUp;
    PGRigidBody* _body;
}
@property (nonatomic, readonly) TRTreeTypeR treeType;
@property (nonatomic, readonly) PGVec2 position;
@property (nonatomic, readonly) PGVec2 size;
@property (nonatomic, readonly) NSInteger z;
@property (nonatomic, readonly) CGFloat rigidity;
@property (nonatomic) CGFloat rustle;
@property (nonatomic, readonly) PGRigidBody* body;

+ (instancetype)treeWithTreeType:(TRTreeTypeR)treeType position:(PGVec2)position size:(PGVec2)size;
- (instancetype)initWithTreeType:(TRTreeTypeR)treeType position:(PGVec2)position size:(PGVec2)size;
- (CNClassType*)type;
- (NSInteger)compareTo:(TRTree*)to;
- (PGVec2)incline;
- (void)updateWithWind:(PGVec2)wind delta:(CGFloat)delta;
- (NSString*)description;
+ (CNClassType*)type;
@end


