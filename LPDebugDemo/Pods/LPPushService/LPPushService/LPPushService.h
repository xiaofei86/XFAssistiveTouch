//
//  LPPushService.h
//  LPPushServiceDemo
//
//  Created by XuYafei on 15/9/28.
//  Copyright © 2015年 loopeer. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LPPushDataManager;

/// 是否打印推送记录，默认YES
static BOOL _pushLogEnable = YES;

/// 打印推送记录，根据pushLogEnable判断是否打印
FOUNDATION_EXPORT void LPPushLog(NSString *format, ...) NS_FORMAT_FUNCTION(1,2);

/**
 * 基于百度推送1.4.3
 * 直接将AppDelegate继承自此类并在application:didFinishLaunchingWithOptions:中
 * 调用application:registerPushServiceWithOptions:andApiKey方法注册百度推送后即可使用
 * 可以通过以下三个property设置对应参数,其中cacheEnable在设置后无法更改
 * cacheEnable必须在调用application:registerPushServiceWithOptions:andApiKey方法前设置
 */
@interface LPPushService : UIResponder

/**
 * @brief 在application:didFinishLaunchingWithOptions 中调用
 * @param enable 是否向Apple注册推送,如果项目中集成有其他推送则可以设为NO
 * @param launchOptions 启动参数
 * @param apiKey 百度推送的apiKey,nil表示不向百度注册推送
 */
- (void)application:(UIApplication *)application registerPushServiceToApple:(BOOL)enable withOptions:(NSDictionary *)launchOptions andApiKey:(NSString *)apiKey;

/**
 * @brief 向自己的服务器注册推送服务(暂未实现)
 * @param ServerURL 请求地址
 * @param params 请求参数
 */
- (void)registerPushServiceToServer:(NSString *)ServerURL withParams:(NSDictionary *)params;

/**
 * @brief 发送本地通知(localNotificationEnable必须为YES此方法才有用)
 * @param notification 通知内容
 */
- (void)sendLocalNotification:(NSString *)notification;

/// 查看registerToApple状态
@property (assign, nonatomic, readonly) BOOL registerToApple;

/// 是否将推送信息缓存到本地，默认YES
@property (assign, nonatomic) BOOL cacheEnable;

/**
 * 是否在以下情况下发送通知
 * 通过推送消息启动,收到本地通知,收到远程通知,收到远程静默通知,获取设备号成功,获取设备号失败
 * 默认YES
 */
@property (assign, nonatomic) BOOL notificationEnable;

/// 是否可以发送本地通知，默认NO
@property (assign, nonatomic) BOOL localNotificationEnable;

// 还要添加其他平台的推送以下方法需要在AppDelegate中调用父类方法

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings;
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken;
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error;
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo;
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler;
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification;

// TODO:注册登出服务器/通过通知自动注册登出

@end
