//
//  LPDataCache.h
//  MXCloudBrowser
//
//  Created by 徐亚非 on 16/6/2.
//  Copyright © 2016年 www.maxthon.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LPDataCache : NSObject

+ (NSArray *)getCacheDataWithKey:(NSString *)key;
+ (void)setCacheData:(NSArray *)array withKey:(NSString *)key;

+ (void)addCacheData:(NSDictionary *)dictionary withKey:(NSString *)key;
+ (void)removeCacheData:(NSDictionary *)dictionary withKey:(NSString *)key;
+ (void)removeCacheDataAtIndex:(NSInteger)index withKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
