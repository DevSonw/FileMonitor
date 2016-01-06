//
//  DBPreDicateTool.h
//  NSPredicate
//
//  Created by dengbin on 15/1/5.
//  Copyright (c) 2015年 IUAIJIA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DBPreDicateTool : NSObject
//是否为邮箱
+(BOOL)isEmail:(NSString *)email;

//是否包涵数字汉字字母
+(BOOL)isName:(NSString *)name;

//是否为数字
+(BOOL)isNumber:(NSString *)number;

//是否为手机号
+(BOOL)isMobile:(NSString *)mobile;


@end
