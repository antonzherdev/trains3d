#import "TRHelpView.h"

#import "TRLevel.h"
#import "EGDirector.h"
#import "EGPlatformPlat.h"
#import "EGPlatform.h"
#import "EGContext.h"
#import "ATReact.h"
#import "TRStrings.h"
#import "EGSprite.h"
#import "EGMaterial.h"
#import "EGInput.h"
@implementation TRHelpView
static ODClassType* _TRHelpView_type;
@synthesize level = _level;
@synthesize _allowClose = __allowClose;

+ (instancetype)helpViewWithLevel:(TRLevel*)level {
    return [[TRHelpView alloc] initWithLevel:level];
}

- (instancetype)initWithLevel:(TRLevel*)level {
    self = [super init];
    __weak TRHelpView* _weakSelf = self;
    if(self) {
        _level = level;
        _delta = 12 * [[EGDirector current] scale];
        _helpText = [EGText applyFont:[ATReact applyValue:[EGGlobal mainFontWithSize:((egPlatform().isPhone) ? 14 : 16)]] text:[_level.help mapF:^NSString*(id h) {
            return [[h mapF:^NSString*(TRHelp* _) {
                return ((TRHelp*)(_)).text;
            }] getOrValue:@""];
        }] position:[EGGlobal.context.scaledViewSize mapF:^id(id _) {
            return wrap(GEVec2, (geVec2DivI((uwrap(GEVec2, _)), 2)));
        }] alignment:[ATReact applyValue:wrap(EGTextAlignment, (egTextAlignmentApplyXY(0.0, 0.0)))] color:[ATReact applyValue:wrap(GEVec4, (GEVec4Make(0.0, 0.0, 0.0, 1.0)))]];
        _tapText = [EGText applyFont:[ATReact applyValue:[EGGlobal mainFontWithSize:12]] text:[ATReact applyValue:[NSString stringWithFormat:@"(%@)", [TRStr.Loc tapToContinue]]] position:_helpText.position alignment:[[_helpText sizeInPixels] mapF:^id(id helpSize) {
            TRHelpView* _self = _weakSelf;
            return wrap(EGTextAlignment, (egTextAlignmentApplyXYShift(0.0, 0.0, (GEVec2Make(0.0, (uwrap(GEVec2, helpSize).y / 2 + _self->_delta))))));
        }] color:[ATReact applyValue:wrap(GEVec4, (GEVec4Make(0.0, 0.0, 0.0, 1.0)))]];
        _helpBackSprite = [EGSprite spriteWithVisible:[ATReact applyValue:@YES] material:[ATReact applyValue:[EGColorSource applyColor:GEVec4Make(1.0, 1.0, 1.0, 0.8)]] position:_helpText.position rect:[ATReact applyA:[_helpText sizeInPixels] b:[_tapText sizeInP] f:^id(id helpSize, id tapSize) {
            TRHelpView* _self = _weakSelf;
            GEVec2 size = geVec2AddVec2((geVec2MulVec2((uwrap(GEVec2, helpSize)), (GEVec2Make(1.1, 1.4)))), (GEVec2Make(0.0, (uwrap(GEVec2, tapSize).y + _self->_delta))));
            return wrap(GERect, (GERectMake((geVec2DivI(size, -2)), size)));
        }]];
        __allowClose = NO;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [TRHelpView class]) _TRHelpView_type = [ODClassType classTypeWithCls:[TRHelpView class]];
}

- (void)draw {
    [_helpBackSprite draw];
    [_helpText draw];
    [_tapText draw];
    __weak TRHelpView* ws = self;
    delay(1.0, ^void() {
        ws._allowClose = YES;
    });
}

- (BOOL)tapEvent:(id<EGEvent>)event {
    if(__allowClose) {
        [_level clearHelp];
        [[EGDirector current] resume];
    }
    return YES;
}

- (ODClassType*)type {
    return [TRHelpView type];
}

+ (ODClassType*)type {
    return _TRHelpView_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    TRHelpView* o = ((TRHelpView*)(other));
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


