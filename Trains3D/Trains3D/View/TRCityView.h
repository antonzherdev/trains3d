#import "objd.h"
#import "GEVec.h"
#import "EGMapIso.h"
#import "EGInput.h"
@class TRLevel;
@class EGTexture;
@class EGTextureFilter;
@class EGGlobal;
@class EGVertexArray;
@class TRModels;
@class EGBlendMode;
@class EGColorSource;
@class EGStandardMaterial;
@class EGMesh;
@class TRCity;
@class GEMat4;
@class EGMMatrixModel;
@class TRCityAngle;
@class TRCityColor;
@class EGMatrixStack;
@class EGBlendFunction;
@class EGContext;
@class TRTrain;
@class TRTrainType;
@class TRTrainView;
@class EGD2D;
@class EGCounter;
@class EGEnablingState;
@class TRRailroad;
@class EGBillboard;
@class EGTextureFormat;
@class EGDirector;

@class TRCityView;
@class TRCallRepairerView;

@interface TRCityView : NSObject
@property (nonatomic, readonly) TRLevel* level;
@property (nonatomic, readonly) EGTexture* cityTexture;
@property (nonatomic, readonly) EGVertexArray* vaoBody;

+ (instancetype)cityViewWithLevel:(TRLevel*)level;
- (instancetype)initWithLevel:(TRLevel*)level;
- (ODClassType*)type;
- (void)draw;
- (void)drawExpected;
+ (GEVec2)moveVecForLevel:(TRLevel*)level city:(TRCity*)city;
+ (ODClassType*)type;
@end


@interface TRCallRepairerView : NSObject<EGInputProcessor>
@property (nonatomic, readonly) TRLevel* level;

+ (instancetype)callRepairerViewWithLevel:(TRLevel*)level;
- (instancetype)initWithLevel:(TRLevel*)level;
- (ODClassType*)type;
- (void)reshape;
- (void)draw;
- (void)drawButtonForCity:(TRCity*)city;
- (EGRecognizers*)recognizers;
+ (ODClassType*)type;
@end


