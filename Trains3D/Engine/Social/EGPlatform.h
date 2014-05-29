#import "objd.h"
#import "GEVec.h"
@class CNChain;

@class EGOS;
@class EGDevice;
@class EGPlatform;
@class EGVersion;
@class EGOSType;
@class EGInterfaceIdiom;
@class EGDeviceType;

typedef enum EGOSTypeR {
    EGOSType_Nil = 0,
    EGOSType_MacOS = 1,
    EGOSType_iOS = 2
} EGOSTypeR;
@interface EGOSType : CNEnum
@property (nonatomic, readonly) BOOL shadows;
@property (nonatomic, readonly) BOOL touch;

+ (NSArray*)values;
@end
static EGOSType* EGOSType_Values[3];
static EGOSType* EGOSType_MacOS_Desc;
static EGOSType* EGOSType_iOS_Desc;


typedef enum EGInterfaceIdiomR {
    EGInterfaceIdiom_Nil = 0,
    EGInterfaceIdiom_phone = 1,
    EGInterfaceIdiom_pad = 2,
    EGInterfaceIdiom_computer = 3
} EGInterfaceIdiomR;
@interface EGInterfaceIdiom : CNEnum
@property (nonatomic, readonly) BOOL isPhone;
@property (nonatomic, readonly) BOOL isPad;
@property (nonatomic, readonly) BOOL isComputer;

+ (NSArray*)values;
@end
static EGInterfaceIdiom* EGInterfaceIdiom_Values[4];
static EGInterfaceIdiom* EGInterfaceIdiom_phone_Desc;
static EGInterfaceIdiom* EGInterfaceIdiom_pad_Desc;
static EGInterfaceIdiom* EGInterfaceIdiom_computer_Desc;


typedef enum EGDeviceTypeR {
    EGDeviceType_Nil = 0,
    EGDeviceType_iPhone = 1,
    EGDeviceType_iPad = 2,
    EGDeviceType_iPodTouch = 3,
    EGDeviceType_Simulator = 4,
    EGDeviceType_Mac = 5
} EGDeviceTypeR;
@interface EGDeviceType : CNEnum
+ (NSArray*)values;
@end
static EGDeviceType* EGDeviceType_Values[6];
static EGDeviceType* EGDeviceType_iPhone_Desc;
static EGDeviceType* EGDeviceType_iPad_Desc;
static EGDeviceType* EGDeviceType_iPodTouch_Desc;
static EGDeviceType* EGDeviceType_Simulator_Desc;
static EGDeviceType* EGDeviceType_Mac_Desc;


@interface EGOS : NSObject {
@protected
    EGOSTypeR _tp;
    EGVersion* _version;
    BOOL _jailbreak;
}
@property (nonatomic, readonly) EGOSTypeR tp;
@property (nonatomic, readonly) EGVersion* version;
@property (nonatomic, readonly) BOOL jailbreak;

+ (instancetype)sWithTp:(EGOSTypeR)tp version:(EGVersion*)version jailbreak:(BOOL)jailbreak;
- (instancetype)initWithTp:(EGOSTypeR)tp version:(EGVersion*)version jailbreak:(BOOL)jailbreak;
- (CNClassType*)type;
- (BOOL)isIOS;
- (BOOL)isIOSLessVersion:(NSString*)version;
- (NSString*)description;
- (BOOL)isEqual:(id)to;
- (NSUInteger)hash;
+ (CNClassType*)type;
@end


@interface EGDevice : NSObject {
@protected
    EGDeviceTypeR _tp;
    EGInterfaceIdiomR _interfaceIdiom;
    EGVersion* _version;
    GEVec2 _screenSize;
}
@property (nonatomic, readonly) EGDeviceTypeR tp;
@property (nonatomic, readonly) EGInterfaceIdiomR interfaceIdiom;
@property (nonatomic, readonly) EGVersion* version;
@property (nonatomic, readonly) GEVec2 screenSize;

+ (instancetype)deviceWithTp:(EGDeviceTypeR)tp interfaceIdiom:(EGInterfaceIdiomR)interfaceIdiom version:(EGVersion*)version screenSize:(GEVec2)screenSize;
- (instancetype)initWithTp:(EGDeviceTypeR)tp interfaceIdiom:(EGInterfaceIdiomR)interfaceIdiom version:(EGVersion*)version screenSize:(GEVec2)screenSize;
- (CNClassType*)type;
- (BOOL)isIPhoneLessVersion:(NSString*)version;
- (BOOL)isIPodTouchLessVersion:(NSString*)version;
- (NSString*)description;
- (BOOL)isEqual:(id)to;
- (NSUInteger)hash;
+ (CNClassType*)type;
@end


@interface EGPlatform : NSObject {
@protected
    EGOS* _os;
    EGDevice* _device;
    NSString* _text;
    BOOL _shadows;
    BOOL _touch;
    EGInterfaceIdiomR _interfaceIdiom;
    BOOL _isPhone;
    BOOL _isPad;
    BOOL _isComputer;
}
@property (nonatomic, readonly) EGOS* os;
@property (nonatomic, readonly) EGDevice* device;
@property (nonatomic, readonly) NSString* text;
@property (nonatomic, readonly) BOOL shadows;
@property (nonatomic, readonly) BOOL touch;
@property (nonatomic, readonly) EGInterfaceIdiomR interfaceIdiom;
@property (nonatomic, readonly) BOOL isPhone;
@property (nonatomic, readonly) BOOL isPad;
@property (nonatomic, readonly) BOOL isComputer;

+ (instancetype)platformWithOs:(EGOS*)os device:(EGDevice*)device text:(NSString*)text;
- (instancetype)initWithOs:(EGOS*)os device:(EGDevice*)device text:(NSString*)text;
- (CNClassType*)type;
- (GEVec2)screenSize;
- (CGFloat)screenSizeRatio;
- (NSString*)description;
- (BOOL)isEqual:(id)to;
- (NSUInteger)hash;
+ (CNClassType*)type;
@end


@interface EGVersion : NSObject<CNComparable> {
@protected
    NSArray* _parts;
}
@property (nonatomic, readonly) NSArray* parts;

+ (instancetype)versionWithParts:(NSArray*)parts;
- (instancetype)initWithParts:(NSArray*)parts;
- (CNClassType*)type;
+ (EGVersion*)applyStr:(NSString*)str;
- (NSInteger)compareTo:(EGVersion*)to;
- (BOOL)lessThan:(NSString*)than;
- (BOOL)moreThan:(NSString*)than;
- (NSString*)description;
- (BOOL)isEqual:(id)to;
- (NSUInteger)hash;
+ (CNClassType*)type;
@end


