#import "objd.h"
#import "GL.h"

@class EGMesh;
@class EGMeshModel;

@class TRModels;
@class EGMeshDataModel;

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
+ (ODType*)type;

+ (EGMesh *)city;
+ (EGMesh *)damage;
+ (EGMeshDataModel *)light;
+ (CNPArray *)lightGreenGlow;
+ (CNPArray *)lightRedGlow;
+ (CNPArray *)lightGlowIndex;

+ (EGMesh *)car;
+ (EGMesh *)carBlack;
+ (EGMesh *)carShadow;

+ (EGMesh *)engine;
+ (EGMesh *)engineBlack;
+ (EGMesh *)engineShadow;

+ (EGMesh *)expressCar;
+ (EGMesh *)expressCarBlack;
+ (EGMesh *)expressCarShadow;

+ (EGMesh *)expressEngine;
+ (EGMesh *)expressEngineBlack;
+ (EGMesh *)expressEngineShadow;
@end


