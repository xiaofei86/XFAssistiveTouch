//
//  LPAssistiveTouch.m
//  LPAssistiveTouchDemo
//
//  Created by XuYafei on 15/10/29.
//  Copyright © 2015年 loopeer. All rights reserved.
//

#import "LPAssistiveTouch.h"
#import "LPATRootViewController.h"

@interface LPAssistiveTouch () <LPATViewControllerDelegate>

@end

@implementation LPAssistiveTouch {
    CGRect _assistiveWindowRect;
    CGRect _coverWindowRect;
    LPATRootViewController *_rootViewController;
}

#pragma mark - Initialization

+ (instancetype)shareInstance {
    static id shareInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = [[self alloc] init];
    });
    return shareInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _rootViewController = [[LPATRootViewController alloc] init];
        _rootViewController.delegate = self;
        _assistiveWindowRect = _rootViewController.assistiveViewRect;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    }
    return self;
}

- (void)showAssistiveTouch {
    _assistiveWindow = [[UIWindow alloc] initWithFrame:_assistiveWindowRect];
    _assistiveWindow.windowLevel = powf(10, 7);
    _assistiveWindow.backgroundColor = [UIColor clearColor];
    _assistiveWindow.rootViewController = _rootViewController;
    [self makeVisibleWindow];
}

- (void)makeVisibleWindow {
    UIWindow *keyWindows = [UIApplication sharedApplication].keyWindow;
    [_assistiveWindow makeKeyAndVisible];
    if (keyWindows) {
        [keyWindows makeKeyWindow];
    }
}

#pragma mark - LPATViewControllerDelegate

- (void)touchBegan {
    _coverWindowRect = CGRectZero;
    _assistiveWindow.frame = [[UIScreen mainScreen] bounds];
    _rootViewController.view.frame = [[UIScreen mainScreen] bounds];
    CGFloat pointX = CGRectGetMidX(_assistiveWindowRect);
    CGFloat pointY = CGRectGetMidY(_assistiveWindowRect);
    _rootViewController.shrinkPoint = CGPointMake(pointX, pointY);
}

- (void)shrinkToRect:(CGRect)rect {
    _assistiveWindowRect = rect;
    _assistiveWindow.frame = _assistiveWindowRect;
    CGFloat pointX = CGRectGetWidth(_rootViewController.contentItem.frame) / 2;
    _rootViewController.shrinkPoint = CGPointMake(pointX, pointX);
}

#pragma mark - UIKeyboardWillChangeFrameNotification

- (void)keyboardWillChangeFrame:(NSNotification *)notification {
    /*因为动画过程中不能实时修改_assistiveWindowRect,
     *所以如果执行点击操作的话,_assistiveTouchView位置会以动画之前的位置为准.
     *如果执行拖动操作则会有跳动效果.所以需要禁止用户操作.*/
    _assistiveWindow.userInteractionEnabled = NO;
    NSDictionary *info = [notification userInfo];
    CGFloat duration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    CGRect endKeyboardRect = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    //根据实时位置计算于键盘的间距
    CGFloat yOffset = endKeyboardRect.origin.y - _assistiveWindow.frame.origin.y - _assistiveWindow.frame.size.height;
    
    //如果键盘弹起给_coverWindowRect赋值
    if (endKeyboardRect.origin.y < CGRectGetHeight([[UIScreen mainScreen] bounds])) {
        _coverWindowRect = _assistiveWindowRect;
    }
    
    //根据间距计算移动后的位置viewFrame
    CGRect viewFrame = _assistiveWindow.frame;
    viewFrame.origin.y += yOffset;
    //如果viewFrame在原位置之下,将viewFrame变为原位置
    if (viewFrame.origin.y > _coverWindowRect.origin.y) {
        viewFrame.origin.y = _coverWindowRect.origin.y;
    }
    //如果_assistiveWindow被移动,将viewFrame变为移动后的位置
    if (_coverWindowRect.origin.x == 0
        && _coverWindowRect.origin.y == 0
        && _coverWindowRect.size.width == 0
        && _coverWindowRect.size.height == 0) {
        viewFrame.origin.y = _assistiveWindow.frame.origin.y;
    }
    
    //根据计算好的位置执行动画
    [UIView animateWithDuration:duration animations:^{
        _assistiveWindow.frame = viewFrame;
    } completion:^(BOOL finished) {
        //将_assistiveWindowRect变为移动后的位置并恢复用户操作
        _assistiveWindowRect = _assistiveWindow.frame;
        _assistiveWindow.userInteractionEnabled = YES;
        //使其遮盖键盘
        [self makeVisibleWindow];
    }];
}

@end
