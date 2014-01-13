#import "GL.h"
#import <ImageIO/ImageIO.h>
#include <sys/sysctl.h>


id egGetProgramError(GLuint program) {
    GLint linkSuccess;
    glGetProgramiv(program, GL_LINK_STATUS, &linkSuccess);
    if (linkSuccess == GL_FALSE)
    {
        NSLog(@"GLSL Program Error");
        GLchar messages[1024];
        glGetProgramInfoLog(program, sizeof(messages), 0, &messages[0]);
        return [NSString stringWithCString:messages encoding:NSUTF8StringEncoding];
    }
    return [CNOption none];
}

void egShaderSource(GLuint shader, NSString* source) {
    char const *s = [source cStringUsingEncoding:NSUTF8StringEncoding];
    glShaderSource(shader, 1, &s, 0);
}

id egGetShaderError(GLuint shader) {
    GLint compileSuccess;
    glGetShaderiv(shader, GL_COMPILE_STATUS, &compileSuccess);
    if (compileSuccess == GL_FALSE)
    {
        NSLog(@"GLSL Program Error");
        GLchar messages[1024];
        glGetShaderInfoLog(shader, sizeof(messages), 0, &messages[0]);
        return [CNOption someValue:[NSString stringWithCString:messages encoding:NSUTF8StringEncoding]];
    }
    return [CNOption none];
}


NSUInteger egGLSLVersion() {
    const GLubyte* pVersion = glGetString(GL_SHADING_LANGUAGE_VERSION);
    if(pVersion == nil) return 100;
    if(pVersion[0] == 'O' && pVersion[1] == 'p' && pVersion[15] == 'E') {
        return ((NSUInteger) pVersion[18] - '0')*100 + (pVersion[20] - '0') *10 + (pVersion[21] == 0 ? 0 : pVersion[21]  - '0');
    }
    return ((NSUInteger) pVersion[0] - '0')*100 + (pVersion[2] - '0') *10 + pVersion[3]  - '0';
}

GEVec2 egLoadTextureFromFile(GLuint target, NSString* file, GLenum magFilter, GLenum minFilter) {
    CFURLRef url = (__bridge CFURLRef)[NSURL fileURLWithPath:file];
    CGImageSourceRef myImageSourceRef = CGImageSourceCreateWithURL(url, NULL);
    CGImageRef myImageRef = CGImageSourceCreateImageAtIndex (myImageSourceRef, 0, NULL);

    size_t width = CGImageGetWidth(myImageRef);
    size_t height = CGImageGetHeight(myImageRef);
    CGRect rect = {{0, 0}, {width, height}};
    void * myData = calloc(width * 4, height);
    CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
    CGContextRef myBitmapContext = CGBitmapContextCreate (myData,
            width, height, 8,
            width*4, space,
            kCGBitmapByteOrder32Host | kCGImageAlphaPremultipliedFirst);


    GEVec2 size = GEVec2Make(width, height);
    CGContextSetBlendMode(myBitmapContext, kCGBlendModeCopy);
    CGContextDrawImage(myBitmapContext, rect, myImageRef);
    egLoadTextureFromData(target, magFilter, minFilter, size, myData);

    CGContextRelease(myBitmapContext);
    CFRelease(myImageSourceRef);
    CFRelease(myImageRef);
    CFRelease(space);
    free(myData);
    egCheckError();
    return size;

}

void egLoadTextureFromData(GLuint target, GLenum magFilter, GLenum minFilter, GEVec2 size, void *myData) {
    glBindTexture(GL_TEXTURE_2D, target);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, magFilter);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, minFilter);
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, (GLsizei)size.x, (GLsizei)size.y, 0, GL_BGRA, GL_UNSIGNED_BYTE, myData);
    if(minFilter == GL_LINEAR_MIPMAP_LINEAR || minFilter == GL_LINEAR_MIPMAP_NEAREST
            || minFilter == GL_NEAREST_MIPMAP_LINEAR || minFilter == GL_NEAREST_MIPMAP_NEAREST)
    {
        glGenerateMipmap(GL_TEXTURE_2D);
    }
    glBindTexture(GL_TEXTURE_2D, 0);
}

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
   
    platform = [EGPlatform platformWithOs:[EGOSType iOS]
                           interfaceIdiom:UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ? [EGInterfaceIdiom phone] : [EGInterfaceIdiom pad]
                                  version:[EGVersion applyStr:device.systemVersion]
                                  screenSize:GEVec2Make((float) rect.size.width, (float) rect.size.height)
                                     text:[NSString stringWithFormat:@"%@ iOS %@", sDeviceModel, device.systemVersion]];

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
                               text:[NSString stringWithFormat:@"%s Mac OS X %@ %ix%i",
                                                               model, [verArr objectAtIndex:1],
                                               (int) rect.size.width, (int) rect.size.height]];

#endif

    return platform;
}
