//
//  LPPushService.m
//  LPPushServiceDemo
//
//  Created by XuYafei on 15/9/28.
//  Copyright © 2015年 loopeer. All rights reserved.
//

#import "LPPushService.h"
#import "LPPushDataManager.h"
#import "LPPushNetworking.h"
#import <BPush.h>

@implementation LPPushService {
    LPPushDataManager *_dataManager;
    NSString *_apiKey;
    NSString *_serverURL;
    NSDictionary *_params;
}

#pragma mark - Initialization

- (instancetype)init {
    self = [super init];
    if (self) {
        _cacheEnable = YES;
        _notificationEnable = YES;
        _localNotificationEnable = NO;
    }
    return self;
}

#pragma mark - RegisterPushSerview

- (void)application:(UIApplication *)application registerToApns:(BOOL)enable withOptions:(NSDictionary *)launchOptions andApiKey:(NSString *)apiKey {
    
    _apiKey = apiKey;
    
    // 初始化LPPushDataManager
    _dataManager = [[LPPushDataManager alloc] initWithCacheEnable:_cacheEnable];
    
    // 注册APNS推送
    _registerToApple = enable;
    if (_registerToApple) {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000
            UIUserNotificationType myTypes = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
            UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:myTypes categories:nil];
            [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
#else
            UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeSound;
            [[UIApplication sharedApplication] registerForRemoteNotificationTypes:myTypes];
#endif
    }
    
    // 注册百度云推送服务
    if (_apiKey) {
#ifdef DEBUG
        [BPush registerChannel:launchOptions
                        apiKey:apiKey
                      pushMode:BPushModeDevelopment
               withFirstAction:nil withSecondAction:nil
                  withCategory:nil
                       isDebug:YES];
#else
        [BPush registerChannel:launchOptions
                        apiKey:apiKey
                      pushMode:BPushModeProduction
               withFirstAction:nil
              withSecondAction:nil withCategory:nil
                       isDebug:YES];
#endif
    }
    
    // 通过推送消息启动
    NSDictionary *userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (userInfo) {
        [LPPushDataManager setCacheData:@[@{kLaunchCacheKey:@YES}] withKey:kLaunchCacheKey];
        if (apiKey) {
            [BPush handleNotification:userInfo];
        }
    } else {
        [LPPushDataManager setCacheData:@[@{kLaunchCacheKey:@NO}] withKey:kLaunchCacheKey];
    }
    
    // 模拟器
#if TARGET_IPHONE_SIMULATOR
    Byte dt[32] = {0xc6, 0x1e, 0x5a, 0x13, 0x2d, 0x04, 0x83, 0x82, 0x12, 0x4c,
        0x26, 0xcd, 0x0c, 0x16, 0xf6, 0x7c, 0x74, 0x78, 0xb3, 0x5f, 0x6b, 0x37,
        0x0a, 0x42, 0x4f, 0xe7, 0x97, 0xdc, 0x9f, 0x3a, 0x54, 0x10};
    [self application:application didRegisterForRemoteNotificationsWithDeviceToken:[NSData dataWithBytes:dt length:32]];
#endif
    
}

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    _registerToApple? [application registerForRemoteNotifications]: NULL;
}

#pragma mark - RegisterState

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    if (_apiKey) {
        [BPush registerDeviceToken:deviceToken];
        [BPush bindChannelWithCompleteHandler:^(id result, NSError *error) {
            LPPushLog(@"Method:%@\n%@", BPushRequestMethodBind,result);
        }];
    }
    
    NSString *deviceTokenString = [NSString stringWithFormat:@"%@", deviceToken];
    deviceTokenString = [deviceTokenString stringByReplacingOccurrencesOfString:@"<" withString:@""];
    deviceTokenString = [deviceTokenString stringByReplacingOccurrencesOfString:@">" withString:@""];
    deviceTokenString = [deviceTokenString stringByReplacingOccurrencesOfString:@" " withString:@""];
    [LPPushDataManager setCacheData:@[@{kDeviceTokenCacheKey:deviceTokenString}] withKey:kDeviceTokenCacheKey];
    
    if (_notificationEnable) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kPushGetDeviceTokenSuccessNotification object:deviceTokenString];
    }
    LPPushLog(@"deviceToken:%@", deviceToken);
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    if (_notificationEnable) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kPushGetDeviceTokenFailNotification object:error];
    }
    LPPushLog(@"DeviceToken获取失败:%@", error);
}

#pragma mark - ReceiveNotification

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    _apiKey? [BPush handleNotification:userInfo]: NULL;
    [self p_receiveRemoteNotification:userInfo];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    completionHandler(UIBackgroundFetchResultNewData);
    [self p_receiveRemoteNotification:userInfo];
}

- (void)p_receiveRemoteNotification:(NSDictionary *)userInfo {
    // Notification to cache to print
    BOOL isInactive = [UIApplication sharedApplication].applicationState == UIApplicationStateInactive;
    if (isInactive && _notificationEnable) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kPushLaunchNotification object:userInfo];
    } else if (!isInactive && _notificationEnable) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kPushRemoteNotification object:userInfo];
    }
    if (_cacheEnable) {
        [LPPushDataManager addNotification:userInfo];
    }
    if (isInactive) {
        [LPPushDataManager setCacheData:@[@{kLaunchCacheKey:@YES}] withKey:kLaunchCacheKey];
        LPPushLog(@"从消息启动:%@", userInfo);
    } else {
        LPPushLog(@"收到远程通知:%@", userInfo);
    }
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    // ???: It will be invoked when app launch from notification sometimes (random).
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateInactive) {
        if (_notificationEnable) {
            [[NSNotificationCenter defaultCenter] postNotificationName:kPushLaunchNotification object:notification.userInfo];
        }
        [LPPushDataManager setCacheData:@[@{kLaunchCacheKey:@YES}] withKey:kLaunchCacheKey];
        LPPushLog(@"从消息启动:%@", notification.userInfo);
        return;
    }
    // ???
    if (_localNotificationEnable) {
        if (_notificationEnable) {
            [[NSNotificationCenter defaultCenter] postNotificationName:kPushLocalNotification object:notification.userInfo];
        }
        LPPushLog(@"收到本地通知:%@", notification.userInfo);
        //[BPush showLocalNotificationAtFront:notification identifierKey:nil];
    }
}

#pragma mark - Action

- (void)sendLocalNotification:(NSString *)notification {
    if (_localNotificationEnable) {
        LPPushLog(@"发送本地通知:%@", notification);
        if (_apiKey) {
            NSDate *fireDate = [[NSDate new] dateByAddingTimeInterval:5];
            [BPush localNotification:fireDate alertBody:notification badge:3 withFirstAction:@"打开" withSecondAction:@"关闭" userInfo:nil soundName:nil region:nil regionTriggersOnce:YES category:nil];
        }
    }
}

#pragma mark - Public

void LPPushLog(NSString *format, ...) {
    if (_pushLogEnable) {
        va_list args;
        va_start(args, format);
        NSString *str = [[NSString alloc] initWithFormat:format arguments:args];
        va_end(args);
        NSLog(@"%@", str);
    }
}

@end