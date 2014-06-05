#import "TRHelpView.h"

#import "TRLevel.h"
#import "PGText.h"
#import "PGPlatformPlat.h"
#import "PGPlatform.h"
#import "PGContext.h"
#import "CNReact.h"
#import "TRStrings.h"
#import "PGSprite.h"
#import "PGMaterial.h"
#import "PGDirector.h"
#import "PGInput.h"
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
        _helpText = [PGText applyFont:[CNReact applyValue:[PGGlobal mainFontWithSize:((egPlatform()->_isPhone) ? 14 : 16)]] text:[level->_help mapF:^NSString*(TRHelp* h) {
            if(h != nil) return ((TRHelp*)(nonnil(h)))->_text;
            else return @"";
        }] position:[[PGGlobal context]->_scaledViewSize mapF:^id(id _) {
            return wrap(PGVec3, (pgVec3ApplyVec2((pgVec2DivI((uwrap(PGVec2, _)), 2)))));
        }] alignment:[CNReact applyValue:wrap(PGTextAlignment, (pgTextAlignmentApplyXYShift(0.0, 0.0, (PGVec2Make(0.0, ((float)(_delta)))))))] color:[CNReact applyValue:wrap(PGVec4, (PGVec4Make(0.0, 0.0, 0.0, 1.0)))]];
        _tapText = [PGText applyFont:[CNReact applyValue:[PGGlobal mainFontWithSize:12]] text:[CNReact applyValue:[NSString stringWithFormat:@"(%@)", [[TRStr Loc] tapToContinue]]] position:_helpText->_position alignment:[[_helpText sizeInPoints] mapF:^id(id helpSize) {
            return wrap(PGTextAlignment, (pgTextAlignmentApplyXYShift(0.0, 0.0, (PGVec2Make(0.0, (uwrap(PGVec2, helpSize).y / -2))))));
        }] color:[CNReact applyValue:wrap(PGVec4, (PGVec4Make(0.0, 0.0, 0.0, 1.0)))]];
        _helpBackSprite = [PGSprite spriteWithVisible:[CNReact applyValue:@YES] material:[CNReact applyValue:[PGColorSource applyColor:PGVec4Make(1.0, 1.0, 1.0, 0.8)]] position:_helpText->_position rect:[CNReact applyA:[_helpText sizeInPoints] b:[_tapText sizeInPoints] f:^id(id helpSize, id tapSize) {
            PGVec2 size = pgVec2AddVec2((pgVec2MulVec2((uwrap(PGVec2, helpSize)), (PGVec2Make(1.1, 1.4)))), (PGVec2Make(0.0, (uwrap(PGVec2, tapSize).y))));
            return wrap(PGRect, (PGRectMake((pgVec2DivI(size, -2)), size)));
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
    __weak TRHelpView* _weakSelf = self;
    [_helpBackSprite draw];
    [_helpText draw];
    [_tapText draw];
    delay(1.0, ^void() {
        TRHelpView* _self = _weakSelf;
        if(_self != nil) _self->__allowClose = YES;
    });
}

- (BOOL)tapEvent:(id<PGEvent>)event {
    if(__allowClose) {
        [_level clearHelp];
        [[PGDirector current] resume];
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

