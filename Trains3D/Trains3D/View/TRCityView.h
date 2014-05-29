#import "objd.h"
#import "EGTexture.h"
#import "GEVec.h"
#import "EGMaterial.h"
#import "TRCity.h"
#import "TRTrain.h"
#import "EGMapIso.h"
#import "EGInput.h"
@class TRLevel;
@class EGGlobal;
@class EGVertexArray;
@class TRModels;
@class EGMesh;
@class EGMatrixStack;
@class GEMat4;
@class EGMMatrixModel;
@class EGContext;
@class EGEnablingState;
@class TRLevelRules;
@class TRTrainModels;
@class EGD2D;
@class TRRailroadState;
@class TRRailroadDamages;
@class CNReact;
@class EGSprite;
@class CNChain;

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
- (CNClassType*)type;
- (void)drawCities:(NSArray*)cities;
- (void)drawExpectedCities:(NSArray*)cities;
+ (GEVec2)moveVecForLevel:(TRLevel*)level city:(TRCity*)city;
- (NSString*)description;
+ (CNClassType*)type;
@end


@interface TRCallRepairerView : EGInputProcessor_impl {
@protected
    TRLevel* _level;
    CNMHashMap* _buttons;
    CNMHashMap* _stammers;
}
@property (nonatomic, readonly) TRLevel* level;

+ (instancetype)callRepairerViewWithLevel:(TRLevel*)level;
- (instancetype)initWithLevel:(TRLevel*)level;
- (CNClassType*)type;
- (void)drawRrState:(TRRailroadState*)rrState cities:(NSArray*)cities;
- (void)drawButtonForCity:(TRCity*)city;
- (EGRecognizers*)recognizers;
- (NSString*)description;
+ (CNClassType*)type;
@end


