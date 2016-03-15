//
//  LPPushDataManager.h
//  LPPushServiceDemo
//
//  Created by XuYafei on 15/9/28.
//  Copyright © 2015年 loopeer. All rights reserved.
//

#import <Foundation/Foundation.h>

/// 通过推送消息启动
static NSString *kPushLaunchNotification = @"kPushLaunchNotification";
/// 收到本地通知
static NSString *kPushLocalNotification = @"kPushLocalNotification";
/// 收到远程通知
static NSString *kPushRemoteNotification = @"kPushRemoteNotification";
/// 收到远程静默通知(打开静默通知的情况下远程通知无效)
static NSString *kPushSilentNotification = @"kPushSilentNotification";
/// 获取设备号成功
static NSString *kPushGetDeviceTokenSuccessNotification = @"kPushGetDeviceTokenSuccessNotification";
/// 获取设备号失败
static NSString *kPushGetDeviceTokenFailNotification = @"kPushGetDeviceTokenFailNotification";

/// 缓存DeviceToken的KEY
static NSString *kDeviceTokenCacheKey = @"kDeviceTokenCacheKey";
/// 缓存是否从通知启动的KEY
static NSString *kLaunchCacheKey = @"kLaunchCacheKey";
/// 未使用的KEY,供自定义KEY进行推送数据管理时使用
static NSString *kPushPrivateCacheKey = @"kPushPrivateCacheKey";

/// 管理推送数据的单例
@interface LPPushDataManager : NSObject

/**
 * 首次调用时设置CacheEnable才是有效的
 * 在LPPushService RegisterPushService的时候会调用此方法
 * 最好不要手动调用,建议使用sharedInstance
 */
- (instancetype)initWithCacheEnable:(BOOL)enable;

+ (instancetype)sharedInstance;

// 使用自动缓存的推送数据

+ (NSArray *)getCacheData;
+ (void)setCacheData:(NSArray *)array;
+ (void)addNotification:(NSDictionary *)dictionary;

// 自定义KEY进行推送数据管理

+ (NSArray *)getCacheDataWithKey:(NSString *)key;
+ (void)setCacheData:(NSArray *)array withKey:(NSString *)key;
+ (void)addNotification:(NSDictionary *)dictionary withKey:(NSString *)key;

// 推送相关属性管理

+ (NSString *)getAppId;
+ (NSString *)getChannelId;
+ (NSString *)getUserId;
+ (NSString *)getDeviceToken;
+ (BOOL)isLuanchFromNotification;

// 角标管理

+ (void)setAppBadgeNumber:(NSInteger)count;

@end
