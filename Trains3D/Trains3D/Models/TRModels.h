#import "objd.h"
#import "GL.h"

@class EGMesh;
@class EGMeshModel;

@class TRModels;

@interface TRModels : NSObject
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

+ (EGMesh *)cityBodies;
+ (EGMesh *)car;
+ (EGMesh *)carBlack;
+ (EGMesh *)engine;
+ (EGMesh *)engineBlack;
+ (EGMesh *)engineFloor;
+ (EGMesh *)damage;

+ (EGMesh *)lightGreen;

+ (EGMesh *)lightRed;

+ (EGMesh *)lightGreenGlow;

+ (EGMesh *)lightRedGlow;

+ (EGMesh *)cityRoofs;

+ (EGMesh *)cityWindows;
@end


