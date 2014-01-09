#import "EGTTFFont.h"

#import "EGTexture.h"
@implementation EGTTFFont{
    NSString* _name;
    NSUInteger _size;
    NSMutableDictionary* _symbols;
    id _textureOpt;
}
static ODClassType* _EGTTFFont_type;
@synthesize name = _name;
@synthesize size = _size;

+ (id)fontWithName:(NSString*)name size:(NSUInteger)size {
    return [[EGTTFFont alloc] initWithName:name size:size];
}

- (id)initWithName:(NSString*)name size:(NSUInteger)size {
    self = [super init];
    if(self) {
        _name = name;
        _size = size;
        _symbols = [NSMutableDictionary mutableDictionary];
        _textureOpt = [CNOption none];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGTTFFont_type = [ODClassType classTypeWithCls:[EGTTFFont class]];
}

- (id)symbolOptSmb:(unichar)smb {
    return [CNOption applyValue:[_symbols objectForKey:nums(smb) orUpdateWith:^EGFontSymbolDesc*() {
        return [self symbolSmb:smb];
    }]];
}

- (EGFontSymbolDesc*)symbolSmb:(unichar)smb {
    @throw @"Method symbol is abstract";
}

- (EGTexture*)texture {
    return [_textureOpt getOrElseF:^EGTexture*() {
        return [self updateTexture];
    }];
}

- (EGTexture*)updateTexture {
    EGTexture* txt = [self generateTexture];
    _textureOpt = [CNOption applyValue:txt];
    return txt;
}

- (EGTexture*)generateTexture {
    @throw @"Method generateTexture is abstract";
}

- (ODClassType*)type {
    return [EGTTFFont type];
}

+ (ODClassType*)type {
    return _EGTTFFont_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGTTFFont* o = ((EGTTFFont*)(other));
    return [self.name isEqual:o.name] && self.size == o.size;
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.name hash];
    hash = hash * 31 + self.size;
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"name=%@", self.name];
    [description appendFormat:@", size=%lu", (unsigned long)self.size];
    [description appendString:@">"];
    return description;
}

@end


