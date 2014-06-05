#import "TRCityView.h"

#import "TRLevel.h"
#import "PGContext.h"
#import "PGVertexArray.h"
#import "TRModels.h"
#import "PGMesh.h"
#import "GL.h"
#import "PGMatrixModel.h"
#import "PGMat4.h"
#import "TRTrainView.h"
#import "math.h"
#import "PGD2D.h"
#import "TRRailroad.h"
#import "CNReact.h"
#import "PGSprite.h"
#import "CNChain.h"
@implementation TRCityView
static CNClassType* _TRCityView_type;
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
        _cityTexture = [PGGlobal compressedTextureForFile:@"City" filter:PGTextureFilter_mipmapNearest];
        _vaoBody = [[TRModels city] vaoMaterial:[PGStandardMaterial applyDiffuse:[PGColorSource colorSourceWithColor:PGVec4Make(1.0, 0.0, 0.0, 1.0) texture:_cityTexture blendMode:PGBlendMode_darken alphaTestLevel:-1.0]] shadow:YES];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [TRCityView class]) _TRCityView_type = [CNClassType classTypeWithCls:[TRCityView class]];
}

- (void)drawCities:(NSArray*)cities {
    egPushGroupMarker(@"Cities");
    for(TRCityState* cityState in cities) {
        TRCity* city = ((TRCityState*)(cityState))->_city;
        {
            PGMatrixStack* __tmp__il__1r_1self = [PGGlobal matrix];
            {
                [__tmp__il__1r_1self push];
                {
                    PGMMatrixModel* _ = [__tmp__il__1r_1self value];
                    [[_ modifyW:^PGMat4*(PGMat4* w) {
                        return [w translateX:((float)(city->_tile.x)) y:((float)(city->_tile.y)) z:0.0];
                    }] modifyM:^PGMat4*(PGMat4* m) {
                        return [m rotateAngle:((float)([TRCityAngle value:city->_angle].angle)) x:0.0 y:-1.0 z:0.0];
                    }];
                }
                [_vaoBody drawParam:[PGStandardMaterial applyDiffuse:[PGColorSource applyColor:[TRCityColor value:city->_color].color texture:_cityTexture]]];
                [__tmp__il__1r_1self pop];
            }
        }
    }
    egPopGroupMarker();
}

- (void)drawExpectedCities:(NSArray*)cities {
    PGEnablingState* __il__0__tmp__il__0self = [PGGlobal context]->_blend;
    {
        BOOL __il__0__il__0changed = [__il__0__tmp__il__0self enable];
        {
            [[PGGlobal context] setBlendFunction:[PGBlendFunction standard]];
            {
                PGEnablingState* __tmp__il__0rp0self = [PGGlobal context]->_depthTest;
                {
                    BOOL __il__0rp0changed = [__tmp__il__0rp0self disable];
                    for(TRCityState* cityState in cities) {
                        TRTrain* train = ((TRCityState*)(cityState))->_expectedTrain;
                        if(train != nil) {
                            TRCity* city = ((TRCityState*)(cityState))->_city;
                            CGFloat time = ((TRCityState*)(cityState))->_expectedTrainCounterTime;
                            PGVec4 color = ((((TRTrain*)(train))->_trainType == TRTrainType_crazy) ? [TRTrainModels crazyColorTime:time * _level->_rules->_trainComingPeriod] : [TRCityColor value:((TRTrain*)(train))->_color].trainColor);
                            [PGD2D drawCircleBackColor:pgVec4ApplyVec3W((pgVec3MulK(pgVec4Xyz(color), 0.5)), 0.85) strokeColor:PGVec4Make(0.0, 0.0, 0.0, 0.2) at:pgVec3ApplyVec2iZ(city->_tile, 0.0) radius:0.2 relative:pgVec2MulF([TRCityView moveVecForLevel:_level city:city], 0.25) segmentColor:color start:M_PI_2 end:M_PI_2 - 2 * time * M_PI];
                        }
                    }
                    if(__il__0rp0changed) [__tmp__il__0rp0self enable];
                }
            }
        }
        if(__il__0__il__0changed) [__il__0__tmp__il__0self disable];
    }
}

+ (PGVec2)moveVecForLevel:(TRLevel*)level city:(TRCity*)city {
    PGMapTileCutState cut = [level->_map cutStateForTile:city->_tile];
    PGVec2 p = PGVec2Make(0.0, 0.0);
    if(cut.x != 0) p = pgVec2AddVec2(p, (PGVec2Make(1.0, 0.0)));
    if(cut.x2 != 0) p = pgVec2AddVec2(p, (PGVec2Make(-1.0, 0.0)));
    if(cut.y != 0) p = pgVec2AddVec2(p, (PGVec2Make(0.0, -1.0)));
    if(cut.y2 != 0) p = pgVec2AddVec2(p, (PGVec2Make(0.0, 1.0)));
    return p;
}

- (NSString*)description {
    return [NSString stringWithFormat:@"CityView(%@)", _level];
}

- (CNClassType*)type {
    return [TRCityView type];
}

+ (CNClassType*)type {
    return _TRCityView_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation TRCallRepairerView
static CNClassType* _TRCallRepairerView_type;
@synthesize level = _level;

+ (instancetype)callRepairerViewWithLevel:(TRLevel*)level {
    return [[TRCallRepairerView alloc] initWithLevel:level];
}

- (instancetype)initWithLevel:(TRLevel*)level {
    self = [super init];
    if(self) {
        _level = level;
        _buttons = [CNMHashMap hashMap];
        _stammers = [CNMHashMap hashMap];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [TRCallRepairerView class]) _TRCallRepairerView_type = [CNClassType classTypeWithCls:[TRCallRepairerView class]];
}

- (void)drawRrState:(TRRailroadState*)rrState cities:(NSArray*)cities {
    if(!([rrState->_damages->_points isEmpty]) && [_level repairer] == nil) {
        egPushGroupMarker(@"Call repairer");
        {
            PGEnablingState* __tmp__il__0t_1self = [PGGlobal context]->_depthTest;
            {
                BOOL __il__0t_1changed = [__tmp__il__0t_1self disable];
                PGEnablingState* __il__0t_1rp0__tmp__il__0self = [PGGlobal context]->_blend;
                {
                    BOOL __il__0t_1rp0__il__0changed = [__il__0t_1rp0__tmp__il__0self enable];
                    {
                        [[PGGlobal context] setBlendFunction:[PGBlendFunction standard]];
                        for(TRCityState* cityState in cities) {
                            if([((TRCityState*)(cityState)) canRunNewTrain]) [self drawButtonForCity:((TRCityState*)(cityState))->_city];
                        }
                    }
                    if(__il__0t_1rp0__il__0changed) [__il__0t_1rp0__tmp__il__0self disable];
                }
                if(__il__0t_1changed) [__tmp__il__0t_1self enable];
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
    PGSprite* stammer = [_stammers applyKey:city orUpdateWith:^PGSprite*() {
        return [PGSprite applyMaterial:[CNReact applyValue:[[[PGGlobal scaledTextureForName:@"Pause" format:PGTextureFormat_RGBA4] regionX:0.0 y:32.0 width:32.0 height:32.0] colorSource]] position:[CNReact applyValue:wrap(PGVec3, (pgVec3ApplyVec2iZ(city->_tile, 0.0)))] rect:[CNReact applyValue:wrap(PGRect, (pgRectAddVec2((pgRectApplyXYWidthHeight(-16.0, -16.0, 32.0, 32.0)), (pgVec2MulI([TRCityView moveVecForLevel:_level city:city], 32)))))]];
    }];
    PGSprite* billboard = [_buttons applyKey:city orUpdateWith:^PGSprite*() {
        return [PGSprite applyMaterial:[CNReact applyValue:[PGColorSource applyColor:pgVec4ApplyVec3W(pgVec4Xyz([TRCityColor value:city->_color].color), 0.8)]] position:stammer->_position rect:stammer->_rect];
    }];
    [billboard draw];
    [stammer draw];
}

- (PGRecognizers*)recognizers {
    return [PGRecognizers applyRecognizer:[PGRecognizer applyTp:[PGTap apply] on:^BOOL(id<PGEvent> event) {
        PGVec2 p = [event locationInViewport];
        CNTuple* b = [[_buttons chain] findWhere:^BOOL(CNTuple* _) {
            return [((PGSprite*)(((CNTuple*)(_))->_b)) containsViewportVec2:p];
        }];
        {
            CNTuple* kv = b;
            if(kv != nil) {
                if([((TRCity*)(((CNTuple*)(kv))->_a)) canRunNewTrain]) [_level runRepairerFromCity:((CNTuple*)(kv))->_a];
            }
        }
        return b != nil;
    }]];
}

- (NSString*)description {
    return [NSString stringWithFormat:@"CallRepairerView(%@)", _level];
}

- (CNClassType*)type {
    return [TRCallRepairerView type];
}

+ (CNClassType*)type {
    return _TRCallRepairerView_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

