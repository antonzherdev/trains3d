#import "objd.h"
#import "EGFont.h"
#import "EGTexture.h"
#import "GEVec.h"
@class CNChain;

@class EGBMFont;

@interface EGBMFont : EGFont {
@protected
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
- (CNClassType*)type;
- (void)_init;
- (EGFontSymbolDesc*)symbolOptSmb:(unichar)smb;
- (NSString*)description;
- (BOOL)isEqual:(id)to;
- (NSUInteger)hash;
+ (CNClassType*)type;
@end


