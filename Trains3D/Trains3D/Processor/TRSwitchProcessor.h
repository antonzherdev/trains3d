#import "objd.h"
#import "EGInput.h"
#import "GEVec.h"
@class TRLevel;
@class EGCollisionBox2d;
@class EGCollisionWorld;
@class TRRailroad;
@class EGCollisionBody;
@class TRSwitch;
@class TRRailConnector;
@class TRRailLight;
@class TRRailroadConnectorContent;
@class GEMat4;
@class EGCrossPoint;
@class EGDirector;

@class TRSwitchProcessor;

@interface TRSwitchProcessor : NSObject<EGInputProcessor>
@property (nonatomic, readonly) TRLevel* level;
@property (nonatomic, readonly) EGCollisionBox2d* switchShape;
@property (nonatomic, readonly) EGCollisionWorld* world;

+ (id)switchProcessorWithLevel:(TRLevel*)level;
- (id)initWithLevel:(TRLevel*)level;
- (ODClassType*)type;
- (EGRecognizers*)recognizers;
+ (ODClassType*)type;
@end


