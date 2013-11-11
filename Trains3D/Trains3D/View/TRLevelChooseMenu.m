#import "TRLevelChooseMenu.h"

#import "TRGameDirector.h"
#import "EGSprite.h"
#import "EGCamera2D.h"
#import "EGContext.h"
#import "TRStrings.h"
#import "EGMaterial.h"
#import "EGInput.h"
@implementation TRLevelChooseMenu{
    NSString* _name;
    NSInteger _maxLevel;
    id<CNSeq> _buttons;
    EGFont* _font;
}
static ODClassType* _TRLevelChooseMenu_type;
@synthesize name = _name;
@synthesize maxLevel = _maxLevel;

+ (id)levelChooseMenu {
    return [[TRLevelChooseMenu alloc] init];
}

- (id)init {
    self = [super init];
    __weak TRLevelChooseMenu* _weakSelf = self;
    if(self) {
        _name = @"Level Choose manu";
        _maxLevel = [TRGameDirector.instance maxAvailableLevel];
        _buttons = [[[intTo(0, 3) chain] flatMap:^CNChain*(id y) {
            return [[intTo(0, 3) chain] map:^EGButton*(id x) {
                NSInteger level = (3 - unumi(y)) * 4 + unumi(x) + 1;
                return [EGButton applyRect:geRectApplyXYWidthHeight(((float)(unumi(x))), ((float)(unumi(y))), 1.0, 1.0) onDraw:[_weakSelf drawButtonX:unumi(x) y:unumi(y) level:level] onClick:^void() {
                    [TRGameDirector.instance setLevel:level];
                }];
            }];
        }] toArray];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _TRLevelChooseMenu_type = [ODClassType classTypeWithCls:[TRLevelChooseMenu class]];
}

+ (EGScene*)scene {
    return [EGScene applySceneView:[TRLevelChooseMenu levelChooseMenu]];
}

- (EGCamera2D*)camera {
    return [EGCamera2D camera2DWithSize:GEVec2Make(4.0, 4.0)];
}

- (void)reshapeWithViewport:(GERect)viewport {
    _font = [EGGlobal fontWithName:@"lucida_grande" size:24];
}

- (void(^)(GERect))drawButtonX:(NSInteger)x y:(NSInteger)y level:(NSInteger)level {
    EGText* text = [EGText applyFont:nil text:[TRStr.Loc levelNumber:((NSUInteger)(level))] position:GEVec3Make(((float)(x + 0.5)), ((float)(y + 0.5)), 0.0) alignment:egTextAlignmentApplyXY(0.0, 0.0) color:((level > _maxLevel) ? GEVec4Make(0.7, 0.7, 0.7, 1.0) : GEVec4Make(0.0, 0.0, 0.0, 1.0))];
    return ^void(GERect rect) {
        [text setFont:_font];
        [text draw];
    };
}

- (void)draw {
    [EGBlendFunction.standard applyDraw:^void() {
        [_buttons forEach:^void(EGButton* _) {
            [((EGButton*)(_)) draw];
        }];
    }];
}

- (BOOL)isProcessorActive {
    return YES;
}

- (BOOL)processEvent:(EGEvent*)event {
    return [_buttons existsWhere:^BOOL(EGButton* _) {
        return [event tapProcessor:_];
    }];
}

- (void)prepare {
}

- (EGEnvironment*)environment {
    return EGEnvironment.aDefault;
}

- (void)updateWithDelta:(CGFloat)delta {
}

- (ODClassType*)type {
    return [TRLevelChooseMenu type];
}

+ (ODClassType*)type {
    return _TRLevelChooseMenu_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    return YES;
}

- (NSUInteger)hash {
    return 0;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendString:@">"];
    return description;
}

@end


