//
//  UIDevice+IOKitDeviceInfo.m
//  lightBee
//
//  Created by liuhongnian on 14-11-9.
//  Copyright (c) 2014年 www.cz001.com.cn. All rights reserved.
//

#import "UIDevice+IOKitDeviceInfo.h"
#include <dlfcn.h>

@implementation UIDevice (IOKitDeviceInfo)

#define IOKit_PATH "/System/Library/Frameworks/IOKit.framework/IOKit"

typedef UInt32 IOOptionBits;
typedef mach_port_t io_object_t;
typedef mach_port_t io_service_t;
typedef io_object_t io_registry_entry_t;
extern const mach_port_t kIOMasterPortDefault;
typedef kern_return_t (* IOObjectRelease)(io_object_t	object );
typedef CFMutableDictionaryRef (* IOServiceMatching)(const char *name );
typedef CFMutableDictionaryRef (* IOServiceNameMatching)(const char *name);
typedef io_service_t (* IOServiceGetMatchingService)( mach_port_t masterPort, CFDictionaryRef matching );
typedef kern_return_t (*IORegistryEntryCreateCFProperties)(
                                                           io_registry_entry_t entry,
                                                           CFMutableDictionaryRef *properties,
                                                           CFAllocatorRef allocator,
                                                           IOOptionBits options );
typedef CFTypeRef (* IORegistryEntryCreateCFProperty)(
                                                      io_registry_entry_t entry,
                                                      CFStringRef key,
                                                      CFAllocatorRef allocator,
                                                      IOOptionBits options );

static const CFStringRef kIODeviceIMEI = CFSTR("device-imei");

+ (NSString *)IOSerialNumber
{
    return [[self class]IODeviceInfoForKey:CFSTR("IOPlatformSerialNumber")];;
}

+ (NSString *)IOPlatformUUID
{
    return [[self class] IODeviceInfoForKey:CFSTR("IOPlatformUUID")];
}

+ (NSString*)IODeviceIMEI
{
    return [[self class] IODeviceInfoForKey:kIODeviceIMEI];
}

+ (NSString *)deviceIMEI
{
    void *IOKit = dlopen("/System/Library/Frameworks/IOKit.framework/IOKit", RTLD_NOW);
    if (!IOKit) {
        return nil;
    }
    
    IOServiceGetMatchingService pIOServiceGetMatchingService = dlsym(IOKit, "IOServiceGetMatchingService");
    IOServiceMatching pIOServiceMatching = dlsym(IOKit, "IOServiceMatching");
    IORegistryEntryCreateCFProperty pIORegistryEntryCreateCFProperty = dlsym(IOKit, "IORegistryEntryCreateCFProperty");
    IORegistryEntryCreateCFProperties pIORegistryEntryCreateCFProperties = dlsym(IOKit, "IORegistryEntryCreateCFProperties");
    IOObjectRelease pIOObjectRelease = dlsym(IOKit, "IOObjectRelease");
    mach_port_t *kIOMasterPortDefault = dlsym(IOKit, "kIOMasterPortDefault");
    io_object_t platformExpert;
    IOServiceNameMatching pIOServiceNameMatching = dlsym(IOKit, "IOServiceNameMatching");
    CFDictionaryRef ma = pIOServiceNameMatching("baseband");
    const void *keys[]={CFSTR("IOProviderClass"),CFSTR("IOClass")};
    const void *values[]={CFSTR("IOPlatformDevice"),CFSTR("baseband")};
    CFDictionaryRef match = CFDictionaryCreate(kCFAllocatorDefault, keys, values, sizeof(keys)/sizeof(keys[0]), &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
    platformExpert = pIOServiceGetMatchingService(*kIOMasterPortDefault, ma);
    
    CFMutableDictionaryRef res = NULL;
    pIORegistryEntryCreateCFProperties(platformExpert,&res,kCFAllocatorDefault,0);
    NSLog(@" %@\n",res);
    
    NSString *imeiString;
    if (platformExpert) {
        CFTypeRef imei = pIORegistryEntryCreateCFProperty(platformExpert, CFSTR("device-imei"), kCFAllocatorDefault, 0);
        imeiString = [[NSString alloc]initWithBytes:[(NSData *)CFBridgingRelease(imei) bytes] length:[(NSData *)CFBridgingRelease(imei) length] encoding:NSUTF8StringEncoding];
        NSLog(@"device imei = %@\n",imeiString);
//        CFRelease(imei);
    }

    return imeiString;
}

+ (NSString*)IODeviceInfoForKey:(CFStringRef)key
{
    void *IOKit = dlopen("/System/Library/Frameworks/IOKit.framework/IOKit", RTLD_NOW);
    if (!IOKit) {
        return nil;
    }
    NSString *retVal = nil;

    IOServiceGetMatchingService pIOServiceGetMatchingService = dlsym(IOKit, "IOServiceGetMatchingService");
    IOServiceMatching pIOServiceMatching = dlsym(IOKit, "IOServiceMatching");
    IORegistryEntryCreateCFProperty pIORegistryEntryCreateCFProperty = dlsym(IOKit, "IORegistryEntryCreateCFProperty");
//    IORegistryEntryCreateCFProperties pIORegistryEntryCreateCFProperties = dlsym(IOKit, "IORegistryEntryCreateCFProperties");
    
    IOObjectRelease pIOObjectRelease = dlsym(IOKit, "IOObjectRelease");
    mach_port_t *kIOMasterPortDefault = dlsym(IOKit, "kIOMasterPortDefault");
    io_object_t platformExpert;
//    IOServiceNameMatching pIOServiceNameMatching = dlsym(IOKit, "IOServiceNameMatching");
    CFDictionaryRef ma = pIOServiceMatching("IOPlatformExpertDevice");
    platformExpert = pIOServiceGetMatchingService(*kIOMasterPortDefault, ma);
    if (platformExpert) {
        CFTypeRef value = pIORegistryEntryCreateCFProperty(platformExpert, key, kCFAllocatorDefault, 0);
        retVal = (NSString*)CFBridgingRelease(value);
        pIOObjectRelease(platformExpert);
    }

    return retVal;
}
@end
