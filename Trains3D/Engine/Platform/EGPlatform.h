#import "objd.h"
#import "GEVec.h"

@class EGPlatform;
@class EGVersion;
@class EGOSType;
@class EGInterfaceIdiom;

@interface EGOSType : ODEnum
@property (nonatomic, readonly) BOOL shadows;
@property (nonatomic, readonly) BOOL touch;

+ (EGOSType*)MacOS;
+ (EGOSType*)iOS;
+ (NSArray*)values;
@end


@interface EGInterfaceIdiom : ODEnum
@property (nonatomic, readonly) BOOL isPhone;
@property (nonatomic, readonly) BOOL isPad;
@property (nonatomic, readonly) BOOL isComputer;

+ (EGInterfaceIdiom*)phone;
+ (EGInterfaceIdiom*)pad;
+ (EGInterfaceIdiom*)computer;
+ (NSArray*)values;
@end


@interface EGPlatform : NSObject
@property (nonatomic, readonly) EGOSType* os;
@property (nonatomic, readonly) EGInterfaceIdiom* interfaceIdiom;
@property (nonatomic, readonly) EGVersion* version;
@property (nonatomic, readonly) GEVec2 screenSize;
@property (nonatomic, readonly) BOOL shadows;
@property (nonatomic, readonly) BOOL touch;
@property (nonatomic, readonly) BOOL isPhone;
@property (nonatomic, readonly) BOOL isPad;
@property (nonatomic, readonly) BOOL isComputer;

+ (id)platformWithOs:(EGOSType*)os interfaceIdiom:(EGInterfaceIdiom*)interfaceIdiom version:(EGVersion*)version screenSize:(GEVec2)screenSize;
- (id)initWithOs:(EGOSType*)os interfaceIdiom:(EGInterfaceIdiom*)interfaceIdiom version:(EGVersion*)version screenSize:(GEVec2)screenSize;
- (ODClassType*)type;
- (CGFloat)screenSizeRatio;
+ (ODClassType*)type;
@end


@interface EGVersion : NSObject<ODComparable>
@property (nonatomic, readonly) id<CNSeq> parts;

+ (id)versionWithParts:(id<CNSeq>)parts;
- (id)initWithParts:(id<CNSeq>)parts;
- (ODClassType*)type;
+ (EGVersion*)applyStr:(NSString*)str;
- (NSInteger)compareTo:(EGVersion*)to;
+ (ODClassType*)type;
@end


