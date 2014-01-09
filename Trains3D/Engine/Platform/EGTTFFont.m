#import "EGTTFFont.h"

#import "EGTexture.h"
#import "GL.h"
@implementation EGTTFFont{
    NSString* _name;
    NSUInteger _size;
    NSMutableDictionary* _symbols;
    id _textureOpt;
    NSUInteger _height;
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
        #if TARGET_OS_IPHONE
        UIFont* font = [UIFont fontWithName:_name size:_size];
        _height = (NSUInteger) ceil(font.lineHeight);
        #else
        NSFont* font = [NSFont fontWithName:_name size:_size];
        _height = (NSUInteger) [[[NSLayoutManager alloc] init] defaultLineHeightForFont:font];
        #endif

        NSAssert(font, @"Not found font %@", _name);
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGTTFFont_type = [ODClassType classTypeWithCls:[EGTTFFont class]];
}

- (id)symbolOptSmb:(unichar)smb {
    return [CNOption applyValue:[_symbols objectForKey:nums(smb) orUpdateWith:^EGFontSymbolDesc*() {
        _textureOpt = [CNOption none];
        [[EGFont fontChangeNotification] postSender:self];
        return [self symbolSmb:smb];
    }]];
}

- (EGFontSymbolDesc*)symbolSmb:(unichar)smb {
    return [EGFont zeroDesc];
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

- (NSUInteger)height {
    return _height;
}

- (BOOL)resymbol {
    if([_textureOpt isEmpty]) {
        [self updateTexture];
        return YES;
    }
    return NO;
}


- (EGTexture*)generateTexture {
    #if TARGET_OS_IPHONE
    UIFont* font = [UIFont fontWithName:_name size:_size];
    #else
    NSFont* font = [NSFont fontWithName:_name size:_size];
    #endif
    
    //Measure texture size
    NSUInteger symbolsCount = _symbols.count;
    NSUInteger symbolsInString = (NSUInteger) ceil(sqrt(symbolsCount));
    NSUInteger textureSize = (NSUInteger) (symbolsInString * _height);
    NSUInteger w = 32;
    while(textureSize > w) w *= 2;
    textureSize = w;

    NSLog(@"Font: GenerateTexture: %@ %lu %lu%lui", _name, (unsigned long)_size, (unsigned long)textureSize, (unsigned long)textureSize);

    
    //Create Texture
    unsigned char* data = calloc(textureSize, textureSize * 4);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(data, textureSize, textureSize, 8, textureSize * 4, colorSpace, 
            kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);
    if (!context)
    {
        free(data);
        return NULL;
    }
    CGAffineTransform flipVertical = CGAffineTransformMake(1, 0, 0, -1, 0, textureSize);
    CGContextConcatCTM(context, flipVertical);
    #if TARGET_OS_IPHONE
    UIGraphicsPushContext(context);
    UIColor* color = [UIColor whiteColor];
    [color set];
    #else
    [NSGraphicsContext saveGraphicsState];
    NSGraphicsContext * nscg = [NSGraphicsContext graphicsContextWithGraphicsPort:context flipped:YES];
    [NSGraphicsContext setCurrentContext:nscg];
    NSColor* color = [NSColor whiteColor];
    [color set];
    #endif


  
    __block NSUInteger i = 0;
    __block NSUInteger x = 0, y = 0;
    NSDictionary *attributes = @{NSFontAttributeName : font, NSForegroundColorAttributeName : color};
    [[_symbols copy] enumerateKeysAndObjectsUsingBlock:^(id key, EGFontSymbolDesc* desc, BOOL *stop) {
        unichar c = unums(key);
        NSAttributedString *str = [[NSAttributedString alloc] initWithString:[NSString stringWithCharacters:&c length:1] attributes:attributes];
        GEVec2 size;
        if(desc.width == 0) {
            #if TARGET_OS_IPHONE
            CGSize s = [str size];
            #else
            NSSize s = [str size];
            #endif
            size = (GEVec2){ceil(s.width), ceil(s.height)};
        } else {
            size = desc.size;
        }
        EGFontSymbolDesc *d = [EGFontSymbolDesc fontSymbolDescWithWidth:size.x offset:GEVec2Make(0, 0) size:size
                                                              textureRect:geRectDivF(geRectApplyXYWidthHeight(
                                                                      x, y, size.x, _height), textureSize)
                                                                isNewLine:false];
        [_symbols setObject:d forKey:key];

        [str drawAtPoint:CGPointMake(x, y)];
        i++;
        if(i >= symbolsInString) {
            i = 0;
            x = 0;
            y += _height;
        } else {
            x += size.x;
        }
    }];

#if TARGET_OS_IPHONE
    UIGraphicsPopContext();
#else
    [NSGraphicsContext restoreGraphicsState];
#endif
    CGContextRelease(context);

    //Create texture
    GEVec2 ts = GEVec2Make(textureSize, textureSize);
    EGEmptyTexture *texture = [EGEmptyTexture emptyTextureWithSize:ts];
    egLoadTextureFromData(texture.id, GL_NEAREST, GL_NEAREST, ts, data);
//    egSaveTextureToFile(texture.id, @"./test.png");
    free(data);
    return texture;
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


