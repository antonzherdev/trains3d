#import "objd.h"
#import "EGGL.h"
@class EGMesh;
@class EGMeshModel;

@class TR3D;

@interface TR3D : NSObject
+ (id)r3D;
- (id)init;
- (ODType*)type;
+ (EGMesh*)railTies;
+ (EGMesh*)railGravel;
+ (EGMesh*)rails;
+ (EGMesh*)railTurnTies;
+ (EGMesh*)railTurnGravel;
+ (EGMesh*)railsTurn;
+ (EGMesh*)switchStraight;
+ (EGMesh*)switchTurn;
+ (EGMesh*)light;
+ (ODType*)type;
@end


