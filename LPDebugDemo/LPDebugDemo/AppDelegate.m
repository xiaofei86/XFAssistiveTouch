//
//  AppDelegate.m
//  LPDebugDemo
//
//  Created by XuYafei on 15/12/23.
//  Copyright © 2015年 loopeer. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "LPAssistiveTouch.h"

@interface AppDelegate () <LPATRootViewControllerDelegate>

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    _window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[ViewController new]];
    [_window makeKeyAndVisible];
    
    LPAssistiveTouch *_assistiveTouch = [LPAssistiveTouch shareInstance];
    [_assistiveTouch showAssistiveTouch];
//    LPATRootViewController *rootViewController = (LPATRootViewController *)_assistiveTouch.rootNavigationController.rootViewController;
//    rootViewController.delegate = self;
    
    NSSetUncaughtExceptionHandler(&UncaughtExceptionHandler);
    
    //hookLog();
    //NSLog(@"%@", [NSThread callStackSymbols]);
    
    return YES;
}

void UncaughtExceptionHandler(NSException *exception) {
    NSArray *callStack = [exception callStackSymbols];
    NSString *reason = [exception reason];
    NSString *name = [exception name];
    NSString *content = [NSString stringWithFormat:@"========异常错误报告========\nname:%@\nreason:\n%@\ncallStackSymbols:\n%@",name,reason,[callStack componentsJoinedByString:@"\n"]];
    NSLog(@"%@", content);
}

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

//    Method ori_Method =  class_getInstanceMethod([NSArray class], @selector(lastObject));
//    Method my_Method = class_getInstanceMethod([NSArray class], @selector(myLastObject));
//    method_exchangeImplementations(ori_Method, my_Method);

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
    
}

@end
