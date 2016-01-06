//
//  NSString+LBExtension.h
//  lightBee
//
//  Created by liuhongnian on 14-10-23.
//  Copyright (c) 2014年 www.cz001.com.cn. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;

@interface NSString (LBExtension)

@property (nonatomic, readonly) NSData *				data;
@property (nonatomic, readonly) NSDate *				date;

@property (nonatomic, readonly) NSString *				MD5;
@property (nonatomic, readonly) NSData *				MD5Data;//todo

@property (nonatomic, readonly) NSString *				SHA1;

- (BOOL)isEmpty;
- (BOOL)isNotEmpty;

- (BOOL)isNormal;

- (BOOL)isTelephone;    // match telephone
- (BOOL)isMobilephone;  // match mobilephone, 11 numberic
- (BOOL)isUserName;     // match alphabet 3-20
- (BOOL)isChineseUserName;  // match alphabet and chinese characters, 3-20
- (BOOL)isPureChineseName;// match just chinese characters 2-16
- (BOOL)isPassword;
- (BOOL)isEmail;
- (BOOL)isWebURL;
- (BOOL)isIPAddress;

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
- (CGSize)sizeWithFont:(UIFont *)font byWidth:(CGFloat)width;
#endif

@end
