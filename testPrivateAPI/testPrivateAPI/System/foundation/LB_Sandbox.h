//
//  LB_Sandbox.h
//  lightBee
//
//  Created by liuhongnian on 14-10-23.
//  Copyright (c) 2014年 www.cz001.com.cn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LB_Singleton.h"

@interface LB_Sandbox : NSObject

@property (nonatomic, readonly) NSString *	appPath;
@property (nonatomic, readonly) NSString *	docPath;
@property (nonatomic, readonly) NSString *	libPrefPath;
@property (nonatomic, readonly) NSString *	libCachePath;
@property (nonatomic, readonly) NSString *	tmpPath;

AS_SINGLETON(LB_Sandbox)

+ (NSString *)appPath;		// 程序目录，不能存任何东西
+ (NSString *)docPath;		// 文档目录，需要ITUNES同步备份的数据存这里
+ (NSString *)libPrefPath;	// 配置目录，配置文件存这里
+ (NSString *)libCachePath;	// 缓存目录，系统永远不会删除这里的文件，ITUNES会删除
+ (NSString *)tmpPath;		// 缓存目录，APP退出后，系统可能会删除这里的内容

@end
