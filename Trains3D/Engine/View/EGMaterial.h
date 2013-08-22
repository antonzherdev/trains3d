#import "objd.h"
#import "EGTypes.h"

@class EGMaterial;

@interface EGMaterial : NSObject
@property (nonatomic, readonly) EGColor ambient;
@property (nonatomic, readonly) EGColor diffuse;
@property (nonatomic, readonly) EGColor specular;
@property (nonatomic, readonly) CGFloat shininess;

+ (id)materialWithAmbient:(EGColor)ambient diffuse:(EGColor)diffuse specular:(EGColor)specular shininess:(CGFloat)shininess;
- (id)initWithAmbient:(EGColor)ambient diffuse:(EGColor)diffuse specular:(EGColor)specular shininess:(CGFloat)shininess;
- (void)set;
- (void)drawF:(void(^)())f;
+ (EGMaterial*)default;
+ (EGMaterial*)emerald;
+ (EGMaterial*)jade;
+ (EGMaterial*)obsidian;
+ (EGMaterial*)pearl;
+ (EGMaterial*)ruby;
+ (EGMaterial*)turquoise;
+ (EGMaterial*)brass;
+ (EGMaterial*)bronze;
+ (EGMaterial*)chrome;
+ (EGMaterial*)copper;
+ (EGMaterial*)gold;
+ (EGMaterial*)silver;
+ (EGMaterial*)blackPlastic;
+ (EGMaterial*)cyanPlastic;
+ (EGMaterial*)greenPlastic;
+ (EGMaterial*)redPlastic;
+ (EGMaterial*)whitePlastic;
+ (EGMaterial*)yellowPlastic;
+ (EGMaterial*)blackRubber;
+ (EGMaterial*)cyanRubber;
+ (EGMaterial*)greenRubber;
+ (EGMaterial*)redRubber;
+ (EGMaterial*)whiteRubber;
+ (EGMaterial*)yellowRubber;
+ (EGMaterial*)wood;
+ (EGMaterial*)stone;
+ (EGMaterial*)steel;
+ (EGMaterial*)blackMetal;
+ (EGMaterial*)grass;
@end


