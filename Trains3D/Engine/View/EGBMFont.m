#import "EGBMFont.h"

#import "CNChain.h"
@implementation EGBMFont
static CNClassType* _EGBMFont_type;
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
        _texture = [EGFileTexture fileTextureWithName:name fileFormat:EGTextureFileFormat_PNG format:EGTextureFormat_RGBA8 scale:1.0 filter:EGTextureFilter_nearest];
        [self _init];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGBMFont class]) _EGBMFont_type = [CNClassType classTypeWithCls:[EGBMFont class]];
}

- (void)_init {
    CNMHashMap* charMap = [CNMHashMap hashMap];
    GEVec2 ts = [_texture size];
    _height = 1;
    _size = 1;
    {
        id<CNIterator> __il__4i = [[[CNBundle readToStringResource:[NSString stringWithFormat:@"%@.fnt", _name]] splitBy:@"\n"] iterator];
        while([__il__4i hasNext]) {
            NSString* line = [__il__4i next];
            {
                CNTuple* t = [line tupleBy:@" "];
                if(t != nil) {
                    NSString* name = ((CNTuple*)(t)).a;
                    NSDictionary* map = [[[[((CNTuple*)(t)).b splitBy:@" "] chain] mapOptF:^CNTuple*(NSString* _) {
                        return [_ tupleBy:@"="];
                    }] toMap];
                    if([name isEqual:@"info"]) {
                        _size = [((NSString*)(nonnil([map applyKey:@"size"]))) toUInt];
                    } else {
                        if([name isEqual:@"common"]) {
                            _height = [((NSString*)(nonnil([map applyKey:@"lineHeight"]))) toUInt];
                        } else {
                            if([name isEqual:@"char"]) {
                                unichar code = ((unichar)([((NSString*)(nonnil([map applyKey:@"id"]))) toInt]));
                                float width = ((float)([((NSString*)(nonnil([map applyKey:@"xadvance"]))) toFloat]));
                                GEVec2i offset = GEVec2iMake([((NSString*)(nonnil([map applyKey:@"xoffset"]))) toInt], [((NSString*)(nonnil([map applyKey:@"yoffset"]))) toInt]);
                                GERect r = geRectApplyXYWidthHeight(((float)([((NSString*)(nonnil([map applyKey:@"x"]))) toFloat])), ((float)([((NSString*)(nonnil([map applyKey:@"y"]))) toFloat])), ((float)([((NSString*)(nonnil([map applyKey:@"width"]))) toFloat])), ((float)([((NSString*)(nonnil([map applyKey:@"height"]))) toFloat])));
                                [charMap setKey:nums(code) value:[EGFontSymbolDesc fontSymbolDescWithWidth:width offset:geVec2ApplyVec2i(offset) size:r.size textureRect:geRectDivVec2(r, ts) isNewLine:NO]];
                            }
                        }
                    }
                }
            }
        }
    }
    _symbols = charMap;
}

- (GERect)parse_rect:(NSString*)_rect {
    NSArray* parts = [[[_rect splitBy:@" "] chain] toArray];
    CGFloat y = [[parts applyIndex:1] toFloat];
    CGFloat h = [[parts applyIndex:3] toFloat];
    return geRectApplyXYWidthHeight(((float)([[parts applyIndex:0] toFloat])), ((float)(y)), ((float)([[parts applyIndex:2] toFloat])), ((float)(h)));
}

- (EGFontSymbolDesc*)symbolOptSmb:(unichar)smb {
    return [_symbols applyKey:nums(smb)];
}

- (NSString*)description {
    return [NSString stringWithFormat:@"BMFont(%@)", _name];
}

- (BOOL)isEqual:(id)to {
    if(self == to) return YES;
    if(to == nil || !([to isKindOfClass:[EGBMFont class]])) return NO;
    EGBMFont* o = ((EGBMFont*)(to));
    return [_name isEqual:o.name];
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [_name hash];
    return hash;
}

- (CNClassType*)type {
    return [EGBMFont type];
}

+ (CNClassType*)type {
    return _EGBMFont_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

