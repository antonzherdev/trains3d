#import "TRCallRepairerView.h"

#import "TRLevel.h"
#import "EGContext.h"
#import "TRRailroad.h"
#import "GL.h"
#import "TRCity.h"
#import "EGBillboard.h"
#import "TRStrings.h"
@implementation TRCallRepairerView{
    TRLevel* _level;
    EGFont* _font;
}
static GEVec2 _TRCallRepairerView_buttonSize = (GEVec2){1.0, 0.3};
static ODClassType* _TRCallRepairerView_type;
@synthesize level = _level;

+ (id)callRepairerViewWithLevel:(TRLevel*)level {
    return [[TRCallRepairerView alloc] initWithLevel:level];
}

- (id)initWithLevel:(TRLevel*)level {
    self = [super init];
    if(self) {
        _level = level;
        _font = [EGGlobal fontWithName:@"lucida_grande_18"];
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
    }
}

- (void)drawButtonForCity:(TRCity*)city {
    EGMapTileCutState cut = [_level.map cutStateForTile:city.tile];
    GEVec2 p;
    if(cut.x != 0 && cut.y == 0 && cut.y2 == 0) {
        p = GEVec2Make(0.0, ((float)(EGMapSso.ISO / 4 + _TRCallRepairerView_buttonSize.y)));
    } else {
        if(cut.y != 0) {
            if(cut.x2 != 0) p = GEVec2Make(((float)(-EGMapSso.ISO / 2 - _TRCallRepairerView_buttonSize.x)), -_TRCallRepairerView_buttonSize.y);
            else p = GEVec2Make(((float)(EGMapSso.ISO / 2)), -_TRCallRepairerView_buttonSize.y);
        } else {
            if(cut.y2 != 0) {
                if(cut.x2 != 0) p = GEVec2Make(((float)(-EGMapSso.ISO / 2 - _TRCallRepairerView_buttonSize.x)), 0.0);
                else p = GEVec2Make(((float)(EGMapSso.ISO / 2)), 0.0);
            } else {
                p = GEVec2Make(-_TRCallRepairerView_buttonSize.x, ((float)(EGMapSso.ISO / 4 + _TRCallRepairerView_buttonSize.y)));
            }
        }
    }
    GEVec3 at = geVec3ApplyVec2Z(geVec2ApplyVec2i(city.tile), 0.0);
    [EGBillboard drawMaterial:[EGColorSource applyColor:geVec4ApplyVec3W(geVec4Xyz(city.color.color), 0.8)] at:at rect:GERectMake(p, _TRCallRepairerView_buttonSize)];
    [_font drawText:[TRStr.Loc callRepairer] color:GEVec4Make(0.1, 0.1, 0.1, 1.0) at:at alignment:EGTextAlignmentMake(0.0, 0.0, NO, geVec3ApplyVec2Z(geVec2AddVec2(p, geVec2DivI(_TRCallRepairerView_buttonSize, 2)), 0.0))];
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


