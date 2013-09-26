#import "objd.h"
#import "GEVec.h"
@class EGMapSso;

@class TRTreesRules;
@class TRTrees;
@class TRTree;

@interface TRTreesRules : NSObject
@property (nonatomic, readonly) CGFloat thickness;

+ (id)treesRulesWithThickness:(CGFloat)thickness;
- (id)initWithThickness:(CGFloat)thickness;
- (ODClassType*)type;
+ (ODClassType*)type;
@end


@interface TRTrees : NSObject
@property (nonatomic, readonly) EGMapSso* map;
@property (nonatomic, readonly) TRTreesRules* rules;
@property (nonatomic, readonly) id<CNSeq> trees;

+ (id)treesWithMap:(EGMapSso*)map rules:(TRTreesRules*)rules;
- (id)initWithMap:(EGMapSso*)map rules:(TRTreesRules*)rules;
- (ODClassType*)type;
+ (ODClassType*)type;
@end


@interface TRTree : NSObject<ODComparable>
@property (nonatomic, readonly) GEVec2 position;

+ (id)treeWithPosition:(GEVec2)position;
- (id)initWithPosition:(GEVec2)position;
- (ODClassType*)type;
- (NSInteger)compareTo:(TRTree*)to;
+ (ODClassType*)type;
@end


