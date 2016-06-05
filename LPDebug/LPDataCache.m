//
//  LPDataCache.m
//  MXCloudBrowser
//
//  Created by 徐亚非 on 16/6/2.
//  Copyright © 2016年 www.maxthon.com. All rights reserved.
//

#import "LPDataCache.h"

@implementation LPDataCache

+ (NSArray *)getCacheDataWithKey:(NSString *)key {
    NSArray *array = [[NSUserDefaults standardUserDefaults] arrayForKey:key];
    if (!array) {
        array = [NSArray array];
    }
    //NSLog(@"getCacheData:%@ withKey:%@", array ,key);
    return array;
}

+ (void)setCacheData:(NSArray *)array withKey:(NSString *)key {
    if (!array) {
        array = [NSArray array];
    }
    [[NSUserDefaults standardUserDefaults] setObject:array forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
    //NSLog(@"setCacheData:%@ withKey:%@", array, key);
}

+ (void)addCacheData:(NSDictionary *)dictionary withKey:(NSString *)key {
    NSMutableArray *array = [[LPDataCache getCacheDataWithKey:key] mutableCopy];
    [array addObject:dictionary];
    [LPDataCache setCacheData:array withKey:key];
}

+ (void)removeCacheData:(NSDictionary *)dictionary withKey:(NSString *)key {
    NSMutableArray *array = [[LPDataCache getCacheDataWithKey:key] mutableCopy];
    [array removeObject:dictionary];
    [LPDataCache setCacheData:array withKey:key];
}

+ (void)removeCacheDataAtIndex:(NSInteger)index withKey:(NSString *)key {
    NSMutableArray *array = [[LPDataCache getCacheDataWithKey:key] mutableCopy];
    [array removeObjectAtIndex:index];
    [LPDataCache setCacheData:array withKey:key];
}

@end
