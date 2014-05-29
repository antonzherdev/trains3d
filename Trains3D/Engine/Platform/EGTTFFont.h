#import "objd.h"
#import "EGFont.h"
@class EGTexture;

@class EGTTFFont;

@interface EGTTFFont : EGFont
@property (nonatomic, readonly) NSString* name;
@property (nonatomic, readonly) NSUInteger size;

+ (id)fontWithName:(NSString*)name size:(NSUInteger)size;
- (id)initWithName:(NSString*)name size:(NSUInteger)size;
- (CNClassType*)type;
- (id)symbolOptSmb:(unichar)smb;
- (EGFontSymbolDesc*)symbolSmb:(unichar)smb;
- (EGTexture*)texture;
+ (CNClassType*)type;
@end


