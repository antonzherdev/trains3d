#import "objd.h"
#import "GEVec.h"
@class EGMapSso;

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


@interface TRForest : NSObject
@property (nonatomic, readonly) EGMapSso* map;
@property (nonatomic, readonly) TRForestRules* rules;
@property (nonatomic, readonly) id<CNSeq> trees;

+ (id)forestWithMap:(EGMapSso*)map rules:(TRForestRules*)rules;
- (id)initWithMap:(EGMapSso*)map rules:(TRForestRules*)rules;
- (ODClassType*)type;
+ (ODClassType*)type;
@end


@interface TRTree : NSObject<ODComparable>
@property (nonatomic, readonly) TRTreeType* treeType;
@property (nonatomic, readonly) GEVec2 position;
@property (nonatomic, readonly) GEVec2 size;

+ (id)treeWithTreeType:(TRTreeType*)treeType position:(GEVec2)position size:(GEVec2)size;
- (id)initWithTreeType:(TRTreeType*)treeType position:(GEVec2)position size:(GEVec2)size;
- (ODClassType*)type;
- (NSInteger)compareTo:(TRTree*)to;
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


