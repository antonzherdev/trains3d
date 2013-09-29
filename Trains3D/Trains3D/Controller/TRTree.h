#import "objd.h"
#import "EGScene.h"
#import "GEVec.h"
@class EGMapSso;
@class TRWeather;
@class TRRail;
@class TRRailForm;
@class TRRailConnector;

@class TRForestRules;
@class TRForest;
@class TRTree;
@class TRTreeType;

@interface TRForestRules : NSObject
@property (nonatomic, readonly) id<CNSeq> types;
@property (nonatomic, readonly) CGFloat thickness;

+ (id)forestRulesWithTypes:(id<CNSeq>)types thickness:(CGFloat)thickness;
- (id)initWithTypes:(id<CNSeq>)types thickness:(CGFloat)thickness;
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
- (id<CNSeq>)trees;
- (void)cutDownTile:(GEVec2i)tile;
- (void)cutDownForRail:(TRRail*)rail;
- (void)cutDownRect:(GERect)rect;
- (void)updateWithDelta:(CGFloat)delta;
+ (ODClassType*)type;
@end


@interface TRTree : NSObject<ODComparable, EGController>
@property (nonatomic, readonly) TRTreeType* treeType;
@property (nonatomic, readonly) GEVec2 position;
@property (nonatomic, readonly) GEVec2 size;
@property (nonatomic) CGFloat rustle;

+ (id)treeWithTreeType:(TRTreeType*)treeType position:(GEVec2)position size:(GEVec2)size;
- (id)initWithTreeType:(TRTreeType*)treeType position:(GEVec2)position size:(GEVec2)size;
- (ODClassType*)type;
- (NSInteger)compareTo:(TRTree*)to;
- (void)updateWithDelta:(CGFloat)delta;
+ (ODClassType*)type;
@end


@interface TRTreeType : ODEnum
+ (TRTreeType*)pine;
+ (TRTreeType*)tree1;
+ (TRTreeType*)tree2;
+ (TRTreeType*)tree3;
+ (TRTreeType*)yellow;
+ (NSArray*)values;
@end


