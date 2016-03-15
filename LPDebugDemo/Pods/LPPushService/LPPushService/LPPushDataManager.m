//
//  LPPushDataManager.m
//  LPPushServiceDemo
//
//  Created by XuYafei on 15/9/28.
//  Copyright © 2015年 loopeer. All rights reserved.
//

#import "LPPushDataManager.h"
#import "LPPushService.h"
#import <BPush.h>

static NSString *kPushCacheKey = @"kPushCacheKey";
static NSString *kLaunchNotificationCacheKey = @"kLaunchNotificationCacheKey";

@implementation LPPushDataManager {
    BOOL _cacheEnable;
}

- (instancetype)initWithCacheEnable:(BOOL)enable {
    self = [LPPushDataManager sharedInstance];
    if (self) {
        static dispatch_once_t once;
        dispatch_once(&once, ^{
            _cacheEnable = enable;
        });
    }
    return self;
}

+ (instancetype)sharedInstance {
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

+ (NSArray *)getCacheData {
    return [LPPushDataManager getCacheDataWithKey:kPushCacheKey];
}

+ (void)setCacheData:(NSArray *)array {
    [self setCacheData:array withKey:kPushCacheKey];
}

+ (void)addNotification:(NSDictionary *)dictionary {
    [self addNotification:dictionary withKey:kPushCacheKey];
}

+ (NSArray *)getCacheDataWithKey:(NSString *)key {
    NSArray *array = [[NSUserDefaults standardUserDefaults] arrayForKey:key];
    if (!array) {
        array = [NSArray array];
    }
    LPPushLog(@"getCacheData:%@ withKey:%@", array ,key);
    return array;
}

+ (void)setCacheData:(NSArray *)array withKey:(NSString *)key {
    if (!array) {
        array = [NSArray array];
    }
    [[NSUserDefaults standardUserDefaults] setObject:array forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
    LPPushLog(@"setCacheData:%@ withKey:%@", array, key);
}

+ (void)addNotification:(NSDictionary *)dictionary withKey:(NSString *)key {
    NSMutableArray *array = [[LPPushDataManager getCacheDataWithKey:key] mutableCopy];
    if (!array) {
        array = [[NSMutableArray alloc] init];
    }
    [array addObject:dictionary];
    [LPPushDataManager setCacheData:array withKey:key];
    LPPushLog(@"addNotification:%@ withKey:%@", dictionary, key);
}

+ (NSString *)getAppId {
    return [BPush getAppId];
}

+ (NSString *)getChannelId {
    return [BPush getChannelId];
}

+ (NSString *)getUserId {
    return [BPush getUserId];
}

+ (NSString *)getDeviceToken {
    return [[LPPushDataManager getCacheDataWithKey:kDeviceTokenCacheKey].lastObject objectForKey:kDeviceTokenCacheKey];
}

+ (BOOL)isLuanchFromNotification {
    return [[[LPPushDataManager getCacheDataWithKey:kLaunchCacheKey].lastObject objectForKey:kLaunchCacheKey] boolValue];
}

+ (void)setAppBadgeNumber:(NSInteger)count {
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:count];
}

@end
