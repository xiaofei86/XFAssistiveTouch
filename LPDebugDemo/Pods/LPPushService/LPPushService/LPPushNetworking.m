//
//  LPNetworking.m
//  LPNetworkingDemo
//
//  Created by XuYafei on 15/12/26.
//  Copyright © 2015年 loopeer. All rights reserved.
//

#import "LPPushNetworking.h"

@implementation LPPushNetworking

+ (instancetype)shareInstance {
    static id shareInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = [[self alloc] init];
    });
    return shareInstance;
}

+ (void)Get:(NSString *)URLString parameters:(NSDictionary *)parameters completion:(LPNetworkRequestCompletionBlock)completionBlock {
    LPPushNetworking *networking = [LPPushNetworking shareInstance];
    [networking Request:URLString HTTPMethod:@"GET" parameters:parameters completion:completionBlock];
}

+ (void)Post:(NSString *)URLString parameters:(NSDictionary *)parameters completion:(LPNetworkRequestCompletionBlock)completionBlock {
    LPPushNetworking *networking = [LPPushNetworking shareInstance];
    [networking Request:URLString HTTPMethod:@"POST" parameters:parameters completion:completionBlock];
}

- (void)Request:(NSString *)URLString HTTPMethod:(NSString *)HTTPMethod parameters:(NSDictionary *)parameters completion:(LPNetworkRequestCompletionBlock)completionBlock {
    NSMutableURLRequest *request;
    NSURL *URL = [NSURL URLWithString:URLString];
    if ([HTTPMethod isEqualToString:@"POST"]) {
        request = [NSMutableURLRequest requestWithURL:URL];
        NSData *postData = [NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:nil];
        [request setHTTPBody:postData];
        [request setHTTPMethod:HTTPMethod];
        NSLog(@"Request:%@\n%@", URL, parameters);
    } else if ([HTTPMethod isEqualToString:@"GET"]) {
        request = [NSMutableURLRequest requestWithURL:URL];
        [request setHTTPMethod:HTTPMethod];
        NSLog(@"Request:%@", URL);
    }
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSURLSessionDataTask *sessionDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSDictionary *result = [NSDictionary dictionary];
        if (data) {
            id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            if ([jsonObject isKindOfClass:[NSDictionary class]]) {
                result = (NSDictionary *)jsonObject;
            }
        }
        
        if (error) {
            NSLog(@"Response:%@", error);
        } else {
            NSLog(@"Response:%@", result);
        }
        
        if (completionBlock) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(result, response, error);
            });
        }
    }];
    [sessionDataTask resume];
}

- (NSString *)integrateParams:(NSDictionary *)params toURL:(NSString *)URLString {
    NSMutableString *mURLString = [URLString mutableCopy];
    for (int i = 0; i < params.count; i++) {
        NSString *key = params.allKeys[i];
        NSString *value = params[key];
        if (i) {
            [mURLString appendFormat:@"&%@=%@", key, value];
        } else {
            [mURLString appendFormat:@"?%@=%@", key, value];
        }
    }
    return URLString;
}

@end
