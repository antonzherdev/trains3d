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
#import "EGMatrixModel.h"
#import "GEMat4.h"
#import "TRTrain.h"
#import "TRTrainView.h"
#import "EGD2D.h"
#import "TRRailroad.h"
#import "ATReact.h"
#import "EGSprite.h"
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
        _vaoBody = [TRModels.city vaoMaterial:[EGStandardMaterial applyDiffuse:[EGColorSource colorSourceWithColor:GEVec4Make(1.0, 0.0, 0.0, 1.0) texture:_cityTexture blendMode:EGBlendMode.darken alphaTestLevel:-1.0]] shadow:YES];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [TRCityView class]) _TRCityView_type = [ODClassType classTypeWithCls:[TRCityView class]];
}

- (void)drawCities:(NSArray*)cities {
    egPushGroupMarker(@"Cities");
    for(TRCityState* cityState in cities) {
        TRCity* city = ((TRCityState*)(cityState)).city;
        {
            EGMatrixStack* __tmp_1_1self = EGGlobal.matrix;
            {
                [__tmp_1_1self push];
                {
                    EGMMatrixModel* _ = [__tmp_1_1self value];
                    [[_ modifyW:^GEMat4*(GEMat4* w) {
                        return [w translateX:((float)(city.tile.x)) y:((float)(city.tile.y)) z:0.0];
                    }] modifyM:^GEMat4*(GEMat4* m) {
                        return [m rotateAngle:((float)(city.angle.angle)) x:0.0 y:-1.0 z:0.0];
                    }];
                }
                [_vaoBody drawParam:[EGStandardMaterial applyDiffuse:[EGColorSource applyColor:city.color.color texture:_cityTexture]]];
                [__tmp_1_1self pop];
            }
        }
    }
    egPopGroupMarker();
}

- (void)drawExpectedCities:(NSArray*)cities {
    EGEnablingState* __inline__0___tmp_0self = EGGlobal.context.blend;
    {
        BOOL __inline__0___inline__0_changed = [__inline__0___tmp_0self enable];
        {
            [EGGlobal.context setBlendFunction:EGBlendFunction.standard];
            {
                EGEnablingState* __tmp_0self = EGGlobal.context.depthTest;
                {
                    BOOL __inline__0_changed = [__tmp_0self disable];
                    for(TRCityState* cityState in cities) {
                        TRTrain* train = ((TRCityState*)(cityState)).expectedTrain;
                        if(train != nil) {
                            TRCity* city = ((TRCityState*)(cityState)).city;
                            CGFloat time = ((TRCityState*)(cityState)).expectedTrainCounterTime;
                            GEVec4 color = ((((TRTrain*)(train)).trainType == TRTrainType.crazy) ? [TRTrainModels crazyColorTime:time * TRLevel.trainComingPeriod] : ((TRTrain*)(train)).color.trainColor);
                            [EGD2D drawCircleBackColor:geVec4ApplyVec3W((geVec3MulK(geVec4Xyz(color), 0.5)), 0.85) strokeColor:GEVec4Make(0.0, 0.0, 0.0, 0.2) at:geVec3ApplyVec2iZ(city.tile, 0.0) radius:0.2 relative:geVec2MulF4([TRCityView moveVecForLevel:_level city:city], 0.25) segmentColor:color start:M_PI_2 end:M_PI_2 - 2 * time * M_PI];
                        }
                    }
                    if(__inline__0_changed) [__tmp_0self enable];
                }
            }
        }
        if(__inline__0___inline__0_changed) [__inline__0___tmp_0self disable];
    }
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

- (void)drawRrState:(TRRailroadState*)rrState cities:(NSArray*)cities {
    if(!([rrState.damages.points isEmpty]) && [_level repairer] == nil) {
        egPushGroupMarker(@"Call repairer");
        {
            EGEnablingState* __tmp_0_1self = EGGlobal.context.depthTest;
            {
                BOOL __inline__0_1_changed = [__tmp_0_1self disable];
                EGEnablingState* __inline__0_1___tmp_0self = EGGlobal.context.blend;
                {
                    BOOL __inline__0_1___inline__0_changed = [__inline__0_1___tmp_0self enable];
                    {
                        [EGGlobal.context setBlendFunction:EGBlendFunction.standard];
                        for(TRCityState* cityState in cities) {
                            if([((TRCityState*)(cityState)) canRunNewTrain]) [self drawButtonForCity:((TRCityState*)(cityState)).city];
                        }
                    }
                    if(__inline__0_1___inline__0_changed) [__inline__0_1___tmp_0self disable];
                }
                if(__inline__0_1_changed) [__tmp_0_1self enable];
            }
        }
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
        return [EGSprite applyMaterial:[ATReact applyValue:[[[EGGlobal scaledTextureForName:@"Pause" format:EGTextureFormat.RGBA4] regionX:0.0 y:32.0 width:32.0 height:32.0] colorSource]] position:[ATReact applyValue:wrap(GEVec3, (geVec3ApplyVec2iZ(city.tile, 0.0)))] rect:[ATReact applyValue:wrap(GERect, (geRectAddVec2((geRectApplyXYWidthHeight(-16.0, -16.0, 32.0, 32.0)), (geVec2MulF4([TRCityView moveVecForLevel:_level city:city], 32.0)))))]];
    }];
    EGSprite* billboard = [_buttons objectForKey:city orUpdateWith:^EGSprite*() {
        return [EGSprite applyMaterial:[ATReact applyValue:[EGColorSource applyColor:geVec4ApplyVec3W(geVec4Xyz(city.color.color), 0.8)]] position:stammer.position rect:stammer.rect];
    }];
    [billboard draw];
    [stammer draw];
}

- (EGRecognizers*)recognizers {
    return [EGRecognizers applyRecognizer:[EGRecognizer applyTp:[EGTap apply] on:^BOOL(id<EGEvent> event) {
        GEVec2 p = [event locationInViewport];
        CNTuple* b = [[_buttons chain] findWhere:^BOOL(CNTuple* _) {
            return [((EGSprite*)(((CNTuple*)(_)).b)) containsViewportVec2:p];
        }];
        {
            CNTuple* kv = b;
            if(kv != nil) {
                if([((TRCity*)(kv.a)) canRunNewTrain]) [_level runRepairerFromCity:kv.a];
            }
        }
        return b != nil;
    }]];
}

- (BOOL)isProcessorActive {
    return !(unumb([[EGDirector current].isPaused value]));
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

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"level=%@", self.level];
    [description appendString:@">"];
    return description;
}

@end


