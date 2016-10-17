//
//  XFDebug.m
//  XFDebugExample
//
//  Created by 徐亚非 on 2016/10/9.
//  Copyright © 2016年 XuYafei. All rights reserved.
//

#import "XFDebug.h"
#if __has_include(<XFPushController.h>)
#define XFPushController_h
#import <XFPushController.h>
#endif
#import "XFQuickAccessViewController.h"
#import "XFMainViewController.h"

@interface XFDebug () <XFATRootViewControllerDelegate>

@property (nonatomic, strong) XFAssistiveTouch *assistiveTouch;
@property (nonatomic, strong) XFATRootViewController *rootViewController;

@end

@implementation XFDebug

#pragma mark - Initialization

+ (instancetype)sharedInstance {
    static id sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [self new];
    });
    return sharedInstance;
    
}

+ (void)run {
    [self sharedInstance];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _assistiveTouch = [XFAssistiveTouch sharedInstance];
        [_assistiveTouch showAssistiveTouch];
        _rootViewController = (XFATRootViewController *)_assistiveTouch.navigationController.viewControllers.firstObject;
        _rootViewController.delegate = self;
        
        NSSetUncaughtExceptionHandler(&XFDebugUncaughtExceptionHandler);
    }
    return self;
}

#pragma mark - XFDebugLog

void XFDebugLog(NSString *format, ...) {
    va_list args;
    va_start(args, format);
    NSString *string = [[NSString alloc] initWithFormat:format arguments:args];
    va_end(args);
    
    [XFMainViewController print:string];
    
    printf("[XFDebug]:%s\n", string.UTF8String);
}

#pragma mark - UncaughtExceptionHandler

void XFDebugUncaughtExceptionHandler(NSException *exception) {
    NSArray *callStack = [exception callStackSymbols];
    NSString *reason = [exception reason];
    NSString *name = [exception name];
    NSString *content = [NSString stringWithFormat:@"name:%@\nreason:\n%@\ncallStackSymbols:\n%@",
                         name,
                         reason,
                         [callStack componentsJoinedByString:@"\n"]];
    XFDebugLog(@"%@", content);
}

#pragma mark - XFATRootViewControllerDelegate

- (NSInteger)numberOfItemsInViewController:(XFATRootViewController *)viewController {
    return 3;
}

- (XFATItemView *)viewController:(XFATRootViewController *)viewController itemViewAtPosition:(XFATPosition *)position {
    switch (position.index) {
        case 0:
            return [XFATItemView itemWithType:XFATItemViewTypeCount + 1];
            break;
        case 1:
            return [XFATItemView itemWithType:XFATItemViewTypeCount + 2];
            break;
        case 2:
            return [XFATItemView itemWithType:XFATItemViewTypeCount + 3];
            break;
        default:
            return [XFATItemView itemWithType:XFATItemViewTypeNone];
            break;
    }
}

- (void)viewController:(XFATRootViewController *)viewController didSelectedAtPosition:(XFATPosition *)position {
    switch (position.index) {
        case 0: {
            [_assistiveTouch pushViewController:[XFMainViewController sharedInstance]];
            break;
        } case 1: {
#ifdef XFPushController_h
            [_assistiveTouch pushViewController:[XFPushController new]];
#endif
            break;
        } case 2: {
            NSMutableArray *array = [NSMutableArray array];
            for (int i = 0; i < 8; i++) {
                XFATItemView *itemView = [XFATItemView itemWithType:XFATItemViewTypeCount + i];
                itemView.tag = i;
                UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(p_transformItemViewAction:)];
                [itemView addGestureRecognizer:tapGesture];
                [array addObject:itemView];
            }
            XFATViewController *viewController = [[XFATViewController alloc] initWithItems:[array copy]];
            [_rootViewController.navigationController pushViewController:viewController
                                                              atPisition:position];
            break;
        } default: {
            break;
        }
    }
}

#pragma mark - Action

- (void)p_transformItemViewAction:(UITapGestureRecognizer *)tapGesture {
    XFATItemView *itemView = (XFATItemView *)tapGesture.view;
    NSInteger index = itemView.tag;
    XFQuickAccessViewController *transformViewController = [XFQuickAccessViewController new];
    transformViewController.user = index;
    transformViewController.transformArray = [self p_getTransformViewControllersFromDelegate];
    [_assistiveTouch pushViewController:transformViewController];
}

- (NSMutableArray *)p_getTransformViewControllersFromDelegate {
    static NSMutableArray *transformArray;
    if (transformArray.count) {
        return transformArray;
    }
    transformArray = [NSMutableArray array];
    if (_transformDelegate && [_transformDelegate respondsToSelector:@selector(debugViewControllerByUser:atIndex:)]) {
        for (int i = 0; i < 8; i++) {
            NSMutableArray *array = [NSMutableArray array];
            UIViewController *vc;
            do {
                vc = [_transformDelegate debugViewControllerByUser:i atIndex:array.count];
                if (vc) {
                    [array addObject:vc];
                } else {
                    break;
                }
            } while (YES);
            [transformArray addObject:array];
        }
    }
    return transformArray;
}

@end
