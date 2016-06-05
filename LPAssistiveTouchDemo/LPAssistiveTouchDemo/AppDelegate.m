//
//  AppDelegate.m
//  LPAssistiveTouchDemo
//
//  Created by XuYafei on 15/10/29.
//  Copyright © 2015年 loopeer. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "LPAssistiveTouch.h"

@interface AppDelegate () <LPATRootViewControllerDelegate>

@end

@implementation AppDelegate {
    LPAssistiveTouch *_assistiveTouch;
    LPATRootViewController *_rootViewController;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    _window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    _window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[ViewController new]];
    [_window makeKeyAndVisible];
    
    _assistiveTouch = [LPAssistiveTouch shareInstance];
    [_assistiveTouch showAssistiveTouch];
    _rootViewController = (LPATRootViewController *)_assistiveTouch.rootNavigationController.rootViewController;
    _rootViewController.delegate = self;
    
    return YES;
}

#pragma mark - LPATRootViewControllerDelegate

- (NSInteger)numberOfItemsInController:(LPATRootViewController *)atViewController {
    return 3;
}

- (LPATItemView *)controller:(LPATRootViewController *)controller itemViewAtPosition:(LPATPosition *)position {
    switch (position.index) {
        case 0:
            return [LPATItemView itemWithType:LPATItemViewTypeNSLog];
            break;
        case 1:
            return [LPATItemView itemWithType:LPATItemViewTypeAPNS];
            break;
        case 2:
            return [LPATItemView itemWithType:LPATItemViewTypeTransform];
            break;
        default:
            return [LPATItemView itemWithType:LPATItemViewTypeNone];
            break;
    }
}

- (void)controller:(LPATRootViewController *)controller didSelectedAtPosition:(LPATPosition *)position {
    switch (position.index) {
        case 0: {
            break;
        } case 1: {
            break;
        } case 2: {
            NSMutableArray *array = [NSMutableArray array];
            for (int i = 0; i < 8; i++) {
                NSString *imageName = [NSString stringWithFormat:@"Transform%d.png", i + 1];
                CALayer *layer = [CALayer layer];
                layer.contents = (__bridge id _Nullable)([UIImage imageNamed:imageName].CGImage);
                LPATItemView *itemView = [LPATItemView itemWithLayer:layer];
                [array addObject:itemView];
            }
            LPATViewController *viewController = [[LPATViewController alloc] initWithItems:[array copy]];
            [_rootViewController.navigationController pushViewController:viewController
                                                              atPisition:position];
            break;
        } default: {
            break;
        }
    }
}

#pragma mark - Private

- (void)p_pushViewController:(UIViewController *)viewController {
    UIViewController *topvc = [self p_topViewController];
    if ([topvc isKindOfClass:[UINavigationController class]]) {
        [(UINavigationController *)topvc pushViewController:viewController animated:YES];
    } else {
        [topvc presentViewController:viewController animated:YES completion:^{}];
    }
    [_rootViewController.navigationController shrink];
}

- (UIViewController *)p_topViewController{
    static UIViewController *cachevc;
    if (cachevc) {
        return cachevc;
    }
    cachevc = [self p_topViewController:[UIApplication sharedApplication].keyWindow.rootViewController];
    return cachevc;
}

- (UIViewController *)p_topViewController:(UIViewController *)rootvc {
    if ([rootvc isKindOfClass:[UITabBarController class]]) {
        UIViewController *tabvc = ((UITabBarController *)rootvc).selectedViewController;
        return [self p_topViewController:tabvc];
    } else {
        UIViewController *topvc = rootvc;
        while (topvc.presentedViewController) {
            topvc = topvc.presentedViewController;
        }
        return topvc;
    }
}

@end
