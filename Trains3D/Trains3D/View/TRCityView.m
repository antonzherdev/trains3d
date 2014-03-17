#import "TRCityView.h"

#import "TRLevel.h"
#import "EGTexture.h"
#import "EGContext.h"
#import "EGVertexArray.h"
#import "TRModels.h"
#import "EGMaterial.h"
#import "EGMesh.h"
#import "GL.h"
#import "TRCity.h"
#import "GEMat4.h"
#import "EGMatrixModel.h"
#import "TRTrain.h"
#import "TRTrainView.h"
#import "EGSprite.h"
#import "EGSchedule.h"
#import "TRRailroad.h"
#import "ATReact.h"
#import "EGDirector.h"
@implementation TRCityView
static ODClassType* _TRCityView_type;
@synthesize level = _level;
@synthesize cityTexture = _cityTexture;
@synthesize vaoBody = _vaoBody;

+ (instancetype)cityViewWithLevel:(TRLevel*)level {
    return [[TRCityView alloc] initWithLevel:level];
}

- (instancetype)initWithLevel:(TRLevel*)level {
    self = [super init];
    if(self) {
        _level = level;
        _cityTexture = [EGGlobal compressedTextureForFile:@"City" filter:EGTextureFilter.mipmapNearest];
        _vaoBody = [TRModels.city vaoMaterial:[EGStandardMaterial applyDiffuse:[EGColorSource colorSourceWithColor:GEVec4Make(1.0, 0.0, 0.0, 1.0) texture:[CNOption applyValue:_cityTexture] blendMode:EGBlendMode.darken alphaTestLevel:-1.0]] shadow:YES];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [TRCityView class]) _TRCityView_type = [ODClassType classTypeWithCls:[TRCityView class]];
}

- (void)draw {
    egPushGroupMarker(@"Cities");
    [[_level cities] forEach:^void(TRCity* city) {
        [EGGlobal.matrix applyModify:^void(EGMMatrixModel* _) {
            [[_ modifyW:^GEMat4*(GEMat4* w) {
                return [w translateX:((float)(((TRCity*)(city)).tile.x)) y:((float)(((TRCity*)(city)).tile.y)) z:0.0];
            }] modifyM:^GEMat4*(GEMat4* m) {
                return [m rotateAngle:((float)(((TRCity*)(city)).angle.angle)) x:0.0 y:-1.0 z:0.0];
            }];
        } f:^void() {
            [_vaoBody drawParam:[EGStandardMaterial applyDiffuse:[EGColorSource applyColor:((TRCity*)(city)).color.color texture:_cityTexture]]];
        }];
    }];
    egPopGroupMarker();
}

- (void)drawExpected {
    [EGBlendFunction.standard applyDraw:^void() {
        [EGGlobal.context.depthTest disabledF:^void() {
            [[_level cities] forEach:^void(TRCity* city) {
                [((TRCity*)(city)).expectedTrainCounter forF:^void(CGFloat time) {
                    TRTrain* train = ((TRCity*)(city)).expectedTrain;
                    GEVec4 color = ((train.trainType == TRTrainType.crazy) ? [TRTrainModels crazyColorTime:time * TRLevel.trainComingPeriod] : train.color.trainColor);
                    [EGD2D drawCircleBackColor:geVec4ApplyVec3W((geVec3MulK(geVec4Xyz(color), 0.5)), 0.85) strokeColor:GEVec4Make(0.0, 0.0, 0.0, 0.2) at:geVec3ApplyVec2Z(geVec2ApplyVec2i(((TRCity*)(city)).tile), 0.0) radius:0.2 relative:geVec2MulF([TRCityView moveVecForLevel:_level city:city], 0.25) segmentColor:color start:M_PI_2 end:M_PI_2 - 2 * time * M_PI];
                }];
            }];
        }];
    }];
}

+ (GEVec2)moveVecForLevel:(TRLevel*)level city:(TRCity*)city {
    EGMapTileCutState cut = [level.map cutStateForTile:city.tile];
    GEVec2 p = GEVec2Make(0.0, 0.0);
    if(cut.x != 0) p = geVec2AddVec2(p, (GEVec2Make(1.0, 0.0)));
    if(cut.x2 != 0) p = geVec2AddVec2(p, (GEVec2Make(-1.0, 0.0)));
    if(cut.y != 0) p = geVec2AddVec2(p, (GEVec2Make(0.0, -1.0)));
    if(cut.y2 != 0) p = geVec2AddVec2(p, (GEVec2Make(0.0, 1.0)));
    return p;
}

- (ODClassType*)type {
    return [TRCityView type];
}

+ (ODClassType*)type {
    return _TRCityView_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    TRCityView* o = ((TRCityView*)(other));
    return [self.level isEqual:o.level];
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.level hash];
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"level=%@", self.level];
    [description appendString:@">"];
    return description;
}

@end


@implementation TRCallRepairerView
static ODClassType* _TRCallRepairerView_type;
@synthesize level = _level;

+ (instancetype)callRepairerViewWithLevel:(TRLevel*)level {
    return [[TRCallRepairerView alloc] initWithLevel:level];
}

- (instancetype)initWithLevel:(TRLevel*)level {
    self = [super init];
    if(self) {
        _level = level;
        _buttons = [NSMutableDictionary mutableDictionary];
        _stammers = [NSMutableDictionary mutableDictionary];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [TRCallRepairerView class]) _TRCallRepairerView_type = [ODClassType classTypeWithCls:[TRCallRepairerView class]];
}

- (void)drawRrState:(TRRailroadState*)rrState {
    if(!([rrState.damages.points isEmpty]) && [[_level repairer] isEmpty]) {
        egPushGroupMarker(@"Call repairer");
        [EGGlobal.context.depthTest disabledF:^void() {
            [EGBlendFunction.standard applyDraw:^void() {
                [[_level cities] forEach:^void(TRCity* city) {
                    if([((TRCity*)(city)) canRunNewTrain]) [self drawButtonForCity:city];
                }];
            }];
        }];
        egPopGroupMarker();
    } else {
        if(!([_buttons isEmpty])) {
            [_buttons clear];
            [_stammers clear];
        }
    }
}

- (void)drawButtonForCity:(TRCity*)city {
    EGSprite* stammer = [_stammers objectForKey:city orUpdateWith:^EGSprite*() {
        return [EGSprite applyMaterial:[ATReact applyValue:[[[EGGlobal scaledTextureForName:@"Pause" format:EGTextureFormat.RGBA4] regionX:0.0 y:32.0 width:32.0 height:32.0] colorSource]] position:[ATReact applyValue:wrap(GEVec3, (geVec3ApplyVec2Z(geVec2ApplyVec2i(city.tile), 0.0)))]];
    }];
    EGSprite* billboard = [_buttons objectForKey:city orUpdateWith:^EGSprite*() {
        return [EGSprite applyMaterial:[ATReact applyValue:[EGColorSource applyColor:geVec4ApplyVec3W(geVec4Xyz(city.color.color), 0.8)]] position:[ATReact applyValue:wrap(GEVec3, (geVec3ApplyVec2Z(geVec2ApplyVec2i(city.tile), 0.0)))] rect:stammer.rect];
    }];
    [billboard draw];
    [stammer draw];
}

- (EGRecognizers*)recognizers {
    return [EGRecognizers applyRecognizer:[EGRecognizer applyTp:[EGTap apply] on:^BOOL(id<EGEvent> event) {
        GEVec2 p = [event locationInViewport];
        id b = [[_buttons chain] findWhere:^BOOL(CNTuple* _) {
            return [((EGSprite*)(((CNTuple*)(_)).b)) containsViewportVec2:p];
        }];
        [b forEach:^void(CNTuple* kv) {
            if([((TRCity*)(((CNTuple*)(kv)).a)) canRunNewTrain]) [_level runRepairerFromCity:((CNTuple*)(kv)).a];
        }];
        return [b isDefined];
    }]];
}

- (BOOL)isProcessorActive {
    return !([[EGDirector current] isPaused]);
}

- (ODClassType*)type {
    return [TRCallRepairerView type];
}

+ (ODClassType*)type {
    return _TRCallRepairerView_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    TRCallRepairerView* o = ((TRCallRepairerView*)(other));
    return [self.level isEqual:o.level];
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.level hash];
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"level=%@", self.level];
    [description appendString:@">"];
    return description;
}

@end


