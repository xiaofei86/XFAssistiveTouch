//
//  LPDebug.m
//  LPDebugDemo
//
//  Created by XuYafei on 16/3/15.
//  Copyright © 2016年 loopeer. All rights reserved.
//

#import "LPDebug.h"
#import "LPAssistiveTouch.h"
#if __has_include(<LPPushController.h>)
#define LPPushController_h
#import <LPPushController.h>
#endif

@interface LPDebug () <LPATRootViewControllerDelegate>

@end

@implementation LPDebug {
    LPAssistiveTouch *_assistiveTouch;
    LPATRootViewController *_rootViewController;
}

#pragma mark - Initialization

+ (instancetype)run {
    static id sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [self new];
    });
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _assistiveTouch = [LPAssistiveTouch shareInstance];
        [_assistiveTouch showAssistiveTouch];
        _rootViewController = (LPATRootViewController *)_assistiveTouch.rootNavigationController.rootViewController;
        _rootViewController.delegate = self;
        
        NSSetUncaughtExceptionHandler(&LPDebugUncaughtExceptionHandler);
        
//        hookLog();
//        NSLog(@"%@", [NSThread callStackSymbols]);
    }
    return self;
}

#pragma mark - HookNSLog

void hookLog() {
    char pathBuffer[1024];
    fflush(stdout);
    fflush(stderr);
    snprintf(pathBuffer,
             sizeof(pathBuffer),
             "%s/tmp/stdout-%li.log", getenv("HOME"), time(NULL));
    setvbuf(stdout, NULL, _IONBF, 0);
    int fd = open(pathBuffer, (O_RDWR | O_CREAT), 0644);
    dup2(fd, STDOUT_FILENO);
    dup2(fd, STDERR_FILENO);
    //printf("Here is dll init, redirect stdout and stderr to logfile\n");
}

//+ (void)injectIntoNSURLConnectionCancel
//{
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        Class class = [NSURLConnection class];
//        SEL selector = @selector(cancel);
//        SEL swizzledSelector = [FLEXUtility swizzledSelectorForSelector:selector];
//        Method originalCancel = class_getInstanceMethod(class, selector);
//
//        void (^swizzleBlock)(NSURLConnection *) = ^(NSURLConnection *slf) {
//            [[FLEXNetworkObserver sharedObserver] connectionWillCancel:slf];
//            ((void(*)(id, SEL))objc_msgSend)(slf, swizzledSelector);
//        };
//
//        IMP implementation = imp_implementationWithBlock(swizzleBlock);
//        class_addMethod(class, swizzledSelector, implementation, method_getTypeEncoding(originalCancel));
//        Method newCancel = class_getInstanceMethod(class, swizzledSelector);
//        method_exchangeImplementations(originalCancel, newCancel);
//    });
//}

#pragma mark - UncaughtExceptionHandler

void LPDebugUncaughtExceptionHandler(NSException *exception) {
    NSArray *callStack = [exception callStackSymbols];
    NSString *reason = [exception reason];
    NSString *name = [exception name];
    NSString *content = [NSString stringWithFormat:@"name:%@\nreason:\n%@\ncallStackSymbols:\n%@",
                         name,
                         reason,
                         [callStack componentsJoinedByString:@"\n"]];
    NSLog(@"%@", content);
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
            NSLog(@"NSLog");
            break;
        } case 1: {
#ifdef LPPushController_h
            [self p_pushViewController:[LPPushController new]];
#endif
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
    if (_navigationController) {
        return _navigationController;
    } else {
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
}

@end
