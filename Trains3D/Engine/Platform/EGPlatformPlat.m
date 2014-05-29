
#import "EGPlatformPlat.h"
#include <sys/sysctl.h>

EGPlatform* egPlatform() {
    static EGPlatform * platform = nil;
    if(platform != nil) return platform;
#if TARGET_OS_IPHONE
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *model = malloc(size);
    sysctlbyname("hw.machine", model, &size, NULL, 0);
    NSString *m = [NSString stringWithCString:model encoding:NSUTF8StringEncoding];
    CGRect rect = [[UIScreen mainScreen] bounds];
    UIDevice *device = [UIDevice currentDevice];

    NSString *mnm;
    if ([m isEqualToString:@"iPhone1,1"])    mnm = @"iPhone 1G";
    else if ([m isEqualToString:@"iPhone1,2"])    mnm = @"iPhone 3G";
    else if ([m isEqualToString:@"iPhone2,1"])    mnm = @"iPhone 3GS";
    else if ([m isEqualToString:@"iPhone3,1"])    mnm = @"iPhone 4";
    else if ([m isEqualToString:@"iPhone3,2"])    mnm = @"iPhone 4 CDMA";
    else if ([m isEqualToString:@"iPhone3,3"])    mnm = @"Verizon iPhone 4";
    else if ([m isEqualToString:@"iPhone4,1"])    mnm = @"iPhone 4S";
    else if ([m isEqualToString:@"iPhone5,1"])    mnm = @"iPhone 5 (GSM)";
    else if ([m isEqualToString:@"iPhone5,2"])    mnm = @"iPhone 5 (GSM+CDMA)";
    else if ([m isEqualToString:@"iPhone5,3"])    mnm = @"iPhone 5c GSM";
    else if ([m isEqualToString:@"iPhone5,4"])    mnm = @"iPhone 5c Global";
    else if ([m isEqualToString:@"iPhone6,1"])    mnm = @"iPhone 5s GSM";
    else if ([m isEqualToString:@"iPhone6,2"])    mnm = @"iPhone 5s Global";

    else if ([m isEqualToString:@"iPod1,1"])      mnm = @"iPod Touch 1G";
    else if ([m isEqualToString:@"iPod2,1"])      mnm = @"iPod Touch 2G";
    else if ([m isEqualToString:@"iPod3,1"])      mnm = @"iPod Touch 3G";
    else if ([m isEqualToString:@"iPod4,1"])      mnm = @"iPod Touch 4G";
    else if ([m isEqualToString:@"iPod5,1"])      mnm = @"iPod Touch 5G";

    else if ([m isEqualToString:@"iPad1,1"])      mnm = @"iPad";
    else if ([m isEqualToString:@"iPad2,1"])      mnm = @"iPad 2 WiFi";
    else if ([m isEqualToString:@"iPad2,2"])      mnm = @"iPad 2 GSM";
    else if ([m isEqualToString:@"iPad2,3"])      mnm = @"iPad 2 CDMA";
    else if ([m isEqualToString:@"iPad2,4"])      mnm = @"iPad 2 CDMAS";
    else if ([m isEqualToString:@"iPad2,5"])      mnm = @"iPad Mini Wifi";
    else if ([m isEqualToString:@"iPad2,6"])      mnm = @"iPad Mini (GSM)";
    else if ([m isEqualToString:@"iPad2,7"])      mnm = @"iPad Mini (GSM + CDMA)";
    else if ([m isEqualToString:@"iPad3,1"])      mnm = @"iPad 3 WiFi";
    else if ([m isEqualToString:@"iPad3,2"])      mnm = @"iPad 3 CDMA";
    else if ([m isEqualToString:@"iPad3,3"])      mnm = @"iPad 3 GSM";
    else if ([m isEqualToString:@"iPad3,4"])      mnm = @"iPad 4 Wifi";
    else if ([m isEqualToString:@"iPad3,5"])      mnm = @"iPad 4 (GSM)";
    else if ([m isEqualToString:@"iPad3,6"])      mnm = @"iPad 4 (GSM+CDMA)";
    else if ([m isEqualToString:@"iPad4,1"])      mnm = @"iPad Air Wifi";
    else if ([m isEqualToString:@"iPad4,2"])      mnm = @"iPad Air (GSM+CDMA)";
    else if ([m isEqualToString:@"iPad4,4"])      mnm = @"iPad Mini 2 Wifi";
    else if ([m isEqualToString:@"iPad4,5"])      mnm = @"iPad Mini 2 (GSM+CDMA)";
    else if ([m isEqualToString:@"i386"])         mnm = @"Simulator";
    else if ([m isEqualToString:@"x86_64"])       mnm = @"Simulator";

    NSURL* url = [NSURL URLWithString:@"cydia://package/com.example.package"];
    BOOL jb = [[UIApplication sharedApplication] canOpenURL:url];

    EGOS *os = [EGOS sWithTp:EGOSType_iOS version:[EGVersion applyStr:device.systemVersion] jailbreak:jb];
    EGDeviceTypeR deviceType =
            [m hasPrefix:@"iPhone"] ? EGDeviceType_iPhone : (
              [m hasPrefix:@"iPad"] ? EGDeviceType_iPad : (
              [m hasPrefix:@"iPod"] ? EGDeviceType_iPodTouch :
                                      EGDeviceType_Simulator));
    NSString *devVersion =
            [([m hasPrefix:@"iPhone"] ? [m substringFromIndex:6] : (
                [m hasPrefix:@"iPad"] ? [m substringFromIndex:4] : (
                [m hasPrefix:@"iPod"] ? [m substringFromIndex:4] :
                                        @"0"))) replaceOccurrences:@"," withString:@"."];
    EGDevice *dev = [EGDevice deviceWithTp:deviceType
                            interfaceIdiom:UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ?
                                    EGInterfaceIdiom_phone : EGInterfaceIdiom_pad
                                   version:[EGVersion applyStr:devVersion]
                                screenSize:GEVec2Make((float) rect.size.width, (float) rect.size.height)];
    platform = [EGPlatform platformWithOs:os
                                   device:dev
                                     text:[NSString stringWithFormat:@"%@ iOS %@ %@", mnm, device.systemVersion, jb ? @"b" : @"a"]];

#elif TARGET_OS_MAC
    size_t size;
    sysctlbyname("hw.model", NULL, &size, NULL, 0);
    char *model = malloc(size);
    sysctlbyname("hw.model", model, &size, NULL, 0);
    NSProcessInfo *pInfo = [NSProcessInfo processInfo];
    NSArray *verArr = [[pInfo operatingSystemVersionString] componentsSeparatedByString:@" "];
    NSRect rect = [[NSScreen mainScreen] frame];

    EGOS *os = [EGOS sWithTp:EGOSType_MacOS version:[EGVersion applyStr:[verArr objectAtIndex:1]] jailbreak:NO];
    EGDevice *dev = [EGDevice deviceWithTp:EGDeviceType_Mac
                            interfaceIdiom:EGInterfaceIdiom_computer
                                   version:[EGVersion versionWithParts:[NSArray arrayWithObject:@0]]
                                screenSize:GEVec2Make((float) rect.size.width, (float) rect.size.height)];
    platform = [EGPlatform platformWithOs:os
                                   device:dev
                                     text:[NSString stringWithFormat:@"%s Mac OS X %@ %ix%i",
                                                        model, [verArr objectAtIndex:1],
                                                        (int) rect.size.width, (int) rect.size.height]];
#endif

    return platform;
}