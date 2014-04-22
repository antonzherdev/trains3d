#import "objd.h"
#import "GEVec.h"

@class EGOS;
@class EGDevice;
@class EGPlatform;
@class EGVersion;
@class EGOSType;
@class EGInterfaceIdiom;
@class EGDeviceType;

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


@interface EGDeviceType : ODEnum
+ (EGDeviceType*)iPhone;
+ (EGDeviceType*)iPad;
+ (EGDeviceType*)iPodTouch;
+ (EGDeviceType*)Simulator;
+ (EGDeviceType*)Mac;
+ (NSArray*)values;
@end


@interface EGOS : NSObject {
@protected
    EGOSType* _tp;
    EGVersion* _version;
    BOOL _jailbreak;
}
@property (nonatomic, readonly) EGOSType* tp;
@property (nonatomic, readonly) EGVersion* version;
@property (nonatomic, readonly) BOOL jailbreak;

+ (instancetype)sWithTp:(EGOSType*)tp version:(EGVersion*)version jailbreak:(BOOL)jailbreak;
- (instancetype)initWithTp:(EGOSType*)tp version:(EGVersion*)version jailbreak:(BOOL)jailbreak;
- (ODClassType*)type;
- (BOOL)isIOS;
- (BOOL)isIOSLessVersion:(NSString*)version;
+ (ODClassType*)type;
@end


@interface EGDevice : NSObject {
@protected
    EGDeviceType* _tp;
    EGInterfaceIdiom* _interfaceIdiom;
    EGVersion* _version;
    GEVec2 _screenSize;
}
@property (nonatomic, readonly) EGDeviceType* tp;
@property (nonatomic, readonly) EGInterfaceIdiom* interfaceIdiom;
@property (nonatomic, readonly) EGVersion* version;
@property (nonatomic, readonly) GEVec2 screenSize;

+ (instancetype)deviceWithTp:(EGDeviceType*)tp interfaceIdiom:(EGInterfaceIdiom*)interfaceIdiom version:(EGVersion*)version screenSize:(GEVec2)screenSize;
- (instancetype)initWithTp:(EGDeviceType*)tp interfaceIdiom:(EGInterfaceIdiom*)interfaceIdiom version:(EGVersion*)version screenSize:(GEVec2)screenSize;
- (ODClassType*)type;
- (BOOL)isIPhoneLessVersion:(NSString*)version;
- (BOOL)isIPodTouchLessVersion:(NSString*)version;
+ (ODClassType*)type;
@end


@interface EGPlatform : NSObject {
@protected
    EGOS* _os;
    EGDevice* _device;
    NSString* _text;
    BOOL _shadows;
    BOOL _touch;
    EGInterfaceIdiom* _interfaceIdiom;
    BOOL _isPhone;
    BOOL _isPad;
    BOOL _isComputer;
}
@property (nonatomic, readonly) EGOS* os;
@property (nonatomic, readonly) EGDevice* device;
@property (nonatomic, readonly) NSString* text;
@property (nonatomic, readonly) BOOL shadows;
@property (nonatomic, readonly) BOOL touch;
@property (nonatomic, readonly) EGInterfaceIdiom* interfaceIdiom;
@property (nonatomic, readonly) BOOL isPhone;
@property (nonatomic, readonly) BOOL isPad;
@property (nonatomic, readonly) BOOL isComputer;

+ (instancetype)platformWithOs:(EGOS*)os device:(EGDevice*)device text:(NSString*)text;
- (instancetype)initWithOs:(EGOS*)os device:(EGDevice*)device text:(NSString*)text;
- (ODClassType*)type;
- (GEVec2)screenSize;
- (CGFloat)screenSizeRatio;
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


