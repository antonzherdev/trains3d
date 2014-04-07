#import "EGButton.h"

#import "EGSprite.h"
#import "EGText.h"
#import "ATObserver.h"
#import "EGInput.h"
#import "ATReact.h"
@implementation EGButton
static ODClassType* _EGButton_type;
@synthesize sprite = _sprite;
@synthesize text = _text;

+ (instancetype)buttonWithSprite:(EGSprite*)sprite text:(EGText*)text {
    return [[EGButton alloc] initWithSprite:sprite text:text];
}

- (instancetype)initWithSprite:(EGSprite*)sprite text:(EGText*)text {
    self = [super init];
    if(self) {
        _sprite = sprite;
        _text = text;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGButton class]) _EGButton_type = [ODClassType classTypeWithCls:[EGButton class]];
}

- (ATSignal*)tap {
    return _sprite.tap;
}

- (void)draw {
    [_sprite draw];
    [_text draw];
}

- (BOOL)tapEvent:(id<EGEvent>)event {
    return [_sprite tapEvent:event];
}

+ (EGButton*)applyVisible:(ATReact*)visible font:(ATReact*)font text:(ATReact*)text textColor:(ATReact*)textColor backgroundMaterial:(ATReact*)backgroundMaterial position:(ATReact*)position rect:(ATReact*)rect {
    return [EGButton buttonWithSprite:[EGSprite spriteWithVisible:visible material:backgroundMaterial position:position rect:rect] text:[EGText applyVisible:visible font:font text:text position:position alignment:[rect mapF:^id(id r) {
        return wrap(EGTextAlignment, (EGTextAlignmentMake(0.0, 0.0, NO, (geRectCenter((uwrap(GERect, r)))))));
    }] color:textColor]];
}

+ (EGButton*)applyFont:(ATReact*)font text:(ATReact*)text textColor:(ATReact*)textColor backgroundMaterial:(ATReact*)backgroundMaterial position:(ATReact*)position rect:(ATReact*)rect {
    return [EGButton applyVisible:[ATReact applyValue:@YES] font:font text:text textColor:textColor backgroundMaterial:backgroundMaterial position:position rect:rect];
}

- (ODClassType*)type {
    return [EGButton type];
}

+ (ODClassType*)type {
    return _EGButton_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"sprite=%@", self.sprite];
    [description appendFormat:@", text=%@", self.text];
    [description appendString:@">"];
    return description;
}

@end


