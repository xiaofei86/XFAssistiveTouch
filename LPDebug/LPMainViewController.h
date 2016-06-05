//
//  LPMainViewController.h
//  LPDebugDemo
//
//  Created by 徐亚非 on 16/5/29.
//  Copyright © 2016年 loopeer. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LPMainViewController : UIViewController

+ (instancetype)sharedInstance;

+ (void)print:(NSString *)string;

@end

NS_ASSUME_NONNULL_END