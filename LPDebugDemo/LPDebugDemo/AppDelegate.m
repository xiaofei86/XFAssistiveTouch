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
    if (index > 8) {
        return nil;
    }
    UIViewController *vc = [UIViewController new];
    UIColor *color = [UIColor colorWithRed:user*30/255.0 green:index*30/255.0 blue:index*30/255.0 alpha:1];
    vc.view.backgroundColor = color;
    NSString *string = [NSString stringWithFormat:@"UIViewController%ld-%ld", user, index];
    vc.navigationItem.title = string;
    return vc;
}

@end
