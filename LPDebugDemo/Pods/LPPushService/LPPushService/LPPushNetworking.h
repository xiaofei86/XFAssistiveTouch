//
//  LPNetworking.h
//  LPNetworkingDemo
//
//  Created by XuYafei on 15/12/26.
//  Copyright © 2015年 loopeer. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LPPushNetworking : NSObject

typedef void (^LPNetworkRequestCompletionBlock)(NSDictionary *result,
                                                NSURLResponse *response,
                                                NSError *error);

+ (void)Get:(NSString *)URLString
 parameters:(nullable NSDictionary *)parameters
 completion:(LPNetworkRequestCompletionBlock)completionBlock;

+ (void)Post:(NSString *)URLString
  parameters:(nullable NSDictionary *)parameters
  completion:(LPNetworkRequestCompletionBlock)completionBlock;

@end

NS_ASSUME_NONNULL_END