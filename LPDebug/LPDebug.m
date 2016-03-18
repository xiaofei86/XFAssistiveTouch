//
//  LPDebug.m
//  LPDebugDemo
//
//  Created by XuYafei on 16/3/15.
//  Copyright © 2016年 loopeer. All rights reserved.
//

#import "LPDebug.h"
#if __has_include(<LPPushController.h>)
#define LPPushController_h
#import <LPPushController.h>
#endif
#import "LPTransformViewController.h"

static NSInteger _itemViewTag = 3252;

@interface LPDebug () <LPATRootViewControllerDelegate>

@end

@implementation LPDebug {
    LPAssistiveTouch *_assistiveTouch;
    LPATRootViewController *_rootViewController;
    dispatch_source_t source;
}

#pragma mark - Initialization

+ (instancetype)sharedInstance {
    return [LPDebug run];
}

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
//        LPDebugLog(@"%@\n", [NSThread callStackSymbols]);
//        NSString *string = [[UIApplication sharedApplication].keyWindow valueForKey:@"recursiveDescription"];
//        LPDebugLog(@"%@\n", string);
    }
    return self;
}

#pragma mark - LPLog

void LPDebugLog(NSString *format, ...) {
    va_list args;
    va_start(args, format);
    NSString *str = [[NSString alloc] initWithFormat:format arguments:args];
    va_end(args);
    printf("[LPDebug]:%s", str.UTF8String);
}

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
            [_assistiveTouch pushViewController:[LPPushController new]];
#endif
            break;
        } case 2: {
            NSMutableArray *array = [NSMutableArray array];
            for (int i = 0; i < 8; i++) {
                NSString *imageName = [NSString stringWithFormat:@"Transform%d.png", i + 1];
                CALayer *layer = [CALayer layer];
                layer.contents = (__bridge id _Nullable)([UIImage imageNamed:imageName].CGImage);
                LPATItemView *itemView = [LPATItemView itemWithLayer:layer];
                itemView.tag = _itemViewTag + i;
                UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(p_transformItemViewAction:)];
                [itemView addGestureRecognizer:tapGesture];
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

#pragma mark - Action

- (void)p_transformItemViewAction:(UITapGestureRecognizer *)tapGesture {
    LPATItemView *itemView = (LPATItemView *)tapGesture.view;
    NSInteger index = itemView.tag - _itemViewTag;
    LPTransformViewController *transformViewController = [LPTransformViewController new];
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
