#import "objd.h"
#import "EGScene.h"
#import "GEVec.h"
@class EGMapSso;
@class TRWeather;
@class TRRail;
@class TRRailForm;
@class TRRailConnector;
@class TRSwitch;

@class TRForestRules;
@class TRForest;
@class TRTree;
@class TRTreeType;

@interface TRForestRules : NSObject
@property (nonatomic, readonly) TRTreeType* treeType;
@property (nonatomic, readonly) CGFloat thickness;

+ (id)forestRulesWithTreeType:(TRTreeType*)treeType thickness:(CGFloat)thickness;
- (id)initWithTreeType:(TRTreeType*)treeType thickness:(CGFloat)thickness;
- (ODClassType*)type;
+ (ODClassType*)type;
@end


@interface TRForest : NSObject<EGController>
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
- (void)cutDownRect:(GERect)rect;
- (void)updateWithDelta:(CGFloat)delta;
+ (ODClassType*)type;
@end


@interface TRTree : NSObject<ODComparable>
@property (nonatomic, readonly) GEVec2 position;
@property (nonatomic, readonly) GEVec2 size;
@property (nonatomic, readonly) NSInteger z;
@property (nonatomic, readonly) CGFloat rigidity;
@property (nonatomic) CGFloat rustle;

+ (id)treeWithPosition:(GEVec2)position size:(GEVec2)size;
- (id)initWithPosition:(GEVec2)position size:(GEVec2)size;
- (ODClassType*)type;
- (NSInteger)compareTo:(TRTree*)to;
- (GEVec2)incline;
- (void)updateWithWind:(GEVec2)wind delta:(CGFloat)delta;
+ (ODClassType*)type;
@end


@interface TRTreeType : ODEnum
@property (nonatomic, readonly) CGFloat width;
@property (nonatomic, readonly) CGFloat height;

+ (TRTreeType*)Pine;
+ (TRTreeType*)SnowPine;
+ (NSArray*)values;
@end


