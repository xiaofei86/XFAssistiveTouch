//
//  AppDelegate.m
//  LPDebugDemo
//
//  Created by XuYafei on 15/12/23.
//  Copyright © 2015年 loopeer. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "LPDebug.h"

@interface AppDelegate () <LPTransformDelegate>

@end

@implementation AppDelegate {
    LPDebug *_debug;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    _window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[ViewController new]];
    [_window makeKeyAndVisible];
    _debug = [LPDebug run];
    _debug.transformDelegate = self;
    
    return YES;
}

- (UIViewController *)debugViewControllerByUser:(LPDebugUser)user atIndex:(NSInteger)index {
    if (index > 1) {
        return nil;
    }
    UIViewController *vc = [UIViewController new];
    switch (user) {
        case LPDebugUserHanShuai:
            vc.view.backgroundColor = [UIColor colorWithRed:user*30 green:index*30 blue:index*30 alpha:1];
            break;
        case LPDebugUserRaoZhizhen:
            vc.view.backgroundColor = [UIColor colorWithRed:user*30 green:index*30 blue:index*30 alpha:1];
            break;
        case LPDebugUserZouZhigang:
            vc.view.backgroundColor = [UIColor colorWithRed:user*30 green:index*30 blue:index*30 alpha:1];
            break;
        case LPDebugUserZhaoWanda:
            vc.view.backgroundColor = [UIColor colorWithRed:user*30 green:index*30 blue:index*30 alpha:1];
            break;
        case LPDebugUserXuYafei:
            vc.view.backgroundColor = [UIColor colorWithRed:user*30 green:index*30 blue:index*30 alpha:1];
            break;
        case LPDebugUserDengJiebin:
            vc.view.backgroundColor = [UIColor colorWithRed:user*30 green:index*30 blue:index*30 alpha:1];
            break;
        case LPDebugUserLongXiaowen:
            vc.view.backgroundColor = [UIColor colorWithRed:user*30 green:index*30 blue:index*30 alpha:1];
            break;
        default:
            vc.view.backgroundColor = [UIColor colorWithRed:user*30 green:index*30 blue:index*30 alpha:1];
            break;
    }
    return vc;
}

@end
