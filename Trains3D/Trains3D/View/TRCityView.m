#import "TRCityView.h"

#import "TRLevel.h"
#import "EGTexture.h"
#import "GL.h"
#import "EGContext.h"
#import "EGMesh.h"
#import "TRModels.h"
#import "EGMaterial.h"
#import "TRCity.h"
#import "GEMat4.h"
#import "EGSprite.h"
#import "EGSchedule.h"
#import "TRStrings.h"
#import "TRRailroad.h"
#import "EGBillboard.h"
#import "EGDirector.h"
@implementation TRCityView{
    TRLevel* _level;
    EGTexture* _cityTexture;
    EGVertexArray* _vaoBody;
}
static ODClassType* _TRCityView_type;
@synthesize level = _level;
@synthesize cityTexture = _cityTexture;
@synthesize vaoBody = _vaoBody;

+ (id)cityViewWithLevel:(TRLevel*)level {
    return [[TRCityView alloc] initWithLevel:level];
}

- (id)initWithLevel:(TRLevel*)level {
    self = [super init];
    if(self) {
        _level = level;
        _cityTexture = [EGGlobal textureForFile:@"City.png" magFilter:GL_LINEAR minFilter:GL_LINEAR_MIPMAP_NEAREST];
        _vaoBody = [TRModels.city vaoMaterial:[EGStandardMaterial applyDiffuse:[EGColorSource colorSourceWithColor:GEVec4Make(1.0, 0.0, 0.0, 1.0) texture:[CNOption applyValue:_cityTexture] blendMode:EGBlendMode.darken alphaTestLevel:-1.0]] shadow:YES];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _TRCityView_type = [ODClassType classTypeWithCls:[TRCityView class]];
}

- (void)draw {
    egPushGroupMarker(@"Cities");
    [[_level cities] forEach:^void(TRCity* city) {
        [EGGlobal.matrix applyModify:^EGMatrixModel*(EGMatrixModel* _) {
            return [[_ modifyW:^GEMat4*(GEMat4* w) {
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
    [EGGlobal.context.depthTest disabledF:^void() {
        [[_level cities] forEach:^void(TRCity* city) {
            [((TRCity*)(city)).expectedTrainCounter forF:^void(CGFloat time) {
                [EGD2D drawCircleMaterial:[EGColorSource applyColor:geVec4ApplyVec3W(geVec4Xyz(((TRCity*)(city)).expectedTrainColor.color), 0.85)] at:geVec3ApplyVec2Z(geVec2ApplyVec2i(((TRCity*)(city)).tile), 0.0) radius:0.08 relative:geVec2MulF([TRCityView moveVecForLevel:_level city:city], 0.25) start:M_PI_2 end:M_PI_2 - 2 * time * M_PI];
            }];
        }];
    }];
}

+ (GEVec2)moveVecForLevel:(TRLevel*)level city:(TRCity*)city {
    EGMapTileCutState cut = [level.map cutStateForTile:city.tile];
    GEVec2 p = GEVec2Make(0.0, 0.0);
    if(cut.x != 0) p = geVec2AddVec2(p, GEVec2Make(1.0, 0.0));
    if(cut.x2 != 0) p = geVec2AddVec2(p, GEVec2Make(-1.0, 0.0));
    if(cut.y != 0) p = geVec2AddVec2(p, GEVec2Make(0.0, -1.0));
    if(cut.y2 != 0) p = geVec2AddVec2(p, GEVec2Make(0.0, 1.0));
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


@implementation TRCallRepairerView{
    TRLevel* _level;
    EGFont* _font;
    GEVec2 _buttonSize;
    NSMutableDictionary* _buttons;
}
static ODClassType* _TRCallRepairerView_type;
@synthesize level = _level;

+ (id)callRepairerViewWithLevel:(TRLevel*)level {
    return [[TRCallRepairerView alloc] initWithLevel:level];
}

- (id)initWithLevel:(TRLevel*)level {
    self = [super init];
    if(self) {
        _level = level;
        _buttons = [NSMutableDictionary mutableDictionary];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _TRCallRepairerView_type = [ODClassType classTypeWithCls:[TRCallRepairerView class]];
}

- (void)reshapeWithViewport:(GERect)viewport {
    _font = [EGGlobal fontWithName:@"lucida_grande" size:18];
    _buttonSize = geVec2MulF([_font measureCText:[TRStr.Loc callRepairer]], 1.2);
}

- (void)draw {
    if(!([[_level.railroad damagesPoints] isEmpty]) && [[_level repairer] isEmpty]) {
        egPushGroupMarker(@"Call repairer");
        [EGGlobal.context.depthTest disabledF:^void() {
            [EGBlendFunction.standard applyDraw:^void() {
                [[_level cities] forEach:^void(TRCity* _) {
                    [self drawButtonForCity:_];
                }];
            }];
        }];
        egPopGroupMarker();
    } else {
        if(!([_buttons isEmpty])) [_buttons clear];
    }
}

- (void)drawButtonForCity:(TRCity*)city {
    GEVec2 bs = _buttonSize;
    GEVec2 p = [TRCityView moveVecForLevel:_level city:city];
    EGBillboard* billboard = [_buttons objectForKey:city orUpdateWith:^EGBillboard*() {
        return [EGBillboard applyMaterial:[EGColorSource applyColor:geVec4ApplyVec3W(geVec4Xyz(city.color.color), 0.8)]];
    }];
    billboard.position = geVec3ApplyVec2Z(geVec2ApplyVec2i(city.tile), 0.0);
    GEVec2 r = geVec2MulVec2(geVec2SubF(p, 0.5), bs);
    billboard.rect = GERectMake(r, bs);
    [billboard draw];
    [_font drawText:[TRStr.Loc callRepairer] color:GEVec4Make(0.1, 0.1, 0.1, 1.0) at:billboard.position alignment:EGTextAlignmentMake(0.0, 0.0, NO, geVec3ApplyVec2Z(geVec2AddVec2(r, geVec2DivI(bs, 2)), 0.0))];
}

- (BOOL)processEvent:(EGEvent*)event {
    return [event tapProcessor:self];
}

- (BOOL)tapEvent:(EGEvent*)event {
    GEVec2 p = [event locationInViewport];
    id b = [[_buttons chain] findWhere:^BOOL(CNTuple* _) {
        return [((EGBillboard*)(((CNTuple*)(_)).b)) containsVec2:p];
    }];
    [b forEach:^void(CNTuple* kv) {
        [_level runRepairerFromCity:((CNTuple*)(kv)).a];
    }];
    return [b isDefined];
}

- (BOOL)isProcessorActive {
    return !([[EGGlobal director] isPaused]);
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


