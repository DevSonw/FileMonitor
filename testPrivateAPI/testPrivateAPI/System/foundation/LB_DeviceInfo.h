//
//  LB_DeviceInfo.h
//  lightBee
//
//  Created by liuhongnian on 14-10-23.
//  Copyright (c) 2014年 www.cz001.com.cn. All rights reserved.
//

#import <Foundation/Foundation.h>

//frome SDiPhoneVersion

@interface LB_DeviceInfo : NSObject

typedef NS_ENUM(NSInteger, DeviceVersion){
    iPhone4 = 3,
    iPhone4S = 4,
    iPhone5 = 5,
    iPhone5C = 5,
    iPhone5S = 6,
    iPhone6 = 7,
    iPhone6Plus = 8,
    
    iPad1 = 9,
    iPad2 = 10,
    iPadMini = 11,
    iPad3 = 12,
    iPad4 = 13,
    iPadAir = 15,
    iPadMiniRetina = 16,
    Simulator = 0
};

typedef NS_ENUM(NSInteger, DeviceSize){
    iPhone35inch = 1,
    iPhone4inch = 2,
    iPhone47inch = 3,
    iPhone55inch = 4
};

+(DeviceVersion)deviceVersion;
+(DeviceSize)deviceSize;
+(NSString*)deviceName;

+ (BOOL)isDevicePhone;
+ (BOOL)isDevicePad;

@end
