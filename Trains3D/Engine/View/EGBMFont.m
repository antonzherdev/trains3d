#import "EGBMFont.h"

#import "EGTexture.h"
@implementation EGBMFont
static ODClassType* _EGBMFont_type;
@synthesize name = _name;
@synthesize texture = _texture;
@synthesize height = _height;
@synthesize size = _size;

+ (instancetype)fontWithName:(NSString*)name {
    return [[EGBMFont alloc] initWithName:name];
}

- (instancetype)initWithName:(NSString*)name {
    self = [super init];
    if(self) {
        _name = name;
        _texture = [EGFileTexture fileTextureWithName:_name fileFormat:EGTextureFileFormat.PNG format:EGTextureFormat.RGBA8 scale:1.0 filter:EGTextureFilter.nearest];
        [self _init];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGBMFont class]) _EGBMFont_type = [ODClassType classTypeWithCls:[EGBMFont class]];
}

- (void)_init {
    NSMutableDictionary* charMap = [NSMutableDictionary mutableDictionary];
    GEVec2 ts = [_texture size];
    [[[OSBundle readToStringResource:[NSString stringWithFormat:@"%@.fnt", _name]] splitBy:@"\n"] forEach:^void(NSString* line) {
        CNTuple* t = ((CNTuple*)([line tupleBy:@" "]));
        if(t != nil) {
            NSString* name = ((CNTuple*)(t)).a;
            id<CNImMap> map = [[[[((CNTuple*)(t)).b splitBy:@" "] chain] mapOpt:^CNTuple*(NSString* _) {
                return [_ tupleBy:@"="];
            }] toMap];
            if([name isEqual:@"info"]) {
                _size = [[map applyKey:@"size"] toUInt];
            } else {
                if([name isEqual:@"common"]) {
                    _height = [[map applyKey:@"lineHeight"] toUInt];
                } else {
                    if([name isEqual:@"char"]) {
                        unichar code = ((unichar)([[map applyKey:@"id"] toInt]));
                        float width = ((float)([[map applyKey:@"xadvance"] toFloat]));
                        GEVec2i offset = GEVec2iMake([[map applyKey:@"xoffset"] toInt], [[map applyKey:@"yoffset"] toInt]);
                        GERect r = geRectApplyXYWidthHeight(((float)([[map applyKey:@"x"] toFloat])), ((float)([[map applyKey:@"y"] toFloat])), ((float)([[map applyKey:@"width"] toFloat])), ((float)([[map applyKey:@"height"] toFloat])));
                        [charMap setKey:nums(code) value:[EGFontSymbolDesc fontSymbolDescWithWidth:width offset:geVec2ApplyVec2i(offset) size:r.size textureRect:geRectDivVec2(r, ts) isNewLine:NO]];
                    }
                }
            }
        }
    }];
    _symbols = charMap;
}

- (GERect)parse_rect:(NSString*)_rect {
    NSArray* parts = [[[_rect splitBy:@" "] chain] toArray];
    CGFloat y = [[parts applyIndex:1] toFloat];
    CGFloat h = [[parts applyIndex:3] toFloat];
    return geRectApplyXYWidthHeight(((float)([[parts applyIndex:0] toFloat])), ((float)(y)), ((float)([[parts applyIndex:2] toFloat])), ((float)(h)));
}

- (EGFontSymbolDesc*)symbolOptSmb:(unichar)smb {
    return [_symbols optKey:nums(smb)];
}

- (ODClassType*)type {
    return [EGBMFont type];
}

+ (ODClassType*)type {
    return _EGBMFont_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGBMFont* o = ((EGBMFont*)(other));
    return [self.name isEqual:o.name];
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.name hash];
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"name=%@", self.name];
    [description appendString:@">"];
    return description;
}

@end


