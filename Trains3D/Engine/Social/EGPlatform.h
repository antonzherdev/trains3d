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


@interface EGPlatform : NSObject {
@protected
    EGOSType* _os;
    EGInterfaceIdiom* _interfaceIdiom;
    EGVersion* _version;
    GEVec2 _screenSize;
    BOOL _jailbreak;
    NSString* _text;
    BOOL _shadows;
    BOOL _touch;
    BOOL _isPhone;
    BOOL _isPad;
    BOOL _isComputer;
}
@property (nonatomic, readonly) EGOSType* os;
@property (nonatomic, readonly) EGInterfaceIdiom* interfaceIdiom;
@property (nonatomic, readonly) EGVersion* version;
@property (nonatomic, readonly) GEVec2 screenSize;
@property (nonatomic, readonly) BOOL jailbreak;
@property (nonatomic, readonly) NSString* text;
@property (nonatomic, readonly) BOOL shadows;
@property (nonatomic, readonly) BOOL touch;
@property (nonatomic, readonly) BOOL isPhone;
@property (nonatomic, readonly) BOOL isPad;
@property (nonatomic, readonly) BOOL isComputer;

+ (instancetype)platformWithOs:(EGOSType*)os interfaceIdiom:(EGInterfaceIdiom*)interfaceIdiom version:(EGVersion*)version screenSize:(GEVec2)screenSize jailbreak:(BOOL)jailbreak text:(NSString*)text;
- (instancetype)initWithOs:(EGOSType*)os interfaceIdiom:(EGInterfaceIdiom*)interfaceIdiom version:(EGVersion*)version screenSize:(GEVec2)screenSize jailbreak:(BOOL)jailbreak text:(NSString*)text;
- (ODClassType*)type;
- (CGFloat)screenSizeRatio;
- (BOOL)isIOS;
- (BOOL)isIOSLessVersion:(NSString*)version;
+ (ODClassType*)type;
@end


@interface EGVersion : NSObject<ODComparable> {
@protected
    NSArray* _parts;
}
@property (nonatomic, readonly) NSArray* parts;

+ (instancetype)versionWithParts:(NSArray*)parts;
- (instancetype)initWithParts:(NSArray*)parts;
- (ODClassType*)type;
+ (EGVersion*)applyStr:(NSString*)str;
- (NSInteger)compareTo:(EGVersion*)to;
- (BOOL)lessThan:(NSString*)than;
- (BOOL)moreThan:(NSString*)than;
+ (ODClassType*)type;
@end


