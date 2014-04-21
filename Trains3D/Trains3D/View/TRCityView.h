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
@class TRCityState;
@class EGMatrixStack;
@class TRCity;
@class GEMat4;
@class EGMMatrixModel;
@class TRCityAngle;
@class TRCityColor;
@class EGContext;
@class EGEnablingState;
@class EGBlendFunction;
@class TRTrain;
@class TRTrainType;
@class TRTrainModels;
@class EGD2D;
@class TRRailroadState;
@class TRRailroadDamages;
@class EGTextureFormat;
@class EGTextureRegion;
@class ATReact;
@class EGSprite;
@class EGDirector;

@class TRCityView;
@class TRCallRepairerView;

@interface TRCityView : NSObject {
@protected
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
- (void)drawCities:(NSArray*)cities;
- (void)drawExpectedCities:(NSArray*)cities;
+ (GEVec2)moveVecForLevel:(TRLevel*)level city:(TRCity*)city;
+ (ODClassType*)type;
@end


@interface TRCallRepairerView : NSObject<EGInputProcessor> {
@protected
    TRLevel* _level;
    NSMutableDictionary* _buttons;
    NSMutableDictionary* _stammers;
}
@property (nonatomic, readonly) TRLevel* level;

+ (instancetype)callRepairerViewWithLevel:(TRLevel*)level;
- (instancetype)initWithLevel:(TRLevel*)level;
- (ODClassType*)type;
- (void)drawRrState:(TRRailroadState*)rrState cities:(NSArray*)cities;
- (void)drawButtonForCity:(TRCity*)city;
- (EGRecognizers*)recognizers;
+ (ODClassType*)type;
@end


