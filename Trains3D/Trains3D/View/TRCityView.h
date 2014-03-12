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
@class TRTrainModels;
@class EGD2D;
@class EGCounter;
@class EGEnablingState;
@class TRRailroadState;
@class TRRailroadDamages;
@class EGBillboard;
@class EGTextureFormat;
@class EGDirector;

@class TRCityView;
@class TRCallRepairerView;

@interface TRCityView : NSObject {
@private
    TRLevel* _level;
    EGTexture* _cityTexture;
    EGVertexArray* _vaoBody;
}
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


@interface TRCallRepairerView : NSObject<EGInputProcessor> {
@private
    TRLevel* _level;
    GEVec2 _buttonSize;
    NSMutableDictionary* _buttons;
    NSMutableDictionary* _stammers;
}
@property (nonatomic, readonly) TRLevel* level;

+ (instancetype)callRepairerViewWithLevel:(TRLevel*)level;
- (instancetype)initWithLevel:(TRLevel*)level;
- (ODClassType*)type;
- (void)reshape;
- (void)drawRrState:(TRRailroadState*)rrState;
- (void)drawButtonForCity:(TRCity*)city;
- (EGRecognizers*)recognizers;
+ (ODClassType*)type;
@end


