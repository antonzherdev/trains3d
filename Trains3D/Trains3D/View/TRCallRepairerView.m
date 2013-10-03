#import "TRCallRepairerView.h"

#import "TRLevel.h"
#import "EGContext.h"
#import "TRStrings.h"
#import "GEMat4.h"
#import "TRRailroad.h"
#import "GL.h"
#import "TRCity.h"
#import "EGBillboard.h"
#import "EGDirector.h"
@implementation TRCallRepairerView{
    TRLevel* _level;
    EGFont* _font;
    CNCache* _buttonSize;
    NSMutableDictionary* _buttons;
}
static ODClassType* _TRCallRepairerView_type;
@synthesize level = _level;
@synthesize font = _font;

+ (id)callRepairerViewWithLevel:(TRLevel*)level {
    return [[TRCallRepairerView alloc] initWithLevel:level];
}

- (id)initWithLevel:(TRLevel*)level {
    self = [super init];
    __weak TRCallRepairerView* _weakSelf = self;
    if(self) {
        _level = level;
        _font = [EGGlobal fontWithName:@"lucida_grande_18"];
        _buttonSize = [CNCache cacheWithF:^id(id vp) {
            GEVec2 textSize = [_weakSelf.font measureText:[TRStr.Loc callRepairer]];
            return wrap(GEVec2, geVec4Xy([[EGGlobal.matrix p] divBySelfVec4:geVec4ApplyVec2ZW(geVec2MulF(textSize, 1.2), 0.0, 0.0)]));
        }];
        _buttons = [NSMutableDictionary mutableDictionary];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _TRCallRepairerView_type = [ODClassType classTypeWithCls:[TRCallRepairerView class]];
}

- (void)draw {
    if(!([[_level.railroad damagesPoints] isEmpty]) && [[_level repairer] isEmpty]) {
        glDisable(GL_DEPTH_TEST);
        egBlendFunctionApplyDraw(egBlendFunctionStandard(), ^void() {
            [[_level cities] forEach:^void(TRCity* _) {
                [self drawButtonForCity:_];
            }];
        });
        glEnable(GL_DEPTH_TEST);
    } else {
        if(!([_buttons isEmpty])) [_buttons clear];
    }
}

- (void)drawButtonForCity:(TRCity*)city {
    EGMapTileCutState cut = [_level.map cutStateForTile:city.tile];
    GEVec2 bs = uwrap(GEVec2, [_buttonSize applyX:wrap(GERectI, [EGGlobal.context viewport])]);
    GEVec2 p;
    if(cut.x != 0 && cut.y == 0 && cut.y2 == 0) {
        p = GEVec2Make(0.0, ((float)(EGMapSso.ISO / 4 + bs.y)));
    } else {
        if(cut.y != 0) {
            if(cut.x2 != 0) p = GEVec2Make(((float)(-EGMapSso.ISO / 2 - bs.x)), -bs.y);
            else p = GEVec2Make(((float)(EGMapSso.ISO / 2)), -bs.y);
        } else {
            if(cut.y2 != 0) {
                if(cut.x2 != 0) p = GEVec2Make(((float)(-EGMapSso.ISO / 2 - bs.x)), 0.0);
                else p = GEVec2Make(((float)(EGMapSso.ISO / 2)), 0.0);
            } else {
                p = GEVec2Make(-bs.x, ((float)(EGMapSso.ISO / 4 + bs.y)));
            }
        }
    }
    EGBillboard* billboard = ((EGBillboard*)([_buttons objectForKey:city orUpdateWith:^EGBillboard*() {
        return [EGBillboard applyMaterial:[EGColorSource applyColor:geVec4ApplyVec3W(geVec4Xyz(city.color.color), 0.8)]];
    }]));
    billboard.position = geVec3ApplyVec2Z(geVec2ApplyVec2i(city.tile), 0.0);
    billboard.rect = GERectMake(p, bs);
    [billboard draw];
    [_font drawText:[TRStr.Loc callRepairer] color:GEVec4Make(0.1, 0.1, 0.1, 1.0) at:billboard.position alignment:EGTextAlignmentMake(0.0, 0.0, NO, geVec3ApplyVec2Z(geVec2AddVec2(p, geVec2DivI(bs, 2)), 0.0))];
}

- (BOOL)processEvent:(EGEvent*)event {
    return [event leftMouseProcessor:self];
}

- (BOOL)mouseDownEvent:(EGEvent*)event {
    GEVec2 p = [event locationInViewport];
    id b = [[_buttons chain] find:^BOOL(CNTuple* _) {
        return [((EGBillboard*)(_.b)) containsVec2:p];
    }];
    [b forEach:^void(CNTuple* kv) {
        [_level runRepairerFromCity:((TRCity*)(kv.a))];
    }];
    return [b isDefined];
}

- (BOOL)isProcessorActive {
    return !([[EGGlobal director] isPaused]);
}

- (BOOL)mouseDragEvent:(EGEvent*)event {
    return NO;
}

- (BOOL)mouseUpEvent:(EGEvent*)event {
    return NO;
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


