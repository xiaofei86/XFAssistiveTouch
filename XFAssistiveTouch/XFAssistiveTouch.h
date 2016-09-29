//
//  XFAssistiveTouch.h
//  XFAssistiveTouchExample
//
//  Created by 徐亚非 on 2016/9/26.
//  Copyright © 2016年 XuYafei. All rights reserved.
//

#import "XFATRootNavigationController.h"

@interface XFAssistiveTouch : NSObject

+ (instancetype)shareInstance;

- (void)showAssistiveTouch;

@property (nonatomic, strong) UIWindow *assistiveWindow;

@property (nonatomic, strong) XFATRootNavigationController *rootNavigationController;

@property (nonatomic, weak) UINavigationController *navigationController;

- (void)pushViewController:(UIViewController *)viewController;

@end
