//
//  AppDelegate.m
//  XFDebugExample
//
//  Created by 徐亚非 on 2016/10/9.
//  Copyright © 2016年 XuYafei. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "XFDebug.h"

@interface AppDelegate () <XFTransformDelegate>

@end

@implementation AppDelegate {
    XFDebug *_debug;
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    _debug = [XFDebug run];
    _debug.transformDelegate = self;
    return YES;
}

- (UIViewController *)debugViewControllerByUser:(NSInteger)user atIndex:(NSInteger)index {
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
