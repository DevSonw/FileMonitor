//
//  NSArray+LBExtension.h
//  lightBee
//
//  Created by liuhongnian on 14-12-1.
//  Copyright (c) 2014年 www.cz001.com.cn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (LBExtension)

+ (NSMutableArray*)noRetainingMutableArray;

- (void)insertObjectNoRetain:(id)anObject atIndex:(NSUInteger)index;
- (void)addObjectNoRetain:(NSObject *)obj;

@end
