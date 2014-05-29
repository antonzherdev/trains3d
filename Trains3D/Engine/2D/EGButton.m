#import "EGButton.h"

#import "EGSprite.h"
#import "EGText.h"
#import "CNObserver.h"
#import "EGInput.h"
#import "CNReact.h"
@implementation EGButton
static CNClassType* _EGButton_type;
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
    if(self == [EGButton class]) _EGButton_type = [CNClassType classTypeWithCls:[EGButton class]];
}

- (CNSignal*)tap {
    return _sprite.tap;
}

- (void)draw {
    [_sprite draw];
    [_text draw];
}

- (BOOL)tapEvent:(id<EGEvent>)event {
    return [_sprite tapEvent:event];
}

+ (EGButton*)applyVisible:(CNReact*)visible font:(CNReact*)font text:(CNReact*)text textColor:(CNReact*)textColor backgroundMaterial:(CNReact*)backgroundMaterial position:(CNReact*)position rect:(CNReact*)rect {
    return [EGButton buttonWithSprite:[EGSprite spriteWithVisible:visible material:backgroundMaterial position:position rect:rect] text:[EGText applyVisible:visible font:font text:text position:position alignment:[rect mapF:^id(id r) {
        return wrap(EGTextAlignment, (EGTextAlignmentMake(0.0, 0.0, NO, (geRectCenter((uwrap(GERect, r)))))));
    }] color:textColor]];
}

+ (EGButton*)applyFont:(CNReact*)font text:(CNReact*)text textColor:(CNReact*)textColor backgroundMaterial:(CNReact*)backgroundMaterial position:(CNReact*)position rect:(CNReact*)rect {
    return [EGButton applyVisible:[CNReact applyValue:@YES] font:font text:text textColor:textColor backgroundMaterial:backgroundMaterial position:position rect:rect];
}

- (NSString*)description {
    return [NSString stringWithFormat:@"Button(%@, %@)", _sprite, _text];
}

- (CNClassType*)type {
    return [EGButton type];
}

+ (CNClassType*)type {
    return _EGButton_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

