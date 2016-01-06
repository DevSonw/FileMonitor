//
//  UIDevice+IOKitDeviceInfo.h
//  lightBee
//
//  Created by liuhongnian on 14-11-9.
//  Copyright (c) 2014年 www.cz001.com.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIDevice (IOKitDeviceInfo)

+ (NSString*)IOSerialNumber;
+ (NSString*)IOPlatformUUID;

+ (NSString*)deviceIMEI;
+ (NSString*)IODeviceIMEI;
@end
