#import "objd.h"
#import "GL.h"

@class PGMesh;
@class PGMeshModel;

@class TRModels;
@class PGMeshDataModel;
@class PGMeshDataBuffer;

@interface TRModels : NSObject
+ (id)r3D;
- (id)init;
- (CNType*)type;
+ (PGMesh*)railTies;
+ (PGMesh*)railGravel;
+ (PGMesh*)rails;
+ (PGMesh*)railTurnTies;
+ (PGMesh*)railTurnGravel;
+ (PGMesh*)railsTurn;
+ (PGMesh*)switchStraight;
+ (PGMesh*)switchTurn;
+ (CNType*)type;

+ (PGMesh *)city;
+ (PGMesh *)damage;
+ (PGMeshDataModel *)light;
+ (PGMeshDataBuffer *)lightGreenGlow;
+ (PGMeshDataBuffer *)lightRedGlow;
+ (CNPArray *)lightGlowIndex;

+ (PGMesh *)car;
+ (PGMesh *)carBlack;
+ (PGMesh *)carShadow;

+ (PGMesh *)engine;
+ (PGMesh *)engineBlack;
+ (PGMesh *)engineShadow;

+ (PGMesh *)expressCar;
+ (PGMesh *)expressCarBlack;
+ (PGMesh *)expressCarShadow;

+ (PGMesh *)expressEngine;
+ (PGMesh *)expressEngineBlack;
+ (PGMesh *)expressEngineShadow;
@end


