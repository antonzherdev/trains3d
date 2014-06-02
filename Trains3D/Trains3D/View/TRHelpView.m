#import "TRHelpView.h"

#import "TRLevel.h"
#import "EGText.h"
#import "EGPlatformPlat.h"
#import "EGPlatform.h"
#import "EGContext.h"
#import "CNReact.h"
#import "TRStrings.h"
#import "EGSprite.h"
#import "EGMaterial.h"
#import "EGDirector.h"
#import "EGInput.h"
@implementation TRHelpView
static CNClassType* _TRHelpView_type;
@synthesize level = _level;
@synthesize _allowClose = __allowClose;

+ (instancetype)helpViewWithLevel:(TRLevel*)level {
    return [[TRHelpView alloc] initWithLevel:level];
}

- (instancetype)initWithLevel:(TRLevel*)level {
    self = [super init];
    if(self) {
        _level = level;
        _delta = 12;
        _helpText = [EGText applyFont:[CNReact applyValue:[EGGlobal mainFontWithSize:((egPlatform().isPhone) ? 14 : 16)]] text:[level.help mapF:^NSString*(TRHelp* h) {
            if(h != nil) return ((TRHelp*)(nonnil(h))).text;
            else return @"";
        }] position:[EGGlobal.context.scaledViewSize mapF:^id(id _) {
            return wrap(GEVec3, (geVec3ApplyVec2((geVec2DivI((uwrap(GEVec2, _)), 2)))));
        }] alignment:[CNReact applyValue:wrap(EGTextAlignment, (egTextAlignmentApplyXYShift(0.0, 0.0, (GEVec2Make(0.0, ((float)(_delta)))))))] color:[CNReact applyValue:wrap(GEVec4, (GEVec4Make(0.0, 0.0, 0.0, 1.0)))]];
        _tapText = [EGText applyFont:[CNReact applyValue:[EGGlobal mainFontWithSize:12]] text:[CNReact applyValue:[NSString stringWithFormat:@"(%@)", [TRStr.Loc tapToContinue]]] position:_helpText.position alignment:[[_helpText sizeInPoints] mapF:^id(id helpSize) {
            return wrap(EGTextAlignment, (egTextAlignmentApplyXYShift(0.0, 0.0, (GEVec2Make(0.0, (uwrap(GEVec2, helpSize).y / -2))))));
        }] color:[CNReact applyValue:wrap(GEVec4, (GEVec4Make(0.0, 0.0, 0.0, 1.0)))]];
        _helpBackSprite = [EGSprite spriteWithVisible:[CNReact applyValue:@YES] material:[CNReact applyValue:[EGColorSource applyColor:GEVec4Make(1.0, 1.0, 1.0, 0.8)]] position:_helpText.position rect:[CNReact applyA:[_helpText sizeInPoints] b:[_tapText sizeInPoints] f:^id(id helpSize, id tapSize) {
            GEVec2 size = geVec2AddVec2((geVec2MulVec2((uwrap(GEVec2, helpSize)), (GEVec2Make(1.1, 1.4)))), (GEVec2Make(0.0, (uwrap(GEVec2, tapSize).y))));
            return wrap(GERect, (GERectMake((geVec2DivI(size, -2)), size)));
        }]];
        __allowClose = NO;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [TRHelpView class]) _TRHelpView_type = [CNClassType classTypeWithCls:[TRHelpView class]];
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

- (NSString*)description {
    return [NSString stringWithFormat:@"HelpView(%@)", _level];
}

- (CNClassType*)type {
    return [TRHelpView type];
}

+ (CNClassType*)type {
    return _TRHelpView_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

