#import "objd.h"
#import "PGTexture.h"
#import "PGVec.h"
#import "PGMaterial.h"
#import "TRCity.h"
#import "TRTrain.h"
#import "PGMapIso.h"
#import "PGInput.h"
@class TRLevel;
@class PGGlobal;
@class PGVertexArray;
@class TRModels;
@class PGMesh;
@class PGMatrixStack;
@class PGMat4;
@class PGMMatrixModel;
@class PGContext;
@class PGEnablingState;
@class TRLevelRules;
@class TRTrainModels;
@class PGD2D;
@class TRRailroadState;
@class TRRailroadDamages;
@class CNReact;
@class PGSprite;
@class CNChain;

@class TRCityView;
@class TRCallRepairerView;

@interface TRCityView : NSObject {
@public
    TRLevel* _level;
    PGTexture* _cityTexture;
    PGVertexArray* _vaoBody;
}
@property (nonatomic, readonly) TRLevel* level;
@property (nonatomic, readonly) PGTexture* cityTexture;
@property (nonatomic, readonly) PGVertexArray* vaoBody;

+ (instancetype)cityViewWithLevel:(TRLevel*)level;
- (instancetype)initWithLevel:(TRLevel*)level;
- (CNClassType*)type;
- (void)drawCities:(NSArray*)cities;
- (void)drawExpectedCities:(NSArray*)cities;
+ (PGVec2)moveVecForLevel:(TRLevel*)level city:(TRCity*)city;
- (NSString*)description;
+ (CNClassType*)type;
@end


@interface TRCallRepairerView : PGInputProcessor_impl {
@public
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
- (PGRecognizers*)recognizers;
- (NSString*)description;
+ (CNClassType*)type;
@end


