//
//  XFAssistiveTouch.h
//  XFAssistiveTouchExample
//
//  Created by 徐亚非 on 2016/9/26.
//  Copyright © 2016年 XuYafei. All rights reserved.
//

#import "XFATNavigationController.h"
#import "XFATRootViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface XFAssistiveTouch : NSObject

+ (instancetype)sharedInstance;
- (void)showAssistiveTouch;

@property (nonatomic, strong) UIWindow *assistiveWindow;
@property (nonatomic, strong) XFATNavigationController *navigationController;

- (void)pushViewController:(UIViewController *)viewController atViewController:(UIViewController *)targetViewcontroller;
- (void)pushViewController:(UIViewController *)viewController;

@end

NS_ASSUME_NONNULL_END
