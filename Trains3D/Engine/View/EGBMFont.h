#import "objd.h"
#import "EGFont.h"
#import "GEVec.h"
@class EGFileTexture;
@class EGTextureFileFormat;
@class EGTextureFormat;
@class EGTextureFilter;

@class EGBMFont;

@interface EGBMFont : EGFont {
@private
    NSString* _name;
    EGFileTexture* _texture;
    id<CNMap> _symbols;
    NSUInteger _height;
    NSUInteger _size;
}
@property (nonatomic, readonly) NSString* name;
@property (nonatomic, readonly) EGFileTexture* texture;
@property (nonatomic, readonly) NSUInteger height;
@property (nonatomic, readonly) NSUInteger size;

+ (instancetype)fontWithName:(NSString*)name;
- (instancetype)initWithName:(NSString*)name;
- (ODClassType*)type;
- (void)_init;
- (EGFontSymbolDesc*)symbolOptSmb:(unichar)smb;
+ (ODClassType*)type;
@end


