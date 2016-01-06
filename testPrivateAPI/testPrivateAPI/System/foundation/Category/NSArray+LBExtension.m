//
//  NSArray+LBExtension.m
//  lightBee
//
//  Created by liuhongnian on 14-12-1.
//  Copyright (c) 2014年 www.cz001.com.cn. All rights reserved.
//

#import "NSArray+LBExtension.h"

static const void *	__TTRetainNoOp( CFAllocatorRef allocator, const void * value ) { return value; }
static void			__TTReleaseNoOp( CFAllocatorRef allocator, const void * value ) { }

@implementation NSMutableArray (LBExtension)

+ (NSMutableArray *)noRetainingMutableArray
{
    CFArrayCallBacks callbacks = kCFTypeArrayCallBacks;
    callbacks.retain = __TTRetainNoOp;
    callbacks.release = __TTReleaseNoOp;
    return (NSMutableArray *)CFBridgingRelease(CFArrayCreateMutable( nil, 0, &callbacks )) ;
}


- (void)insertObjectNoRetain:(id)object atIndex:(NSUInteger)index
{
    [self insertObject:object atIndex:index];
}

- (void)addObjectNoRetain:(NSObject *)object
{
    [self addObject:object];
}

@end
