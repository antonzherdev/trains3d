
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
    NSString *sDeviceModel = [NSString stringWithCString:model encoding:NSUTF8StringEncoding];
    CGRect rect = [[UIScreen mainScreen] bounds];
    UIDevice *device = [UIDevice currentDevice];
    if ([sDeviceModel isEqualToString:@"iPhone1,1"])    sDeviceModel = @"iPhone 1G";
    else if ([sDeviceModel isEqualToString:@"iPhone1,2"])    sDeviceModel = @"iPhone 3G";
    else if ([sDeviceModel isEqualToString:@"iPhone2,1"])    sDeviceModel = @"iPhone 3GS";
    else if ([sDeviceModel isEqualToString:@"iPhone3,1"])    sDeviceModel = @"iPhone 4";
    else if ([sDeviceModel isEqualToString:@"iPhone3,2"])    sDeviceModel = @"iPhone 4 CDMA";
    else if ([sDeviceModel isEqualToString:@"iPhone3,3"])    sDeviceModel = @"Verizon iPhone 4";
    else if ([sDeviceModel isEqualToString:@"iPhone4,1"])    sDeviceModel = @"iPhone 4S";
    else if ([sDeviceModel isEqualToString:@"iPhone5,1"])    sDeviceModel = @"iPhone 5 (GSM)";
    else if ([sDeviceModel isEqualToString:@"iPhone5,2"])    sDeviceModel = @"iPhone 5 (GSM+CDMA)";
    else if ([sDeviceModel isEqualToString:@"iPhone5,3"])    sDeviceModel = @"iPhone 5c GSM";
    else if ([sDeviceModel isEqualToString:@"iPhone5,4"])    sDeviceModel = @"iPhone 5c Global";
    else if ([sDeviceModel isEqualToString:@"iPhone6,1"])    sDeviceModel = @"iPhone 5s GSM";
    else if ([sDeviceModel isEqualToString:@"iPhone6,2"])    sDeviceModel = @"iPhone 5s Global";

    else if ([sDeviceModel isEqualToString:@"iPod1,1"])      sDeviceModel = @"iPod Touch 1G";
    else if ([sDeviceModel isEqualToString:@"iPod2,1"])      sDeviceModel = @"iPod Touch 2G";
    else if ([sDeviceModel isEqualToString:@"iPod3,1"])      sDeviceModel = @"iPod Touch 3G";
    else if ([sDeviceModel isEqualToString:@"iPod4,1"])      sDeviceModel = @"iPod Touch 4G";
    else if ([sDeviceModel isEqualToString:@"iPod5,1"])      sDeviceModel = @"iPod Touch 5G";

    else if ([sDeviceModel isEqualToString:@"iPad1,1"])      sDeviceModel = @"iPad";
    else if ([sDeviceModel isEqualToString:@"iPad2,1"])      sDeviceModel = @"iPad 2 WiFi";
    else if ([sDeviceModel isEqualToString:@"iPad2,2"])      sDeviceModel = @"iPad 2 GSM";
    else if ([sDeviceModel isEqualToString:@"iPad2,3"])      sDeviceModel = @"iPad 2 CDMA";
    else if ([sDeviceModel isEqualToString:@"iPad2,4"])      sDeviceModel = @"iPad 2 CDMAS";
    else if ([sDeviceModel isEqualToString:@"iPad2,5"])      sDeviceModel = @"iPad Mini Wifi";
    else if ([sDeviceModel isEqualToString:@"iPad2,6"])      sDeviceModel = @"iPad Mini (GSM)";
    else if ([sDeviceModel isEqualToString:@"iPad2,7"])      sDeviceModel = @"iPad Mini (GSM + CDMA)";
    else if ([sDeviceModel isEqualToString:@"iPad3,1"])      sDeviceModel = @"iPad 3 WiFi";
    else if ([sDeviceModel isEqualToString:@"iPad3,2"])      sDeviceModel = @"iPad 3 CDMA";
    else if ([sDeviceModel isEqualToString:@"iPad3,3"])      sDeviceModel = @"iPad 3 GSM";
    else if ([sDeviceModel isEqualToString:@"iPad3,4"])      sDeviceModel = @"iPad 4 Wifi";
    else if ([sDeviceModel isEqualToString:@"iPad3,5"])      sDeviceModel = @"iPad 4 (GSM)";
    else if ([sDeviceModel isEqualToString:@"iPad3,6"])      sDeviceModel = @"iPad 4 (GSM+CDMA)";
    else if ([sDeviceModel isEqualToString:@"iPad4,1"])      sDeviceModel = @"iPad Air Wifi";
    else if ([sDeviceModel isEqualToString:@"iPad4,2"])      sDeviceModel = @"iPad Air (GSM+CDMA)";
    else if ([sDeviceModel isEqualToString:@"iPad4,4"])      sDeviceModel = @"iPad Mini 2 Wifi";
    else if ([sDeviceModel isEqualToString:@"iPad4,5"])      sDeviceModel = @"iPad Mini 2 (GSM+CDMA)";
    else if ([sDeviceModel isEqualToString:@"i386"])         sDeviceModel = @"Simulator";
    else if ([sDeviceModel isEqualToString:@"x86_64"])       sDeviceModel = @"Simulator";

    NSURL* url = [NSURL URLWithString:@"cydia://package/com.example.package"];
    BOOL jb = [[UIApplication sharedApplication] canOpenURL:url];

    platform = [EGPlatform platformWithOs:[EGOSType iOS]
                           interfaceIdiom:UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ? [EGInterfaceIdiom phone] : [EGInterfaceIdiom pad]
                                  version:[EGVersion applyStr:device.systemVersion]
                               screenSize:GEVec2Make((float) rect.size.width, (float) rect.size.height)
                                jailbreak:jb
                                     text:[NSString stringWithFormat:@"%@ iOS %@ %@", sDeviceModel, device.systemVersion, jb ? @"b" : @"a"]];

#elif TARGET_OS_MAC
    size_t size;
    sysctlbyname("hw.model", NULL, &size, NULL, 0);
    char *model = malloc(size);
    sysctlbyname("hw.model", model, &size, NULL, 0);
    NSProcessInfo *pInfo = [NSProcessInfo processInfo];
    NSArray *verArr = [[pInfo operatingSystemVersionString] componentsSeparatedByString:@" "];
    NSRect rect = [[NSScreen mainScreen] frame];

    platform = [EGPlatform platformWithOs:[EGOSType MacOS]
                           interfaceIdiom:[EGInterfaceIdiom computer]
                                  version:[EGVersion applyStr:[verArr objectAtIndex:1]]
                               screenSize:GEVec2Make((float) rect.size.width, (float) rect.size.height)
                                jailbreak:NO
                                     text:[NSString stringWithFormat:@"%s Mac OS X %@ %ix%i",
                                                                     model, [verArr objectAtIndex:1],
                                                                     (int) rect.size.width, (int) rect.size.height]];

#endif

    return platform;
}