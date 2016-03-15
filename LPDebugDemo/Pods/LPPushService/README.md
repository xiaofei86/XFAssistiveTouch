#LPPushService

[![LICENSE](https://img.shields.io/badge/license-MIT-green.svg?style=flat)](https://raw.githubusercontent.com/xiaofei86/LPPushService/master/LICENSE)&nbsp;
[![PLATFORM](https://img.shields.io/cocoapods/p/LPPushService.svg?style=flat)](https://developer.apple.com/library/ios/navigation/)&nbsp;
[![SUPPORT](https://img.shields.io/badge/support-iOS%207%2B%20-blue.svg?style=flat)](https://en.wikipedia.org/wiki/IOS_7)&nbsp;
[![BLOG](https://img.shields.io/badge/blog-xuyafei.cn-orange.svg?style=flat)](http://xuyafei.cn)&nbsp;

封装官方推送和百度推送，需要引入百度推送SDK。

[图片备用链接](http://e.picphotos.baidu.com/album/s%3D680%3Bq%3D90/sign=7968d36a27a446237acaa66aa8190333/4034970a304e251f81804de8a086c9177f3e53ae.jpg)

<img src = "https://github.com/xiaofei86/LPPushService/raw/master/Images/1.png" width = 373>

[图片备用链接](http://e.picphotos.baidu.com/album/s%3D680%3Bq%3D90/sign=a7ed031dffdcd100c99cfb2942b0362d/08f790529822720e90d94bea7ccb0a46f21fab8f.jpg)

<img src = "https://github.com/xiaofei86/LPPushService/raw/master/Images/2.png" width = 373>

#OneLine

```objective-c
[self application:application registerPushServiceToApple:YES withOptions:launchOptions andApiKey:kPushApiKey];
```
 
#Usage

将方法application:registerPushServiceToApple:withOptions:andApiKey:添加在AppDelegate的application:didFinishLaunchingWithOptions:方法中。
 
registerPushServiceToApple:如果项目中同时集成了其他第三方推送应该设为NO。这样LPPushService就不会再向苹果进行注册。如果重复注册，一条推送就会收到多条通知。
 
withOptions:将launchOptions传入。
 
andApiKey:传入百度推送的ApiKey（网站上注册完百度推送就可获得）。传nil表示使用官方推送。
 
除此之外，还需要将AppDelegate继承关系从UIResponder改成LPPushService。
 
####LPPushService

```objective-c
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
```
 
####LPPushDataManager

推送的数据LPPushService会进行自动缓存，通过LPPushDataManager来获取和编辑本地的推送数据。同时还可以通过LPPushDataManager获取推送相关的数据，设置推本相关参数等功能。

```objective-c
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
```